import 'dart:convert';
// To parse this JSON data, do
//
//     final followProduct = followProductFromJson(jsonString);

List<FollowProduct> followProductFromJson(String str) =>
    List<FollowProduct>.from(
        json.decode(str).map((x) => FollowProduct.fromJson(x)));

String followProductToJson(List<FollowProduct> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FollowProduct {
  int pid;
  String proName;
  String proDetail;
  String proImg;
  String proStatus;
  String trackingNumber;
  int uidFkSend;
  int uidFkAccept;
  dynamic ridFk;
  String senderName;
  String senderLastname;
  String senderPhone;
  String senderAddress;
  String senderLatitude;
  String senderLongitude;
  String receiverName;
  String receiverLastname;
  String receiverPhone;
  String receiverAddress;
  String receiverLatitude;
  String receiverLongitude;
  dynamic riderName;
  dynamic riderLastname;
  dynamic riderPhone;

  FollowProduct({
    required this.pid,
    required this.proName,
    required this.proDetail,
    required this.proImg,
    required this.proStatus,
    required this.trackingNumber,
    required this.uidFkSend,
    required this.uidFkAccept,
    required this.ridFk,
    required this.senderName,
    required this.senderLastname,
    required this.senderPhone,
    required this.senderAddress,
    required this.senderLatitude,
    required this.senderLongitude,
    required this.receiverName,
    required this.receiverLastname,
    required this.receiverPhone,
    required this.receiverAddress,
    required this.receiverLatitude,
    required this.receiverLongitude,
    required this.riderName,
    required this.riderLastname,
    required this.riderPhone,
  });

  factory FollowProduct.fromJson(Map<String, dynamic> json) => FollowProduct(
        pid: json["pid"],
        proName: json["pro_name"],
        proDetail: json["pro_detail"],
        proImg: json["pro_img"],
        proStatus: json["pro_status"],
        trackingNumber: json["tracking_number"],
        uidFkSend: json["uid_fk_send"],
        uidFkAccept: json["uid_fk_accept"],
        ridFk: json["rid_fk"],
        senderName: json["sender_name"],
        senderLastname: json["sender_lastname"],
        senderPhone: json["sender_phone"],
        senderAddress: json["sender_address"],
        senderLatitude: json["sender_latitude"],
        senderLongitude: json["sender_longitude"],
        receiverName: json["receiver_name"],
        receiverLastname: json["receiver_lastname"],
        receiverPhone: json["receiver_phone"],
        receiverAddress: json["receiver_address"],
        receiverLatitude: json["receiver_latitude"],
        receiverLongitude: json["receiver_longitude"],
        riderName: json["rider_name"],
        riderLastname: json["rider_lastname"],
        riderPhone: json["rider_phone"],
      );

  Map<String, dynamic> toJson() => {
        "pid": pid,
        "pro_name": proName,
        "pro_detail": proDetail,
        "pro_img": proImg,
        "pro_status": proStatus,
        "tracking_number": trackingNumber,
        "uid_fk_send": uidFkSend,
        "uid_fk_accept": uidFkAccept,
        "rid_fk": ridFk,
        "sender_name": senderName,
        "sender_lastname": senderLastname,
        "sender_phone": senderPhone,
        "sender_address": senderAddress,
        "sender_latitude": senderLatitude,
        "sender_longitude": senderLongitude,
        "receiver_name": receiverName,
        "receiver_lastname": receiverLastname,
        "receiver_phone": receiverPhone,
        "receiver_address": receiverAddress,
        "receiver_latitude": receiverLatitude,
        "receiver_longitude": receiverLongitude,
        "rider_name": riderName,
        "rider_lastname": riderLastname,
        "rider_phone": riderPhone,
      };
}
