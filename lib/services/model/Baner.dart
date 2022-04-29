import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';

class Baner {
  int id;
  int userService_id;
  String image;
  String url;

  Baner({
    this.id,
    this.image,
    this.userService_id,
    this.url,});


}
class Bannsers extends ChangeNotifier{
  List<Baner> _banner = [];
  List<Baner>get  banner {
    return [..._banner];}
    Future<List<Baner>> getServiceBanner() async {
      var url = '${AllProviders.hostName}/api/v1/sliders/banners';
      List<Baner> banner = [];
      try {
        final response = await http.get(Uri.parse(url),headers: {
          'Authorization':'${UserProvider.token}',
          'Accept' :'application/json',
        });
        var extractCarData = json.decode(response.body);
        if(extractCarData['status']==true)
          extractCarData['sliders'].forEach((item) {
            banner.add(Baner(id:item['id'],
              image: item['photo'].toString(),
              userService_id: item['product_id'] ,
              url: item['link'] ,
            ));
          });
        _banner=banner;
        notifyListeners();
        return banner;
      } on SocketException {
        throw SocketException;
      } catch (error) {
        print('$error  nnnnnnnnnnnnnnnnnnnnnnnnnn banners');
      }}}