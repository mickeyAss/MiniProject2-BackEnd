import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fontend_miniproject2/config/config.dart';
import 'package:fontend_miniproject2/pages/home_rider.dart';
import 'package:fontend_miniproject2/pages/login_rider.dart';
import 'package:fontend_miniproject2/models/register_rider_request.dart';
import 'package:fontend_miniproject2/models/register_rider_respone.dart';

class RegisterRiderPage extends StatefulWidget {
  const RegisterRiderPage({super.key});

  @override
  State<RegisterRiderPage> createState() => _RegisterRiderPageState();
}

class _RegisterRiderPageState extends State<RegisterRiderPage> {
  TextEditingController nameNoCt1 = TextEditingController();
  TextEditingController lastnameNoCt1 = TextEditingController();
  TextEditingController phoneNoCt1 = TextEditingController();
  TextEditingController diveNoCt1 = TextEditingController();
  TextEditingController passwordNoCt1 = TextEditingController();
  TextEditingController conpasswordNoCt1 = TextEditingController();

  final ImagePicker picker = ImagePicker();
  XFile? image;

  String downloadUrl = '';

  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'สมัครไรเดอร์',
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 128, 128, 128)),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // แสดง CircularProgressIndicator เมื่อกำลังอัปโหลด
              if (isUploading) CircularProgressIndicator(),
              // ปุ่มสำหรับอัปโหลดภาพ
              OutlinedButton(
                onPressed: () async {
                  image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    log(image!.path.toString());
                    setState(() {});
                  } else {
                    log('No Image');
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color.fromARGB(255, 72, 0, 0),
                  ),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(
                      0), // เอา padding ออกเพื่อให้รูปเต็มปุ่ม
                ),
                child: (image != null)
                    ? ClipOval(
                        // ใช้ ClipOval เพื่อให้ภาพเป็นวงกลม
                        child: Image.file(
                          File(image!.path),
                          width: 100, // กำหนดขนาดของรูปที่แสดงในปุ่ม
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.photo,
                        color: Color.fromARGB(255, 72, 0, 0),
                        size: 30, // ขนาดของไอคอน
                      ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Text(
                      'สมัครสมาชิก',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                  keyboardType: TextInputType.text,
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
                  controller: diveNoCt1,
                  keyboardType: TextInputType.phone,
                  cursorColor: Colors.green, // เปลี่ยนสีของเคอร์เซอร์
                  decoration: InputDecoration(
                    hintText: 'ทะเบียนรถ',
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
      ),
    );
  }

  Future<String?> uploadImage() async {
    if (image != null) {
      setState(() {
        isUploading = true; // เริ่มการอัปโหลด
      });

      try {
        // สร้าง reference ไปยัง Firebase Storage
        final ref =
            FirebaseStorage.instance.ref().child('image/${image!.name}');

        // อัปโหลดไฟล์ไปยัง Firebase Storage
        await ref.putFile(File(image!.path));

        // รับ URL ของภาพที่อัปโหลด
        String downloadUrl = await ref.getDownloadURL();

        log('Image uploaded successfully: $downloadUrl');
        return downloadUrl; // ส่งกลับ URL
      } catch (e) {
        log('Error uploading image: $e');
        return null; // ส่งกลับ null หากเกิดข้อผิดพลาด
      } finally {
        setState(() {
          isUploading = false; // สิ้นสุดการอัปโหลด
        });
      }
    } else {
      log('No image selected');
      return null; // ส่งกลับ null หากไม่มีรูปภาพ
    }
  }

  void register() async {
    if (nameNoCt1.text.trim().isEmpty ||
        lastnameNoCt1.text.trim().isEmpty ||
        phoneNoCt1.text.trim().isEmpty ||
        passwordNoCt1.text.trim().isEmpty ||
        conpasswordNoCt1.text.trim().isEmpty) {
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

    // อัปโหลดภาพและรับ URL
    String? imageUrl = await uploadImage();

    // ตรวจสอบว่า imageUrl ไม่เป็น null
    if (imageUrl == null) {
      log('Image upload failed');
      return; // หยุดการสมัครสมาชิกหากไม่สามารถอัปโหลดภาพได้
    }

    // ทำการสมัครสมาชิก
    var model = RegisterRiderRequest(
        name: nameNoCt1.text,
        lastname: lastnameNoCt1.text,
        phone: phoneNoCt1.text,
        password: passwordNoCt1.text,
        img: imageUrl,
        carRegistration: diveNoCt1.text);

    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    try {
      var response = await http.post(
        Uri.parse("$url/rider/register"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: registerRiderRequestToJson(model),
      );

      log(response.body);
      var res = registerRiderResponeFromJson(response.body);

      if (response.body.contains('Phone number is already registered')) {
        // แสดงการแจ้งเตือนว่าเบอร์โทรศัพท์ถูกใช้งานซ้ำ
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(
                  child: Text(
                'เบอร์โทรศัพท์ซ้ำโปรดใช้เบอร์อื่น',
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
      } else {
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginRiderPage(),
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
      }
    } catch (e) {
      log('Error: $e');
      // แสดงป็อบอัพเมื่อมีข้อผิดพลาด
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'เบอร์โทรศัพท์ซ้ำโปรดใช้เบอร์อื่น',
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
