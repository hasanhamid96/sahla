import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
class HappyCenter with ChangeNotifier{
  Future<bool> sendHappyCenter({
    String name,
    String phone,
    String reason,
    String email,
    String message,
  }) async {
    print(name);
    print(phone);
    print(reason);
    print(email);
    print(message);
    var url = Uri.parse("${AllProviders.hostName}/api/v1/feedback/store");
    var request = http.MultipartRequest("POST", (url));
    try {
      print("editing...");
      request.headers.addAll({
        'Accept': 'application/json',
      });
      request.fields["name"] = name;
      request.fields["phone"] = phone;
      request.fields["reason"] = reason;
      request.fields["email"] = email;
      request.fields["message"] = message;
      http.Response response = await http.Response.fromStream(await request.send());
      print("Result: ${response.statusCode}");
      if (response.statusCode == 200) {
        print('success');
        return true;
      }
      return response.statusCode == 200?true:false;
    }
    catch (e) {
      print('$e');
      return Future.value(false);
    }}}