import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:fontend_miniproject2/config/config.dart';
import 'package:fontend_miniproject2/pages/home_user.dart';
import 'package:fontend_miniproject2/pages/select_login.dart';
import 'package:fontend_miniproject2/pages/register_user.dart';
import 'package:fontend_miniproject2/models/login_user_respone.dart';
import 'package:fontend_miniproject2/models/login_user_request.dart';

class LoginUserPage extends StatefulWidget {
  const LoginUserPage({super.key});

  @override
  State<LoginUserPage> createState() => _LoginUserPageState();
}

class _LoginUserPageState extends State<LoginUserPage> {
  TextEditingController phoneNoCt1 = TextEditingController();
  TextEditingController passwordNoCt1 = TextEditingController();
  GetStorage gs = GetStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (gs.read('uid') != null) {
      log(gs.read('uid').toString());
      //รอให้หน้านี้โหลดก่อนค่อย redirec
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Get.to(
          () => HomeUserPage(
            uid: gs.read('uid'),
          ),
        );
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ผู้ใช้งานทั่วไป',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 128, 128, 128)),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      SelectLoginPage()), // เปลี่ยน HomePage เป็นหน้าหลักของคุณ
              (Route<dynamic> route) => false,
            );
          },
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 30),
                  child: Image.asset(
                    'assets/images/login.png',
                    width: 50,
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      'เข้าสู่ระบบ',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
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
              SizedBox(
                height: 30,
              ),
              FilledButton(
                  onPressed: loginuser,
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        Color.fromARGB(255, 72, 0, 0), // สีพื้นหลังของปุ่ม
                    foregroundColor: Colors.white, // สีข้อความบนปุ่ม
                    padding: EdgeInsets.only(left: 125, right: 125),
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // ปรับขอบมน
                    ),
                  ),
                  child: Text(
                    'เข้าสู่ระบบ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
              Padding(
                padding:
                    const EdgeInsets.only(top: 300), // เว้นระยะห่างจากขอบล่าง
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('คุณยังไม่มีบัญชี?'),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterUserPage()),
                        );
                      },
                      child: Text(
                        'ลงทะเบียน',
                        style: TextStyle(
                          color: Color.fromARGB(255, 72, 0, 0), // สีข้อความ
                          fontWeight: FontWeight.bold, // เพิ่มความหนา
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginuser() async {
    LoginUserRequest model = LoginUserRequest(
      phone: phoneNoCt1.text,
      password: passwordNoCt1.text,
    );

    // เช็คว่ามีการกรอกข้อมูลหรือไม่
    if (model.phone.trim().isEmpty || model.password.trim().isEmpty) {
      // แสดงป็อบอัพเตือนเมื่อไม่มีการกรอกข้อมูล
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'กรุณากรอกเบอร์โทรศัพท์และรหัสผ่าน',
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
      return; // ออกจากฟังก์ชันถ้าไม่มีข้อมูล
    }

    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    try {
      final response = await http.post(
        Uri.parse("$url/user/login"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: jsonEncode(model.toJson()),
      );

      if (response.statusCode == 200) {
        // การล็อกอินสำเร็จ
        var responseData = jsonDecode(response.body); // เปลี่ยนตรงนี้
        if (responseData['message'] == 'Login successful') {
          gs.write(
              'uid',
              responseData['user']
                  ['uid']); //ถ้าlogin ผ่านให้เก็บ username ไว้ในระบบ
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeUserPage(
                uid: responseData['user']['uid'], // เปลี่ยนตรงนี้
              ),
            ),
          );
          log('เข้าสู่ระบบสำเร็จ');
        }
      } else if (response.statusCode == 400) {
        // ข้อมูลไม่ครบถ้วน
        var errorData = jsonDecode(response.body);
        log('Error: ${errorData['error']}');
      } else if (response.statusCode == 404) {
        // ไม่พบผู้ใช้
        var errorData = jsonDecode(response.body);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                  child: Text(
                'ไม่พบผู้ใช้',
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
        log('Error: ${errorData['error']}');
      } else if (response.statusCode == 401) {
        // รหัสผ่านไม่ถูกต้อง
        var errorData = jsonDecode(response.body);
        // แสดงป็อบอัพเตือนเมื่อรหัสผ่านไม่ถูกต้อง
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                  child: Text(
                'รหัสผ่านไม่ถูกต้อง',
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
        log('Error: ${errorData['error']}');
      } else {
        // ข้อผิดพลาดอื่น ๆ
        log('Unexpected error: ${response.statusCode}');
      }
    } catch (e) {
      log('Error: $e');
    }
  }
}
