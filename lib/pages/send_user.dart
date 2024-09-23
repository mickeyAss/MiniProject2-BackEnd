import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fontend_miniproject2/config/config.dart';
import 'package:fontend_miniproject2/pages/send_product.dart';
import 'package:fontend_miniproject2/models/get_data_users.dart';
import 'package:fontend_miniproject2/models/search_user_respone.dart';

class SendUserPage extends StatefulWidget {
  int uid = 0;
  SendUserPage({super.key, required this.uid});

  @override
  State<SendUserPage> createState() => _SendUserPageState();
}

class _SendUserPageState extends State<SendUserPage> {
  TextEditingController _addressController = TextEditingController();
  String searchResult = 'กรุณากรอกที่อยู่';
  List<SearchUserRespone> suggestions = [];

  late GetDataUsers user;
  late Future<void> loadData_User;

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
          'ส่งพัสดุ',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(30, 0, 0, 10),
            child: Text(
              "รายละเอียดการจัดส่ง",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: "กรอกเบอร์โทรศัพท์เพื่อค้นหาผู้รับ",
                hintStyle: TextStyle(
                  color: Colors.black38,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.black12,
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.black38),
                  onPressed: () {
                    String address = _addressController.text;
                    _performSearch(address);
                  },
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              ),
              onChanged: (value) {
                setState(() {
                  searchResult = ''; // ล้าง searchResult เมื่อมีการกรอกข้อมูล
                });
                _getSuggestions(value);
              },
            ),
          ),
          if (suggestions.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: suggestions.length,
                separatorBuilder: (context, index) =>
                    Divider(), // เส้นกั้นระหว่างข้อมูล
                itemBuilder: (context, index) {
                  return Container(
                    color: const Color.fromARGB(
                        255, 255, 255, 255), // สีพื้นหลังของรายการ
                    child: ListTile(
                      title: Text(suggestions[index].address),
                      onTap: () {
                        // เมื่อเลือกข้อมูล ส่ง uid ไปยัง NextPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendProductPage(
                              uid: suggestions[index].uid,
                              myuid: widget.uid,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          Center(
            child: Text(
              searchResult,
              style: TextStyle(
                  color: const Color.fromARGB(255, 200, 200, 200),
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          )
        ],
      ),
    );
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

  void _performSearch(String address) async {
    if (address.isNotEmpty) {
      var config = await Configuration.getConfig();
      var url = config['apiEndpoint'];
      var data = Uri.parse('$url/user/search-address/$address');
      var response = await http.get(data);

      if (response.statusCode == 200) {
        var data = searchUserResponeFromJson(response.body);
        setState(() {
          suggestions = data; // เก็บข้อมูลทั้งหมดลงใน suggestions
          log(response.body);
        });
      } else {
        setState(() {
          searchResult = "ไม่พบข้อมูลที่อยู่";
        });
      }
    } else {
      setState(() {
        searchResult = "กรุณากรอกที่อยู่";
      });
    }
  }

  void _getSuggestions(String query) async {
    if (query.isNotEmpty) {
      var config = await Configuration.getConfig();
      var url = config['apiEndpoint'];
      var data = Uri.parse('$url/user/search-address/$query');
      var response = await http.get(data);

      if (response.statusCode == 200) {
        var data = searchUserResponeFromJson(response.body);
        setState(() {
          if (data.isNotEmpty) {
            suggestions = data;
            searchResult = ''; // ล้าง searchResult ถ้ามีข้อมูล
          } else {
            suggestions.clear(); // ล้างลิสต์หากไม่พบข้อมูล
            searchResult = "ไม่พบข้อมูลที่อยู่"; // อาจจะแสดงข้อความที่เหมาะสม
          }
        });
      } else {
        setState(() {
          suggestions.clear(); // ล้างลิสต์ถ้าเกิดข้อผิดพลาด
          searchResult = "ไม่พบข้อมูลที่อยู่"; // อาจจะแสดงข้อความที่เหมาะสม
        });
      }
    } else {
      setState(() {
        suggestions.clear(); // ล้างลิสต์หากไม่มีการพิมพ์
        searchResult = ''; // ล้างข้อความผลลัพธ์
      });
    }
  }
}