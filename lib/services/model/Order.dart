import 'Service.dart';
class Order {
  int id;
  int user_id;
  int service_id;
  String description;
  String user_name;
  String user_phone;
  int server_id;
  String server_name;
  String status_description;
  String status_date;
  double additionalPrice;
  double total;
  String preorder;
  String providerNotes;
  String server_phone;
  String user_image;
  String status;
  String service_start;
  String service_end;
  String service_end_user_approval;
  String duration;
  String notes;
  String lat;
  String long;
  String operator;
  Service service;
  double rate;
  List<String> request_service_photo;
  Order({
  this.id,
  this.rate,
  this.user_id,
  this.providerNotes,
  this.total,
  this.additionalPrice,
  this.operator,
  this.service_end_user_approval,
  this.duration,
  this.status_date,
  this.status_description,
  this.preorder,
  this.service_id,
  this.user_phone,
  this.user_name,
  this.user_image,
  this.server_name,
  this.server_id,
  this.server_phone,
  this.description,
  this.status,
  this.service_start,
  this.service_end,
  this.notes,
  this.lat,
  this.long,
  this.service,
  this.request_service_photo,});}