var express = require('express');
var router = express.Router();
var conn = require('../dbconnect')


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

router.get("/get/:uid1/:uid2", (req, res) => {
    const { uid1, uid2 } = req.params; // รับค่า uid สองตัวจากพารามิเตอร์

    try {
        conn.query("SELECT * FROM users WHERE uid IN (?, ?)", [uid1, uid2], (err, result) => {
            if (err) {
                console.log(err);
                return res.status(400).json({ error: 'Query error' });
            }
            if (result.length === 0) {
                return res.status(404).json({ error: 'Users not found' });
            }
            res.status(200).json(result); // ส่งข้อมูลผู้ใช้ที่ตรงกับ uid ทั้งสองตัว
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
        conn.query("SELECT * FROM users WHERE phone = ?", [phone], (err, result) => {
            if (err) {
                console.error(err);
                return res.status(500).json({ error: 'Database query error' });
            }

            // ตรวจสอบว่าพบผู้ใช้หรือไม่
            if (result.length === 0) {
                return res.status(404).json({ error: 'User not found' });
            }

            const user = result[0];
            if (password !== user.password) {
                return res.status(401).json({ error: 'Invalid phone or password' });
            }

            // ลบการสร้างและส่ง token
            res.status(200).json({ message: 'Login successful', user });
        });
    } catch (err) {
        console.error(err);
        return res.status(500).json({ error: 'Server error' });
    }
});

// เส้นทางสำหรับการสมัครสมาชิก
router.post("/register", (req, res) => {
    const { name, lastname, phone, password, img, address, latitude, longitude } = req.body; // รับค่าทั้งหมดจาก body

    // ตรวจสอบว่ามีการส่งข้อมูลสำคัญมาครบหรือไม่
    if (!name || !lastname || !phone || !password) {
        return res.status(400).json({ error: 'Name, lastname, phone, and password are required' });
    }

    // แปลงค่า latitude และ longitude เป็นตัวเลข (double)
    const lat = latitude !== undefined ? parseFloat(latitude) : null;
    const lon = longitude !== undefined ? parseFloat(longitude) : null;

    // ตรวจสอบว่าค่า latitude และ longitude เป็นตัวเลขหรือไม่
    if (lat === null || isNaN(lat)) {
        return res.status(400).json({ error: 'Latitude must be a valid number' });
    }

    if (lon === null || isNaN(lon)) {
        return res.status(400).json({ error: 'Longitude must be a valid number' });
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

            // แทรกข้อมูลผู้ใช้ใหม่ลงในฐานข้อมูล (รวม name, lastname, img, address, latitude, longitude)
            conn.query(
                "INSERT INTO users (name, lastname, phone, password, img, address, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
                [name, lastname, phone, password, img || null, address || null, lat, lon],
                (err, result) => {
                    if (err) {
                        console.log(err);
                        return res.status(500).json({ error: 'Insert user error' });
                    }

                    const insertedUserId = result.insertId;

                    // ดึงข้อมูลผู้ใช้ที่เพิ่งถูกเพิ่มจากฐานข้อมูล
                    conn.query("SELECT * FROM users WHERE uid = ?", [insertedUserId], (err, userResult) => {
                        if (err) {
                            console.log(err);
                            return res.status(500).json({ error: 'Query user error' });
                        }

                        // แสดงข้อมูลผู้ใช้ที่สมัครสมาชิกและส่งกลับไป
                        console.log('Registered user:', userResult[0]); // แสดงข้อมูลผู้ใช้ใน log
                        res.status(201).json({
                            message: 'User registered successfully',
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






// เส้นทางสำหรับการอัปเดตชื่อและนามสกุล
router.put("/update/:uid", (req, res) => {
    const { uid } = req.params; // รับค่า uid จากพารามิเตอร์
    const { latitude, longitude, address } = req.body; // รับค่า latitude, longitude และ address จาก body

    // ตรวจสอบว่ามีการส่งข้อมูลมาครบหรือไม่
    if (!latitude || !longitude || !address) {
        return res.status(400).json({ error: 'Latitude, longitude, and address are required' });
    }

    try {
        // อัปเดต latitude, longitude และ address ในฐานข้อมูล
        conn.query(
            "UPDATE users SET latitude = ?, longitude = ?, address = ? WHERE uid = ?",
            [latitude, longitude, address, uid],
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


// เส้นทางสำหรับการลบข้อมูลผู้ใช้ตาม uid
router.delete("/delete/:uid", (req, res) => {
    const { uid } = req.params; // รับค่า uid จากพารามิเตอร์

    try {
        // ลบข้อมูลผู้ใช้ตาม uid
        conn.query("DELETE FROM users WHERE uid = ?", [uid], (err, result) => {
            if (err) {
                console.log(err);
                return res.status(500).json({ error: 'Query error' });
            }
            // ตรวจสอบว่าพบผู้ใช้หรือไม่
            if (result.affectedRows === 0) {
                return res.status(404).json({ error: 'User not found' });
            }

            // ส่งข้อความยืนยันการลบข้อมูล
            res.status(200).json({ message: 'User deleted successfully' });
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});

router.delete("/delete-all", (req, res) => {
    try {
        // ลบข้อมูลผู้ใช้ทั้งหมด
        conn.query("DELETE FROM users", (err, result) => {
            if (err) {
                console.log(err);
                return res.status(500).json({ error: 'Query error' });
            }

            // ตรวจสอบว่ามีการลบข้อมูลหรือไม่
            if (result.affectedRows === 0) {
                return res.status(404).json({ error: 'No users found to delete' });
            }

            // ส่งข้อความยืนยันการลบข้อมูลทั้งหมด
            res.status(200).json({ message: 'All users deleted successfully' });
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});

router.get("/search-phone/:phone", (req, res) => {
    const { phone } = req.params; // รับค่า address จากพารามิเตอร์

    // ตรวจสอบว่ามีการส่งข้อมูล address มาหรือไม่
    if (!phone) {
        return res.status(400).json({ error: 'Phone is required' });
    }

    try {
        // ค้นหาที่อยู่จากฐานข้อมูล
        conn.query(
            "SELECT * FROM users WHERE phone LIKE ?",
            [`%${phone}%`], // ใช้ LIKE เพื่อค้นหาคำที่มีอยู่ใน address
            (err, results) => {
                if (err) {
                    console.log(err);
                    return res.status(500).json({ error: 'Search query error' });
                }

                // ตรวจสอบว่าพบที่อยู่หรือไม่
                if (results.length === 0) {
                    return res.status(404).json({ error: 'Address not found' });
                }

                // ส่งข้อมูลที่ค้นพบกลับไป
                res.status(200).json(results);
            }
        );
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});


