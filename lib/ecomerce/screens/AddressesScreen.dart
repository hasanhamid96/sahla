import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/font.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/templetes/address_order_template.dart';
import 'package:provider/provider.dart';

import 'AddAddressScreen.dart';

class AddressesScreen extends StatefulWidget {
  final String searchInitial;

  AddressesScreen({this.searchInitial});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  TextEditingController myController = TextEditingController();

  @override
  void initState() {
    // CartProvider.loadedaddress = null;
    // CartProvider.once3 = false;
    // TODO: implement initState
    super.initState();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final allpro = Provider.of<AllProviders>(context, listen: false);
    final lang = Provider.of<Languages>(context);
    // appProvider.sharePrefsContaine("search");
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(
          lang.translation['shippingAddressTitle'][Languages.selectedLanguage],
          textAlign: TextAlign.right,
          style: TextStyle(
            fontSize: 20,
            fontFamily: fonts,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Consumer<AllProviders>(
                builder: (ctx, pro, _) {
                  if (AllProviders.allAddreses.length == 0) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.6,
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: Icon(
                                    Icons.pin_drop,
                                    size: 80,
                                    color: Colors.deepPurple.withOpacity(0.7),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    lang.translation[
                                            'thersisNoAddressHaveBeenAdded']
                                        [Languages.selectedLanguage],
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: fonts,
                                      color: Theme.of(context)
                                          .bottomAppBarColor
                                          .withOpacity(0.4),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: AllProviders.allAddreses.map((address) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: AddressOrderTemplate(address, true),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
              //add address
              Container(
                margin: EdgeInsets.only(top: 10, bottom: 140),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(12),
                  child: isLoading == false
                      ? Text(
                          lang.translation['addNewShippingAddress']
                              [Languages.selectedLanguage],
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: fonts,
                              fontSize: 18),
                        )
                      : CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (allpro.allCountriesItems.length == 0 &&
                        allpro.allCountriesItems != null) {
                      setState(() {
                        isLoading = true;
                      });
                      allpro.getCountries().then((value) {
                        if (value == true)
                          allpro
                              .getCity(allpro.allCountriesItems.last.id)
                              .then((value) {
                            setState(() {
                              isLoading = false;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddAddressScreen(),
                                ));
                          }).catchError((onError) {
                            setState(() {
                              isLoading = false;
                            });
                          });
                      });
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddAddressScreen(),
                          ));
                    }
                    //controller.jumpToTab(4);
                  },
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
