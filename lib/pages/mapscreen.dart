import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';

class MapScreenPage extends StatefulWidget {
  const MapScreenPage({super.key});

  @override
  State<MapScreenPage> createState() => _MapScreenPageState();
}

class _MapScreenPageState extends State<MapScreenPage> {
  final TextEditingController searchController = TextEditingController();
  LatLng currentLocation = const LatLng(
      16.246825669508297, 103.25199289277295); // เริ่มต้นที่พิกัดนี้
  List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    MapController mapController = MapController();

    return Scaffold(
      appBar: AppBar(
        title: Text('แผนที่'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'ค้นหาสถานที่...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    String searchQuery = searchController.text;
                    try {
                      List<Location> locations =
                          await locationFromAddress(searchQuery);
                      if (locations.isNotEmpty) {
                        Location location = locations.first;
                        setState(() {
                          // อัปเดตตำแหน่งปัจจุบัน
                          currentLocation =
                              LatLng(location.latitude, location.longitude);
                          // ล้าง markers เก่าและเพิ่ม marker ใหม่
                          markers = [
                            Marker(
                              point: currentLocation,
                              width: 40,
                              height: 40,
                              child: GestureDetector(
                                onTap: () {
                                  // แสดงพิกัดเมื่อกดที่ Marker
                                  _showCoordinates(
                                      location.latitude, location.longitude);
                                },
                                child: const Icon(
                                  Icons.location_on,
                                  size: 40,
                                  color: Color.fromARGB(255, 11, 0, 215),
                                ),
                              ),
                            ),
                          ];
                        });
                        // อัปเดตแผนที่
                        mapController.move(currentLocation, 15.0);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('ไม่พบสถานที่นี้')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: currentLocation,
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                  maxNativeZoom: 19,
                ),
                MarkerLayer(
                  markers: markers,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันเพื่อแสดงพิกัดใน AlertDialog
  void _showCoordinates(double latitude, double longitude) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('พิกัด'),
        content: Text('ละติจูด: $latitude\nลองจิจูด: $longitude'),
        actions: [
          TextButton(
            child: Text('คัดลอกละติจูด'),
            onPressed: () {
              // คัดลอกละติจูดไปยังคลิปบอร์ด
              Clipboard.setData(ClipboardData(text: '$latitude'));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('คัดลอกละติจูดแล้ว')),
              );
              Navigator.of(context).pop(); // ปิด AlertDialog หลังจากคัดลอก
            },
          ),
          TextButton(
            child: Text('คัดลอกลองจิจูด'),
            onPressed: () {
              // คัดลอกลองจิจูดไปยังคลิปบอร์ด
              Clipboard.setData(ClipboardData(text: '$longitude'));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('คัดลอกลองจิจูดแล้ว')),
              );
              Navigator.of(context).pop(); // ปิด AlertDialog หลังจากคัดลอก
            },
          ),
          TextButton(
            child: Text('ปิด'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
