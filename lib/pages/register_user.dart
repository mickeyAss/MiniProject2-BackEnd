import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fontend_miniproject2/config/config.dart';
import 'package:fontend_miniproject2/pages/mapscreen.dart';
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
  TextEditingController addressNoCt1 = TextEditingController();
  TextEditingController latitudeNoCt1 = TextEditingController();
  TextEditingController longitudeNoCt1 = TextEditingController();

  final ImagePicker picker = ImagePicker();
  XFile? image;

  String downloadUrl = '';

  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'สมัครสมาชิก',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 128, 128, 128),
          ),
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
                          color: Colors.green), // สีของเส้นขอบเมื่อโฟกัส
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
                          color: Colors.green), // สีของเส้นขอบเมื่อโฟกัส
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
                          color: Colors.green), // สีของเส้นขอบเมื่อโฟกัส
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),
              // เพิ่มปุ่มเพื่อไปหน้าแสดงแผนที่
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the map screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MapScreenPage()), // เปลี่ยน MapScreenPage() เป็นหน้าจอแผนที่ของคุณ
                    );
                  },
                  child: Image.asset(
                    'assets/images/pngtree-cartoon-creative-map-location-image_2286149-Photoroom.png', // ใส่พาธของรูปภาพที่คุณต้องการ
                    width: 30, // กำหนดขนาดความกว้างของภาพ
                    height: 30, // กำหนดขนาดความสูงของภาพ
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: TextField(
                  controller: addressNoCt1,
                  keyboardType: TextInputType.text,
                  cursorColor: Colors.green, // เปลี่ยนสีของเคอร์เซอร์
                  decoration: InputDecoration(
                    hintText: 'ที่อยู่',
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
                          color: Colors.green), // สีของเส้นขอบเมื่อโฟกัส
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 15.0),
                      child: TextField(
                        controller: latitudeNoCt1,
                        keyboardType: TextInputType
                            .number, // เปลี่ยนเป็น number สำหรับละติจูด
                        cursorColor: Colors.green, // เปลี่ยนสีของเคอร์เซอร์
                        decoration: InputDecoration(
                          hintText: 'กรอกละติจูด',
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
                                color: Colors.green), // สีของเส้นขอบเมื่อโฟกัส
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 30.0),
                      child: TextField(
                        controller: longitudeNoCt1,
                        keyboardType: TextInputType
                            .number, // เปลี่ยนเป็น number สำหรับลองติจูด
                        cursorColor: Colors.green, // เปลี่ยนสีของเคอร์เซอร์
                        decoration: InputDecoration(
                          hintText: 'กรอกลองติจูด',
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
                                color: Colors.green), // สีของเส้นขอบเมื่อโฟกัส
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                    ),
                  ),
                ],
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
                          color: Colors.green), // สีของเส้นขอบเมื่อโฟกัส
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
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
                          color: Colors.green), // สีของเส้นขอบเมื่อโฟกัส
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
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
                ),
              ),

              // FilledButton(
              //   onPressed: () async {
              //     await uploadImage(); // เรียกใช้งานฟังก์ชันอัปโหลดรูปภาพ
              //   },
              //   style: FilledButton.styleFrom(
              //     backgroundColor: Color.fromARGB(255, 72, 0, 0),
              //     foregroundColor: Colors.white,
              //     padding: EdgeInsets.only(left: 140, right: 140),
              //     elevation: 15,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //   ),
              //   child: Text(
              //     'อัปโหลด',
              //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              //   ),
              // ),
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
    // ตรวจสอบให้แน่ใจว่าทุกช่องกรอกข้อมูลถูกต้องและไม่มีช่องว่าง
    if (nameNoCt1.text.trim().isEmpty ||
        lastnameNoCt1.text.trim().isEmpty ||
        phoneNoCt1.text.trim().isEmpty ||
        passwordNoCt1.text.trim().isEmpty ||
        conpasswordNoCt1.text.trim().isEmpty ||
        addressNoCt1.text.trim().isEmpty ||
        latitudeNoCt1.text.trim().isEmpty ||
        longitudeNoCt1.text.trim().isEmpty) {
      log('กรอกข้อมูลไม่ครบทุกช่องหรือมีช่องว่าง');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'กรุณากรอกข้อมูลให้ครบทุกช่องและไม่มีช่องว่าง',
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

    // แปลง latitude และ longitude เป็น double
    double? latitude;
    double? longitude;

    try {
      latitude = double.parse(latitudeNoCt1.text);
      longitude = double.parse(longitudeNoCt1.text);
    } catch (e) {
      log('Invalid latitude or longitude value');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              'กรุณากรอกค่า Latitude และ Longitude ให้ถูกต้อง',
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
    var model = RegisterUserRequest(
        name: nameNoCt1.text,
        lastname: lastnameNoCt1.text,
        phone: phoneNoCt1.text,
        password: passwordNoCt1.text,
        img: imageUrl,
        address: addressNoCt1.text,
        latitude: latitude.toString(),
        longitude: longitude.toString());

    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    try {
      var response = await http.post(
        Uri.parse("$url/user/register"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: registerUserRequestToJson(model),
      );

      // ล็อกข้อมูลการตอบสนอง
      log('Status code: ${response.statusCode}');
      log('Response body: ${response.body}');

      // แสดงป็อบอัพสำหรับสถานะสมัครสมาชิกสำเร็จ
      if (response.statusCode == 201) {
        // แสดงป็อบอัพเมื่อสมัครสมาชิกสำเร็จ
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
                            builder: (context) => LoginUserPage(),
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
                errorResponse['error'] ?? 'เกิดข้อผิดพลาด',
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
