import 'package:flutter/material.dart';
class ProductOrderModel {
  final int id;
  final int order_id;
  final int product_id;
  final int piece_id;
  final String name;
  final String photo;
  final String color_code;
  final String size;
  final int quantity;
  final String price;
  final String created_at;
  ProductOrderModel({
    this.id,
    this.order_id,
    this.product_id,
    this.piece_id,
    this.name,
    this.photo,
    this.color_code,
    this.size,
    this.quantity,
    this.price,
    this.created_at,
  });}