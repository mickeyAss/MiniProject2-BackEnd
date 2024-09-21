var express = require('express');
var app = express();
const userRouter =  require('./api/user');
const riderRouter =  require('./api/rider');
const cors = require('cors');
var bodyParser = require('body-parser')

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.text());

app.use("/user",userRouter);
app.use("/rider",riderRouter);

module.exports = app;