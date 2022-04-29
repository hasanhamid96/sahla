import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:new_sahla/ecomerce/model/userModel.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AllProviders.dart';
import 'languages.dart';


String fonts='ithra';

class UserProvider with ChangeNotifier {
  static String appName = 'basmazon';
  static bool isLogin = false;
  static String userName;
  static String userImage;
  static String userPhone;
  static String type;
  static double latitude = 33.305398;
  static double longitude = 44.369635;
  static int userId;
  static String token;
  static int pointPerCurrency = 1;
  static String points = '0';
  static String newPoints = '0';
  String fonts = 'ithra';
  GoogleSignInAccount currentUser;
  String _contactText;
  List<UserModel> _user = [];

  List<UserModel> get user {
    return _user;
  }

  var userData;
  List<UserModel> loadedUser = [];

  Future<void> register(String name,
      String password,
      String password_confirmation,
      String phone,
      String onesignal,
      BuildContext contextExit,
      Function snackBar,
      AllProviders allprov2,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(onesignal);
    await http.post(
        Uri.parse("${AllProviders.hostName}/api/v1/user/registers"), body: {
      "name": name,
      "phone": phone,
      "password": password,
      "password_confirmation": password_confirmation,
      "onesignal": onesignal,
    }).then((respon) {
      print(respon.body);
      userData = json.decode(respon.body);
      if (userData['status'] == false) {
        isLogin = false;
        // snackBar("");
        notifyListeners();
      } else if (userData['status'] == true) {
        print("");

        Navigator.of(contextExit).pop();
        loadedUser.add(UserModel(
          id: userData['user']['id'],
          name: userData['user']['name'],
          phone: userData['user']['phone'],
          token: userData['user']['token'],
        ));
        prefs.setString('$appName' + '_' + 'name', name);
        prefs.setInt('$appName' + '_' + 'id', userData['user']['id']);
        prefs.setString('$appName' + '_' + 'phone', phone);
        prefs.setString('$appName' + '_' + 'token', userData['user']['token']);

        token = userData['user']['token'];
        if(userData['user']['type']!=null) {
          type = userData['user']['type'];
          prefs.setString('$appName' + '_' + 'type', userData['user']['type']);
        }
        userName = name;
        userPhone = phone;
        userId = userData['user']['id'];
        prefs.setString('$appName' + '_' + 'username', name);
        prefs.setString('$appName' + '_' + 'userphone', userPhone);
        isLogin = true;
        _user = loadedUser;
        notifyListeners();
      } else {

      }
    });
  }

  var userData2;

  Future<void> login(String phone,
      String password,
      BuildContext contextExit,
      Function snackBar,
      AllProviders allprov2,
      String playerID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(playerID);
    await http.post(Uri.parse("${AllProviders.hostName}/api/v1/user/login"),
        body: {
          "phone": phone,
          "password": password,
          'onesignal': playerID
        }).then((respon) {
      userData2 = json.decode(respon.body);
      print('$userData2  123456789');
      if (userData2['status'].toString() == 'false') {
        isLogin = false;
        // snackBar("
      } else {
        loadedUser.add(UserModel(
          id: userData2['user']['id'],
          name: userData2['user']['name'],
          token: userData2['user']['token'],
          phone: userData2['user']['phone'],
          type: userData2['user']['type'],
          points: userData2['points'] ?? '0',
        ));
        prefs.setInt('$appName' + '_' + 'id', userData2['user']['id']);
        prefs.setString('$appName' + '_' + 'name', userData2['user']['name']);
        prefs.setString('$appName' + '_' + 'phone', userData2['user']['phone']);
        prefs.setString('$appName' + '_' + 'token', userData2['user']['token']);
        prefs.setString('$appName' + '_' + 'type', userData2['user']['type']);
        prefs.setString(
            '$appName' + '_' + 'points', userData2['points'] ?? '0');
        token = userData2['user']['token'];
        userName = userData2['user']['name'];
        userPhone = userData2['user']['phone'];
        userId = userData2['user']['id'];
        type = userData2['user']['type'];
        points = userData2['points'] ?? '0';
        isLogin = true;
        print("this is the user id : $userId");
        _user = loadedUser;
        notifyListeners();
        Navigator.of(contextExit).pop();

        // Navigator.of(contextExit).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainScreen(4),),
        //         (route) => false);
      }
    });
  }

  var userData3;

  Future<void> loginSocial(String provider_id,
      String provider_name,
      String onesignal,
      String name,
      BuildContext contextExit,
      AllProviders allpro,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await http.post(
        Uri.parse("${AllProviders.hostName}/api/v1/user/social"), body: {
      "provider_id": provider_id,
      "provider_name": provider_name,
      "onesignal": onesignal,
      "name": name,
    }).then((respon) {
      userData3 = json.decode(respon.body);
      print(respon.body);
      if (userData3['status'] == false) {
        isLogin = false;
        // snackBar("
      } else {
        loadedUser.add(UserModel(
          id: userData3['user']['id'],
          name: userData3['user']['name'],
          token: userData3['user']['token'],
          phone: userData3['user']['phone'],
        ));
        prefs.setInt('$appName' + '_' + 'id', userData3['user']['id']);
        prefs.setString('$appName' + '_' + 'name', userData3['user']['name']);
        prefs.setString('$appName' + '_' + 'phone', userData3['user']['phone']);
        userName = userData3['user']['name'];
        userPhone = userData3['user']['phone'];
        userId = userData3['user']['id'];
        prefs.setString(
            '$appName' + '_' + 'username', userData3['user']['name']);
        prefs.setString('$appName' + '_' + 'token', userData3['user']['token']);
        token = userData3['user']['token'];
        isLogin = true;
        print("this is the user id : $userId");
        _user = loadedUser;
        notifyListeners();

        Navigator.of(contextExit).pop();
      }
    });
  }

  signOut(PageController pageController) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('$appName' + '_' + "id");
    prefs.remove('$appName' + '_' + "name");
    prefs.remove('$appName' + '_' + "password");
    prefs.remove('$appName' + '_' + "token");
    prefs.remove('$appName' + '_' + "phone");
    prefs.remove('$appName' + '_' + "phone");
    userImage = null;
    prefs.clear();
    isLogin = false;

    if (pageController != null)
      Languages.selectedLanguage == 0
          ? pageController.jumpToPage(4)
          : pageController.jumpToPage(0);
  }

  bool once = false;

  checkLogin() async {
    if (once == false) {
      once = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs.clear();
      if (prefs.containsKey('$appName' + '_' + 'phone') ||
          prefs.containsKey('$appName' + '_' + "password") ||
          prefs.containsKey('$appName' + '_' + "name") ||
          prefs.containsKey('$appName' + '_' + "id")) {
        isLogin = true;
        loadedUser = [
          UserModel(
            id: prefs.getInt('$appName' + '_' + "id"),
            name: prefs.getString('$appName' + '_' + "name"),
            phone: prefs.getString('$appName' + '_' + "phone"),
            type: prefs.getString('$appName' + '_' + "type"),
          )
        ];
        userName = prefs.getString('$appName' + '_' + "name");
        userPhone = prefs.getString('$appName' + '_' + "phone");
        userId = prefs.getInt('$appName' + '_' + "id");
        token = prefs.getString('$appName' + '_' + "token");
        type = prefs.getString('$appName' + '_' + "type");
        // points = prefs.getString('$appName' + '_' + "$points");
        _user = loadedUser;
        // fetchUserFiles(loadedPatient[0].id);
        //print("he is online");
      }
      print('$points pointspoints');
    }
  }

  bool getOnceProfile = true;

  Future<bool> getProfile() async {
    if (getOnceProfile) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print('start fetching...');
      try {
        final response = await http.get(
            Uri.parse('${AllProviders.hostName}/api/v1/me'),
            headers: {
              'Authorization': '${token}',
              'Accept': 'application/json'
            });
        var data4 = json.decode(response.body);
        print('$data4  data4data4data4data4data4');
        if (data4['status'] == false) {
          return null;
        }
        else {
          var userItem = data4['user'];
          userId = userItem['id'];
          userName = userItem['name'];
          userPhone = userItem['phone'];
          userImage = 'https://sahla.creativeapps.me${userItem['photo']}';
          points = userItem['points'] != null ?
          userItem['points']['points'].toString() : '0';
          prefs.setString('points', '$appName' + '_' + "$points");
          newPoints = points;
          if (data4['status'] == true) {
            notifyListeners();
            return true;
          }
        }
        print('$userImage  userImageuserImageuserImageuserImageuserImage');
      } catch (e) {
        print('$e getProfile');
        return false;
      }
    }
  }

  Future<bool> editProfile({
    File file,
    String name,
    String phone,
    String password,
  }) async {
    var url = Uri.parse("${AllProviders.hostName}/api/v1/user/update");
    var request = http.MultipartRequest("POST", (url));
    try {
      print("editing...");
      print("$name");
      print("$phone");
      print("$password");
      print("$file");
      request.headers.addAll({
        'Authorization': '$token',
        'Accept': 'application/json',
      });
      request.fields["name"] = name;
      request.fields["phone"] = phone;
      if (password != null)
        request.fields["password"] = password;
      if (file != null) {
        var pic = await http.MultipartFile.fromPath("photo", file.path);
        request.files.add(pic);
      }
      http.Response response = await http.Response.fromStream(
          await request.send());
      print("Result: ${response.statusCode}");
      print("Result: ${response.body}");
      if (response.statusCode == 200) {
        print('success');
        return true;
      }
      return response.statusCode == 200 ? true : false;
    }
    catch (e) {
      print('$e');
      return Future.value(false);
    }
  }

  // Future<Null> loginAppleId(String name, String email) async {
  //   loginSocial(accessToken.userId, "Facebook", onesignal, userName,
  //       contextExit, allpro);
  //   await http.post("${AllProvider.hostName}/insert-user-social.php",
  //       body: {"name": name, "email": email}).then((respon) {
  //     userData5 = respon.body;
  //     userId = int.parse(userData5);
  //     print("google user id : $userId");
  //     notifyListeners();
  //   });
  // }
  String _message = 'Log in/out by pressing the buttons below.';

  void _showMessage(String message) {
    //setState(() {
    _message = message;
    print(_message);
    //});
  }

}
                    // void googleFirstMove(
                    //     String onesignal, BuildContext contextExit, AllProviders allpro) {
                    //   _googleSignIn.onCurrentUserChanged
                    //       .listen((GoogleSignInAccount account) async {
                    //     print("hi");
                    //     currentUser = account;
                    //     if (currentUser != null) {
                    //       handleGetContact();
                    //       isLogin = true;
                    //       userName = currentUser.displayName;
                    //       //Text(_currentUser.email)
                    //       notifyListeners();
                    //     }
                    //     loginSocial(currentUser.id, "Google", onesignal, currentUser.displayName,
                    //         contextExit, allpro);
                    //   });
                    //   _googleSignIn.signInSilently();
                    //   GoogleSignIn _googleSignIn = GoogleSignIn(
                    //     scopes: <String>[
                    //       'email',
                    //       'https://www.googleapis.com/auth/contacts.readonly',
                    //     ],
                    //     hostedDomain: "",
                    //     clientId: "",
                    //   );}
                    //   Future<void> handleGetContact() async {
                    //     // setState(() {
                    //     //   _contactText = "Loading contact info...";
                    //     // });
                    //     final http.Response response = await http.get(Uri.parse(
                    //       'https://people.googleapis.com/v1/people/me/connections'
                    //           '?requestMask.includeField=person.names',),
                    //       headers: await currentUser.authHeaders,
                    //     );
                    //     if (response.statusCode != 200) {
                    //       // setState(() {
                    //       _contactText = "People API gave a ${response.statusCode} "
                    //           "response. Check logs for details.";
                    //       // });
                    //       print('People API ${response.statusCode} response: ${response.body}');
                    //       return;
                    //     }
                    //     final Map<String, dynamic> data = json.decode(response.body);
                    //     final String namedContact = pickFirstNamedContact(data);
                    //     // setState(() {
                    //     if (namedContact != null) {
                    //       _contactText = "I see you know $namedContact!";
                    //       print(namedContact);
                    //     } else {
                    //       _contactText = "No contacts to display.";
                    //     }}
                    //     // });
                    //     String pickFirstNamedContact(Map<String, dynamic> data) {
                    //       final List<dynamic> connections = data['connections'];
                    //       final Map<String, dynamic> contact = connections?.firstWhere(
                    //             (dynamic contact) => contact['names'] != null,
                    //         orElse: () => null,
                    //       );
                    //       if (contact != null) {
                    //         final Map<String, dynamic> name = contact['names'].firstWhere(
                    //               (dynamic name) => name['displayName'] != null,
                    //           orElse: () => null,
                    //         );
                    //         if (name != null) {
                    //           return name['displayName'];
                    //         }
                    //       }
                    //       return null;}
                    //       Future<void> handleSignInGoogle() async {
                    //         try {
                    //           await _googleSignIn.signIn();
                    //         } catch (error) {
                    //           print(error);
                    //         }}
                    //         Future<void> handleSignOut() => _googleSignIn.disconnect();
                    //         static RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
                    //         static Function mathFunc = (Match match) => '${match[1]},';
                    //         String numToString(String string) {
                    //           String result = string.replaceAllMapped(reg, mathFunc);
                    //           return result;
                    //           String durationTOTime(int dura) {
                    //             Duration duration =Duration(minutes: dura);
                    //             String twoDigits(int n) => n.toString().padLeft(2, "0");
                    //             String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
                    //             String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
                    //             return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";