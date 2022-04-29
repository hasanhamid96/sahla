import 'dart:io';
import 'dart:math';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:new_sahla/ecomerce/model/Category.dart';
import 'package:new_sahla/ecomerce/model/OrderModel.dart';
import 'package:new_sahla/ecomerce/model/Pieces.dart';
import 'package:new_sahla/ecomerce/model/Product.dart';
import 'package:new_sahla/ecomerce/model/ProductImage.dart';
import 'package:new_sahla/ecomerce/model/ProductOrderModel.dart';
import 'package:new_sahla/ecomerce/model/PromoCode.dart';
import 'package:new_sahla/ecomerce/model/SearchCat.dart';
import 'package:new_sahla/ecomerce/model/SliderModel.dart';
import 'package:new_sahla/ecomerce/model/SubCategory.dart';
import 'package:new_sahla/ecomerce/model/address.dart';
import 'package:new_sahla/ecomerce/model/cartItemModel.dart';
import 'package:new_sahla/ecomerce/model/city.dart';
import 'package:new_sahla/ecomerce/model/country.dart';
import 'package:new_sahla/ecomerce/model/news.dart';
import 'package:new_sahla/ecomerce/model/productQuestion.dart';
import 'package:new_sahla/ecomerce/model/productShow.dart';
import 'package:new_sahla/services/model/Service.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Languages.dart';
import 'RepositoryServiceTodo.dart';
import 'UserProvider.dart';
class AllProviders extends ChangeNotifier {
  static const String hostName = "https://sahla.creativeapps.me";
  String aboutus = '';
  String facebook = '';
  String insta = '';
  String twitter = '';
  String youtube = '';
  String share = '';
  String whatsup = '';
  static String currency = 'USD';
  int cartItemCount;
  bool onceGetCartItems = false;
  static bool isColorsNavigatorOpen = false;
  static BuildContext colorBuildcontex;
  static int selectedCountry = 0;
  Address selectedAddress;
  String selectedShipPrice; var offlieContactUs;
  static List<Address> allAddreses;
  static BuildContext mainBuid;

  get appName => null;
  List<ProductShow> allFavoriteItems = [];
  List<int> favoriteIds = List<int>();

  void refreshCartItem(int numberCart) {
    cartItemCount = numberCart;
    notifyListeners();}

  void refreshAddress(List<Address> allAddreses1) {
    allAddreses = allAddreses1;
    notifyListeners();
  }

  void setSelectedAddress(Address selectedAddress2) {
    selectedAddress = selectedAddress2;
    notifyListeners();
  }

  int calcuatePromocode(String promocode2, int product_id,
      List<CartItemModel> cartItemsAll) {
    lastlastTotalPrice = 0;
    if (product_id == null) {
      if (promocode2.contains("%")) {
        var amount = promocode2.replaceAll("%", "");
        cartItemsAll.forEach((item) {
          lastlastTotalPrice += item.price * item.quantity;
        });
        num first = num.parse(amount) / 100;
        num second = first * lastlastTotalPrice;
        var percentageDiscount = lastlastTotalPrice - second;
        lastlastTotalPrice = percentageDiscount + shippingCost;
        totalIraqi = lastlastTotalPrice * exchangeRate;
        return 1;
      }
      else {
        cartItemsAll.forEach((item) {
          lastlastTotalPrice += item.price * item.quantity;
        });
        lastlastTotalPrice -= int.parse(promocode2);
        if (lastlastTotalPrice <= 0) {
          lastlastTotalPrice += int.parse(promocode2);
          lastlastTotalPrice += shippingCost;
          promocode.amount = '0';
          totalIraqi = lastlastTotalPrice * exchangeRate;
          notifyListeners();
          return 0;
        }
        else {
          lastlastTotalPrice += shippingCost;
          totalIraqi = lastlastTotalPrice * exchangeRate;
          return 1;
        }
      }
    }
    else {
      num itemAmount = 0.0;
      if (promocode2.contains("%")) {
        var amount = promocode2.replaceAll("%", "");
        cartItemsAll.forEach((item) {
          print("this is the cart " + item.product_id.toString());
          if (item.product_id == product_id) {
            itemAmount = item.price;
          }
          lastlastTotalPrice += item.price * item.quantity;
        });
        num first = num.parse(amount) / 100;
        num second = first * itemAmount;
        var percentageDiscount = lastlastTotalPrice - second;
        lastlastTotalPrice = percentageDiscount + shippingCost;
        totalIraqi = lastlastTotalPrice * exchangeRate;
        return 1;
      }
      else {
        cartItemsAll.forEach((item) {
          if (item.product_id == product_id) {
            itemAmount = num.parse(promocode2);
            print(itemAmount);
          }
          lastlastTotalPrice += item.price * item.quantity;
        });
        lastlastTotalPrice -= itemAmount;
        if (lastlastTotalPrice <= 0) {
          lastlastTotalPrice += itemAmount;
          lastlastTotalPrice += shippingCost;
          promocode.amount = '0';
          totalIraqi = lastlastTotalPrice * exchangeRate;
          notifyListeners();
          return 0;
        } else {
          lastlastTotalPrice += shippingCost;
          totalIraqi = lastlastTotalPrice * exchangeRate;
          return 1;
        }
      }
    }
  }

  num lastTotalPrice = 0;
  num lastlastTotalPrice = 0;
  num totalIraqi = 0;
  num totalPoints = 0;

  num getTotalPrice(num promocode) {
    lastTotalPrice = 0;
    cartItemsAll.forEach((item) {
      lastTotalPrice += item.price * item.quantity;
    });
    cartItemsAll.forEach((item) {
      totalPoints += item.points;
    });
    lastlastTotalPrice = 0;
    if (promocode != 0 && promocode < lastTotalPrice) {
      lastlastTotalPrice = (lastTotalPrice + shippingCost) - promocode;
      totalIraqi = lastlastTotalPrice * exchangeRate;
      return lastlastTotalPrice;
    } else {
      cartItemsAll.forEach((item) {
        lastlastTotalPrice += item.price * item.quantity;
      });
      lastlastTotalPrice += shippingCost;
      totalIraqi = lastlastTotalPrice * exchangeRate;
      return lastlastTotalPrice;
    }
  }

  void changeTotal(isUsingPoints, num price, cartItemPoint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isUsingPoints) {
      lastTotalPrice -= price;
      UserProvider.points =
          (int.parse(UserProvider.points) - cartItemPoint).toString();
      prefs.setString('points', 'basmazon' + '_' + "${ UserProvider.points}");
      lastlastTotalPrice = lastTotalPrice + shippingCost;
      totalIraqi = lastlastTotalPrice * exchangeRate;
    }
    else {
      lastTotalPrice += price;
      UserProvider.points =
          (int.parse(UserProvider.points) + cartItemPoint).toString();
      prefs.setString('points', 'basmazon' + '_' + "${ UserProvider.points}");
      lastlastTotalPrice = lastTotalPrice + shippingCost;
      totalIraqi = lastlastTotalPrice * exchangeRate;
      // }
      print(lastTotalPrice);
      notifyListeners();
    }
  }

  num getTotalPoints() {
    //int promocodeValue = 0;
    Promocode promocode =
    Promocode(id: 1, code: "wrong", amount: "0", product_id: null);
  }
  Promocode promocode =
  Promocode(id: 1, code: "wrong", amount: "0", product_id: null);
  Future<Promocode> getPromocodes(String code) async {


    var response =
    await http.post(
        Uri.parse('${AllProviders.hostName}/api/v1/promocode'), body: {
      'code': code,
    });
    var promosJson = json.decode(response.body);
    print(promosJson);
    if (promosJson['status'] == false) {
      //promocodeValue = 0;

      return promocode;
    } else {
      promocode = Promocode(
        id: promosJson['promocode']['id'],
        code: promosJson['promocode']['code'],
        amount: promosJson['promocode']['amount'],
        product_id: promosJson['promocode']['product_id'],
      );
      //promocodeValue = promosJson['promocode']['amount'];
    }
    return promocode;
  }


    List<CartItemModel> cartItemsAll;


  Future<void> getCartItems() async {
    final respo = await RepositoryServiceTodo.getAllCarts();
    cartItemsAll = respo;
    //print(cartItemsAll);
    var offlieContactUs;
    bool once = false;
  }

  bool once = false;

  Future<void> fetchDataInfo() async {
    if (once == false) {
      final response =
      await http.get(Uri.parse(
          '${AllProviders.hostName}/api/v1/settings/all'));
      // print(response.body);
      var data = json.decode(response.body);
      if (data == null) {
        return;
      }
      offlieContactUs = data;
      aboutus = data['info']['about'];
      facebook = data['info']['facebook'];
      insta = data['info']['instagram'];
      twitter = data['info']['twitter'];
      youtube = data['info']['youtube'];
      whatsup = data['info']['phone'];
      share = data['info']['share'];
      once = true;
      notifyListeners();
    }
  }

  List<Country> allCountriesItems = [];

  Future<bool> getCountries() async {
    final response = await http.get(Uri.parse(
        '${AllProviders
            .hostName}/api/v1/settings/countries?lang=${Languages
            .selectedLanguageStr}'));
    //print(response.body);
    try {
      var data = json.decode(response.body);
      if (data['status'] == false) {
        return false;
      }
      else {
        data['countries'].forEach((newsId) {
          allCountriesItems.add(Country(
            id: newsId['id'],
            name: newsId['name_${Languages
                .selectedLanguageStr}'],
          ));
        });
        selectedCountry = allCountriesItems.last.id;
        notifyListeners();
        return true;
      }
    } catch (er) {
      print(er.toString());
      return false;
    }
  }


  List<City> allCitiesItems = List<City>();
  List<int> citiesIds = List<int>();

  Future<void> getCity(int id) async {
    allCitiesItems = [];
    final response = await http.get(Uri.parse(
        '${AllProviders
            .hostName}/api/v1/settings/countries/single/$id?lang=${Languages
            .selectedLanguageStr}'));
    print(response.body);
    var data = json.decode(response.body);
    if (data['status'] == false) {
      return;
    }
    data['country']['governorates'].forEach((newsId) {
      citiesIds.add(newsId['id']);
      allCitiesItems.add(City(
        id: newsId['id'],
        country_id: newsId['country_id'],
        name: newsId['name_${Languages.selectedLanguageStr}'],
        cost: newsId['cost'],
      ));
    });
    notifyListeners();
  }

  num shippingCost;

  Future<int> getShippingCost(int id) async {
    allCitiesItems = [];
    final response = await http.get(Uri.parse(
        '${AllProviders
            .hostName}/api/v1/settings/city/single/$id?lang=${Languages
            .selectedLanguageStr}'));
    print(response.body);
    var data = json.decode(response.body);
    if (data['status'] == false) {
      return 0;
    }
    shippingCost = data['city']['cost'];
    notifyListeners();
    return 1;
  }

  List<OrderModel> allOrdersItems = [];
  int ordersCoun = 0;
  bool isProductOrderOk = false;
  int orderPendingCount = 0;
  int orderNoPendingCount = 0;

  Future<void> getOrders() async {
    orderPendingCount = 0;
    orderNoPendingCount = 0;
    List<OrderModel> loadedOrders = [];
    isProductOrderOk = false;
    try {
      final response = await http.get(Uri.parse(
          '${AllProviders.hostName}/api/v1/orders/status'),
          headers: {'Authorization': UserProvider.token});
      var data = json.decode(response.body);
      print(data);
      if (data['status'] == false) {
        return;
      }
      isProductOrderOk = true;
      print(' ratinggg ${data}');
      data['orders'].forEach((newsId) {
        List<ProductOrderModel> productOrders = [];
        newsId['product_order'].forEach((newsId) {
          productOrders.add(ProductOrderModel(
            id: newsId['id'],
            order_id: newsId['order_id'],
            product_id: newsId['product_id'],
            piece_id: newsId['piece_id'],
            name: newsId['name'],
            photo: newsId['photo'],
            color_code: newsId['color_code'],
            size: newsId['size'],
            quantity: newsId['quantity'],
            price: newsId['price'],
            created_at: newsId['created_at'],
          ));
        });
        print(newsId['status']);
        loadedOrders.add(OrderModel(
          id: newsId['id'],
          user_id: newsId['user_id'],
          name: newsId['name'],
          phone: newsId['phone'],
          country: newsId['country'],
          city: newsId['city'],
          point: newsId['point'],
          status: newsId['status'],
          photo: newsId['photo'],
          message: newsId['message'],
          total: newsId['total'].toString(),
          product_order: productOrders,
          created_at: newsId['created_at'],
          total_iq: newsId['total_iq'],
          approval_order: newsId['approval_order'],
          rate: newsId['rate'] ?? 0,),);
        if (newsId['status'] == "pending") {
          orderPendingCount++;
        } else if (newsId['status'] != "pending") {
          orderNoPendingCount++;
        }
      });
      allOrdersItems = loadedOrders;
      ordersCoun = orderPendingCount;
      notifyListeners();
    }
    catch (e) {
      print(e);
      isProductOrderOk = true;
      notifyListeners();
      print('noOrders');
      return e;
    }
  }

  Future<String> getOneSignalPlayerId() async {
    var status = await OneSignal.shared.getDeviceState();
    var playerId = status.userId;
    print(playerId);
    return (playerId);
  }

  List<Service> _searchServices = [];

  List<Service> get searchServices {
    return _searchServices;
  }

  static List<Service> loadedAllsearchServices = [];

  Future<void> searchService(String searchText, BuildContext context,
      Languages lang) async {
    if (searchText != '') {
      loadedAllsearchServices = [];
      if (searchText != "") {
        String text = searchText.replaceFirst(" ", ".");
        final List<Service> loadedAllServices = [];
        List<String> text2 = text.split(".");
        var jsonText = jsonEncode(text2);
        print(jsonText);
        final response = await http.post(Uri.parse(
            '${AllProviders.hostName}/api/v1/search/searchService'),
            body: {
              'search': searchText,
            });
        var data2 = json.decode(response.body);
        if (data2['services'] as List != [])
          data2['services'].forEach((items) {
            loadedAllServices.add(Service(
                id: items['id'],
                name: items['name_${Languages.selectedLanguageStr}'],
                description:
                items['description_${Languages.selectedLanguageStr}'],
                image: items['photo'],
                price: items['price'],
                isActive: items['approval'] == 1 ? true : false,
                inMinutes: items['in_minutes'],
                special: items['special']),);
          });
        _searchServices = loadedAllServices;
        notifyListeners();
        print(response.body);
      }
    }
  }

  List<ProductShow> _searchProducts = [];

  List<ProductShow> get searchProducts {
    return _searchProducts;
  }

  static List<ProductShow> loadedAllsearchProducts = List<ProductShow>();

  Future<void> search(String searchText, BuildContext context,
      Languages lang) async {
    if (searchText != '') {
      loadedAllsearchProducts = [];
      String tempSearch = '';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool searchResultEmply = false;
      List<String> oldSearchResult = [];
      if (searchText != "") {
        String text = searchText.replaceFirst(" ", ".");
        List<String> text2 = text.split(".");
        var jsonText = jsonEncode(text2);
        print(jsonText);
        final response = await http.post(Uri.parse(
            '${AllProviders.hostName}/api/v1/search/searchProduct'),
            body: {
              'search': searchText,
            });
        var data2 = json.decode(response.body);
        print(response.body);
        if (data2['msg'] == "No product" || data2['products'].length == 0) {
          Flushbar(
            title: lang.translation['noSearchResult']
            [Languages.selectedLanguage],
            message: lang.translation['researchAgain']
            [Languages.selectedLanguage],
            barBlur: 0.4,
            duration: Duration(milliseconds: 3000),
            backgroundColor: Theme
                .of(context)
                .primaryColor,
            flushbarPosition: FlushbarPosition.TOP,
          ).show(context);
          searchResultEmply = true;
          return null;
        }
        if (prefs.containsKey('search')) {
          tempSearch = prefs.getString("search") + ',' + searchText;
          prefs.setString('search', "$tempSearch");
          oldSearchResult = prefs.getString('search').split(",");
        } else {
          prefs.setString('search', "$searchText");
          oldSearchResult.add(prefs.getString('search'));
        }
        var index = 0;
        if (data2['products'] != []) {
          data2['products'].forEach((newsId) {
            loadedAllsearchProducts.add(
              ProductShow(
                id: newsId['id'],
                image: newsId['photo'],
                title: newsId['name'],
                description:
                newsId['description'],
                price: newsId['price'],
                discount: newsId['discount'],
                isActive: newsId['approval'] == 1 ? true : false,
                discountPercentage: percentage,
                isFavorite: favoriteIds.contains(newsId['id']) ? true : false,
                index: index,
              ),
            );
            index++;
          });
          _searchProducts = loadedAllsearchProducts;
        } else {
          _searchProducts = [];
        }
        notifyListeners();
      } else {
        notifyListeners();
      }
    } else {
      _searchProducts = [];
    }
  }

  static List<ProductShow> loadedAllsearchCategoriesProducts =
  List<ProductShow>();
  bool onceSearchCategories = false;

  Future<void> searchCatProducts(String catType, int catId,
      BuildContext context, Languages lang) async {
    loadedAllsearchCategoriesProducts = [];
    if (onceSearchCategories == false) {
      onceSearchCategories = true;
      _searchProducts = [];
      loadedAllsearchCategoriesProducts = [];
      var url;
      if (catType == "MainCategory") {
        print("in main ");
        url =
        '${AllProviders
            .hostName}/api/v1/maincategories/single/$catId?lang=${Languages
            .selectedLanguageStr}';
      } else if (catType == "Category") {
        print("in sub");
        url =
        "${AllProviders
            .hostName}/api/v1/subcategories/single/$catId?lang=${Languages
            .selectedLanguageStr}&type=$catType&category_type=store";
      }
      final response = await http.get(Uri.parse(url));
      var dataAllProductsCategoriesSearch = json.decode(response.body);
      print(dataAllProductsCategoriesSearch.toString());
      if (dataAllProductsCategoriesSearch['status'] == false) {
        return;
      }
      var percentageMainCat;
      if (catType == "MainCategory") {
        if (dataAllProductsCategoriesSearch['Main Category']['categories'] !=
            []) {
          dataAllProductsCategoriesSearch['Main Category']['categories']
              .forEach((newsId) {
            newsId['products'].forEach((newsID2) {
              print("we have enter the huaven" + newsID2['name_ar'].toString());
              if (newsID2['discount'] != 0 && newsID2['discount'] != null) {
                num first = newsID2['discount'] / newsID2['price'];
                num second = first * 100;
                percentageMainCat = second - 100;
              }
              var index = 0;
              loadedAllsearchCategoriesProducts.add(
                ProductShow(
                  id: newsID2['id'],
                  image: newsID2['photo'],
                  title: newsID2['name_${Languages.selectedLanguageStr}'],
                  description:
                  newsID2['description_${Languages.selectedLanguageStr}'],
                  price: newsID2['price'],
                  discount: newsID2['discount'],
                  isActive: newsID2['approval'] == 1 ? true : false,
                  discountPercentage: percentageMainCat,
                  isFavorite:
                  favoriteIds.contains(newsID2['id']) ? true : false,
                  index: index,
                ),
              );
              index++;
            });
          });
          dataAllProductsCategoriesSearch['Main Category']['products']
              .forEach((newsID2) {
            print("we have enter the huaven" + newsID2['name_ar'].toString());
            if (newsID2['discount'] != 0 && newsID2['discount'] != null) {
              num first = newsID2['discount'] / newsID2['price'];
              num second = first * 100;
              percentageMainCat = second - 100;
            }
            var index = 0;
            loadedAllsearchCategoriesProducts.add(
              ProductShow(
                id: newsID2['id'],
                image: newsID2['photo'],
                title: newsID2['name_${Languages.selectedLanguageStr}'],
                description:
                newsID2['description_${Languages.selectedLanguageStr}'],
                price: newsID2['price'],
                discount: newsID2['discount'],
                discountPercentage: percentageMainCat,
                isFavorite: favoriteIds.contains(newsID2['id']) ? true : false,
                index: index,
              ),
            );
            index++;
          });
          _searchProducts = loadedAllsearchCategoriesProducts;
        } else {
          _searchProducts = [];
        }
      }
      // else if (catType == "Category") {
      //   var percentageSubCat;
      //   if (dataAllProductsCategoriesSearch['category']['products'] != []) {
      //     dataAllProductsCategoriesSearch['category']['products']
      //         .forEach((newsId) {
      //       if (newsId['discount'] != 0) {
      //         num first = newsId['discount'] / newsId['price'];
      //         num second = first * 100;
      //         percentageSubCat = second - 100;
      //       }
      //       var index = 0;
      //       loadedAllsearchCategoriesProducts.add(
      //         ProductShow(
      //           id: newsId['id'],
      //           image: newsId['photo'],
      //           title: newsId['name_${Languages.selectedLanguageStr}'],
      //           description:
      //               newsId['description_${Languages.selectedLanguageStr}'],
      //           price: newsId['price'],
      //           discount: newsId['discount'],
      //           discountPercentage: percentageSubCat,
      //           isFavorite: favoriteIds.contains(newsId['id']) ? true : false,
      //           index: index,
      //         ),
      //       );
      //       index++;
      //     });
      //     _searchProducts = loadedAllsearchCategoriesProducts;
      //   } else {
      //     _searchProducts = [];
      //   }
      // }
      _searchProducts = loadedAllsearchCategoriesProducts;
      notifyListeners();
    }
  }

  var data2;
  bool searchResultEmply = false;
  List<String> oldSearchResult = [];
  String tempSearch = "";
  bool isContainKey = false;

  void sharePrefsContaine(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      isContainKey = true;
    } else {
      isContainKey = false;
    }
  }

  void deleteSearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tempSearch = '';
    oldSearchResult = [];
    prefs.remove("search");
    notifyListeners();
  }

  void searchResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(searchProducts.length);
    if (prefs.containsKey('search')) {
      oldSearchResult = prefs.getString('search').split(",");
    } else {
      return;
    }
    notifyListeners();
  }

  bool showNavBar = true;
  static RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  static Function mathFunc = (Match match) => '${match[1]},';

  String numToString(String string) {
    String result = string.replaceAllMapped(reg, mathFunc);
    return result;
  }

  String numToStringForService(String string) {
    String result = string.replaceAllMapped(reg, mathFunc);
    return result;
  }

  void NavBarShow(bool show) {
    showNavBar = show;
    notifyListeners();
    int selectedCat = 0;
  }

  int selectedCat=0;
  void setCat(int index) {
    selectedCat = index;
    notifyListeners();
  }

  List<Category> _categories = [];

  List<Category> get categories {
    return _categories;
  }

  int postEnable;
  int catEnable;
  int catMainStyle;
  int catStyle;
  int appleEnable;
  num exchangeRate;
  var dataOfflineStyle;
  bool onceStyle = false;

  Future<void> fetchStyle() async {
    if (onceStyle == false) {
      onceStyle = true;
      print('fetch all data once');
      await SharedPreferences.getInstance().then((value) {
        final key = 'language';
        final keyStr = 'languageStr';
        final string = value.getInt(key);
        if (string != null) {
          Languages.selectedLanguage = (value.getInt(key));
          Languages.selectedLanguageStr = (value.getString(keyStr));
        }
      }).then((value) async {
        final response = await http.get(
            Uri.parse('$hostName/api/v1/settings/style'));
        print(response.body);
        var data = json.decode(response.body);
        if (data == null) {
          return;
        }
        dataOfflineStyle = data;
        postEnable = data['style'][0]['status'];
        catEnable = data['style'][1]['status'];
        catMainStyle = data['style'][2]['status'];
        catStyle = data['style'][3]['status'];
        appleEnable = data['style'][4]['status'];
        exchangeRate = num.parse(data['style'][5]['name']);
        try {
          await Future.wait([
            getAllfavorite(),
            fetchDataCategories(),
            fetchDataSliders(),
            fetchOffersStore(),
            fetchDataAllProducts(),
            getOrders(),
            fetchDataSearchCategories(),
          ]);
        } catch (e) {
          print(e.toString());
        }
        notifyListeners();
      });
    }
  }

  var dataAllCategories;
  List<Category> loadedAllCategories;
  var dataOfflineAllCategories;
  bool onceCategory = false;
  bool isCategoryOffline = true;

  Future<void> fetchDataCategories() async {
    if (onceCategory == false) {
      onceCategory = true;
      //print("this is the langgggggggg : ${Languages.selectedLanguageStr}");
      final response = await http.get(Uri.parse(
          '${AllProviders.hostName}/api/v1/maincategories?lang=${Languages
              .selectedLanguageStr}&type=store'));
      dataAllCategories = json.decode(response.body);
      final List<Category> loadedAllCategories = [];
      if (dataAllCategories == null) {
        return;
      }
      print('${response.body}    111111111111111');
      isCategoryOffline = false;
      dataOfflineAllCategories = dataAllCategories;
      dataAllCategories['MainCategories'].forEach((newsId) {
        loadedAllCategories.add(Category(
          id: newsId['id'],
          image: newsId['photo'],
          mainCategory: newsId['name_${Languages.selectedLanguageStr}'],
        ));
      });
      _categories = loadedAllCategories;
      notifyListeners();
    }
  }

  var dataAllsubCategoriesProducts;
  List<ProductShow> loadedAllsubCategoriesProducts = List<ProductShow>();
  List<ProductShow> _subCategoriesProducts = [];

  void clearProd() {
    _subCategoriesProducts.clear();
    notifyListeners();
  }

  List<ProductShow> get subCategoriesProducts {
    return _subCategoriesProducts;
  }

  static bool isSubCateforyProductsOk = false;

  Future<void> fetchDataSubCategoriesProducts(int catId, String sort,
      String type) async {
    loadedAllsubCategoriesProducts = [];
    final response = await http.get(Uri.parse(
      // '${AllProviders.hostName}/api/v1/subcategories/single/$catId?lang=${Languages.selectedLanguageStr}&category_type=store'));
        '${AllProviders
            .hostName}/api/v1/categories/single/$catId?lang=ar&sort=price&type=DESC&category_type=store'));
    dataAllsubCategoriesProducts = json.decode(response.body);
    if (dataAllsubCategoriesProducts['status'] == false) {
      return;
    }
    print(dataAllsubCategoriesProducts);
    isSubCateforyProductsOk = true;
    var index = 0;
    if (dataAllsubCategoriesProducts['category']['products'] != []) {
      dataAllsubCategoriesProducts['category']['products'].forEach((newsId) {
        loadedAllsubCategoriesProducts.add(
          ProductShow(
            id: newsId['id'],
            image: newsId['photo'],
            title: newsId['name_${Languages.selectedLanguageStr}'],
            description:
            newsId['description_${Languages.selectedLanguageStr}'],
            price: newsId['price'],
            discount: newsId['discount'],
            isActive: newsId['approval'] == 0 ? false : true,
            discountPercentage: percentage,
            isFavorite: favoriteIds.contains(newsId['id']) ? true : false,
            index: index,
          ),
        );
        index++;
      });
      _subCategoriesProducts = loadedAllsubCategoriesProducts;
    }
    else {
      _subCategoriesProducts = [];
    }
    notifyListeners();
  }

  List<ProductShow> _subSubCategoriesProducts = [];

  List<ProductShow> get subSubCategoriesProducts {
    return _subSubCategoriesProducts;
  }

  Future<void> fetchDataSubSubCategoriesProducts(int catId, String sort,
      String type) async {
    print('start fetching sub sub prod .......');
    print('$catId');
    loadedAllsubCategoriesProducts = [];
    final response = await http.get(Uri.parse(
      // '${AllProviders.hostName}/api/v1/categories?type=store&parent_id=$catId&lang=ar'));
        '${AllProviders
            .hostName}/api/v1/subcategories/single/$catId?lang=${Languages
            .selectedLanguageStr}&category_type=store'));
    dataAllsubCategoriesProducts = json.decode(response.body);
    if (dataAllsubCategoriesProducts['status'] == false) {
      return;
    }
    var index = 0;
    if (dataAllsubCategoriesProducts['category']['products'] != []) {
      dataAllsubCategoriesProducts['category']['products'].forEach((newsId) {
        loadedAllsubCategoriesProducts.add(
          ProductShow(
            id: newsId['id'],
            image: newsId['photo'],
            title: newsId['name_${Languages.selectedLanguageStr}'],
            description:
            newsId['description_${Languages.selectedLanguageStr}'],
            price: newsId['price'],
            discount: newsId['discount'],
            discountPercentage: percentage,
            isActive: newsId['approval'] == 0 ? false : true,
            isFavorite: favoriteIds.contains(newsId['id']) ? true : false,
            index: index,
          ),
        );
        index++;
      });
      _subSubCategoriesProducts = loadedAllsubCategoriesProducts;
    } else {
      _subSubCategoriesProducts = [];
      notifyListeners();
    }
  }

  List<SubCategory> _subCategories = [];

  List<SubCategory> get subCategories {
    return _subCategories;
  }

  List<SubCategory> _subSubCategories = [];

  List<SubCategory> get subSubCategories {
    return _subSubCategories;
  }

  static bool isSubSubCategoryOk = false;

  Future<void> fetchDataSubSubCategories(int catId,) async {
    print('start fetching sub sub ......');
    List<SubCategory> loadedAllsubCategories = [];
    {
      final response = await http.get(Uri.parse(
          '${AllProviders
              .hostName}/api/v1/subcategories?type=store&parent_id=$catId'));
      var dataAllsubCategoriesProducts = json.decode(response.body);
      if (dataAllsubCategoriesProducts['status'] == false) {
        return;
      }
      print(response.body);
      isSubSubCategoryOk = true;
      var index = 0;
      if (dataAllsubCategoriesProducts['categories'] != []) {
        dataAllsubCategoriesProducts['categories'].forEach((newsId) {
          loadedAllsubCategories.add(
              SubCategory(
                id: newsId['id'],
                photo: newsId['photo'],
                title: newsId['name_en'],
              )
          );
          index++;
        });
        _subSubCategories = loadedAllsubCategories;
      } else {
        _subSubCategories = [];
      }
      notifyListeners();
    }
  }

  List<SubCategory> loadedAllsubCategories;
  List<ProductShow> _mainCategoriesProducts = [];

  List<ProductShow> get mainCategoriesProducts {
    return _mainCategoriesProducts;
  }

  var dataAllmainCategories;
  List<ProductShow> loadedAllmainCategories;
  bool isMainCategoryOk = false;
  String selectedCategoryName;
  bool onceMainCategoryProducts = false;

  Future<void> fetchDataMainCategories(int catId, String sort, String type,
      String catName) async {
    print(catId);
    selectedCategoryName = catName;
    loadedAllmainCategories = [];
    loadedAllsubCategories = [];
    print('${Languages.selectedLanguageStr}Languages.selectedLanguageStr');
    final response = await http.get(Uri.parse('${AllProviders
        .hostName}/api/v1/maincategories/single/$catId?lang=${Languages
        .selectedLanguageStr}&category_type=store'));
    // final response = await http.get(Uri.parse('${AllProviders.hostName}/api/v1/categories?type=store&parent_id=$catId}&lang=${Languages.selectedLanguageStr}'));
    dataAllmainCategories = json.decode(response.body);
    print('${dataAllmainCategories}Languages.selectedLanguageStr');
    if (dataAllmainCategories['status'] == false) {
      return;
    }
    print(response.body);
    isMainCategoryOk = true;
    {
      if (dataAllmainCategories['Main Category']['categories'] != []) {
        dataAllmainCategories['Main Category']['categories'].forEach((newsId) {
          loadedAllsubCategories.add(SubCategory(
            id: newsId['id'],
            photo: newsId['photo'],
            title: newsId['name_${Languages.selectedLanguageStr}'],
            maincategory_id: newsId['id'],
          ));
        });
        _subCategories = loadedAllsubCategories;
      } else {
        _subCategories = [];
      }
      print('${response.body}  mmmmm2mmmmm');
      var index = 0;
      // dataAllmainCategories['Main Category']['categories'].forEach((newsId1) {
      //   if (newsId1['products'] != null) {
      //     newsId1['products'].forEach((newsId) {
      //       loadedAllmainCategories.add(
      //         ProductShow(
      //           id: newsId['id'],
      //           image: newsId['photo'],
      //           title: newsId['name_${Languages.selectedLanguageStr}'],
      //           description:
      //           newsId['description_${Languages.selectedLanguageStr}'],
      //           price: newsId['price'],
      //           discount: newsId['discount'],
      //           isActive:newsId['approval']==0?false:true,
      //           discountPercentage: percentage,
      //           isFavorite: favoriteIds.contains(newsId['id']) ? true : false,
      //           index: index,
      //         ),
      //       );
      //       index++;
      //     });
      //   }
      // });
      if (dataAllmainCategories['Main Category']['products'] != []) {
        dataAllmainCategories['Main Category']['products'].forEach(
              (newsId1) {
            print('${newsId1['approval']}approvalapprovalapproval');
            if (newsId1['products'] != []) {
              loadedAllmainCategories.add(
                ProductShow(
                  id: newsId1['id'],
                  image: newsId1['photo'],
                  title: newsId1['name_${Languages.selectedLanguageStr}'],
                  description:
                  newsId1['description_${Languages.selectedLanguageStr}'],
                  price: newsId1['price'],
                  discount: newsId1['discount'],
                  isActive: newsId1['approval'] == 1 ? true : false,
                  discountPercentage: percentage,
                  isFavorite: favoriteIds.contains(newsId1['id'])
                      ? true
                      : false,
                  index: index,
                ),
              );
              index++;
            }
          },
        );
      }
      _mainCategoriesProducts = loadedAllmainCategories;
      notifyListeners();
    }
    notifyListeners();
  }

  var dataAllCategoriesProducts;
  List<ProductShow> loadedAllCategoriesProducts = List<ProductShow>();
  List<ProductShow> _categoriesProducts = [];

  List<ProductShow> get categoriesProducts {
    return _categoriesProducts;
  }

  static bool isMainCatProductsOk = false;
  static bool onceMainCatProducts = false;

  Future<void> fetchDataCategoriesProducts(int catId, String sort,
      String type) async {
    loadedAllCategoriesProducts = [];
    if (onceMainCatProducts == false) {
      onceMainCatProducts = true;
      final response = await http.get(Uri.parse(
          '${AllProviders
              .hostName}/api/v1/maincategories/single/$catId?lang=${Languages
              .selectedLanguageStr}&sort=$sort&type=$type'));
      dataAllCategoriesProducts = json.decode(response.body);
      if (dataAllCategoriesProducts['status'] == false) {
        return;
      }
      isMainCatProductsOk = true;
      var index = 0;
      if (dataAllCategoriesProducts['Main Category']['products'] != []) {
        dataAllCategoriesProducts['Main Category']['products']
            .forEach((newsId) {
          loadedAllCategoriesProducts.add(
            ProductShow(
              id: newsId['id'],
              image: newsId['photo'],
              title: newsId['name_${Languages.selectedLanguageStr}'],
              description:
              newsId['description_${Languages.selectedLanguageStr}'],
              price: newsId['price'],
              discount: newsId['discount'],
              discountPercentage: percentage,
              isActive: newsId['approval'] == 0 ? false : true,
              isFavorite: favoriteIds.contains(newsId['id']) ? true : false,
              index: index,
            ),
          );
          index++;
        });
        _categoriesProducts = loadedAllCategoriesProducts;
      } else {
        _categoriesProducts = [];
      }
      notifyListeners();
    }
  }

  List<ProductShow> _allProductsSimilar = [];

  List<ProductShow> get allProductsSimilar {
    return _allProductsSimilar;
  }

  List<ProductShow> loadedAllProductsSimilar = List<ProductShow>();
  static bool isProductSimilarMainOk = false;
  bool _isProdSimilar = false;

  bool get isProdSimilar => _isProdSimilar;
  static bool onceSimilar = false;

  Future<void> fetchDataAllProductsOnSimilar(String catType, int catId,) async {
    print('$catType fetching similler prod');
    print('$catId fetching similler prod');
    if (onceSimilar == false) {
      onceSimilar = true;
      isProductSimilarMainOk = false;
      loadedAllProductsSimilar = [];
      print("this is the type " + catType);
      var url;
      if (catType == "App\\Model\\MainCategory") {
        print("in maincategories ");
        url =
        '${AllProviders
            .hostName}/api/v1/maincategories/single/$catId?lang=${Languages
            .selectedLanguageStr}&limit=6&category_type=store';
      }
      else if (catType == "App\\Model\\Category") {
        print("in subcategories");
        url =
        "${AllProviders
            .hostName}/api/v1/subcategories/single/$catId?lang=${Languages
            .selectedLanguageStr}&limit=6&type=$catType&category_type=store";
      }
      else if (catType == "App\\Model\\Category") {
        url =
        '${AllProviders
            .hostName}/api/v1/categories/single/$catId?lang=ar&sort=price&type=DESC&category_type=store';
        print("in categories");
      }
      final response = await http.get(Uri.parse(url));
      print('${json.decode(response.body)} dataAllProductsSimilar');
      var dataAllProductsSimilar = json.decode(response.body);
      if (dataAllProductsSimilar['status'] == false) {
        return;
      }
      var percentageMainCat;
      if (catType == "App\\Model\\MainCategory") {
        if (dataAllProductsSimilar['Main Category']['products'] != []) {
          dataAllProductsSimilar['Main Category']['products'].forEach((newsId) {
            if (newsId['discount'] != 0) {
              num first = newsId['discount'] / newsId['price'];
              num second = first * 100;
              percentageMainCat = second - 100;
            }
            var index = 0;
            loadedAllProductsSimilar.add(ProductShow(
              id: newsId['id'],
              image: newsId['photo'],
              title: newsId['name_${Languages.selectedLanguageStr}'],
              description:
              newsId['description_${Languages.selectedLanguageStr}'],
              price: newsId['price'],
              discount: newsId['discount'],
              isActive: newsId['approval'] == 0 ? false : true,
              discountPercentage: percentageMainCat,
              isFavorite: favoriteIds.contains(newsId['id']) ? true : false,
              index: index,
            ),);
            index++;
          });
          _allProductsSimilar = loadedAllProductsSimilar;
        } else {
          _allProductsSimilar = [];
        }
      }
      else if (catType == "App\\Model\\Category") {
        var percentageSubCat;
        if (dataAllProductsSimilar['category']['products'] != []) {
          dataAllProductsSimilar['category']['products'].forEach((newsId) {
            if (newsId['discount'] != 0) {
              num first = newsId['discount'] / newsId['price'];
              num second = first * 100;
              percentageSubCat = second - 100;
            }
            var index = 0;
            loadedAllProductsSimilar.add(
              ProductShow(
                id: newsId['id'],
                image: newsId['photo'],
                title: newsId['name_${Languages.selectedLanguageStr}'],
                description:
                newsId['description_${Languages.selectedLanguageStr}'],
                price: newsId['price'],
                discount: newsId['discount'],
                isActive: newsId['approval'] == 0 ? false : true,
                discountPercentage: percentageSubCat,
                isFavorite: favoriteIds.contains(newsId['id']) ? true : false,
                index: index,
              ),
            );
            index++;
          });
          _allProductsSimilar = loadedAllProductsSimilar;
        } else {
          _allProductsSimilar = [];
        }
      }
      _allProductsSimilar = loadedAllProductsSimilar;
      isProductSimilarMainOk = true;
      _isProdSimilar = true;
      print('$dataAllProductsSimilar dataAllProductsSimilar');
      notifyListeners();
    }
  }

  static bool hasLogin;
  List<News> _posts = [];

  List<News> get posts {
    return _posts;
  }

  bool isPostsOk = false;

  Future<void> fetchOffersStore({type: 'store'}) async {
    final response = await http.get(Uri.parse(
        '$hostName/api/v1/offers?type=$type&lang=${Languages.selectedLanguageStr
            .toString()}'));
    var data = json.decode(response.body);
    print('${data} datadatadatadata');
    final List<News> loadedPosts = [];
    if (data == null) {
      return;
    }
    isPostsOk = true;
    data['offers'].forEach((newsId) {
      loadedPosts.add(News(
        id: newsId["id"],
        title: newsId["title_${Languages.selectedLanguageStr}"],
        text: newsId["description_${Languages.selectedLanguageStr}"],
        date: newsId["created_at"],
        productId: newsId["product_id"],
        image: newsId["photo"],
      ));
    });
    _posts = loadedPosts;
    notifyListeners();
  }

  List<SliderModel> _slider = [];

  List<SliderModel> get sliders {
    return _slider;
  }

  List<SliderModel> loadedSlider;
  var isOfflineSlider;
  bool onceSlider = false;
  bool isEverythingOkSider = false;

  Future<void> fetchDataSliders() async {
    if (onceSlider == false) {
      onceSlider = true;
      final response =
      await http.get(Uri.parse('${AllProviders.hostName}/api/v1/sliders'));
      var data4 = json.decode(response.body);
      final List<SliderModel> loadedSlider = [];
      if (data4 == null) {
        return null;
      }
      isOfflineSlider = data4;
      data4['sliders'].forEach((newsId) {
        loadedSlider.add(SliderModel(
          id: newsId['id'],
          image: newsId['photo'],
          productid: newsId['product_id'],
          // hasProduct: newsId['hasProduct'] == "1" ? true : false,
        ));
      });
      if (data4['status'] == true) {
        isEverythingOkSider = true;
        notifyListeners();
      }
      _slider = loadedSlider;
    }
  }

  List<SearchCat> _searchCat = [];

  List<SearchCat> get searchCat {
    return _searchCat;
  }

  List<SearchCat> loadedSearchCat;
  bool isEverythingOkSearchCat = false;
  bool onceSearchCat = false;

  Future<void> fetchDataSearchCategories() async {
    loadedSearchCat = [];
    if (onceSearchCat == false) {
      onceSearchCat = true;
      final response = await http.get(Uri.parse(
          '${AllProviders.hostName}/api/v1/CategoryCount?lang=${Languages
              .selectedLanguageStr}'));
      //print(response.body);
      print("this is the search category : ${response.body}");
      var data4 = json.decode(response.body);
      if (data4 == null) {
        return null;
      }
      // if (data4['categories'] != []) {
      //   data4['categories'].forEach((newsId) {
      //     loadedSearchCat.add(SearchCat(
      //         id: newsId['id'],
      //         name: newsId['name_${Languages.selectedLanguageStr}'],
      //         products_count: newsId['products_count'],
      //         catType: "Category"
      //         // hasProduct: newsId['hasProduct'] == "1" ? true : false,
      //         ));
      //   });
      // }
      if (data4['MainCategoies'] != []) {
        data4['MainCategoies'].forEach((newsId) {
          loadedSearchCat.add(SearchCat(
              id: newsId['id'],
              name: newsId['name_${Languages.selectedLanguageStr}'],
              products_count: newsId['products_count'],
              catType: "MainCategory"
            // hasProduct: newsId['hasProduct'] == "1" ? true : false,
          ));
        });
      }
      isEverythingOkSearchCat = true;
      _searchCat = loadedSearchCat;
      notifyListeners();
    }
  }

  List<ProductShow> _allProducts = [];

  List<ProductShow> get allProducts {
    return _allProducts;
  }

  List<ProductShow> loadedAllProducts;
  bool isProductsMainOk = false;
  double percentage;
  String currentPostsUrl = "$hostName/api/v1/products?lang=";
  bool waitingForUrl = false;
  List<ProductShow> loadedAllProductsMain = [];
  bool onceGetProductsParam = false;
  List<String> sortBy = [
    'name_${Languages.selectedLanguageStr}',
    'price',
    'description_${Languages.selectedLanguageStr}',
    'id',
    'discount',
    'photo',
    'created_at',
  ];
  List<String> sortByType = [
    'ASC',
    'DESC',
  ];
  final _random = new Random();
  static String sortByElement;
  static String sortByElementType;
  var indexp = 0;

  Future<void> fetchDataAllProducts() async {
    if (onceGetProductsParam == false) {
      onceGetProductsParam = true;
      sortByElement = sortBy[_random.nextInt(sortBy.length)];
      sortByElementType = sortByType[_random.nextInt(sortByType.length)];
    }
    if (currentPostsUrl != null) {
      waitingForUrl = true;
      final response = await http.get(Uri.parse(currentPostsUrl +
          "${Languages.selectedLanguageStr}" +
          "&sort=" +
          sortByElement +
          "&type=" +
          sortByElementType));
      var dataAllProducts = json.decode(response.body);
      if (dataAllProducts['status'] == false) {
        return;
      }
      print('${response.body} eeeeeeeeee');
      isProductsMainOk = true;
      waitingForUrl = false;
      dataAllProducts['products']['data'].forEach((newsId) {
        if (newsId['discount'] != 0) {
          num first = newsId['discount'] - newsId['price'];
          num second = first / newsId['price'];
          percentage = second * 100;
        }
        print('${newsId['approval']} approvalapprovalapproval');
        print('${response.body} eeeeeeeeee');
        loadedAllProductsMain.add(
          ProductShow(
            id: newsId['id'],
            image: newsId['photo'],
            title: newsId['name_${Languages.selectedLanguageStr}'],
            description: newsId['description_${Languages.selectedLanguageStr}'],
            price: newsId['price'],
            discount: newsId['discount'],
            isActive: newsId['approval'] == 0 ? false : true,
            discountPercentage: percentage,
            isFavorite: favoriteIds.contains(newsId['id']) ? true : false,
            index: indexp,
          ),
        );
        indexp++;
        // print("this is the name of the product " +
        //     newsId["name_en"]);
      });
      currentPostsUrl =
      "${dataAllProducts['products']['next_page_url']}&lang=${Languages
          .selectedLanguageStr}&sort=$sortByElement&type=$sortByElementType";
      print(currentPostsUrl);
      //fetchFavorites();   <================= her is the favorite for each product
      _allProducts = loadedAllProductsMain;
      notifyListeners();
    }
  }

  static bool getOnceImage = false;
  static Pieces selectedPiece;
  Product allProduct;
  List<ProductImage> loadedProductImages;
  List<Pieces> loadedProductPieces;
  List<ProductQuestion> loadedProductQuestion;
  List<Product> loadedAllProduct;
  static bool isProductOk = false;
  bool _isProdLoaded = false;

  bool get isProdLoaded => _isProdLoaded;

  Future<void> fetchDataProduct(int productId) async {
    loadedProductImages = [];
    loadedProductPieces = [];
    loadedProductQuestion = [];
    print(productId);
    final response = await http.get(Uri.parse(
        '$hostName/api/v1/products/single/$productId?lang=${Languages
            .selectedLanguageStr}'));
    var dataProduct = json.decode(response.body);
    final List<Product> loadedAllProduct = [];
    print(dataProduct);
    if (dataProduct['status'] == false) {
      return;
    }
    var indexPhotos = 1;
    dataProduct['product']['photos'].forEach((photo) {
      loadedProductImages.add(
        ProductImage(
          index: indexPhotos,
          image: photo['photo'],
          product_id: photo['product_id'],
        ),
      );
      indexPhotos++;
    });
    var percentagePieces;
    dataProduct['product']['pieces'].forEach((piece) {
      percentagePieces = 0.0;
      if (piece['discount'] != null) {
        num first = piece['discount'] / piece['price'];
        num second = first * 100;
        percentagePieces = second - 100;
      }
      loadedProductPieces.add(
        Pieces(
          id: piece['id'],
          size_id: piece['size_id'],
          color_id: piece['color_id'],
          product_id: piece['product_id'],
          quantity: piece['quantity'],
          price: piece['price'],
          discount: piece['discount'],
          color: piece['color']['code'],
          size: piece['size']['size'],
          discountPercentage: percentagePieces,
        ),
      );
    });
    dataProduct['product']['asks'].forEach((photo) {
      loadedProductQuestion.add(
        ProductQuestion(
          question: photo['question_${Languages.selectedLanguageStr}'],
          answer: photo['answer_${Languages.selectedLanguageStr}'],
        ),
      );
    });
    var percentageMainProduct;
    if (dataProduct['product']['discount'] != 0) {
      num first =
          dataProduct['product']['discount'] / dataProduct['product']['price'];
      num second = first * 100;
      percentageMainProduct = second - 100;
    }
    loadedProductImages.insert(
        0, ProductImage(index: 0, image: dataProduct['product']['photo']));
    isProductOk = true;
    notifyListeners();
    var index = 0;
    print('${dataProduct['product']['point']} pointsssss');
    print(dataProduct['product']);
    loadedAllProduct.add(Product(
      id: dataProduct['product']['id'],
      name: dataProduct['product']['name_${Languages.selectedLanguageStr}'],
      description: dataProduct['product']
      ['description_${Languages.selectedLanguageStr}'],
      image: dataProduct['product']['photo'],
      price: dataProduct['product']['price'],
      discount: dataProduct['product']['discount'],
      points: dataProduct['product']['point'] ?? 0,
      discountPercentage: percentageMainProduct,
      quantity: dataProduct['product']['quantity'],
      // approval:  dataProduct['product']['approval']==1?true:false,
      catId: dataProduct['product']['productable_id'],
      catType: dataProduct['product']['productable_type'],
      pointPrice: dataProduct['product']['point_price'] ?? 0,
      images: loadedProductImages,
      pieces: loadedProductPieces,
      questions: loadedProductQuestion,
      isFavorite:
      favoriteIds.contains(dataProduct['product']['id']) ? true : false,
      index: index,
      note: dataProduct['product']['note'],
    ));
    index++;
    _isProdLoaded = true;
    allProduct = loadedAllProduct[0];
    notifyListeners();
  }

  static bool getOnceColors = false;
  static String selectedColor = '';

  // static bool isAnotherColorSelected = false;
  void isAnyColorSelected(String selectedColor2) {
    selectedColor = selectedColor2;
    notifyListeners();
  }

  static String selectedSize = '';

  // static bool isAnotherColorSelected = false;
  void isAnySizeSelected(String selectedSize2) {
    selectedSize = selectedSize2;
    notifyListeners();
  }

  Future<http.Response> sendOrder() async {
    int earnedPoints = 0;
    List<CartItemModel> carts = List<CartItemModel>();
    cartItemsAll.forEach((item) {
      String imageName = item.photo
          .split('/')
          .last;
      // earnedPoints=earnedPoints+item.earnedPoints;
      //print("this is the color :" + item.color_code);
      carts.add(CartItemModel(
        id: item.id,
        product_id: item.product_id,
        name: item.name,
        photo: imageName,
        color_code: item.color_code,
        size: item.size,
        quantity: item.quantity,
        quantityTotal: item.quantity,
        price: item.price,
        pieceId: item.pieceId,
      ));
    });
    var jsondata = jsonEncode(carts);
    print(jsondata);
    // print(promocode.id.toString(),);
    //print(ast);
    print('${shippingCost.toString()}   shippingCost');
    var response =
    await http.post(
        Uri.parse('${AllProviders.hostName}/api/v1/orders/store'), body: {
      "products": jsondata,
      "name": selectedAddress.name_address.toString(),
      "phone": selectedAddress.phone_address.toString(),
      "country": selectedAddress.country_address.toString(),
      "city": selectedAddress.city_address.toString(),
      "lat": selectedAddress.lat.toString(),
      "long": selectedAddress.long.toString(),
      "point": selectedAddress.point_address.toString(),
      'total_points': totalPoints.toString(),
      "promocode_id": promocode.id.toString(),
      "total": lastlastTotalPrice.toString(),
      "shipping": shippingCost.toString(),
      // 'earnedPoints':earnedPoints.toString(),
    }, headers: {
      'Authorization': UserProvider.token,
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
    });
    print(response.body);
    notifyListeners();
    return response;
  }

  Future<http.Response> updatePoints() async {
    print('$totalPoints   totalPoints');
    var response =
    await http.post(
        Uri.parse('${AllProviders.hostName}/api/v1/user/points'), body: {
      "points": totalPoints.toString(),
    }, headers: {
      'Authorization': UserProvider.token,
      'Accept': "application/json"
    });
    print(response.body);
    notifyListeners();
    return response;
  }

  void changeFavoriteValue(int index, bool isFavorittte) {
    allProducts[index].isFavorite = !isFavorittte;
    getAllfavorite();
  }

  //notifyListeners();}
  Future<void> insertFavorite(int id) async {
    if (!favoriteIds.contains(id)) {
      final response = await http
          .post(
          Uri.parse('${AllProviders.hostName}/api/v1/favorites/store'), body: {
        'product_id': id.toString(),
      }, headers: {
        'Authorization': UserProvider.token,
      });
      print(response.body);
      var data = json.decode(response.body);
      if (data['status'] == false) {
        return;
      }
    }
  }

  //notifyListeners();
  Future<void> deleteFavorite(int product_id, int user_id) async {
    var deleteMe;
    allFavoriteItems.forEach((element) {
      if (element.id == product_id) {
        deleteMe = element;
      }
    });
    allFavoriteItems.remove(deleteMe);
    final response = await http.get(Uri.parse(
        '${AllProviders
            .hostName}/api/v1/favorites/delete?product_id=${product_id}&user_id=${user_id}'),
        headers: {
          'Authorization': UserProvider.token,
        });
    print(response.body);
    var data = json.decode(response.body);
    if (data['status'] == false) {
      return;
    }
    notifyListeners();
  }

  bool isFavoriteOk = false;
  bool getFavoriteOnce = false;

  Future<void> getAllfavorite() async {
    if (getFavoriteOnce == false) {
      allFavoriteItems = [];
      getFavoriteOnce = true;
      final response = await http.get(Uri.parse(
          '$hostName/api/v1/favorites?lang=${Languages.selectedLanguageStr}'),
          headers: {
            "Authorization": UserProvider.token,
          });
      isFavoriteOk = true;
      print(response.body);
      var dataAllProductFavorite = json.decode(response.body);
      var index = 0;
      if (dataAllProductFavorite['status'] == true) {
        dataAllProductFavorite['favorites'].forEach((newsId) {
          if (newsId['product']['discount'] != 0) {
            num first =
                newsId['product']['discount'] - newsId['product']['price'];
            double second = first / newsId['product']['price'];
            percentage = second * 100;
          }
          allFavoriteItems.add(
            ProductShow(
              id: newsId['product']['id'],
              image: newsId['product']['photo'],
              title: newsId['product']['name_${Languages.selectedLanguageStr}'],
              description: newsId['product']
              ['description_${Languages.selectedLanguageStr}'],
              price: newsId['product']['price'],
              discount: newsId['product']['discount'],
              discountPercentage: percentage,
              isFavorite: true,
              isActive: newsId['product']['approval'] == 1 ? true : false,
              index: index,
            ),
          );
          favoriteIds.add(newsId['product']['id']);
          //print(favoriteIds[index]);
          index += 1;
        });
      }
      notifyListeners();
    }
  }


}