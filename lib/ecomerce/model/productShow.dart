import 'package:flutter/material.dart';
class ProductShow {
  final int index;
  final int id;
  final String title;
  final String description;
  final String image;
  final num price;
  final num discount;
  final double discountPercentage;
  bool isFavorite;
  final bool isActive;
  ProductShow({
    @required this.index,
    this.id,
    this.title,
    this.description,
    this.image,
    this.price,
    this.discount,
    this.discountPercentage,
    this.isFavorite,
    this.isActive,
  });}