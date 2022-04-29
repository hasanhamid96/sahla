import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/cupertino.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/services/model/Section.dart';
class Sections with ChangeNotifier{
  List<Section> _sectiontems=[
    // Section(
    //     id: 1,
    //     title: '
    //     image: 'https://e3arabi.com/wp-content/uploads/2020/02/shutterstock_1319352563-780x470.jpg'
    // ),
    // Section(
    //     id: 1,
    //     title: '
    //     image: 'https://www.kammasheh.com/wp-content/uploads/2018/08/Tools-Carpenter-Wood-2423826.jpg'
    // ),
  ];
  List<Section>get sectionItems{
    return[..._sectiontems];}
    bool  isEverythingOkSections = false;
    bool  once = true;
    Future<void> fetchSections() async {
      if (once) {
        once=false;
        try {
          final response = await http.get(Uri.parse('${AllProviders
              .hostName}/api/v1/maincategories?lang=${Languages
              .selectedLanguageStr}&type=service'),
              headers: {
                'Accept': 'application/json',
              });
          var data4 = json.decode(response.body);
          final List<Section> loadedCities = [];
          if (data4['status'] == false) {
            return null;
          }
          print(
              '$data4 4data4data4data4data4data4data4data4data4data4data4data4data4data4');
          data4['MainCategories'].forEach((city) {
            loadedCities.add(
              Section(
                  id: city['id'],
                  title: city['name_${Languages.selectedLanguageStr}'],
                  image: city['photo']
              ),
            );
          });
          if (data4['status'] == true) {
            isEverythingOkSections = true;
            notifyListeners();
          }
          _sectiontems = loadedCities;
          notifyListeners();
        } catch (e) {
          print('$e fetch section error');
        }
      }}}