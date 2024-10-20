import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:fontend_miniproject2/config/config.dart';
import 'package:fontend_miniproject2/pages/send_final.dart';
import 'package:fontend_miniproject2/models/get_data_users.dart';

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
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  "กรอกรายละเอียดพัสดุ",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              TextField(
                controller: nameProduct,
                decoration: InputDecoration(
                    hintText: "ชื่อพัสดุ",
                    hintStyle: const TextStyle(color: Colors.black26),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: TextField(
                  controller: detailProduct,
                  decoration: InputDecoration(
                      hintText: "รายละเอียด",
                      hintStyle: const TextStyle(color: Colors.black26),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  minLines: 1,
                  maxLines: null,
                ),
              ),
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
                      padding: const EdgeInsets.only(top: 20),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 72, 0, 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
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
                    child: Text('ถัดไป'),
                  ),
                ],
              )
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

    final response = await http
        .get(Uri.parse("$url/user/get/${widget.uid}/${widget.myuid}"));
    log('Requesting URL: $url');
    log(response.body);
  }
}
