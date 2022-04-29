import 'package:flutter/cupertino.dart';
class Promocode {
  final int id;
  final String code;
  String amount;
  final int product_id;
  Promocode({
    this.id,
    this.code,
    this.amount,
    @required this.product_id,
  });}