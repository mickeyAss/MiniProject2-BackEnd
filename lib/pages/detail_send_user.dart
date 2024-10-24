import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fontend_miniproject2/config/config.dart';
import 'package:fontend_miniproject2/models/get_product.dart';
import 'package:fontend_miniproject2/pages/follow_product.dart';
import 'package:fontend_miniproject2/models/get_data_users.dart';
import 'package:fontend_miniproject2/pages/detail_product_receiver.dart';
import 'package:fontend_miniproject2/pages/detail_product_send_user.dart';

class DetailSendUserPage extends StatefulWidget {
  String track = "";
  int uid = 0;
  DetailSendUserPage({super.key, required this.track, required this.uid});

  @override
  State<DetailSendUserPage> createState() => _DetailSendUserPageState();
}

class _DetailSendUserPageState extends State<DetailSendUserPage> {
  late GetDataUsers user;
  late Future<void> loadData_User;
  late GetProduct getp;
  late Future<void> loadData;
  var firepro;

  bool isLoading = true; // ตัวแปรสถานะการโหลดข้อมูล

  var db = FirebaseFirestore.instance;

  void initState() {
    super.initState();
    loadData = loadDataProduct();
    loadData_User = loadDataUser();
    log(widget.track.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "รายละเอียดการจัดส่ง",
          style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 0, 0, 0)),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Stack(
        children: [
          if (isLoading) // แสดง CircularProgressIndicator ขณะรอข้อมูล
            Container(
                color: Color.fromARGB(255, 255, 255, 255),
                width: double.infinity,
                height: double.infinity,
                child: const Center(child: CircularProgressIndicator()))
          else
            Container(
              color: Color.fromARGB(255, 255, 255, 255),
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('inbox')
                        .where('tracking_number',
                            isEqualTo: widget.track) // กรองเฉพาะเลข track
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      var documents = snapshot.data!.docs;

                      if (documents.isEmpty) {
                        return const Center(
                            child: Text('ไม่พบข้อมูลที่มีเลขพัสดุตรงกัน'));
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          var firepro = documents[index].data();
                          String documentId = documents[index].id;

                          return ListTile(
                            subtitle: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("ผู้ส่ง",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(firepro['sender_name'],
                                          style:
                                              TextStyle(color: Colors.black38)),
                                      const SizedBox(width: 5),
                                      Text(firepro['sender_lastname'],
                                          style:
                                              TextStyle(color: Colors.black38)),
                                      const SizedBox(width: 10),
                                      Text(firepro['sender_phone'],
                                          style:
                                              TextStyle(color: Colors.black38)),
                                    ],
                                  ),
                                  Text(firepro['sender_address'],
                                      style: TextStyle(color: Colors.black38)),
                                  const SizedBox(height: 10),
                                  const Divider(
                                      thickness: 1, color: Colors.black26),
                                  const SizedBox(height: 10),
                                  const Text("ผู้รับ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(firepro['receiver_name'],
                                          style:
                                              TextStyle(color: Colors.black38)),
                                      const SizedBox(width: 5),
                                      Text(firepro['receiver_lastname'],
                                          style:
                                              TextStyle(color: Colors.black38)),
                                      const SizedBox(width: 10),
                                      Text(firepro['receiver_phone'],
                                          style:
                                              TextStyle(color: Colors.black38)),
                                    ],
                                  ),
                                  Text(firepro['receiver_address'],
                                      style: TextStyle(color: Colors.black38)),
                                  SizedBox(height: 30),
                                  FilledButton(
                                    onPressed: () {
                                      if (widget.uid ==
                                          firepro['receiver_uid']) {
                                        Get.to(() => DetailProductReceiverPage(
                                            track: firepro['tracking_number'],
                                            uid: widget.uid));
                                      } else if (widget.uid ==
                                          firepro['sender_uid']) {
                                        Get.to(() => DetailProductSendUserPage(
                                            track: firepro['tracking_number']));
                                      } else {
                                        // Do something when uid does not match

                                        log("User ID does not match any sender or receiver.");
                                      }
                                    },
                                    style: FilledButton.styleFrom(
                                      backgroundColor: Colors.black38,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("รายละเอียดสินค้า",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Row(
                                              children: [
                                                Text("สถานะ : ",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Color.fromARGB(
                                                            255, 72, 0, 0))),
                                                Text(firepro['pro_status'],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Color.fromARGB(
                                                            255, 72, 0, 0))),
                                              ],
                                            )
                                          ],
                                        ),
                                        Icon(Icons.arrow_forward_ios)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          // ปุ่มรับพัสดุอยู่ติดขอบล่าง
          if (!isLoading && getp.proStatus != "รอไรเดอร์มารับ")
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Container(
                width: 140, // กำหนดความกว้างของ Container
                height:
                    140, // กำหนดความสูงของ Container ให้เท่ากับความกว้างเพื่อให้เป็นวงกลม
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  shape: BoxShape.circle, // ทำให้ Container เป็นวงกลม
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Center(
                  // Align ปุ่มให้อยู่กลาง
                  child: ClipOval(
                    // ทำให้ปุ่มเป็นวงกลม
                    child: Material(
                      color: const Color.fromARGB(
                          255, 72, 0, 0), // สีพื้นหลังของปุ่ม
                      child: InkWell(
                        onTap: () {
                          Get.to(() => FollowProductPage(
                              uid: widget.uid, track: widget.track));
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.all(13.0), // ขนาดของปุ่มวงกลม
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/pngtree-cartoon-creative-map-location-image_2286149-Photoroom.png', // path ของรูปภาพ
                                width: 80, // ขนาดความกว้างของรูปภาพ
                                height: 80, // ขนาดความสูงของรูปภาพ
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> loadDataProduct() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    // เริ่มการโหลดข้อมูล
    setState(() {
      isLoading = true;
    });

    final response =
        await http.get(Uri.parse("$url/product/get/${widget.track}"));
    if (response.statusCode == 200) {
      getp = getProductFromJson(response.body);
      log(response.body);
    } else {
      log('Error loading product data: ${response.statusCode}');
    }

    // จบการโหลดข้อมูล
    setState(() {
      isLoading = false;
    });
  }

  // โหลดข้อมูล User
  Future<void> loadDataUser() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    final response = await http.get(Uri.parse("$url/user/get/${widget.uid}"));
    if (response.statusCode == 200) {
      user = getDataUsersFromJson(response.body);
      log(response.body);
      setState(() {});
    } else {
      log('Error loading user data: ${response.statusCode}');
    }
  }
}
