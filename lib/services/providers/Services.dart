import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/services/model/Include.dart';
import 'package:new_sahla/services/model/Service.dart';
import 'package:new_sahla/services/model/SubCat.dart';

import 'DBHelper.dart';

class Services with ChangeNotifier {
  List<Service> _serviceItems = [];

  List<Service> get serviceItems {
    return [..._serviceItems];
  }

  List<Service> _servicesMostUsed = [];

  List<Service> get servicesMostUsed {
    return [..._servicesMostUsed];
  }

  List<SubCat> _subCat = [];

  List<SubCat> get subCat {
    return [..._subCat];
  }

  List<Service> _subServiceItems = [];

  List<Service> get subServiceItems {
    return [..._subServiceItems];
  }

  bool isEverythingOkSections = false;

  Future<void> fetchServices() async {
    var url;
    url = '${AllProviders.hostName}/api/v1/services';
    try {
      final response = await http.get(Uri.parse(url), headers: {
        'Accept': 'application/json',
        'Authorization': UserProvider.token
      });
      var data4 = json.decode(response.body);
      final List<Service> loadedAllServices = [];
      final List<Service> loadedMostServices = [];
      if (data4['status'] == false) {
        return null;
      }
      data4['Services'].forEach((items) {
        List<Include> including = [];
        List<Include> notIncluding = [];
        print(items['service_features']);
        items['service_features'].forEach((inc) {
          if (inc['type'] == 'includes')
            including.add(Include(
                id: inc['id'],
                title: inc['title_${Languages.selectedLanguageStr}'],
                desc: inc['description_${Languages.selectedLanguageStr}'],
                icon: inc['photo']));
          if (inc['type'] == 'excludes')
            notIncluding.add(Include(
                id: inc['id'],
                title: inc['title_${Languages.selectedLanguageStr}'],
                desc: inc['description_${Languages.selectedLanguageStr}'],
                icon: inc['photo']));
        });
        loadedAllServices.add(
          Service(
            id: items['id'],
            name: items['name_${Languages.selectedLanguageStr}'],
            description: items['description_${Languages.selectedLanguageStr}'],
            image: items['photo'],
            price: items['price'],
            inMinutes: items['in_minutes'],
            special: items['special'],
            isActive: items['approval'] == 1 ? true : false,
            include: including,
            notInclude: notIncluding,
          ),
        );
        if (items['special'] == 1)
          loadedMostServices.add(
            Service(
                id: items['id'],
                isActive: items['approval'] == 1 ? true : false,
                name: items['name_${Languages.selectedLanguageStr}'],
                description:
                    items['description_${Languages.selectedLanguageStr}'],
                image: items['photo'],
                price: items['price'],
                inMinutes: items['in_minutes'],
                include: including,
                notInclude: notIncluding,
                special: items['special']),
          );
      });
      if (data4['status'] == true) {
        isEverythingOkSections = true;
        notifyListeners();
      }
      _servicesMostUsed = loadedMostServices;
      _serviceItems = loadedAllServices;
      notifyListeners();
    } catch (e) {
      print('$e fetch service error');
    }
  }

  Future<List<SubCat>> fetchServicesByCategory({SecId, isSub: false}) async {
    var url;
    if (!isSub)
      url = '${AllProviders.hostName}/api/v1/service/maincategory/$SecId';
    else if (isSub)
      url = '${AllProviders.hostName}/api/v1/service/subcategory/$SecId';
    // try {
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': UserProvider.token
    });
    var data4 = json.decode(response.body);
    final List<SubCat> loadedSubCat = [];
    final List<Service> loadedAllServices = [];
    final List<Service> loadedMostServices = [];
    if (data4['status'] == false) {
      return null;
    }
    if (!isSub) {
      print('main cat...');
      if (data4['MainCategory'] as List != [])
        data4['MainCategory'].forEach((mainItems) {
          mainItems['categories'].forEach((mainItems) {
            loadedSubCat.add(SubCat(
              id: mainItems['id'],
              title: mainItems['name_${Languages.selectedLanguageStr}'],
              image: mainItems['photo'],
            ));
          });
          if (mainItems['service'] != [])
            mainItems['service'].forEach((items) {
              List<Include> including = [];
              List<Include> notIncluding = [];
              print(items['service_features']);
              items['service_features'].forEach((inc) {
                if (inc['type'] == 'includes')
                  including.add(Include(
                      id: inc['id'],
                      title: inc['title_${Languages.selectedLanguageStr}'],
                      desc: inc['description_${Languages.selectedLanguageStr}'],
                      icon: inc['photo']));
                if (inc['type'] == 'excludes')
                  notIncluding.add(Include(
                      id: inc['id'],
                      title: inc['title_${Languages.selectedLanguageStr}'],
                      desc: inc['description_${Languages.selectedLanguageStr}'],
                      icon: inc['photo']));
              });
              loadedAllServices.add(
                Service(
                    id: items['id'],
                    isActive: items['approval'] == 1 ? true : false,
                    name: items['name_${Languages.selectedLanguageStr}'],
                    description:
                        items['description_${Languages.selectedLanguageStr}'],
                    image: items['photo'],
                    price: items['price'],
                    inMinutes: items['in_minutes'],
                    include: including,
                    notInclude: notIncluding,
                    special: items['special']),
              );
              if (items['special'] == 1)
                loadedMostServices.add(
                  Service(
                      id: items['id'],
                      name: items['name_${Languages.selectedLanguageStr}'],
                      description:
                          items['description_${Languages.selectedLanguageStr}'],
                      image: items['photo'],
                      price: items['price'],
                      include: including,
                      notInclude: notIncluding,
                      inMinutes: items['in_minutes'],
                      special: items['special']),
                );
            });
        });
    }
    if (isSub) {
      print('sub cat...');
      data4['MainCategory'].forEach((subCategoryitems) {
        subCategoryitems['children'].forEach((subItem) {
          loadedSubCat.add(SubCat(
            id: subItem['id'],
            title: subItem['name_${Languages.selectedLanguageStr}'],
            image: subItem['photo'],
          ));
          if (subCategoryitems['service'] as List != [])
            subCategoryitems['service'].forEach((items) {
              List<Include> including = [];
              List<Include> notIncluding = [];
              print(items['service_features']);
              items['service_features'].forEach((inc) {
                if (inc['type'] == 'includes')
                  including.add(Include(
                      id: inc['id'],
                      title: inc['title_${Languages.selectedLanguageStr}'],
                      desc: inc['description_${Languages.selectedLanguageStr}'],
                      icon: inc['photo']));
                if (inc['type'] == 'excludes')
                  notIncluding.add(Include(
                      id: inc['id'],
                      title: inc['title_${Languages.selectedLanguageStr}'],
                      desc: inc['description_${Languages.selectedLanguageStr}'],
                      icon: inc['photo']));
              });
              loadedAllServices.add(
                Service(
                    id: items['id'],
                    name: items['name_${Languages.selectedLanguageStr}'],
                    description:
                        items['description_${Languages.selectedLanguageStr}'],
                    image: items['photo'],
                    isActive: items['approval'] == 1 ? true : false,
                    price: items['price'],
                    inMinutes: items['in_minutes'],
                    include: including,
                    notInclude: notIncluding,
                    special: items['special']),
              );
              if (items['special'] == 1)
                loadedMostServices.add(
                  Service(
                      id: items['id'],
                      name: items['name_${Languages.selectedLanguageStr}'],
                      description:
                          items['description_${Languages.selectedLanguageStr}'],
                      image: items['photo'],
                      price: items['price'],
                      include: including,
                      notInclude: notIncluding,
                      isActive: items['approval'] == 1 ? true : false,
                      inMinutes: items['in_minutes'],
                      special: items['special']),
                );
            });
        });
      });
    }
    if (data4['status'] == true) {
      isEverythingOkSections = true;
      notifyListeners();
    }
    // if(isSub&&loadedAllServices.isNotEmpty)
    //   _subServiceItems=loadedAllServices;
    // else  if(!isSub&&loadedAllServices.isNotEmpty)
    _serviceItems = loadedAllServices;
    // _servicesMostUsed = loadedMostServices;
    _subCat = loadedSubCat;
    notifyListeners();
    return loadedSubCat;
    // } catch (e) {
    //   print('$e fetch service error');
    // }
  }


List<Service> _subSubServiceItems = [];

List<Service> get subSubServiceItems {
  return [..._subSubServiceItems];
}

Future<List<SubCat>> fetchServicesBySubCategory({SecId, parent_id}) async {
  var url;
  url = '${AllProviders.hostName}/api/v1/service/subcategory/$SecId';
  try {
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': UserProvider.token
    });
    var data4 = json.decode(response.body);
    final List<SubCat> loadedSubCat = [];
    final List<Service> loadedAllServices = [];
    final List<Service> loadedMostServices = [];
    if (data4['status'] == false) {
      return null;
    }
    print('sub sub cat...');
    if (data4['MainCategory'] as List != [])
      data4['MainCategory'].forEach((item) {
        item['children'].forEach((item) {
          loadedSubCat.add(SubCat(
            id: item['id'],
            title: item['name_${Languages.selectedLanguageStr}'],
            image: item['photo'],
            parent_id: item['parent_id'],
          ));
        });
        item['service'].forEach((items) {
          List<Include> including = [];
          List<Include> notIncluding = [];
          print(items['service_features']);
          items['service_features'].forEach((inc) {
            if (inc['type'] == 'includes')
              including.add(Include(
                  id: inc['id'],
                  title: inc['title_${Languages.selectedLanguageStr}'],
                  desc: inc['description_${Languages.selectedLanguageStr}'],
                  icon: inc['photo']));
            if (inc['type'] == 'excludes')
              notIncluding.add(Include(
                  id: inc['id'],
                  title: inc['title_${Languages.selectedLanguageStr}'],
                  desc: inc['description_${Languages.selectedLanguageStr}'],
                  icon: inc['photo']));
          });
          loadedAllServices.add(
            Service(
                id: items['id'],
                isActive: items['approval'] == 1 ? true : false,
                name: items['name_${Languages.selectedLanguageStr}'],
                description:
                    items['description_${Languages.selectedLanguageStr}'],
                image: items['photo'],
                price: items['price'],
                inMinutes: items['in_minutes'],
                include: including,
                notInclude: notIncluding,
                special: items['special']),
          );
          if (items['special'] == 1)
            loadedMostServices.add(
              Service(
                  id: items['id'],
                  name: items['name_${Languages.selectedLanguageStr}'],
                  description:
                      items['description_${Languages.selectedLanguageStr}'],
                  image: items['photo'],
                  price: items['price'],
                  include: including,
                  notInclude: notIncluding,
                  isActive: items['approval'] == 1 ? true : false,
                  inMinutes: items['in_minutes'],
                  special: items['special']),
            );
        });
      });
    if (data4['status'] == true) {
      isEverythingOkSections = true;
      notifyListeners();
    }
    if (parent_id != null)
      _subSubServiceItems = loadedAllServices;
    else
      _subServiceItems = loadedAllServices;
    notifyListeners();
    return loadedSubCat;
  } catch (e) {
    print('$e fetch subSub error');
  }
}

Future<Service> fetchSingleService({SecId}) async {
  var url;
  url = '${AllProviders.hostName}/api/v1/services/$SecId';
  try {
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
    });
    var data4 = json.decode(response.body);
    final List<Service> loadedServices = [];
    if (data4['status'] == false) {
      return null;
    }
    if (data4['status'] == true) {
      List<Include> including = [];
      List<Include> notIncluding = [];
      data4['Services']['service_features'].forEach((inc) {
        if (inc['type'] == 'includes')
          including.add(Include(
              id: inc['id'],
              title: inc['title_${Languages.selectedLanguageStr}'],
              desc: inc['description_${Languages.selectedLanguageStr}'],
              icon: inc['photo']));
        if (inc['type'] == 'excludes')
          notIncluding.add(Include(
              id: inc['id'],
              title: inc['title_${Languages.selectedLanguageStr}'],
              desc: inc['description_${Languages.selectedLanguageStr}'],
              icon: inc['photo']));
      });
      loadedServices.add(
        Service(
            id: data4['Services']['id'],
            name: data4['Services']['name_${Languages.selectedLanguageStr}'],
            description: data4['Services']
                ['description_${Languages.selectedLanguageStr}'],
            image: data4['Services']['photo'],
            include: including,
            notInclude: notIncluding,
            isActive: data4['Services']['approval'] == 1 ? true : false,
            price: data4['Services']['price'],
            inMinutes: data4['Services']['in_minutes'],
            special: data4['Services']['special']),
      );
      isEverythingOkSections = true;
      notifyListeners();
    }
    notifyListeners();
    return loadedServices[0];
  } catch (e) {
    print('$e fetch service error');
    throw e;
  }
}

Future<Service> fetchMyService(SecId) async {
  var url;
  url = '${AllProviders.hostName}/api/v1/services/$SecId';
  try {
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
    });
    var data4 = json.decode(response.body);
    final List<Service> loadedServices = [];
    if (data4['status'] == false) {
      return null;
    }
    if (data4['status'] == true) {
      List<Include> including = [];
      List<Include> notIncluding = [];
      data4['Services']['service_features'].forEach((inc) {
        if (inc['type'] == 'includes')
          including.add(Include(
              id: inc['id'],
              title: inc['title_${Languages.selectedLanguageStr}'],
              desc: inc['description_${Languages.selectedLanguageStr}'],
              icon: inc['photo']));
        if (inc['type'] == 'excludes')
          notIncluding.add(Include(
              id: inc['id'],
              title: inc['title_${Languages.selectedLanguageStr}'],
              desc: inc['description_${Languages.selectedLanguageStr}'],
              icon: inc['photo']));
      });
      loadedServices.add(
        Service(
            id: data4['Services']['id'],
            name: data4['Services']['name_${Languages.selectedLanguageStr}'],
            description: data4['Services']
                ['description_${Languages.selectedLanguageStr}'],
            image: data4['Services']['photo'],
            include: including,
            notInclude: notIncluding,
            isActive: data4['Services']['approval'] == 1 ? true : false,
            price: data4['Services']['price'],
            inMinutes: data4['Services']['in_minutes'],
            special: data4['Services']['special']),
      );
      isEverythingOkSections = true;
      notifyListeners();
    }
    notifyListeners();
    return loadedServices[0];
  } catch (e) {
    print('$e fetch service error');
    throw e;
  }
}

List<Service> favService = [];

Future<List<Service>> getfav() async {
  List<Service> loadedService = [];
  var fetchData = await DBHelper.get('serviceFav');
  fetchData.forEach((items) {
    loadedService.add(Service(
      id: int.parse(items['id']),
      name: items['name'] as String,
      description: items['desc'],
      price: items['price'],
      image: items['image'],
    ));
  });
  notifyListeners();
  favService = loadedService;
  return loadedService;
}

void deleteFav(int id, context) {
  favService.removeWhere((element) => element.id == id);
  DBHelper.delete('serviceFav', id.toString()).then((value) {
    Navigator.of(context).pop();
  });
  notifyListeners();
}
}