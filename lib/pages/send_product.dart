import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fontend_miniproject2/config/config.dart';
import 'package:fontend_miniproject2/pages/send_final.dart';
import 'package:fontend_miniproject2/models/get_data_users.dart';
import 'package:fontend_miniproject2/models/userId_userMyId.dart';

class SendProductPage extends StatefulWidget {
  int uid = 0;
  int myuid = 0;
  SendProductPage({super.key, required this.uid, required this.myuid});

  @override
  State<SendProductPage> createState() => _SendProductPageState();
}

class _SendProductPageState extends State<SendProductPage> {
  late GetDataUsers user;
  late Future<void> loadData_User;
  final ImagePicker picker = ImagePicker();
  XFile? image;
  TextEditingController nameProduct = TextEditingController();
  TextEditingController detailProduct = TextEditingController();
  LatLng latLng = const LatLng(16.246838875918495, 103.2520806150084);
  MapController mapController = MapController();
  List<Marker> markers = []; // รายการ marker
  late UserIdUserMyId getuid;

  @override
  void initState() {
    super.initState();
    loadData_User = loadDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'รายละเอียดพัสดุ',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Stack(
        children: [
          Container(
            color: Color.fromARGB(255, 255, 255, 255),
            width: double.infinity,
            height: double.infinity,
            child: GestureDetector(
              onTap: () {
                // ปิดคีย์บอร์ดเมื่อแตะที่พื้นที่ว่าง
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "กรอกรายละเอียดพัสดุ",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextField(
                        controller: nameProduct,
                        decoration: InputDecoration(
                          hintText: "ชื่อพัสดุ",
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              nameProduct.clear();
                              FocusScope.of(context)
                                  .unfocus(); // ปิดคีย์บอร์ดเมื่อปุ่มถูกกด
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: TextField(
                          controller: detailProduct,
                          decoration: InputDecoration(
                            hintText: "รายละเอียด",
                            hintStyle: const TextStyle(color: Colors.black26),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                detailProduct.clear();
                                FocusScope.of(context)
                                    .unfocus(); // ปิดคีย์บอร์ดเมื่อปุ่มถูกกด
                              },
                            ),
                          ),
                          minLines: 1,
                          maxLines: null,
                        ),
                      ),
                      OutlinedButton(
                          onPressed: () async {
                            image = await picker.pickImage(
                                source: ImageSource.gallery);
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
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.photo,
                                color: Color.fromARGB(255, 72, 0, 0),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "เพิ่มรูปถ่าย",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 72, 0, 0),
                                ),
                              ),
                            ],
                          )),
                      (image != null)
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              child: Container(
                                  width: 200,
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.file(
                                      File(image!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                            )
                          : Container(),
                      // ใช้ Expanded หรือ Flexible สำหรับ FlutterMap จะไม่ทำให้เกิดปัญหากับ SingleChildScrollView
                      SizedBox(
                        height: 300, // กำหนดขนาดความสูงของแผนที่
                        child: FlutterMap(
                          mapController: mapController,
                          options: MapOptions(
                            initialCenter: latLng,
                            initialZoom: 15.0,
                          ),
                          children: [
                            TileLayer(
                              // Display map tiles from any source
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
                              userAgentPackageName: 'com.example.app',
                              maxNativeZoom:
                                  19, // Scale tiles when the server doesn't support higher zoom levels
                            ),
                            MarkerLayer(
                              markers: markers,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 72, 0, 0),
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  if (nameProduct.text.isNotEmpty &&
                      detailProduct.text.isNotEmpty &&
                      image != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SendFinalPage(
                          uid: widget.uid,
                          myuid: widget.myuid,
                          nameProduct: nameProduct.text,
                          detailProduct: detailProduct.text,
                          image: image,
                        ),
                      ),
                    );
                  } else {
                    // แสดงข้อความแจ้งเตือนหากข้อมูลไม่ครบ
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('กรุณากรอกข้อมูลให้ครบถ้วน')),
                    );
                  }
                },
                child: const Text(
                  'ดำเนินการต่อ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // โหลดข้อมูล User
  Future<void> loadDataUser() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    final response = await http
        .get(Uri.parse("$url/user/get/${widget.uid}/${widget.myuid}"));
    if (response.statusCode == 200) {
      getuid = userIdUserMyIdFromJson(response.body);
      log(response.body);

      if (getuid.senderLatitude != null && getuid.senderLongitude != null) {
        try {
          double latitude = double.parse(getuid.senderLatitude!);
          double longitude = double.parse(getuid.senderLongitude!);

          // สร้าง marker จากตำแหน่งผู้ส่งโดยใช้รูปภาพแทน
          final senderMarker = Marker(
              point: LatLng(latitude, longitude),
              width: 40,
              height: 40,
              child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    size: 40,
                  )),
              alignment: Alignment.center);

          // อัพเดตสถานะให้แผนที่และ markers เปลี่ยนแปลง
          setState(() {
            markers.add(senderMarker);
            // ย้ายแผนที่ไปที่ตำแหน่งใหม่
            mapController.move(LatLng(latitude, longitude), 15.0);
          });
        } catch (e) {
          log('Error parsing sender latitude or longitude: $e');
        }
      }
    } else {
      log('Error loading product data: ${response.statusCode}');
    }
  }
}
