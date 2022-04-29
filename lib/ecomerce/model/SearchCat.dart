import 'package:flutter/cupertino.dart';
class SearchCat {
  final int id;
  final String name;
  final int products_count;
  final String catType;
  SearchCat({
    this.id,
    this.name,
    this.products_count,
    @required this.catType,
  });}