const mysql = require('mysql');

let conn;

function handleDisconnect() {
    conn = mysql.createConnection({
        host: '202.28.34.197',
        user: 'web66_65011212028',
        password: '65011212028@csmsu',
        database: 'web66_65011212028'
    });

    conn.connect((err) => {
        if (err) {
            console.log('Error connecting to MySQL database:', err);
            setTimeout(handleDisconnect, 2000); // ลองเชื่อมต่อใหม่ทุก 2 วินาที
        } else {
            console.log('MySQL successfully connected!');
        }
    });

    // เมื่อเกิดข้อผิดพลาดในการเชื่อมต่อ เช่น การเชื่อมต่อถูกตัด
    conn.on('error', (err) => {
        console.log('MySQL error:', err);
        if (err.code === 'PROTOCOL_CONNECTION_LOST') {
            console.log('Reconnecting to MySQL...');
            handleDisconnect(); // เรียกฟังก์ชันเพื่อเชื่อมต่อใหม่
        } else {
            throw err; // ข้อผิดพลาดอื่นๆ ให้แสดงออกมา
        }
    });
}

// เริ่มต้นการเชื่อมต่อ
handleDisconnect();

module.exports = conn;
