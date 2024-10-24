import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fontend_miniproject2/config/config.dart';
import 'package:fontend_miniproject2/pages/home_user.dart';
import 'package:fontend_miniproject2/pages/profile_user.dart';
import 'package:fontend_miniproject2/pages/select_login.dart';
import 'package:fontend_miniproject2/models/get_data_users.dart';
import 'package:fontend_miniproject2/pages/detail_send_user.dart';

class ProductListUserPage extends StatefulWidget {
  final int uid;

  ProductListUserPage({super.key, required this.uid});

  @override
  State<ProductListUserPage> createState() => _ProductListUserPageState();
}

class _ProductListUserPageState extends State<ProductListUserPage> {
  late GetDataUsers user;
  late Future<void> loadData_User;
  GetStorage gs = GetStorage();

  var firepro;

  var db = FirebaseFirestore.instance;

  bool isSentItemsVisible = false; // สำหรับรายการพัสดุที่จัดส่ง
  bool isReceivedItemsVisible = false; // สำหรับรายการพัสดุที่ได้รับ

  Color button1Color = const Color.fromARGB(255, 72, 0, 0);
  Color button2Color = const Color.fromARGB(255, 72, 0, 0);
  Color button1TextColor = Colors.white;
  Color button2TextColor = Colors.white;
  Color button1BorderColor = Colors.white;
  Color button2BorderColor = Colors.white;
  @override
  void initState() {
    super.initState();
    loadData_User = loadDataUser();
    log(loadData_User.toString());

    // เริ่มต้นด้วยการแสดงรายการพัสดุที่จัดส่ง
    isSentItemsVisible = true;
    isReceivedItemsVisible = false;

    // เรียกใช้งานฟังก์ชันที่ฟังการเปลี่ยนแปลงใน Firestore
    startRealtimeGet();

    // เปลี่ยนสีปุ่มให้ถูกต้อง
    changeButtonColor(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'รายการพัสดุ',
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 72, 0, 0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration:
                  const BoxDecoration(color: Color.fromARGB(255, 72, 0, 0)),
              child: FutureBuilder(
                future: loadData_User,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading user data'));
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        child: ClipOval(
                          child: Image.network(
                            user.img,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            user.lastname,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            // เมนูใน Drawer
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('หน้าหลัก'),
              onTap: () {
                Get.to(() => HomeUserPage(uid: widget.uid));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('โปรไฟล์'),
              onTap: () {
                Get.to(() => ProfileUser(uid: widget.uid));
              },
            ),
            ListTile(
              leading: const Icon(Icons.pin_drop_rounded),
              title: const Text('ที่อยู่'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('ออกจากระบบ'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Center(
                        child: Text('ยืนยันการออกจากระบบ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                      ),
                      actions: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              child: const Text('ยกเลิก',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 72, 0, 0))),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Color.fromARGB(255, 72, 0, 0),
                                    width: 2.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                              ),
                            ),
                            FilledButton(
                              child: const Text('ยืนยัน'),
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 72, 0, 0),
                                foregroundColor: Colors.white,
                                textStyle: const TextStyle(fontSize: 14),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                elevation: 5,
                              ),
                              onPressed: () {
                                gs.remove('uid');
                                Get.offAll(() => const SelectLoginPage());
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(255, 72, 0, 0),
            height: 150,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilledButton(
                        onPressed: () {
                          changeButtonColor(1);
                        },
                        child: Text(
                          "รายการพัสดุที่จัดส่ง",
                          style: TextStyle(color: button1TextColor),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: button1Color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: button1BorderColor,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      FilledButton(
                        onPressed: () {
                          changeButtonColor(2);
                        },
                        child: Text(
                          "รายการพัสดุที่ได้รับ",
                          style: TextStyle(color: button2TextColor),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: button2Color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0), // ขอบมน
                            side: BorderSide(
                              color: button2BorderColor, // สีของขอบ
                              width: 2, // ความหนาของขอบ
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('inbox')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      var documents =
                          snapshot.data!.docs; // ดึงข้อมูลเอกสารทั้งหมด
                      List<Map<String, dynamic>> sentItems = [];
                      List<Map<String, dynamic>> receivedItems = [];

                      // แยกเอกสารออกเป็นรายการที่จัดส่งและที่ได้รับ
                      for (var document in documents) {
                        Map<String, dynamic> firepro = document.data();
                        if (firepro['uid_fk_send'] == widget.uid) {
                          sentItems.add(firepro);
                        } else if (firepro['uid_fk_accept'] == widget.uid) {
                          receivedItems.add(firepro);
                        }
                      }
                      log("Received Items: ${receivedItems.length}"); // เพิ่มบรรทัดนี้เพื่อตรวจสอบจำนวนพัสดุที่ได้รับ

                      return Column(
                        children: [
                          // แสดงรายการพัสดุที่จัดส่ง
                          Visibility(
                            visible: isSentItemsVisible,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: sentItems.length,
                              itemBuilder: (context, index) {
                                var firepro = sentItems[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Container(
                                    color: Colors.black38,
                                    padding: const EdgeInsets.all(10),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                firepro['pro_status']
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 72, 0, 0),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "ผู้ส่ง : ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                firepro['sender_name']
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "ผู้รับ : ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                firepro['receiver_name']
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(firepro['tracking_number']
                                              .toString()),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Get.to(() =>
                                                        DetailSendUserPage(
                                                          track: firepro[
                                                              'tracking_number'],
                                                          uid: widget.uid,
                                                        ));
                                                  },
                                                  child: const Text(
                                                    "ดูรายละเอียดเพิ่มเติม >",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 72, 0, 0)),
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // แสดงรายการพัสดุที่ได้รับ
                          Visibility(
                            visible: isReceivedItemsVisible,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: receivedItems.length,
                              itemBuilder: (context, index) {
                                var firepro = receivedItems[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Container(
                                    color: Colors.black38,
                                    padding: const EdgeInsets.all(10),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                firepro['pro_status']
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 72, 0, 0),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "ผู้ส่ง : ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                firepro['sender_name']
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                "ผู้รับ : ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                firepro['receiver_name']
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(firepro['tracking_number']
                                              .toString()),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Get.to(() =>
                                                        DetailSendUserPage(
                                                          track: firepro[
                                                              'tracking_number'],
                                                          uid: widget.uid,
                                                        ));
                                                  },
                                                  child: const Text(
                                                    "ดูรายละเอียดเพิ่มเติม >",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 72, 0, 0)),
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void startRealtimeGet() {
    final inboxCollection = db.collection("inbox");

    inboxCollection.snapshots().listen((snapshot) {
      bool hasSentItems = false;
      bool hasReceivedItems = false;

      for (var document in snapshot.docs) {
        Map<String, dynamic> data = document.data();

        // เช็ค uid_fk_send กับ widget.uid เฉพาะรายการพัสดุที่จัดส่ง
        if (data['uid_fk_send'] == widget.uid) {
          hasSentItems = true;
        }

        // เช็ค uid_fk_receive กับ widget.uid เฉพาะรายการพัสดุที่ได้รับ
        if (data['uid_fk_receive'] == widget.uid) {
          hasReceivedItems = true;
        }
      }

      setState(() {
        // ปรับสถานะการแสดงผลทั้งพัสดุที่จัดส่งและได้รับ
        isSentItemsVisible = hasSentItems;
        isReceivedItemsVisible = hasReceivedItems;
      });
    }, onError: (error) => log("Listen failed: $error"));
  }

  void changeButtonColor(int buttonIndex) {
    setState(() {
      if (buttonIndex == 1) {
        isSentItemsVisible = true; // แสดงรายการพัสดุที่จัดส่ง
        isReceivedItemsVisible = false; // ซ่อนรายการพัสดุที่ได้รับ

        button1Color = Colors.white; // เปลี่ยนเป็นสีขาวเมื่อปุ่ม 1 ถูกกด
        button1TextColor = Colors.black; // เปลี่ยนสีตัวอักษรปุ่ม 1
        button1BorderColor = Colors.white; // เปลี่ยนสีขอบปุ่ม 1

        button2Color = const Color.fromARGB(255, 72, 0, 0); // รีเซ็ตปุ่ม 2
        button2TextColor = Colors.white; // รีเซ็ตสีตัวอักษรปุ่ม 2
        button2BorderColor = Colors.white; // รีเซ็ตสีขอบปุ่ม 2

        log("isSentItemsVisible: $isSentItemsVisible");
      } else {
        isSentItemsVisible = false; // ซ่อนรายการพัสดุที่จัดส่ง
        isReceivedItemsVisible = true; // แสดงรายการพัสดุที่ได้รับ

        button2Color = Colors.white; // เปลี่ยนเป็นสีขาวเมื่อปุ่ม 2 ถูกกด
        button2TextColor = Colors.black; // เปลี่ยนสีตัวอักษรปุ่ม 2
        button2BorderColor = Colors.white; // เปลี่ยนสีขอบปุ่ม 2

        button1Color = const Color.fromARGB(255, 72, 0, 0); // รีเซ็ตปุ่ม 1
        button1TextColor = Colors.white; // รีเซ็ตสีตัวอักษรปุ่ม 1
        button1BorderColor = Colors.white; // รีเซ็ตสีขอบปุ่ม 1

        log("isReceivedItemsVisible: $isReceivedItemsVisible");
      }
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
