import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/services/model/SubCat.dart';

class SubAndDoubleSubCategory with ChangeNotifier {
  List<SubCat> _subCat = [];

  List<SubCat> get subCat {
    return [..._subCat];
  }

  bool isEverythingOkCities = false;

  Future<List<SubCat>> fetch_sub_Categories(int section_id) async {
    print('${section_id} 4444444');
    try {
      final response = await http.get(
          Uri.parse(
              '${AllProviders.hostName}/api/v1/subcategories?type=service&lang=${Languages.selectedLanguageStr}&maincategory_id=$section_id'),
          headers: {
            'Accept': 'application/json',
            'Authorization': '${UserProvider.token}'
          });
      var data4 = json.decode(response.body);
      print(data4);
      final List<SubCat> loadedSubCats = [];
      if (data4['status'] == false) {
        return null;
      }
      data4['categories'].forEach((section) {
        loadedSubCats.add(
          SubCat(
            id: section['id'],
            title: section['name_${Languages.selectedLanguageStr}'],
            image: section['photo'].toString(),
          ),
        );
      });
      print(loadedSubCats.length);
      if (data4['status'] == true) {
        isEverythingOkCities = true;
        notifyListeners();
      }
      notifyListeners();
      // loadedShops.toSet().toList();
      // _subShops=loadedShops;
      // loadedSubCats.toSet().toList();
      _subCat = loadedSubCats;
      return _subCat;
    } catch (e) {
      print('$e fetch sub error');
    }
  }

  List<SubCat> _subSubCat = [];

  List<SubCat> get subSubCat {
    return [..._subSubCat];
  }

  bool isEverythingOkSubSubCat = false;

  Future<List<SubCat>> fetch_2sub_Categories(int subCat_id) async {
    print('${subCat_id} 4444444');
    try {
      final response = await http.get(
          Uri.parse(
              '${AllProviders.hostName}/api/v1/subcategories?type=service&lang=${Languages.selectedLanguageStr}&parent_id=$subCat_id'),
          headers: {
            'Accept': 'application/json',
            'Authorization': '${UserProvider.token}'
          });
      var data4 = json.decode(response.body);
      print(data4);
      final List<SubCat> loadedSubCats = [];
      if (data4['status'] == false) {
        return null;
      }
      data4['categories'].forEach((section) {
        loadedSubCats.add(
          SubCat(
            id: section['id'],
            title: section['name_${Languages.selectedLanguageStr}'],
            image: section['photo'].toString(),
          ),
        );
      });
      print(loadedSubCats.length);
      if (data4['status'] == true) {
        isEverythingOkSubSubCat = true;
        notifyListeners();
      }
      notifyListeners();
      // loadedShops.toSet().toList();
      // _subShops=loadedShops;
      // loadedSubCats.toSet().toList();
      _subSubCat = loadedSubCats;
      return _subSubCat;
    } catch (e) {
      print('$e fetch sub sub error');
    }
  }
}
