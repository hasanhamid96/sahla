import 'package:flutter/material.dart';

import 'Include.dart';
class Service{
  int id;
  int inMinutes;
  String name;
  String image;
  String price;
  String description;
  List<Include> include;
  List<Include> notInclude;
  bool isAddToFav;
  int special;
  bool isActive;
  Service({
  @required this.id,
  @required this.name,
  @required this.image,
  @required this.price,
  this.isAddToFav:false,
  this.include,
  this.notInclude,
  @required this.inMinutes,
  @required this.special,
  @required this.isActive:true,
  this.description,});}