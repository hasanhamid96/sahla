import 'package:flutter/material.dart';

import 'ProductOrderModel.dart';
class OrderModel {
  final int id;
  final int user_id;
  final String name;
  final String phone;
  final String country;
  final String city;
  final String point;
  final String status;
  final String message;
  final String photo;
  final String total;
  final List<ProductOrderModel> product_order;
  final String created_at;
  final String total_iq;
  final String approval_order;
  final int rate;
  OrderModel({
    this.id,
    this.user_id,
    this.name,
    this.phone,
    this.country,
    this.city,
    this.approval_order,
    this.point,
    this.status,
    this.message,
    this.photo,
    this.total,
    this.product_order,
    this.created_at,
    this.rate,
    @required this.total_iq,
  });}