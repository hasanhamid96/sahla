
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/model/address.dart';
import 'package:new_sahla/ecomerce/model/cartItemModel.dart';
import 'package:new_sahla/ecomerce/providers/sqfliteCreate.dart';
import 'package:provider/provider.dart';
import 'UserProvider.dart';
import 'AllProviders.dart';
import 'languages.dart';
class RepositoryServiceTodo {
  static Future<List<CartItemModel>> getAllCarts() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.cartTable}''';
    final data = await db.rawQuery(sql);
    List<CartItemModel> carts = List();
    for (final node in data) {
      final cart = CartItemModel.fromJson(node);
      carts.add(cart);
    }
    return carts;}
    static Future<List<Address>> getAllAddress({AllProviders allpro}) async {
      final sql2 = '''SELECT * FROM ${DatabaseCreator.addressTable}''';
      final data = await db.rawQuery(sql2);
      List<Address> addresses = List<Address>();
      //print("this is the name :" + data.toString());
      data.forEach((element) {
        addresses.add(Address(
          id_address: element['id_address'],
          name_address: element['name_address'],
          phone_address: element['phone_address'],
          country_address: element['country_address'],
          city_address: element['city_address'],
          point_address: element['point_address'],
          cityId: element['cityId'],
        ));
      });
      allpro.refreshAddress(addresses);
      AllProviders.allAddreses = addresses;
      return addresses;}
      static Future<CartItemModel> getCart(int id) async {
        final sql = '''SELECT * FROM ${DatabaseCreator.cartTable}
    WHERE ${DatabaseCreator.product_id} = ?''';
        List<dynamic> params = [id];
        final data = await db.rawQuery(sql, params);
        //  if (data.length != 0) {
        final todo = CartItemModel.fromJson(data.first);
        // print("cart piece id : " + todo.pieceId.toString());
        // print("item piece id : " + pieceId.toString());
        // if (todo.pieceId != pieceId) {
        //   return null;
        // } else {
        return todo;
        //   }
        // } else {
        //   return null;
        // }}
      }
        static Future<void> addCart(
            CartItemModel cart, int pieceId, BuildContext context) async {
          bool incrementOnly = false;
          List<CartItemModel> cartItems = await getAllCarts();
          List<int> ids = [];
          cartItems.forEach((element) async {
            ids.add(element.product_id);
            print(element.product_id.toString());
          });
          List<bool> checkers = [];
          cartItems.forEach((element) {
            if (ids.contains(cart.product_id)) {
              //   int indexOf = ids.indexOf(cart.product_id);
              // print("this is the index of " + indexOf.toString());
              // print("this is the pices id " + cart.pieceId.toString());
              // print("this is the cart items piece id for indexOf " +
              //     element.pieceId.toString());
              if (pieceId == 0) {
                incrementOnly = true;
                checkers.add(true);
              } else {
                if (element.pieceId == cart.pieceId) {
                  incrementOnly = true;
                  checkers.add(true);
                } else {
                  incrementOnly = false;
                  checkers.add(false);
                }
              }
            } else {
              incrementOnly = false;
              checkers.add(false);
            }
          });
          if (checkers.contains(true)) {
            var total = cart.quantityTotal + 1;
            final sql2 = '''UPDATE ${DatabaseCreator.cartTable}
      SET ${DatabaseCreator.quantity} = ${DatabaseCreator.quantity} + 1
      WHERE ${DatabaseCreator.product_id} = ? AND ${DatabaseCreator.pieceId} = ? AND ${DatabaseCreator.quantity} + 1  <  ? 
      ''';
            List<dynamic> params = [cart.product_id, cart.pieceId, total];
            db.rawUpdate(sql2, params).then((value) {
              print("this is the resoult : " + value.toString());
              if (value == 1) {
                Flushbar(
                  messageText:Text( Languages.selectedLanguage == 0
                      ? "تم تحديث عربة التسوق"
                      : "Cart has been updated",style: TextStyle(fontFamily: fonts,color: Colors.white),),
                  barBlur: 0.4,
                  duration: Duration(milliseconds: 10000),
                  backgroundColor: Theme.of(context).primaryColor,
                  flushbarPosition: FlushbarPosition.TOP,
                ).show(context);
              } else if (value == 0) {
                Flushbar(
                  messageText: Text(Languages.selectedLanguage == 0
                      ? "العنصر غير متاح"
                      : "Item Not available",style: TextStyle(fontFamily: fonts,color: Colors.white),),
                  barBlur: 0.4,
                  duration: Duration(milliseconds: 10000),
                  backgroundColor: Theme.of(context).primaryColor,
                  flushbarPosition: FlushbarPosition.TOP,
                ).show(context);
              }
            });
            //DatabaseCreator.databaseLog('Update todo', sql2, null, result, params);
          }
          else {
            final sql = '''INSERT INTO ${DatabaseCreator.cartTable}
      (
        ${DatabaseCreator.product_id},
        ${DatabaseCreator.name},
        ${DatabaseCreator.photo},
        ${DatabaseCreator.color_code},
        ${DatabaseCreator.size},
        ${DatabaseCreator.quantity},
        ${DatabaseCreator.quantityTotal},
        ${DatabaseCreator.price},
         ${DatabaseCreator.pieceId},
         ${DatabaseCreator.points},
         ${DatabaseCreator.earnedPoints},
         ${DatabaseCreator.isUsePoint}
      )
      VALUES (?,?,?,?,?,?,?,?,?,?,?,?)''';
            List<dynamic> params = [
              cart.product_id,
              cart.name,
              cart.photo,
              cart.color_code,
              cart.size,
              cart.quantity,
              cart.quantityTotal,
              cart.price,
              cart.pieceId,
              cart.points,
              cart.earnedPoints,
              false
            ];
            await db.rawInsert(sql, params).then((value) {
              Flushbar(
                messageText: Text(Languages.selectedLanguage == 0
                    ? "تمت إضافة المنتج إلى سلة التسوق"
                    : "Product added to cart",style: TextStyle(fontFamily: fonts,color: Colors.white)),
                barBlur: 0.4,
                duration: Duration(milliseconds: 1000),
                backgroundColor: Theme.of(context).primaryColor,
                flushbarPosition: FlushbarPosition.TOP,
              ).show(context);
            });
            // DatabaseCreator.databaseLog('Add cart', sql, null, result, params);
          }
          getAllCarts();}
          static Future<void> deleteCartItem(
              CartItemModel cart, AllProviders allpro) async {
            final sql = '''DELETE ${DatabaseCreator.cartTable}
    WHERE ${DatabaseCreator.id} = ?
    ''';
            List<dynamic> params = [cart.id];
            final result =
            await db.delete("cart", where: "id = ?", whereArgs: [cart.id]);
            final count = await RepositoryServiceTodo.cartsCount();
            allpro.refreshCartItem(count);
            DatabaseCreator.databaseLog('Delete CART', sql, null, result, params);}

            static Future<void> deleteAllCartItem() async {
              final sql = '''DELETE FROM ${DatabaseCreator.cartTable}; ''';
              final result = await db.delete("cart");
              DatabaseCreator.databaseLog('Delete CART', sql, null, result, null);}
              static Future<void> updateCart(CartItemModel cart, int quant,
                  ) async {
                /*final sql = '''UPDATE ${DatabaseCreator.todoTable}
    SET ${DatabaseCreator.name} = "${todo.name}"
    WHERE ${DatabaseCreator.id} = ${todo.id}
    ''';*/
                final sql = '''UPDATE ${DatabaseCreator.cartTable}
    SET ${DatabaseCreator.quantity} = ?
    WHERE ${DatabaseCreator.id} = ?
    ''';
                List<dynamic> params = [quant, cart.id];
                final result = await db.rawUpdate(sql, params);
                DatabaseCreator.databaseLog('Update todo', sql, null, result, params);}
                static Future<void> updateCartPoint(CartItemModel cart,
                    {bool isUsePoint}) async {
                  /*final sql = '''UPDATE ${DatabaseCreator.todoTable}
    SET ${DatabaseCreator.name} = "${todo.name}"
    WHERE ${DatabaseCreator.id} = ${todo.id}
    ''';*/
                  final sql = '''UPDATE ${DatabaseCreator.cartTable}
    SET ${DatabaseCreator.isUsePoint} = ?
    WHERE ${DatabaseCreator.id} = ?
    ''';
                  List<dynamic> params = [isUsePoint, cart.id];
                  final result = await db.rawUpdate(sql, params);
                  DatabaseCreator.databaseLog('Update todo', sql, null, result, params);}
                  static Future<int> cartsCount() async {
                    final data = await db
                        .rawQuery('''SELECT COUNT(*) FROM ${DatabaseCreator.cartTable}''');
                    int count = data[0].values.elementAt(0);
                    int idForNewItem = count++;
                    return idForNewItem;}
                    static Future<void> addAddress(Address address) async {
                      final sql = '''INSERT INTO ${DatabaseCreator.addressTable}
    (
      ${DatabaseCreator.name_address},
      ${DatabaseCreator.phone_address},
      ${DatabaseCreator.country_address},
      ${DatabaseCreator.city_address},
      ${DatabaseCreator.point_address},
      ${DatabaseCreator.cityId}
    )
    VALUES (?,?,?,?,?,?)''';
                      List<dynamic> params = [
                        address.name_address,
                        address.phone_address,
                        address.country_address,
                        address.city_address,
                        address.point_address,
                        address.cityId,
                      ];
                      final result = await db.rawInsert(sql, params);
                      DatabaseCreator.databaseLog('Add address', sql, null, result, params);}
                      static Future<void> deleteAddress(int id, AllProviders allpro) async {
                        final sql = '''DELETE ${DatabaseCreator.addressTable}
    WHERE ${DatabaseCreator.id_address} = ?
    ''';
                        List<dynamic> params = [id];
                        final result =
                        await db.delete("address", where: "id_address = ?",
                            whereArgs: [id]);
                        getAllAddress(allpro:allpro);
                        allpro.refreshAddress(AllProviders.allAddreses);
                        DatabaseCreator.databaseLog(
                            'Delete ADDRESS', sql, null, result, params);
                      }}