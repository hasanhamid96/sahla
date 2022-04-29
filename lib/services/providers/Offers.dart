import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/services/model/offer.dart';
class Offers with ChangeNotifier{
  List<Offer> _items=[
    // Offer(
    //   id: 1,
    //   title: 'offer 1',
    //   serviceId: 1,
    //   desc: 'desc',
    //   image: 'https://helpx.adobe.com/content/dam/help/en/photoshop/using/convert-color-image-black-white/jcr_content/main-pars/before_and_after/image-before/Landscape-Color.jpg'
    //
    // )
  ];
  List<Offer>get items {
    return[..._items];}
    bool isLoadOffer = true;
    Future<void> fetchData({type:'service'}) async {
      isLoadOffer = true;
      final response = await http.get(Uri.parse(
          '${AllProviders.hostName}/api/v1/offers?type=$type&lang=${Languages
              .selectedLanguageStr.toString()}'));
      var data = json.decode(response.body);
      final List<Offer> loadedPosts = [];
      if (data == null) {
        return;
      }
      if (data['offers'] != null && data['status'])
        data['offers'].forEach((newsId) {
          loadedPosts.add(Offer(
            id: newsId["id"],
            title: newsId["title_${Languages.selectedLanguageStr}"],
            desc: newsId["description_${Languages.selectedLanguageStr}"],
            serviceId: newsId["service_id"],
            image: newsId["photo"],
          ));
        });
      _items = loadedPosts;
      if (response.statusCode == 200)
        isLoadOffer = false;
      notifyListeners();
    }}