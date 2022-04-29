import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/app_themes.dart';
import 'package:new_sahla/ecomerce/model/address.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/RepositoryServiceTodo.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:provider/provider.dart';

class AddressOrderTemplate extends StatefulWidget {
  final Address address;
  final bool isThisEdit;

  AddressOrderTemplate(
    this.address,
    this.isThisEdit,
  );

  @override
  State<AddressOrderTemplate> createState() => _AddressOrderTemplateState();
}

class _AddressOrderTemplateState extends State<AddressOrderTemplate> {
  bool isLoading = false;

  var align =
      Languages.selectedLanguage == 0 ? TextAlign.left : TextAlign.right;

  var dir =
      Languages.selectedLanguage == 0 ? TextDirection.rtl : TextDirection.ltr;

  var revAlign =
      Languages.selectedLanguage == 1 ? TextAlign.left : TextAlign.right;

  var revDir =
      Languages.selectedLanguage == 1 ? TextDirection.rtl : TextDirection.ltr;

  @override
  Widget build(BuildContext context) {
    final allpro = Provider.of<AllProviders>(context, listen: true);
    final lang = Provider.of<Languages>(context);
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0.2,
              blurRadius: 1.9)
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(0),
        ),
      ),
      child: Table(
        children: [
          TableRow(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 0.7))),
              children: [
                Text(
                  widget.address.name_address,
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: align,
                  textDirection: dir,
                ),
                Container(
                    height: 10,
                    margin: EdgeInsets.all(10),
                    child: VerticalDivider(
                      thickness: 3,
                      color: Theme.of(context).primaryColor,
                    )),
                Text(
                  lang.translation['nameTitle'][Languages.selectedLanguage],
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: revAlign,
                  textDirection: revDir,
                ),
              ]),
          TableRow(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 0.7))),
              children: [
                Text(
                  widget.address.point_address,
                  style: Theme.of(context).textTheme.headline1,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: align,
                  textDirection: dir,
                ),
                Container(
                    margin: EdgeInsets.all(10),
                    height: 10,
                    child: VerticalDivider(
                      thickness: 3,
                      color: Theme.of(context).primaryColor,
                    )),
                Text(
                  lang.translation['addressTitle'][Languages.selectedLanguage],
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: revAlign,
                  textDirection: revDir,
                ),
              ]),
          TableRow(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 0.7))),
              children: [
                Text(
                  widget.address.phone_address.toString(),
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: align,
                  textDirection: dir,
                ),
                Container(
                    margin: EdgeInsets.all(10),
                    height: 10,
                    child: VerticalDivider(
                      thickness: 3,
                      color: Theme.of(context).primaryColor,
                    )),
                Text(
                  lang.translation['phoneTitleAddress']
                      [Languages.selectedLanguage],
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: revAlign,
                  textDirection: revDir,
                ),
              ]),
          TableRow(
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.black12, width: 0.7))),
              children: [
                Text(
                  '${widget.address.city_address}',
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: align,
                  textDirection: dir,
                ),
                Container(
                    margin: EdgeInsets.all(10),
                    height: 10,
                    child: VerticalDivider(
                      thickness: 3,
                      color: Theme.of(context).primaryColor,
                    )),
                Text(
                  lang.translation['cityTitle'][Languages.selectedLanguage],
                  style: Theme.of(context).textTheme.headline1,
                  textAlign: revAlign,
                  textDirection: revDir,
                ),
              ]),
          // TableRow(
          //     decoration:BoxDecoration(
          //         border: Border(bottom: BorderSide(color: Colors.black12,width: 0.7))
          //     ),
          //     children: [
          //       Text(
          //         '${ widget.address.country_address}',
          //         style: Theme.of(context).textTheme.headline1,
          //         textAlign: align,
          //         textDirection: dir,
          //       ),
          //       Container(
          //           margin: EdgeInsets.all(10),
          //           height: 10,
          //           child: VerticalDivider(
          //             thickness: 3,
          //             color: Theme.of(context).primaryColor,
          //           )),
          //       Text(
          //         lang.translation['conutryTitle'][Languages.selectedLanguage],
          //         style: Theme.of(context).textTheme.headline1,
          //         textAlign: revAlign,
          //         textDirection: revDir,
          //       ),
          //     ]
          // ),
          if (widget.isThisEdit)
            TableRow(children: [
              RaisedButton(
                onPressed: () {
                  setState(() {
                    RepositoryServiceTodo.deleteAddress(
                            widget.address.id_address, allpro)
                        .then((value) {
                      allpro.refreshAddress(AllProviders.allAddreses);
                    });
                  });
                },
                color: Colors.redAccent,
                child: Container(
                  width: 100,
                  child: Center(
                      child: Text(
                    lang.translation['deleteTitle'][Languages.selectedLanguage],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: fonts,
                    ),
                  )),
                ),
              ),
              Container(
                  height: 10,
                  margin: EdgeInsets.all(10),
                  child: VerticalDivider(
                    thickness: 3,
                    color: Theme.of(context).primaryColor,
                  )),
              RaisedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  allpro.getShippingCost(widget.address.cityId).then((value) {
                    if (value == 0) {
                      isLoading = false;
                      RepositoryServiceTodo.deleteAddress(
                              widget.address.id_address, allpro)
                          .then((value) {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              content: Text(
                                "error",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              title: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.warning,
                                      color: Colors.redAccent,
                                      size: 40,
                                    ),
                                  ],
                                ),
                              ),
                              elevation: 2,
                            );
                          },
                        );
                      });
                    } else {
                      isLoading = false;
                      allpro.setSelectedAddress(widget.address);
                      allpro.selectedAddress = widget.address;
                      // allpro.selectedShipPrice =
                      Navigator.of(context).pop();
                    }
                  });
                },
                color: Colors.green,
                child: Container(
                  width: 100,
                  child: Center(
                      child: isLoading == false
                          ? Text(
                              lang.translation['chooseTitle']
                                  [Languages.selectedLanguage],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: fonts,
                              ),
                            )
                          : Container(
                              width: 25,
                              height: 25,
                              padding: const EdgeInsets.all(2.0),
                              child: CircularProgressIndicator(
                                // backgroundColor: Colors.white,
                                strokeWidth: 5,
                                semanticsValue: 'loading',
                                semanticsLabel: 'ssss',
                              ),
                            )),
                ),
              ),
            ]),
        ],
      ),
    );
  }
}
