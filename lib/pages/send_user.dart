import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fontend_miniproject2/config/config.dart';
import 'package:fontend_miniproject2/pages/send_product.dart';
import 'package:fontend_miniproject2/models/get_all_user.dart';
import 'package:fontend_miniproject2/models/get_data_users.dart';
import 'package:fontend_miniproject2/models/search_user_respone.dart';

class SendUserPage extends StatefulWidget {
  final int uid;
  SendUserPage({super.key, required this.uid});

  @override
  State<SendUserPage> createState() => _SendUserPageState();
}

class _SendUserPageState extends State<SendUserPage> {
  TextEditingController phone = TextEditingController();
  String searchResult = 'กรุณากรอกเบอร์โทรศัพท์';
  List<SearchUserRespone> suggestions = [];
  late GetDataUsers user;
  late Future<void> loadData_User;
  List<GetAllUser> allUsers = [];
  late Future<void> loadData_allUser;

  @override
  void initState() {
    super.initState();
    loadData_User = loadDataUser();
    loadData_allUser = loadAllUsers(); // เรียกใช้ฟังก์ชันดึงข้อมูลสมาชิกทั้งหมด
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ค้นหาผู้รับพัสดุ',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: TextField(
                controller: phone,
                decoration: InputDecoration(
                  hintText: "กรอกเบอร์โทรศัพท์เพื่อค้นหาผู้รับ",
                  hintStyle: TextStyle(color: Colors.black38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.black12,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.black38),
                    onPressed: () {
                      String phone_phone = phone.text;
                      _performSearch(phone_phone);
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

            Padding(
              padding: const EdgeInsets.only(left: 23),
              child: Row(
                children: [
                  Text(
                    'รายชื่อผู้ใช้ทั้งหมด',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 148, 148, 148)),
                  ),
                ],
              ),
            ),

            // แสดงผลลัพธ์การค้นหาแทนที่ข้อมูลทั้งหมด
            if (suggestions.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  itemCount: suggestions
                      .where((user) => user.uid != widget.uid)
                      .length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 20), // ปรับระยะห่างระหว่างรายการ
                  itemBuilder: (context, index) {
                    final filteredSuggestions = suggestions
                        .where((user) => user.uid != widget.uid)
                        .toList();
                    return GestureDetector(
                      onTap: () {
                        // เมื่อเลือกข้อมูล ส่ง uid ไปยังหน้าอื่น
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendProductPage(
                              uid: filteredSuggestions[index].uid,
                              myuid: widget.uid,
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                filteredSuggestions[index].img,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.grey,
                                    child:
                                        Icon(Icons.person, color: Colors.white),
                                  );
                                },
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(filteredSuggestions[index].name),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Expanded(
                child: FutureBuilder(
                  future: loadData_allUser,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (allUsers.isEmpty) {
                      return Center(child: Text('ไม่มีข้อมูลสมาชิก'));
                    } else {
                      // กรองผู้ใช้ที่ไม่ใช่เจ้าของแอคเคาท์ (uid != widget.uid)
                      final filteredUsers = allUsers
                          .where((user) => user.uid != widget.uid)
                          .toList();

                      if (filteredUsers.isEmpty) {
                        return Center(child: Text('ไม่มีสมาชิกที่จะแสดงผล'));
                      }

                      return ListView.builder(
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // เมื่อเลือกผู้ใช้ ส่ง uid ไปยังหน้าอื่น
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SendProductPage(
                                    uid: filteredUsers[index].uid,
                                    myuid: widget.uid,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10), // เพิ่มระยะห่างระหว่างรายการ
                              child: Center(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  width: 350,
                                  height: 80,
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          filteredUsers[index].img,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Icon(Icons.person, size: 40);
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          '${filteredUsers[index].name} ${filteredUsers[index].lastname}',
                                          style: TextStyle(fontSize: 16),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ฟังก์ชันดึงข้อมูลสมาชิกทั้งหมด
  Future<void> loadAllUsers() async {
    var config = await Configuration.getConfig();
    var url = config['apiEndpoint'];

    final response = await http.get(Uri.parse("$url/user/get"));
    if (response.statusCode == 200) {
      allUsers = getAllUserFromJson(response.body);
      log('Response: ${response.body}');
      log('All users: $allUsers');
    } else {
      log('Error loading user data: ${response.statusCode}');
    }
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

  void _performSearch(String phone) async {
    if (phone.isNotEmpty) {
      var config = await Configuration.getConfig();
      var url = config['apiEndpoint'];
      var data = Uri.parse('$url/user/search-phone/$phone');
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
        searchResult = "กรุณากรอกเบอร์โทรศัพท์";
      });
    }
  }

  void _getSuggestions(String query) async {
    if (query.isNotEmpty) {
      var config = await Configuration.getConfig();
      var url = config['apiEndpoint'];
      var data = Uri.parse('$url/user/search-phone/$query');
      var response = await http.get(data);

      if (response.statusCode == 200) {
        var data = searchUserResponeFromJson(response.body);
        setState(() {
          if (data.isNotEmpty) {
            suggestions = data;
            searchResult = ''; // ล้าง searchResult ถ้ามีข้อมูล
          } else {
            suggestions.clear(); // ล้างลิสต์หากไม่พบข้อมูล
            searchResult = "ไม่พบข้อมูล"; // อาจจะแสดงข้อความที่เหมาะสม
          }
        });
      } else {
        setState(() {
          suggestions.clear(); // ล้างลิสต์ถ้าเกิดข้อผิดพลาด
          searchResult = "ไม่พบข้อมูล"; // อาจจะแสดงข้อความที่เหมาะสม
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
