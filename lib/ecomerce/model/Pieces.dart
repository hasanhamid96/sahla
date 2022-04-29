import 'package:flutter/material.dart';
class Pieces {
  final int id;
  final int size_id;
  final int color_id;
  final int product_id;
  final int quantity;
  final String color;
  final String size;
  final int price;
  final int discount;
  final double discountPercentage;
  Pieces(
      {@required this.id,
        this.size_id,
        this.color_id,
        this.product_id,
        this.color,
        this.size,
        this.quantity,
        this.price,
        this.discount,
        this.discountPercentage});}