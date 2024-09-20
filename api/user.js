var express = require('express');
var router = express.Router();
var conn = require('../dbconnect')
var jwt = require('jsonwebtoken');
var secret = 'Fullstack-Login-2024';


module.exports = router;

router.get("/get/:uid", (req, res) => {
    const { uid } = req.params; // รับค่า uid จากพารามิเตอร์

    try {
        conn.query("SELECT * FROM users WHERE uid = ?", [uid], (err, result) => {
            if (err) {
                console.log(err);
                return res.status(400).json({ error: 'Query error' });
            }
            if (result.length === 0) {
                return res.status(404).json({ error: 'User not found' });
            }
            res.status(200).json(result[0]); // ส่งข้อมูลผู้ใช้ที่ตรงกับ uid
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});
// เส้นทางสำหรับการ login
router.post("/login", (req, res) => {
    const { phone, password } = req.body; // รับค่า phone และ password จาก body

    // ตรวจสอบว่ามีการส่งข้อมูลมาครบหรือไม่
    if (!phone || !password) {
        return res.status(400).json({ error: 'Phone and password are required' });
    }

    try {
        // ค้นหาผู้ใช้จากฐานข้อมูลด้วยหมายเลขโทรศัพท์
        conn.query("SELECT * FROM users WHERE phone = ?", [phone], (err, result) => {
            if (err) {
                console.log(err);
                return res.status(500).json({ error: 'Query error' });
            }

            // ตรวจสอบว่ามีผู้ใช้หรือไม่
            if (result.length === 0) {
                return res.status(404).json({ error: 'User not found' });
            }

            // ถ้ามีผู้ใช้ที่มีหมายเลขโทรศัพท์ตรงกัน
            if (result.length > 1) {
                return res.status(409).json({ error: 'Phone number is duplicated in the system' });
            }

            // ตรวจสอบรหัสผ่านที่เก็บไว้ในฐานข้อมูล (ไม่แฮช)
            const user = result[0];
            if (password !== user.password) {
                return res.status(401).json({ error: 'Invalid phone or password' });
            }

            // หากรหัสผ่านถูกต้อง ให้สร้าง JWT token
            const token = jwt.sign({ uid: user.uid, phone: user.phone }, secret, {
                expiresIn: '1h' // ตั้งเวลาให้หมดอายุภายใน 1 ชั่วโมง
            });

            // ส่ง token กลับไปให้ผู้ใช้
            res.status(200).json({ token, message: 'Login successful' });
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});