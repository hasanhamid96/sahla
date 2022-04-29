import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/model/productQuestion.dart';

import 'Pieces.dart';
import 'ProductImage.dart';
class Product {
  final int index;
  final int id;
  final String name;
  final int pointPrice;
  final int points;
  final String description;
  final String image;
  final num price;
  final num discount;
  final double discountPercentage;
  final int quantity;
  final int catId;
  final String catType;
  final List<ProductImage> images;
  final List<Pieces> pieces;
  final List<ProductQuestion> questions;
  final bool isFavorite;
  final String note;
  final bool approval;
  Product({
    @required this.index,
    this.id,
    @required this.points,
    this.name,
    this.pointPrice,
    this.description,
    this.image,
    this.price,
    this.discount,
    this.discountPercentage,
    this.quantity,
    this.catId,
    this.catType,
    this.images,
    this.pieces,
    this.questions,
    this.isFavorite,
    this.approval:true,
    @required this.note,
  });}