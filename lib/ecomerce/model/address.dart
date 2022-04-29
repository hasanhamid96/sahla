import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/sqfliteCreate.dart';
class Address {
  int id_address;
  String name_address;
  int phone_address;
  String country_address;
  String city_address;
  String point_address;
  String lat;
  String long;
  int cityId;
  Address(
      {this.id_address,
        this.name_address,
        this.phone_address,
        this.country_address,
        this.lat,
        this.long,
        this.city_address,
        this.point_address,
        @required this.cityId});
  Address.fromJson(Map<String, dynamic> json) {
    this.id_address = json[DatabaseCreator.id];
    this.name_address = json[DatabaseCreator.product_id];
    this.phone_address = json[DatabaseCreator.name];
    this.country_address = json[DatabaseCreator.photo];
    this.city_address = json[DatabaseCreator.color_code];
    this.lat = json[DatabaseCreator.lat];
    this.long = json[DatabaseCreator.long];
    this.point_address = json[DatabaseCreator.size];
    this.cityId = json[DatabaseCreator.cityId];}}