import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/sqfliteCreate.dart';
class CartItemModel {
  int id;
  int product_id;
  String name;
  String photo;
  String color_code;
  String size;
  int quantity;
  int quantityTotal;
  num price;
  int pieceId;
  int points;
  int earnedPoints;
  bool isUsePoint;
  CartItemModel({
    this.id,
    this.product_id,
    this.name,
    this.photo,
    this.color_code,
    this.size,
    this.quantity,
    this.points,
    this.earnedPoints,
    @required this.quantityTotal,
    this.price,
    this.pieceId,
    this.isUsePoint:false,
  });
  CartItemModel.fromJson(Map<String, dynamic> json) {
    this.id = json[DatabaseCreator.id];
    this.product_id = json[DatabaseCreator.product_id];
    this.name = json[DatabaseCreator.name];
    this.photo = json[DatabaseCreator.photo];
    this.color_code = json[DatabaseCreator.color_code];
    this.size = json[DatabaseCreator.size];
    this.quantity = json[DatabaseCreator.quantity];
    this.quantityTotal = json[DatabaseCreator.quantityTotal];
    this.price = json[DatabaseCreator.price];
    this.pieceId = json[DatabaseCreator.pieceId];
    this.points = json[DatabaseCreator.points];
    this.earnedPoints = json[DatabaseCreator.earnedPoints];
    this.isUsePoint = json[DatabaseCreator.isUsePoint]==0?false:true;
    Map toJson() => {
      'product_id': product_id,
      'name': name,
      'photo': photo,
      'color_code': color_code,
      'size': size,
      'quantity': quantity,
      'quantityTotal': quantityTotal,
      'price': price,
      'piece_id': pieceId,
      'points': points,
      'earnedPoints': earnedPoints,
      'isUsePoint': isUsePoint,
    };
  }}