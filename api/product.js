var express = require('express');
var router = express.Router();
var conn = require('../dbconnect')

module.exports = router;

// รับ tracking_number
router.get("/get/:tracking_number", (req, res) => {
    const { tracking_number } = req.params; 

    // ตรวจสอบว่า tracking_number มีค่าไหม
    if (!tracking_number) {
        return res.status(400).json({ error: 'Tracking number is required' });
    }

    try {
        // คิวรีข้อมูลจากฐานข้อมูล พร้อมเชื่อมกับข้อมูลของผู้ส่ง (uid_fk_send) และผู้รับ (uid_fk_accept)
        const query = `
            SELECT p.pid, p.pro_name, p.pro_detail, p.pro_img, p.pro_status, p.tracking_number, 
                   p.uid_fk_send, p.uid_fk_accept, p.rid_fk,
                   u_send.uid AS sender_uid, u_send.name AS sender_name, u_send.lastname AS sender_lastname, 
                   u_send.phone AS sender_phone, u_send.address AS sender_address, 
                   u_send.latitude AS sender_latitude, u_send.longitude AS sender_longitude, u_send.img AS sender_img,
                   u_accept.uid AS receiver_uid, u_accept.name AS receiver_name, u_accept.lastname AS receiver_lastname, 
                   u_accept.phone AS receiver_phone, u_accept.address AS receiver_address, 
                   u_accept.latitude AS receiver_latitude, u_accept.longitude AS receiver_longitude, u_accept.img AS receiver_img
            FROM product p
            LEFT JOIN users u_send ON p.uid_fk_send = u_send.uid
            LEFT JOIN users u_accept ON p.uid_fk_accept = u_accept.uid
            WHERE p.tracking_number = ?
        `;

        conn.query(query, [tracking_number], (err, result) => {
            if (err) {
                console.log(err);
                return res.status(400).json({ error: 'Query error' });
            }
            if (result.length === 0) {
                return res.status(404).json({ error: 'Product not found' });
            }
            // ส่งผลลัพธ์กลับ
            res.status(200).json(result[0]); 
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});


router.get("/get-latest", (req, res) => {
    try {
        // Query เพื่อดึงข้อมูล product และข้อมูลของผู้ส่ง (uid_fk_send) และผู้รับ (uid_fk_accept)
        const query = `
            SELECT p.pid, p.pro_name, p.pro_detail, p.pro_img, p.pro_status, p.tracking_number, 
                   p.uid_fk_send, p.uid_fk_accept, p.rid_fk,
                   u_send.uid AS sender_uid, u_send.name AS sender_name, u_send.lastname AS sender_lastname, 
                   u_send.phone AS sender_phone, u_send.address AS sender_address, 
                   u_send.latitude AS sender_latitude, u_send.longitude AS sender_longitude, u_send.img AS sender_img,
                   u_accept.uid AS receiver_uid, u_accept.name AS receiver_name, u_accept.lastname AS receiver_lastname, 
                   u_accept.phone AS receiver_phone, u_accept.address AS receiver_address, 
                   u_accept.latitude AS receiver_latitude, u_accept.longitude AS receiver_longitude, u_accept.img AS receiver_img
            FROM product p
            LEFT JOIN users u_send ON p.uid_fk_send = u_send.uid
            LEFT JOIN users u_accept ON p.uid_fk_accept = u_accept.uid
            ORDER BY p.pid DESC LIMIT 1
        `;
        conn.query(query, (err, result) => {
            if (err) {
                console.log(err);
                return res.status(400).json({ error: 'Query error' });
            }
            if (result.length === 0) {
                return res.status(404).json({ error: 'No product found' });
            }
            res.status(200).json(result[0]); // ส่งข้อมูล product พร้อมข้อมูลของผู้ส่งและผู้รับ
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});

router.get("/get-latest/:pid", (req, res) => {
    const { pid } = req.params;  // ดึง pid จากพารามิเตอร์ URL
    try {
        // Query เพื่อดึงข้อมูล product และข้อมูลของผู้ส่ง (uid_fk_send) และผู้รับ (uid_fk_accept)
        const query = `
            SELECT p.pid, p.pro_name, p.pro_detail, p.pro_img, p.pro_status, p.tracking_number, 
                   p.uid_fk_send, p.uid_fk_accept, p.rid_fk,
                   u_send.uid AS sender_uid, u_send.name AS sender_name, u_send.lastname AS sender_lastname, 
                   u_send.phone AS sender_phone, u_send.address AS sender_address, 
                   u_send.latitude AS sender_latitude, u_send.longitude AS sender_longitude, u_send.img AS sender_img,
                   u_accept.uid AS receiver_uid, u_accept.name AS receiver_name, u_accept.lastname AS receiver_lastname, 
                   u_accept.phone AS receiver_phone, u_accept.address AS receiver_address, 
                   u_accept.latitude AS receiver_latitude, u_accept.longitude AS receiver_longitude, u_accept.img AS receiver_img
            FROM product p
            LEFT JOIN users u_send ON p.uid_fk_send = u_send.uid
            LEFT JOIN users u_accept ON p.uid_fk_accept = u_accept.uid
            WHERE p.pid = ?  -- ใช้ pid ที่รับมาใน query
        `;
        conn.query(query, [pid], (err, result) => {
            if (err) {
                console.log(err);
                return res.status(400).json({ error: 'Query error' });
            }
            if (result.length === 0) {
                return res.status(404).json({ error: 'No product found with the provided pid' });
            }
            res.status(200).json(result[0]); // ส่งข้อมูล product พร้อมข้อมูลของผู้ส่งและผู้รับ
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});





router.get("/get-all", (req, res) => {
    try {
        // Query สำหรับดึงข้อมูลทั้งหมดจากตาราง product ที่มี pro_status = 'รอไรเดอร์มารับ'
        conn.query("SELECT * FROM product WHERE pro_status = ?", ['รอไรเดอร์มารับ'], (err, result) => {
            if (err) {
                console.log(err);
                return res.status(400).json({ error: 'Query error' });
            }

            if (result.length === 0) {
                return res.status(404).json({ error: 'No products found' });
            }

            // ส่งข้อมูลทั้งหมดกลับ
            res.status(200).json(result); 
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});



// Route สำหรับ insert ข้อมูล product
router.post('/add', (req, res) => {
    const { pro_name, pro_detail, pro_img, uid_fk_send, uid_fk_accept } = req.body; // รับข้อมูลจาก body

    // ตรวจสอบข้อมูลที่รับเข้ามา
    if (!pro_name || !pro_detail || !pro_img || !uid_fk_send || !uid_fk_accept) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    try {
        // สร้างเลขพัสดุแบบสุ่ม (เช่น 12 หลัก)
        const generateTrackingNumber = () => {
            return 'TRACK-' + Math.floor(100000000000 + Math.random() * 900000000000).toString();
        };

        const trackingNumber = generateTrackingNumber(); // สร้างเลขพัสดุ

        // Query สำหรับ insert ข้อมูลลงเทเบิ้ล product และเพิ่ม pro_status และ tracking_number
        const query = `INSERT INTO product (pro_name, pro_detail, pro_img, uid_fk_send, uid_fk_accept, pro_status, tracking_number) 
                       VALUES (?, ?, ?, ?, ?, ?, ?)`;
        const values = [pro_name, pro_detail, pro_img, uid_fk_send, uid_fk_accept, 'รอไรเดอร์มารับ', trackingNumber];

        conn.query(query, values, (err, result) => {
            if (err) {
                console.log(err);
                return res.status(400).json({ error: 'Insert query error' });
            }

            // ส่ง response กลับเมื่อทำการ insert สำเร็จ พร้อมเลขพัสดุ
            res.status(201).json({ 
                message: 'Product added successfully', 
                productId: result.insertId, 
                trackingNumber: trackingNumber 
            });
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});


// Route สำหรับลบข้อมูลทั้งหมดใน product
router.delete('/delete-all', (req, res) => {
    try {
        // Query สำหรับลบข้อมูลทั้งหมดในเทเบิ้ล product
        const query = "DELETE FROM product";

        conn.query(query, (err, result) => {
            if (err) {
                console.log(err);
                return res.status(400).json({ error: 'Delete query error' });
            }

            // ส่ง response กลับเมื่อทำการลบสำเร็จ
            res.status(200).json({ message: 'All products deleted successfully' });
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});

// Route สำหรับเพิ่มข้อมูล status
router.post('/add-status', (req, res) => {
    const { uid_send, uid_accept, staname } = req.body; // รับข้อมูลจาก body

    // ตรวจสอบข้อมูลที่รับเข้ามา
    if (!uid_send || !uid_accept || !staname) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    try {
        // Query สำหรับ insert ข้อมูลลงในตาราง status
        const query = `INSERT INTO status (uid_send, uid_accept, staname) 
                       VALUES (?, ?, ?)`;
        const values = [uid_send, uid_accept, staname];

        conn.query(query, values, (err, result) => {
            if (err) {
                console.log(err);
                return res.status(400).json({ error: 'Insert query error' });
            }

            // ส่ง response กลับเมื่อทำการ insert สำเร็จ
            res.status(201).json({ 
                message: 'Status added successfully', 
                statusId: result.insertId 
            });
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});