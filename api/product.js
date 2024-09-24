var express = require('express');
var router = express.Router();
var conn = require('../dbconnect')

module.exports = router;

router.get("/get/:pid", (req, res) => {
    const { pid } = req.params; // รับค่า uid จากพารามิเตอร์

    try {
        conn.query("SELECT * FROM product WHERE pid = ?", [pid], (err, result) => {
            if (err) {
                console.log(err);
                return res.status(400).json({ error: 'Query error' });
            }
            if (result.length === 0) {
                return res.status(404).json({ error: 'Product not found' });
            }
            res.status(200).json(result[0]); 
        });
    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: 'Server error' });
    }
});

router.get("/get-all", (req, res) => {
    try {
        // Query สำหรับดึงข้อมูลทั้งหมดจากตาราง product
        conn.query("SELECT * FROM product", (err, result) => {
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
        // Query สำหรับ insert ข้อมูลลงเทเบิ้ล product และเพิ่ม pro_status
        const query = `INSERT INTO product (pro_name, pro_detail, pro_img, uid_fk_send, uid_fk_accept, pro_status) 
                       VALUES (?, ?, ?, ?, ?, ?)`;
        const values = [pro_name, pro_detail, pro_img, uid_fk_send, uid_fk_accept, 'รอไรเดอร์มารับ'];

        conn.query(query, values, (err, result) => {
            if (err) {
                console.log(err);
                return res.status(400).json({ error: 'Insert query error' });
            }

            // ส่ง response กลับเมื่อทำการ insert สำเร็จ
            res.status(201).json({ message: 'Product added successfully', productId: result.insertId });
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