import 'dart:io';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fontend_miniproject2/config/config.dart';
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

  final ImagePicker picker = ImagePicker();
  XFile? image;
  var firepro;

  bool isUploading = false;

  var db = FirebaseFirestore.instance;

  void initState() {
    super.initState();
    loadData = loadDataProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายละเอียดสินค้า"),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder(
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
            return const Center(child: Text('ไม่พบข้อมูลที่มีเลขพัสดุตรงกัน'));
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var firepro = documents[index].data();
              String documentId = documents[index].id;

              return ListTile(
                  subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          firepro['pro_name'],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              "เลขพัสดุ : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(firepro['tracking_number'])
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      firepro['pro_detail'],
                      style: TextStyle(color: Colors.black45),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            firepro['pro_img'],
                            width: 450,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1, // ความหนาของเส้น
                      color: Colors.black26, // สีของเส้น
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "สถานะ : ",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 72, 0, 0)),
                        ),
                        Text(
                          firepro['pro_status'],
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 72, 0, 0)),
                        ),
                      ],
                    ),
                  ],
                ),
              ));
            },
          );
        },
      ),
    );
  }

  void startRealtimeGet() {
    final inboxCollection = db.collection("inbox");

    // ฟังข้อมูลทั้งหมดในคอลเล็กชัน inbox แบบเรียลไทม์
    inboxCollection.snapshots().listen(
      (snapshot) {
        bool hasSentItems = false; // ตัวแปรเช็คว่ามีรายการพัสดุที่จัดส่งไหม

        for (var document in snapshot.docs) {
          Map<String, dynamic> data = document.data();

          // เช็คค่า Track จาก widget.track เฉพาะรายการที่ Track ตรงกัน
          if (data['Track'] == widget.track) {
            hasSentItems = true; // ถ้ามีรายการพัสดุที่จัดส่งให้ปรับเป็น true
            log("Current data: ${data}");
          }
        }

        if (!hasSentItems) {
          log("No items found with the specified Track.");
        }
      },
      onError: (error) => log("Listen failed: $error"),
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
  }
}
