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
            res.status(200).json({ token, message: 'Login successful',result });
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});

// เส้นทางสำหรับการสมัครสมาชิก
router.post("/register", (req, res) => {
    const { name, lastname, phone, password } = req.body; // รับค่า name, lastname, phone และ password จาก body

    // ตรวจสอบว่ามีการส่งข้อมูลมาครบหรือไม่
    if (!name || !lastname || !phone || !password) {
        return res.status(400).json({ error: 'Name, lastname, phone, and password are required' });
    }

    try {
        // ตรวจสอบว่าหมายเลขโทรศัพท์ซ้ำหรือไม่
        conn.query("SELECT * FROM users WHERE phone = ?", [phone], (err, result) => {
            if (err) {
                console.log(err);
                return res.status(500).json({ error: 'Query error' });
            }

            // ถ้ามีผู้ใช้ที่มีหมายเลขโทรศัพท์นี้อยู่แล้ว
            if (result.length > 0) {
                return res.status(409).json({ error: 'Phone number is already registered' });
            }

            // แทรกข้อมูลผู้ใช้ใหม่ลงในฐานข้อมูล (รวม name และ lastname)
            conn.query(
                "INSERT INTO users (name, lastname, phone, password) VALUES (?, ?, ?, ?)",
                [name, lastname, phone, password],
                (err, result) => {
                    if (err) {
                        console.log(err);
                        return res.status(500).json({ error: 'Insert user error' });
                    }

                    // สร้าง JWT token
                    const token = jwt.sign({ uid: result.insertId, phone: phone }, secret, {
                        expiresIn: '1h', // ตั้งเวลาให้หมดอายุภายใน 1 ชั่วโมง
                    });

                    // ส่ง token และข้อความยืนยันการสมัครสมาชิกสำเร็จกลับไป
                    res.status(201).json({
                        message: 'User registered successfully',
                        token,
                        uid: result.insertId,
                    });
                }
            );
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});


// เส้นทางสำหรับการอัปเดตชื่อและนามสกุล
router.put("/update/:uid", (req, res) => {
    const { uid } = req.params; // รับค่า uid จากพารามิเตอร์
    const { name, lastname } = req.body; // รับค่า name และ lastname จาก body

    // ตรวจสอบว่ามีการส่งข้อมูลมาครบหรือไม่
    if (!name || !lastname) {
        return res.status(400).json({ error: 'Name and lastname are required' });
    }

    try {
        // อัปเดตชื่อและนามสกุลในฐานข้อมูล
        conn.query(
            "UPDATE users SET name = ?, lastname = ? WHERE uid = ?",
            [name, lastname, uid],
            (err, result) => {
                if (err) {
                    console.log(err);
                    return res.status(500).json({ error: 'Update query error' });
                }

                // ตรวจสอบว่าพบผู้ใช้หรือไม่
                if (result.affectedRows === 0) {
                    return res.status(404).json({ error: 'User not found' });
                }

                // ส่งข้อความยืนยันการอัปเดตสำเร็จ
                res.status(200).json({ message: 'User updated successfully' });
            }
        );
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});