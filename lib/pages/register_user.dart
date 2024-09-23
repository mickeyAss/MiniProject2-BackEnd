import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fontend_miniproject2/config/config.dart';
import 'package:fontend_miniproject2/pages/home_user.dart';
import 'package:fontend_miniproject2/pages/login_user.dart';
import 'package:fontend_miniproject2/models/register_user_respone.dart';
import 'package:fontend_miniproject2/models/register_user_request.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({super.key});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  TextEditingController nameNoCt1 = TextEditingController();
  TextEditingController lastnameNoCt1 = TextEditingController();
  TextEditingController phoneNoCt1 = TextEditingController();
  TextEditingController passwordNoCt1 = TextEditingController();
  TextEditingController conpasswordNoCt1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'สมัครสมาชิก',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 128, 128, 128)),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 30),
                child: Image.asset(
                  'assets/images/user (1).png',
                  width: 50,
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Text(
                    'สมัครสมาชิก',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: TextField(
                controller: nameNoCt1,
                keyboardType: TextInputType.text,
                cursorColor: Colors.green, // เปลี่ยนสีของเคอร์เซอร์
                decoration: InputDecoration(
                  hintText: 'ชื่อ',
                  labelStyle: TextStyle(
                    fontSize: 15, // ปรับขนาดของ label
                  ),
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey), // สีของเส้นขอบเมื่อใช้งาน
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ), // สีของเส้นขอบเมื่อโฟกัส
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: TextField(
                controller: lastnameNoCt1,
                keyboardType: TextInputType.phone,
                cursorColor: Colors.green, // เปลี่ยนสีของเคอร์เซอร์
                decoration: InputDecoration(
                  hintText: 'นามสกุล',
                  labelStyle: TextStyle(
                    fontSize: 15, // ปรับขนาดของ label
                  ),
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey), // สีของเส้นขอบเมื่อใช้งาน
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ), // สีของเส้นขอบเมื่อโฟกัส
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: TextField(
                controller: phoneNoCt1,
                keyboardType: TextInputType.phone,
                cursorColor: Colors.green, // เปลี่ยนสีของเคอร์เซอร์
                decoration: InputDecoration(
                  hintText: 'เบอร์มือถือ',
                  labelStyle: TextStyle(
                    fontSize: 15, // ปรับขนาดของ label
                  ),
                  border: UnderlineInputBorder(),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey), // สีของเส้นขอบเมื่อใช้งาน
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.green,
                    ), // สีของเส้นขอบเมื่อโฟกัส
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: TextField(
                obscureText: true,
                controller: passwordNoCt1,
                keyboardType: TextInputType.phone,
                cursorColor: Colors.green, // เปลี่ยนสีของเคอร์เซอร์
                decoration: InputDecoration(
                    hintText: 'รหัสผ่าน',
                    labelStyle: TextStyle(
                      fontSize: 15, // ปรับขนาดของ label
                    ),
                    border: UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey), // สีของเส้นขอบเมื่อใช้งาน
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ), // สีของเส้นขอบเมื่อโฟกัส
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: TextField(
                obscureText: true,
                controller: conpasswordNoCt1,
                keyboardType: TextInputType.phone,
                cursorColor: Colors.green, // เปลี่ยนสีของเคอร์เซอร์
                decoration: InputDecoration(
                    hintText: 'ยืนยันรหัสผ่าน',
                    labelStyle: TextStyle(
                      fontSize: 15, // ปรับขนาดของ label
                    ),
                    border: UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey), // สีของเส้นขอบเมื่อใช้งาน
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ), // สีของเส้นขอบเมื่อโฟกัส
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            FilledButton(
                onPressed: register,
                style: FilledButton.styleFrom(
                  backgroundColor:
                      Color.fromARGB(255, 72, 0, 0), // สีพื้นหลังของปุ่ม
                  foregroundColor: Colors.white, // สีข้อความบนปุ่ม
                  padding: EdgeInsets.only(left: 140, right: 140),
                  elevation: 15,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // ปรับขอบมน
                  ),
                ),
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )),
          ],
        ),
      ),
    );
  }

  void register() async {
    if (nameNoCt1.text.isEmpty ||
        lastnameNoCt1.text.isEmpty ||
        phoneNoCt1.text.isEmpty ||
        passwordNoCt1.text.isEmpty ||
        conpasswordNoCt1.text.isEmpty) {
      log('กรอกข้อมูลไม่ครบทุกช่อง');
      // แสดงป็อบอัพเตือนเมื่อไม่มีการกรอกข้อมูล
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'กรุณากรอกข้อมูลให้ครบทุกช่อง',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    child: Text('ตกลง'),
                    style: FilledButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 72, 0, 0),
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        textStyle: TextStyle(fontSize: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 5),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
      return;
    }

    if (passwordNoCt1.text != conpasswordNoCt1.text) {
      log('Passwords do not match');
      // แสดงป็อบอัพเตือนเมื่อรหัสผ่านไม่ตรงกัน
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'รหัสผ่านไม่ตรงกัน',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    child: Text('ตกลง'),
                    style: FilledButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 72, 0, 0),
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        textStyle: TextStyle(fontSize: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 5),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
      return;
    }

    // ทำการสมัครสมาชิก
    var model = RegisterUserRequest(
      name: nameNoCt1.text,
      lastname: lastnameNoCt1.text,
      phone: phoneNoCt1.text,
      password: passwordNoCt1.text,
    );

    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    try {
      var response = await http.post(
        Uri.parse("$url/user/register"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: registerUserRequestToJson(model),
      );

      log(response.body);

      if (response.statusCode == 201) {
        var res = registerUserResponseFromJson(response.body);
        // แสดงข้อความสมัครสมาชิกสำเร็จ
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                  child: Text(
                'สมัครสมาชิกสำเร็จ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      child: Text('ตกลง'),
                      style: FilledButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 0, 247, 37),
                          foregroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          textStyle: TextStyle(fontSize: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 5),
                      onPressed: () {
                        Navigator.pop(context); // ปิดป็อบอัพ
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeUserPage(
                              uid: res.user.uid,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        );
      } else {
        var errorResponse = jsonDecode(response.body);
        // แสดงข้อความที่เซิร์ฟเวอร์ส่งกลับมา
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                  child: Text(
                errorResponse['error'],
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              )),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                      child: Text('ตกลง'),
                      style: FilledButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 72, 0, 0),
                          foregroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          textStyle: TextStyle(fontSize: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          elevation: 5),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      log('Error: $e');
      // แสดงป็อบอัพเมื่อเกิดข้อผิดพลาดในการเชื่อมต่อ
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'เกิดข้อผิดพลาดในการเชื่อมต่อ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            )),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    child: Text('ตกลง'),
                    style: FilledButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 72, 0, 0),
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        textStyle: TextStyle(fontSize: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        elevation: 5),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
  }
}