import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fontend_miniproject2/config/config.dart';
import 'package:fontend_miniproject2/pages/send_rider.dart';
import 'package:fontend_miniproject2/pages/select_login.dart';
import 'package:fontend_miniproject2/pages/profile_user.dart';
import 'package:fontend_miniproject2/models/get_data_rider.dart';
import 'package:fontend_miniproject2/models/get_all_product.dart';

class HomeRiderPage extends StatefulWidget {
  final int rid;
  HomeRiderPage({super.key, required this.rid});

  @override
  State<HomeRiderPage> createState() => _HomeRiderPageState();
}

class _HomeRiderPageState extends State<HomeRiderPage> {
  GetStorage gs = GetStorage();
  late GetDataRider rider;
  late Future<void> loadData_Rider;
  TextEditingController doc1 = TextEditingController();
  TextEditingController header = TextEditingController();
  TextEditingController message = TextEditingController();

  var firepro;

  var db = FirebaseFirestore.instance;

  // เพิ่มตัวแปรสำหรับ StreamSubscription
  StreamSubscription<QuerySnapshot>? _subscription;

  @override
  void initState() {
    super.initState();
    loadData_Rider = loadDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FutureBuilder(
              future: loadData_Rider,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink(); // ไม่แสดงอะไรขณะรอข้อมูล
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error, color: Colors.white);
                }
                return ClipOval(
                  child: Image.network(
                    rider.img,
                    width: 30, // กำหนดขนาดให้เล็กลง
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ],
        ),
        // centerTitle: true,
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
                future: loadData_Rider,
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
                            rider.img,
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
                            rider.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            rider.lastname,
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
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('โปรไฟล์'),
              onTap: () {
                // Get.to(() => ProfileUser(uid: widget.uid));
              },
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
                                gs.remove('rid');
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
      body: Container(
        color: const Color.fromARGB(255, 72, 0, 0),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'งานเข้าแล้ว!!!',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40),
                textAlign: TextAlign.center,
              ),
              Image.asset(
                'assets/images/1f447.gif', // เปลี่ยนเป็น path ของ GIF ของคุณ
                width: 100, // กำหนดขนาดตามที่ต้องการ
                height: 100, // กำหนดขนาดตามที่ต้องการ
                fit: BoxFit.cover, // ควบคุมการตัดของภาพ
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 200,
                height: 200,
                child: FilledButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: const Radius.circular(20)),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: FractionallySizedBox(
                            heightFactor: 0.8,
                            widthFactor: 1.0,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'รายการงาน',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),

                                        const SizedBox(height: 20),

                                        // ใน StreamBuilder ให้ปรับปรุง onPressed ใน FilledButton
                                        StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('inbox')
                                              .where('pro_status',
                                                  isEqualTo:
                                                      'รอไรเดอร์มารับ') // กรองเอกสารที่มี prp_status เท่ากับ "รอไรเดอร์มารับ"
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return const Center(
                                                  child:
                                                      CircularProgressIndicator());
                                            }

                                            var documents = snapshot.data!.docs;

                                            return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: documents.length,
                                              itemBuilder: (context, index) {
                                                var firepro =
                                                    documents[index].data();
                                                String documentId =
                                                    documents[index].id;

                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: Color.fromARGB(
                                                        255, 72, 0, 0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10), // มุมโค้ง
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors
                                                            .black26, // สีเงา
                                                        blurRadius:
                                                            5, // ความเบลอของเงา
                                                        offset: Offset(
                                                            2, 2), // ตำแหน่งเงา
                                                      ),
                                                    ],
                                                  ),
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      vertical:
                                                          10), // ระยะห่างระหว่าง ExpansionTile

                                                  child: ExpansionTile(
                                                    title: Row(
                                                      children: [
                                                        Text(
                                                          'พัสดุ : ${firepro['pro_name'].toString()}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight: FontWeight
                                                                  .bold), // เปลี่ยนสีข้อความให้เป็นสีขาว
                                                        ),
                                                      ],
                                                    ),
                                                    children: <Widget>[
                                                      ListTile(
                                                        title: const Text(
                                                          'รายละเอียดสินค้า',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .white, // เปลี่ยนสีข้อความให้เป็นสีขาว
                                                          ),
                                                        ),
                                                        subtitle: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              firepro['pro_detail']
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white), // เปลี่ยนสีข้อความให้เป็นสีขาว
                                                            ),
                                                            Text(
                                                              'เลขพัสดุ : ${firepro['tracking_number'].toString()}',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white), // เปลี่ยนสีข้อความให้เป็นสีขาว
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12), // ปรับรัศมีของมุม
                                                              child:
                                                                  Image.network(
                                                                firepro[
                                                                    'pro_img'],
                                                                width: 100,
                                                                height: 100,
                                                                fit: BoxFit
                                                                    .cover, // ปรับขนาดรูปให้เต็มพื้นที่
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: Container(
                                                          width: double
                                                              .infinity, // กำหนดให้เต็มขอบจอ
                                                          child: FilledButton(
                                                            style: FilledButton
                                                                .styleFrom(
                                                              backgroundColor:
                                                                  Colors
                                                                      .white, // กำหนดสีพื้นหลังเป็นสีขาว
                                                              foregroundColor:
                                                                  Colors
                                                                      .black, // กำหนดสีข้อความเป็นสีดำ

                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20), // มุมโค้ง
                                                              ),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              try {
                                                                // อัปเดตสถานะเมื่อกดปุ่มรับงาน
                                                                await updateProStatus(
                                                                    documentId);

                                                                // เปลี่ยนหน้าไปยัง SendRederPage
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            SendRederPage(
                                                                      trackingNumber:
                                                                          firepro[
                                                                              'tracking_number'],
                                                                      rid: widget
                                                                          .rid,
                                                                    ),
                                                                  ),
                                                                );
                                                              } catch (e) {
                                                                // จัดการข้อผิดพลาด
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  SnackBar(
                                                                      content: Text(
                                                                          'Error updating status: $e')),
                                                                );
                                                              }
                                                            },
                                                            child: const Text(
                                                                'รับงาน'),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/box.png',
                            width: 100, height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // โหลดข้อมูล User
  Future<void> loadDataUser() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    final response = await http.get(Uri.parse("$url/rider/get/${widget.rid}"));
    if (response.statusCode == 200) {
      rider = getDataRiderFromJson(response.body);
      log(response.body);
      setState(() {});
    } else {
      log('Error loading user data: ${response.statusCode}');
    }
  }

  void startRealtimeGet() {
    final inboxCollection = db.collection("inbox");

    // ฟังข้อมูลทั้งหมดในคอลเล็กชัน inbox แบบเรียลไทม์ ที่มี pro_status เป็น "รอไรเดอร์มารับ"
    _subscription = inboxCollection
        .where('pro_status', isEqualTo: 'รอไรเดอร์มารับ') // กรองข้อมูล
        .snapshots()
        .listen(
      (snapshot) {
        for (var document in snapshot.docs) {
          firepro = document.data();
          log("Current data: ${document.data()}");
        }
      },
      onError: (error) => log("Listen failed: $error"),
    );
  }

  // ฟังก์ชันยกเลิกการฟังข้อมูลแบบเรียลไทม์
  void cancelRealtimeGet() {
    _subscription?.cancel();
    log('Real-time listening cancelled');
  }

  // ฟังก์ชันสำหรับอัปเดตสถานะ
  Future<void> updateProStatus(String documentId) async {
    try {
      // อัปเดตสถานะใน Firestore
      await FirebaseFirestore.instance
          .collection('inbox')
          .doc(documentId)
          .update({
        'pro_status': 'ไรเดอร์กำลังไปรับพัสดุ', // อัปเดตสถานะ
      });
      log('Status updated successfully');

      // ดึงข้อมูลจาก Firestore
      var documentSnapshot = await FirebaseFirestore.instance
          .collection('inbox')
          .doc(documentId)
          .get();

      if (documentSnapshot.exists) {
        var data = documentSnapshot.data();
        var uidSend = data?['uid_fk_send']; // ดึงค่า uid_send
        var uidAccept = data?['uid_fk_accept']; // ดึงค่า uid_accept
        var proStatus = data?['pro_status']; // ดึงค่า pro_status
        var tracking = data?['tracking_number'];

        var config = await Configuration.getConfig();
        var url = config['apiEndpoint'];

        // เตรียมข้อมูลสำหรับ POST ไปยังเส้น API ของ status
        var postData = {
          "uid_send": uidSend,
          "uid_accept": uidAccept,
          "staname": proStatus,
          "tacking": tracking,
        };

        // POST ข้อมูลไปยัง API
        final postResponse = await http.post(
          Uri.parse("$url/product/add-status"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(postData),
        );

        if (postResponse.statusCode == 201) {
          log('Status successfully posted to API');
        } else {
          log('Failed to post status: ${postResponse.body}');
          return; // หยุดการทำงานหาก POST ไม่สำเร็จ
        }

        final updaterid = await http.put(
          Uri.parse("$url/product/update-rid/${documentId}"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"rid_fk": widget.rid}),
        );

        if (updaterid.statusCode == 200) {
          log('RID successfully updated to API');
        } else {
          log('Failed to update status: ${updaterid.body}');
          return; // หยุดการทำงานหาก PUT ไม่สำเร็จ
        }
      } else {
        log('Document does not exist');
      }
    } catch (e) {
      log('Error updating status: $e');
    }
  }
}
