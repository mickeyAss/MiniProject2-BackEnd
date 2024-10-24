import 'dart:io';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fontend_miniproject2/config/config.dart';
import 'package:fontend_miniproject2/models/get_status.dart';
import 'package:fontend_miniproject2/models/get_product.dart';

class DetailProductReceiverPage extends StatefulWidget {
  String track = "";
  int uid = 0;
  DetailProductReceiverPage(
      {super.key, required this.track, required this.uid});

  @override
  State<DetailProductReceiverPage> createState() =>
      _DetailProductReceiverPageState();
}

class _DetailProductReceiverPageState extends State<DetailProductReceiverPage> {
  late GetProduct getp;
  late Future<void> loadData;

  List<GetStatus> getstatus = [];

  String? imagePath; // ตัวแปรเก็บที่อยู่ของรูปภาพที่ถ่าย

  bool isLoading = false;

  void initState() {
    super.initState();
    loadData = loadDataProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "รายละเอียดสินค้า",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                  future: loadData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              'Error loading user data: ${snapshot.error}'));
                    }
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                getp.proName,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "เลขพัสดุ : ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(getp.trackingNumber)
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            getp.proDetail,
                            style: TextStyle(color: Colors.black45),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  getp.proImg,
                                  width: 450,
                                  height: 300,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              isLoading
                  ? CircularProgressIndicator() // แสดงการโหลด
                  : FutureBuilder(
                      future: loadData,
                      builder: (context, snapshot) {
                        return SingleChildScrollView(
                          child: Column(
                            children: getstatus.asMap().entries.map((entry) {
                              int index = entry.key;
                              GetStatus e = entry.value;

                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    child: const Divider(
                                        height: 30,
                                        thickness: 1,
                                        color: Colors.grey),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20.0),
                                        child: Text(
                                          'สถานะ : ${e.staname}',
                                          style: TextStyle(
                                              color:
                                                  Color.fromARGB(255, 72, 0, 0),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Check if the current index is 0 (first item)
                                  if (index == 0)
                                    if (index == 0)
                                      StreamBuilder<DocumentSnapshot>(
                                        stream: FirebaseFirestore.instance
                                            .collection('inbox')
                                            .doc(getp.pid.toString())
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }

                                          if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error: ${snapshot.error}'));
                                          }

                                          if (!snapshot.hasData ||
                                              !snapshot.data!.exists) {
                                            return Center(
                                                child: Text(
                                                    'Document does not exist'));
                                          }

                                          var data = snapshot.data!.data()
                                              as Map<String, dynamic>;
                                          String? imageStatus1 =
                                              data['image_status1'];

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0, right: 20.0),
                                            child: imageStatus1 == null
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'รูปภาพจากผู้ส่ง',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      Text(
                                                        'ผู้ส่งไม่ได้ถ่ายรูป',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'รูปภาพจากผู้ส่ง',
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                            child:
                                                                Image.network(
                                                              imageStatus1, // แสดงรูปภาพจาก Firestore
                                                              width: 100,
                                                              height: 100,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                          );
                                        },
                                      ),

                                  if (index == 2)
                                    StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('inbox')
                                          .doc(getp.pid.toString())
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }

                                        if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}'));
                                        }

                                        if (!snapshot.hasData ||
                                            !snapshot.data!.exists) {
                                          return Center(
                                              child: Text(
                                                  'Document does not exist'));
                                        }

                                        var data = snapshot.data!.data()
                                            as Map<String, dynamic>;
                                        String? imageStatus3 =
                                            data['image_status3'];

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          child: imageStatus3 == null
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 150,
                                                  child: OutlinedButton(
                                                    onPressed: openCamera,
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      side: BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 72, 0, 0),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.camera_alt,
                                                          size: 60,
                                                          color: Color.fromARGB(
                                                              255, 72, 0, 0),
                                                        ),
                                                        Text(
                                                          'ถ่ายรูปภาพประกอบสถานะ',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    72,
                                                                    0,
                                                                    0),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'รูปภาพจากไรเดอร์',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          child: Image.network(
                                                            imageStatus3, // แสดงรูปภาพจาก Firestore
                                                            width: 100,
                                                            height: 100,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                        );
                                      },
                                    ),
                                  if (index == 3)
                                    StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('inbox')
                                          .doc(getp.pid.toString())
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }

                                        if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}'));
                                        }

                                        if (!snapshot.hasData ||
                                            !snapshot.data!.exists) {
                                          return Center(
                                              child: Text(
                                                  'Document does not exist'));
                                        }

                                        var data = snapshot.data!.data()
                                            as Map<String, dynamic>;
                                        String? imageStatus4 =
                                            data['image_status4'];

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.0, right: 20.0),
                                          child: imageStatus4 == null
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 150,
                                                  child: OutlinedButton(
                                                    onPressed: openCamera,
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      side: BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 72, 0, 0),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.camera_alt,
                                                          size: 60,
                                                          color: Color.fromARGB(
                                                              255, 72, 0, 0),
                                                        ),
                                                        Text(
                                                          'ถ่ายรูปภาพประกอบสถานะ',
                                                          style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    72,
                                                                    0,
                                                                    0),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'รูปภาพจากไรเดอร์',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          child: Image.network(
                                                            imageStatus4, // แสดงรูปภาพจาก Firestore
                                                            width: 100,
                                                            height: 100,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                        );
                                      },
                                    ),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadDataProduct() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    final response =
        await http.get(Uri.parse("$url/product/get/${widget.track}"));
    if (response.statusCode == 200) {
      getp = getProductFromJson(response.body);
      log(response.body);
      setState(() {});
    } else {
      log('Error loading user data: ${response.statusCode}');
    }

    final responsestatus =
        await http.get(Uri.parse("$url/product/get-status/${widget.track}"));
    if (responsestatus.statusCode == 200) {
      getstatus = getStatusFromJson(responsestatus.body);
      log(response.body);
    } else {
      log('Error loading user data: ${response.statusCode}');
    }
  }

  // ฟังก์ชันสำหรับเปิดกล้อง
  Future<void> openCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        imagePath = photo.path; // เก็บที่อยู่ของรูปภาพที่ถ่าย
      });
      log('Image path: ${photo.path}');

      // เรียกใช้ฟังก์ชัน updateProStatus ทันทีหลังจากถ่ายภาพ
      await updateProStatus();
    } else {
      log('No image selected.');
    }
  }

  Future<String?> uploadImage() async {
    if (imagePath != null) {
      try {
        // สร้าง reference ไปยัง Firebase Storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

        // อัปโหลดไฟล์ไปยัง Firebase Storage
        await ref.putFile(File(imagePath!));

        // รับ URL ของภาพที่อัปโหลด
        String downloadUrl = await ref.getDownloadURL();

        log('Image uploaded successfully: $downloadUrl');
        return downloadUrl; // ส่งกลับ URL
      } catch (e) {
        log('Error uploading image: $e');
        return null; // ส่งกลับ null หากเกิดข้อผิดพลาด
      }
    } else {
      log('No image selected');
      return null; // ส่งกลับ null หากไม่มีรูปภาพ
    }
  }

  Future<void> updateProStatus() async {
    setState(() {
      isLoading = true; // หยุดการโหลดเมื่อทำงานเสร็จ
    });
    CollectionReference inboxCollection =
        FirebaseFirestore.instance.collection('inbox');

    DocumentReference documentRef = inboxCollection.doc(getp.pid.toString());
    DocumentSnapshot docSnapshot = await documentRef.get();

    if (docSnapshot.exists) {
      // ดึงข้อมูลจากเอกสาร
      var data = docSnapshot.data() as Map<String, dynamic>;
      log('Document data: ${data}');

      // อัปโหลดรูปภาพไปยัง Firebase Storage และรับ URL
      String? imageUrl = await uploadImage();

      if (imageUrl != null) {
        // ถ้ามีเอกสารที่ตรงกับ documentId ให้ทำการอัปเดต pro_status และเพิ่ม URL รูปภาพ
        await documentRef.update({
          'image_status1': imageUrl // เพิ่ม URL รูปภาพเข้าในเอกสาร
        });
        setState(() {
          isLoading = false; // หยุดการโหลดเมื่อทำงานเสร็จ
        });
        log('Updated pro_status and image_url for documentId: ${getp.pid}');
      } else {
        log('Image upload failed.');
        return; // หยุดการทำงานหากอัปโหลดรูปภาพไม่สำเร็จ
      }
    } else {
      log('Document does not exist');
    }
  }
}
