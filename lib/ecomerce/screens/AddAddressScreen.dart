import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_sahla/ecomerce/model/address.dart';
import 'package:new_sahla/ecomerce/model/city.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/RepositoryServiceTodo.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/services/screens/map_screen.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AddAddressScreen extends StatefulWidget {
  final String searchInitial;

  AddAddressScreen({this.searchInitial});

  static var country;
  static var city;

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  TextEditingController myControllerName = TextEditingController();

  TextEditingController myControllerPhone = TextEditingController();

  TextEditingController myControllerAddress = TextEditingController();

  String _selectedCountry;

  String _selectedCountryString;

  String _selectedCity;

  int _selectedCityId;

  bool showCities = true;

  bool isLoading = false;

  @override
  void initState() {
    myControllerName.text = UserProvider.userName;
    myControllerPhone.text = UserProvider.userPhone;
    // TODO: implement initState
    super.initState();
    final allpro = Provider.of<AllProviders>(context, listen: false);
    setState(() {
      isLoading = true;
      allpro.getCity(allpro.allCountriesItems[0].id).then((value) {
        isLoading = false;
      });
    });
  }

  var _key = GlobalKey<FormState>();

  void _add(
    Position position,
  ) {
    final String markerIdVal = '0';
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(
        position.latitude,
        position.longitude,
      ),
      // infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
      // onTap: () {
      //   print("markerId");
      //   _onMarkerTapped(markerId);
      // },
      // onDragEnd: (LatLng position) {
      //   _onMarkerDragEnd(markerId, position);
      // },
    );
    setState(() {
      // allpro.changeMapSelectedStatus(true);
      markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    final allpro = Provider.of<AllProviders>(context, listen: true);
    //final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final lang = Provider.of<Languages>(context);
    _add(Position(
        latitude: UserProvider.latitude, longitude: UserProvider.longitude));
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        title: Container(
          margin: EdgeInsets.only(top: 25, bottom: 20, right: 20),
          //width: MediaQuery.of(context).size.width,
          //alignment: Alignment.centerRight,
          child: Text(
            lang.translation['addNewShippingAddress']
                [Languages.selectedLanguage],
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 20,
              fontFamily: fonts,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              //usernameEnter
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    // border: Border.all(color: Theme.of(context).primaryColor),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          offset: Offset(0, 2),
                          spreadRadius: 2.0),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                width: MediaQuery.of(context).size.width / 1.1,
                child: TextField(
                  controller: myControllerName,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Colors.black, fontSize: 20, fontFamily: fonts),
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: lang.translation['usernameEnter']
                          [Languages.selectedLanguage],
                      hintStyle: TextStyle(
                          color: Colors.black26,
                          fontSize: 17,
                          fontFamily: fonts),
                      labelStyle: TextStyle(
                          color: Colors.black, fontSize: 17, fontFamily: fonts),
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Colors.black87,
                        size: 20,
                      ),
                      suffixStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: fonts)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //phoneTitleEnter
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          offset: Offset(0, 2),
                          spreadRadius: 2.0),
                    ],
                    //border: Border.all(color: Theme.of(context).primaryColor),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                width: MediaQuery.of(context).size.width / 1.1,
                child: TextField(
                  controller: myControllerPhone,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Colors.black, fontSize: 17, fontFamily: fonts),
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      hintText: lang.translation['phoneTitleEnter']
                          [Languages.selectedLanguage],
                      hintStyle: TextStyle(
                          color: Colors.black26,
                          fontSize: 17,
                          fontFamily: fonts),
                      labelStyle: TextStyle(fontSize: 23),
                      prefixIcon: Icon(
                        Icons.phone_android,
                        color: Colors.black87,
                        size: 20,
                      ),
                      suffixStyle: TextStyle(
                          fontFamily: fonts,
                          color: Theme.of(context).primaryColor)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //areOrKeyPlease
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          offset: Offset(0, 2),
                          spreadRadius: 2.0),
                    ],
                    //border: Border.all(color: Theme.of(context).primaryColor),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                width: MediaQuery.of(context).size.width / 1.1,
                child: TextField(
                  controller: myControllerAddress,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: fonts,
                    color: Colors.black,
                    fontSize: 17,
                  ),
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        //"Known place near you",
                        lang.translation['areOrKeyPlease']
                            [Languages.selectedLanguage],
                    hintStyle: TextStyle(
                      fontFamily: fonts,
                      fontSize: 17,
                      color: Colors.black26,
                    ),
                    labelStyle: TextStyle(fontFamily: fonts, fontSize: 16),
                    prefixIcon: Icon(
                      Icons.pin_drop,
                      color: Colors.black87,
                      size: 20,
                    ),
                    suffixStyle: TextStyle(
                        fontFamily: fonts,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   padding: EdgeInsets.all(4),
              //   decoration: BoxDecoration(
              //       boxShadow: <BoxShadow>[
              //         BoxShadow(
              //             color: Colors.grey.withOpacity(0.2),
              //             offset: Offset(0, 2),
              //             spreadRadius: 2.0),
              //       ],
              //       //border: Border.all(color: Theme.of(context).primaryColor),
              //       color: Colors.white,
              //       borderRadius: BorderRadius.all(Radius.circular(6))),
              //   width: MediaQuery.of(context).size.width / 1.1,
              //   child: TextField(
              //     controller: myControllerAddressBuilding,
              //     textAlign: TextAlign.right,
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontSize: 20,
              //     ),
              //     decoration: new InputDecoration(
              //         border: InputBorder.none,
              //         hintText: "Building and floor",
              //         hintStyle: TextStyle(
              //           color: Colors.black87,
              //         ),
              //         labelStyle: TextStyle(fontSize: 16),
              //         // prefixIcon: Icon(
              //         //   Icons.pin_drop,
              //         //   color: Colors.black87,
              //         //   size: 20,
              //         // ),
              //         suffixStyle:
              //             TextStyle(color: Theme.of(context).primaryColor)),
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              // Container(
              //   padding: EdgeInsets.all(4),
              //   decoration: BoxDecoration(
              //       boxShadow: <BoxShadow>[
              //         BoxShadow(
              //             color: Colors.grey.withOpacity(0.2),
              //             offset: Offset(0, 2),
              //             spreadRadius: 2.0),
              //       ],
              //       //border: Border.all(color: Theme.of(context).primaryColor),
              //       color: Colors.white,
              //       borderRadius: BorderRadius.all(Radius.circular(6))),
              //   width: MediaQuery.of(context).size.width / 1.1,
              //   child: TextField(
              //     controller: myControllerAddressStreet,
              //     textAlign: TextAlign.right,
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontSize: 20,
              //     ),
              //     decoration: new InputDecoration(
              //         border: InputBorder.none,
              //         hintText: "Street Name",
              //         hintStyle: TextStyle(
              //           color: Colors.black87,
              //         ),
              //         labelStyle: TextStyle(fontSize: 16),
              //         // prefixIcon: Icon(
              //         //   Icons.pin_drop,
              //         //   color: Colors.black87,
              //         //   size: 20,
              //         // ),
              //         suffixStyle:
              //             TextStyle(color: Theme.of(context).primaryColor)),
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              // Container(
              //   child: Text(
              //     lang.translation['conutryTitle'][Languages.selectedLanguage],
              //     style: TextStyle(
              //         fontFamily: fonts,
              //         fontSize: 19, color: Theme.of(context).bottomAppBarColor),
              //   ),
              // ),
              Divider(),
              // Container(
              //   padding: EdgeInsets.all(4),
              //   decoration: BoxDecoration(
              //       boxShadow: <BoxShadow>[
              //         BoxShadow(
              //             color: Colors.grey.withOpacity(0.2),
              //             offset: Offset(0, 2),
              //             spreadRadius: 2.0),
              //       ],
              //       //border: Border.all(color: Theme.of(context).primaryColor),
              //       color: Colors.white,
              //       borderRadius: BorderRadius.all(Radius.circular(6))),
              //   width: MediaQuery.of(context).size.width / 1.1,
              //   child: DropdownButton<String>(
              //       isExpanded: true,
              //       hint: Container(
              //         color: Colors.white,
              //         width: MediaQuery.of(context).size.width / 1.5,
              //         margin: EdgeInsets.only(left: 50),
              //         child: Center(
              //           child: new Text(
              //             Languages.selectedLanguage == 0
              //                 ? "
              //                 : "Select Country",
              //             textAlign: TextAlign.center,
              //           ),
              //         ),
              //       ),
              //       value: _selectedCountry,
              //       underline: SizedBox(),
              //       icon: SizedBox(),
              //       items: allpro.allCountriesItems.map((Country value) {
              //         return new DropdownMenuItem<String>(
              //           value: value.id.toString(),
              //           child: Container(
              //               color: Colors.white,
              //               width: MediaQuery.of(context).size.width / 1.5,
              //               margin: EdgeInsets.only(left: 50),
              //               child: Center(
              //                 child: new Text(
              //                   value.name,
              //                   textAlign: TextAlign.right,
              //                 ),
              //               )),
              //         );
              //       }).toList(),
              //       onChanged: (newValue) {
              //         setState(() {
              //           isLoading = true;
              //           allpro.getCity(int.parse(newValue)).then((value) {
              //             isLoading = false;
              //           });
              //           showCities = true;
              //           var count = allpro.allCountriesItems
              //               .where((e) => e.id == int.parse(newValue))
              //               .toList();
              //           _selectedCountryString = count[0].name;
              //           _selectedCountry = newValue;
              //           _selectedCity = null;
              //         });
              //       }),
              // ),
              // textFiled(1, Languages.selectedLanguage==1?'country':'
              // ', null, context),
              // conutryTitle
              /* Container(
                width: MediaQuery.of(context).size.width / 1.1,
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: allpro.allCountriesItems.length,
                  itemBuilder: (context, int index) {
                    return InkWell(
                      onTap: () {
                        print(allpro.allCountriesItems[index].name);
                        setState(() {
                          AllProviders.selectedCountry =
                              allpro.allCountriesItems[index].id;
                        });
                        {
                          setState(() {
                            isLoading = true;
                            allpro
                                .getCity(allpro.allCountriesItems[index].id)
                                .then((value) {
                              isLoading = false;
                            });
                            showCities = true;
                            var count = allpro.allCountriesItems
                                .where((e) =>
                                    e.id == allpro.allCountriesItems[index].id)
                                .toList();
                            _selectedCountryString = count[0].name;
                            _selectedCountry =
                                allpro.allCountriesItems[index].name;
                            _selectedCity = null;
                          });
                        }
                      },
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            color: AllProviders.selectedCountry !=
                                    allpro.allCountriesItems[index].id
                                ? Colors.transparent
                                : Theme.of(context).primaryColor,
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 7),
                          child: Text(
                            allpro.allCountriesItems[index].name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: fonts,
                              color: AllProviders.selectedCountry !=
                                      allpro.allCountriesItems[index].id
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                    // ItemTags(
                    //   textStyle: TextStyle(
                    //     fontSize: 18,
                    //   ),
                    //   color: Theme.of(context).canvasColor,
                    //   activeColor: Theme.of(context).primaryColor,
                    //   borderRadius: BorderRadius.all(Radius.circular(5)),
                    //   index: index,
                    //   active: true,
                    //   customData: allpro.allCountriesItems[index],
                    //   // title:
                    //   //     "${appProvider.searchCat[index].products_count} - ${appProvider.searchCat[index].name}",
                    //   title: allpro.allCountriesItems[index].name,
                    //   singleItem: true,
                    //   elevation: 0,
                    //   onPressed: (item) {
                    //     setState(() {
                    //       isLoading = true;
                    //       allpro.getCity(item.customData.id).then((value) {
                    //         isLoading = false;
                    //       });
                    //       showCities = true;
                    //       var count = allpro.allCountriesItems
                    //           .where((e) => e.id == item.customData.id)
                    //           .toList();
                    //       _selectedCountryString = count[0].name;
                    //       _selectedCountry = item.customData.name;
                    //       _selectedCity = null;
                    //     });
                    //   },
                    // );
                  },
                ),
              ),*/
              // Container(
              //   width: MediaQuery.of(context).size.width / 1.1,
              //   child: Tags(
              //     itemCount: allpro.allCountriesItems.length,
              //     horizontalScroll: true,
              //     itemBuilder: (int index) {
              //       return ItemTags(
              //         textStyle: TextStyle(
              //           fontSize: 18,
              //         ),
              //         color: Theme.of(context).canvasColor,
              //         activeColor: Theme.of(context).primaryColor,
              //         borderRadius: BorderRadius.all(Radius.circular(5)),
              //         index: index,
              //         active: true,
              //         customData: allpro.allCountriesItems[index],
              //         // title:
              //         //     "${appProvider.searchCat[index].products_count} - ${appProvider.searchCat[index].name}",
              //         title: allpro.allCountriesItems[index].name,
              //         singleItem: true,
              //         elevation: 0,
              //         onPressed: (item) {
              //           setState(() {
              //             isLoading = true;
              //             allpro.getCity(item.customData.id).then((value) {
              //               isLoading = false;
              //             });
              //             showCities = true;
              //             var count = allpro.allCountriesItems
              //                 .where((e) => e.id == item.customData.id)
              //                 .toList();
              //             _selectedCountryString = count[0].name;
              //             _selectedCountry = item.customData.name;
              //             _selectedCity = null;
              //           });
              //         },
              //       );
              //     },
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              showCities == true &&
                      (allpro.allCitiesItems.length != 0 ||
                          allpro.allCitiesItems.length != null)
                  ? Consumer<AllProviders>(
                      builder: (ctx, value, _) {
                        if (isLoading == false) {
                          return Column(
                            children: <Widget>[
                              Container(
                                child: Text(
                                  lang.translation['cityTitle']
                                      [Languages.selectedLanguage],
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontFamily: fonts,
                                      color:
                                          Theme.of(context).bottomAppBarColor),
                                ),
                              ),
                              Divider(),
                              // textFiled(2, Languages.selectedLanguage==1?'city':'
                              // ', null, context)
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          offset: Offset(0, 2),
                                          spreadRadius: 2.0),
                                    ],
                                    //border: Border.all(color: Theme.of(context).primaryColor),
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(6))),
                                width: MediaQuery.of(context).size.width / 1.1,
                                child: DropdownButton<String>(
                                    isExpanded: true,
                                    hint: Container(
                                      color: Colors.white,
                                      width: MediaQuery.of(context).size.width /
                                          1.5,
                                      margin: EdgeInsets.only(left: 50),
                                      child: Center(
                                        child: new Text(
                                          Languages.selectedLanguage == 0
                                              ? "اختر مدينة"
                                              : "Select city",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontFamily: fonts,
                                              color: Colors.black26),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    value: _selectedCity,
                                    underline: SizedBox(),
                                    icon: SizedBox(),
                                    items:
                                        value.allCitiesItems.map((City value) {
                                      return new DropdownMenuItem<String>(
                                        value: value.name,
                                        child: Container(
                                            color: Colors.white,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.5,
                                            margin: EdgeInsets.only(left: 50),
                                            child: Center(
                                              child: new Text(
                                                value.name,
                                                style: TextStyle(
                                                    fontSize: 19,
                                                    fontFamily: fonts,
                                                    color: Colors.lightBlue),
                                                textAlign: TextAlign.right,
                                              ),
                                            )),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        var count = allpro.allCitiesItems
                                            .where((e) => e.name == newValue)
                                            .toList();
                                        _selectedCityId = count[0].id;
                                        _selectedCity = newValue;
                                      });
                                    }),
                              ),
                            ],
                          );
                        } else {
                          return Shimmer.fromColors(
                            baseColor: Colors.black87,
                            highlightColor: Colors.white,
                            period: Duration(milliseconds: 700),
                            child: Container(
                              height: 80,
                              width: MediaQuery.of(context).size.width / 1.15,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.1),
                                    blurRadius: 0.0,
                                    spreadRadius:
                                        0.1, // has the effect of extending the shadow
                                    offset: Offset(
                                      0, // horizontal, move right 10
                                      0, // vertical, move down 10
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    )
                  : SizedBox(
                      height: 20,
                    ),
              Text(
                'Map:',
                style: TextStyle(
                    fontSize: 19,
                    fontFamily: fonts,
                    color: Theme.of(context).bottomAppBarColor),
              ),
              //map
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 200.0,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: GoogleMap(
                        mapToolbarEnabled: false,
                        onTap: (argument) {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => MapScreen(),
                          ))
                              .then((value) {
                            setState(() {
                              animateTo(UserProvider.latitude,
                                  UserProvider.longitude);
                            });
                          });
                        },
                        myLocationEnabled: false,
                        buildingsEnabled: false,
                        myLocationButtonEnabled: false,
                        onMapCreated: (controller) {
                          _completer.complete(controller);
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              UserProvider.latitude, UserProvider.longitude),
                          zoom: 14.0,
                        ),
                        markers: markers,
                      )),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    lang.translation['insert'][Languages.selectedLanguage],
                    style: TextStyle(
                        fontFamily: fonts, color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    var vaidate = _key.currentState.validate();
                    if (myControllerName.text != '' &&
                        myControllerAddress.text != '' &&
                        myControllerPhone.text != '' &&
                        _selectedCountry != '' &&
                        _selectedCity != '') {
                      setState(() {
                        isLoading = true;
                      });
                      RepositoryServiceTodo.addAddress(Address(
                        name_address: myControllerName.text,
                        phone_address: int.parse(myControllerPhone.text),
                        country_address: _selectedCountry,
                        city_address: _selectedCity,
                        lat: UserProvider.latitude.toString(),
                        long: UserProvider.longitude.toString(),
                        point_address: //"point near you : " +
                            myControllerAddress.text,
                        //+
                        // " " +
                        // "Building : " +
                        // myControllerAddressBuilding.text +
                        // " " +
                        // "Street Name : " +
                        // myControllerAddressStreet.text,
                        cityId: _selectedCityId,
                      ));
                      RepositoryServiceTodo.getAllAddress(allpro: allpro)
                          .then((value) {
                        Navigator.of(context).pop();
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.warning,
                                  color: Colors.redAccent,
                                ),
                                Container(
                                  child: Text(
                                    "error",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: fonts,
                                        color: Colors.black45),
                                  ),
                                ),
                              ],
                            ),
                            elevation: 2,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              SizedBox(
                height: 390,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textFiled(int index, String hint, String selValue, context) {
    final lang = Provider.of<Languages>(context);
    return Padding(
      padding: const EdgeInsets.only(right: 18.0),
      child: CupertinoTextFormFieldRow(
        onSaved: (newValue) {
          if (index == 1) AddAddressScreen.country = newValue;
          if (index == 2) AddAddressScreen.city = newValue;
        },
        style: Theme.of(context).textTheme.headline1,
        placeholder: hint,
        initialValue: selValue,
        textAlign: TextAlign.right,
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Set<Marker> markers = {};

  Completer<GoogleMapController> _completer = Completer();

  Future<void> animateTo(double lat, double lng) async {
    final c = await _completer.future;
    final p = CameraPosition(target: LatLng(lat, lng), zoom: 14.4746);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }
}
