var express = require('express');
var router = express.Router();
var conn = require('../dbconnect')

module.exports = router;

router.get("/get/:rid", (req, res) => {
    const { rid } = req.params; // รับค่า uid จากพารามิเตอร์

    try {
        conn.query("SELECT * FROM rider WHERE rid = ?", [rid], (err, result) => {
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

router.post("/login", (req, res) => {
    const { phone, password } = req.body;

    if (!phone || !password) {
        return res.status(400).json({ error: 'Phone and password are required' });
    }

    try {
        conn.query("SELECT * FROM rider WHERE phone = ?", [phone], (err, result) => {
            if (err) {
                console.error(err);
                return res.status(500).json({ error: 'Database query error' });
            }

            // ตรวจสอบว่าพบผู้ใช้หรือไม่
            if (result.length === 0) {
                return res.status(404).json({ error: 'User not found' });
            }

            const rider = result[0];
            if (password !== rider.password) {
                return res.status(401).json({ error: 'Invalid phone or password' });
            }

            // ลบการสร้างและส่ง token
            res.status(200).json({ message: 'Login successful', rider });
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: 'Server error' });
    }
});

router.post("/register", (req, res) => {
    const { name, lastname, phone, password, img, car_registration } = req.body; // เพิ่มการรับค่า car_registration

    // ตรวจสอบว่ามีการส่งข้อมูลมาครบหรือไม่
    if (!name || !lastname || !phone || !password || !img || !car_registration) {
        return res.status(400).json({ error: 'Name, lastname, phone, password, img, and car_registration are required' });
    }

    try {
        // ตรวจสอบว่าหมายเลขโทรศัพท์ซ้ำหรือไม่
        conn.query("SELECT * FROM rider WHERE phone = ?", [phone], (err, result) => {
            if (err) {
                console.log(err);
                return res.status(500).json({ error: 'Query error' });
            }

            // ถ้ามีผู้ใช้ที่มีหมายเลขโทรศัพท์นี้อยู่แล้ว
            if (result.length > 0) {
                return res.status(409).json({ error: 'Phone number is already registered' });
            }

            // แทรกข้อมูลผู้ใช้ใหม่ลงในฐานข้อมูล (รวม name, lastname, address, img, car_registration)
            conn.query(
                "INSERT INTO rider (name, lastname, phone, password, img, car_registration) VALUES (?, ?, ?, ?, ?, ?)",
                [name, lastname, phone, password, img, car_registration],
                (err, result) => {
                    if (err) {
                        console.log(err);
                        return res.status(500).json({ error: 'Insert rider error' });
                    }

                    const insertedUserId = result.insertId;

                    // ดึงข้อมูลผู้ใช้ที่เพิ่งถูกเพิ่มจากฐานข้อมูล
                    conn.query("SELECT * FROM rider WHERE rid = ?", [insertedUserId], (err, userResult) => {
                        if (err) {
                            console.log(err);
                            return res.status(500).json({ error: 'Query rider error' });
                        }

                        // แสดงข้อมูลผู้ใช้ที่สมัครสมาชิก
                        console.log('Registered user:', userResult[0]); // แสดงข้อมูลผู้ใช้ใน log
                        res.status(201).json({
                            message: 'Rider registered successfully',
                            user: userResult[0] // ส่งข้อมูลผู้ใช้กลับไปด้วย
                        });
                    });
                }
            );
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});



router.delete("/delete-all", (req, res) => {
    try {
        // ลบข้อมูลผู้ใช้ทั้งหมด
        conn.query("DELETE FROM rider", (err, result) => {
            if (err) {
                console.log(err);
                return res.status(500).json({ error: 'Query error' });
            }

            // ตรวจสอบว่ามีการลบข้อมูลหรือไม่
            if (result.affectedRows === 0) {
                return res.status(404).json({ error: 'No rider found to delete' });
            }

            // ส่งข้อความยืนยันการลบข้อมูลทั้งหมด
            res.status(200).json({ message: 'All rider deleted successfully' });
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});

