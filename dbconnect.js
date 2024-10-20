const mysql = require('mysql');

const conn = mysql.createConnection({
    host: '202.28.34.197',
    user: 'web66_65011212028',
    password: '65011212028@csmsu',
    database: 'web66_65011212028'
})

const queryAsync = util.promisify(conn.query).bind(conn);

module.exports = {conn , queryAsync};