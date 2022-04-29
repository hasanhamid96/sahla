import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';

import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController nameController = new TextEditingController();

  TextEditingController passwordController = new TextEditingController();

  TextEditingController phoneController = new TextEditingController();

  ScrollController controller = ScrollController();

  bool isRegister = true;

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: fonts,
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

  final kHintTextStyle = TextStyle(
    color: Colors.black54,
    fontFamily: fonts,
  );

  final kLabelStyle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontFamily: fonts,
  );

  final kBoxDecorationStyle = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  bool _rememberMe = false;

  void logIn() async {
    //  switch (result.status) {
    //   case AuthorizationStatus.authorized:
  }

  Widget _buildUserName(Languages lang) {
    return Column(
      crossAxisAlignment: Languages.selectedLanguage == 0
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          lang.translation['username'][Languages.selectedLanguage],
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: nameController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              fontFamily: fonts,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.supervised_user_circle,
                color: Theme.of(context).primaryColor,
              ),
              hintText: lang.translation['usernameEnter']
                  [Languages.selectedLanguage],
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF(Languages lang) {
    return Column(
      crossAxisAlignment: Languages.selectedLanguage == 0
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          lang.translation['passwordTitle'][Languages.selectedLanguage],
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: passwordController,
            obscureText: true,
            style: TextStyle(
              color: Colors.black,
              fontFamily: fonts,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Theme.of(context).primaryColor,
              ),
              hintText: lang.translation['passwordTitleEnter']
                  [Languages.selectedLanguage],
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhone(Languages lang) {
    return Column(
      crossAxisAlignment: Languages.selectedLanguage == 0
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          lang.translation['phoneTitle'][Languages.selectedLanguage],
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: phoneController,
            // obscureText: true,
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: Colors.black,
              fontFamily: fonts,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.phone_android,
                color: Theme.of(context).primaryColor,
              ),
              hintText: lang.translation['phoneTitleEnter']
                  [Languages.selectedLanguage],
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeCheckbox(Languages lang) {
    return Container(
      height: 20.0,
      child: Row(
        mainAxisAlignment: Languages.selectedLanguage == 0
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: <Widget>[
          Text(
            lang.translation['rememberMe'][Languages.selectedLanguage],
            style: kLabelStyle,
          ),
          Theme(
            data: ThemeData(
                unselectedWidgetColor: Theme.of(context).bottomAppBarColor),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Theme.of(context).bottomAppBarColor,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isLoading = false;

  Widget _buildLoginBtn(
      UserProvider uPro, AllProviders allprov, Languages lang) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          print('login');
          setState(() {
            if (isRegister == true) {
              if (nameController.text == "" ||
                  passwordController.text == "" ||
                  phoneController.text == "") {
                showInSnackBar(lang.translation['pleaseFillAllRecords']
                    [Languages.selectedLanguage]);
              } else {
                isLoading = true;
                allprov.getOneSignalPlayerId().then((playerId) {
                  uPro
                      .register(
                        nameController.text,
                        passwordController.text,
                        passwordController.text,
                        phoneController.text,
                        playerId,
                        context,
                        showInSnackBar,
                        allprov,
                      )
                      .then((value) => isLoading = false);
                });
              }
              //  uPro.register(name, email, password, phone, context, pageController);
            } else {
              if (phoneController.text == "" || passwordController.text == "") {
                showInSnackBar(lang.translation['pleaseFillAllRecords']
                    [Languages.selectedLanguage]);
              } else {
                print('start logging');
                isLoading = true;
                allprov.getOneSignalPlayerId().then((playerID) {
                  print(playerID);
                  uPro
                      .login(phoneController.text, passwordController.text,
                          context, showInSnackBar, allprov, playerID)
                      .then((value) => setState(() => isLoading = false))
                      .catchError(
                          (e) => {print(e), setState(() => isLoading = false)});
                });
              }
            }
          });
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Theme.of(context).primaryColor,
        child: isRegister == false
            ? Container(
                child: isLoading == false
                    ? Text(
                        lang.translation['signinTitle']
                            [Languages.selectedLanguage],
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontFamily: fonts,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
              )
            : Container(
                child: isLoading == false
                    ? Text(
                        lang.translation['registerTitle']
                            [Languages.selectedLanguage],
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontFamily: fonts,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
              ),
      ),
    );
  }

  bool isLoadingFace = false;

  Widget _buildLoginBtnFacebook(
      UserProvider uPro, AllProviders allprov, Languages lang) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          setState(() {
            isLoadingFace = true;
          });
        },
        padding: EdgeInsets.all(15.0),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(30.0),
        // ),
        color: Colors.blue,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                FontAwesome.facebook_f,
                color: Colors.white,
              ),
              Text(
                'Sign in With Facebook',
                style: TextStyle(
                    fontFamily: fonts, color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginBtnGoogle(
      UserProvider uPro, AllProviders allprov, Languages lang) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          allprov.getOneSignalPlayerId().then((playerId) {
            // uPro.handleSignInGoogle();
            // uPro.googleFirstMove(playerId, context, allprov);
          });
        },
        padding: EdgeInsets.all(15.0),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(30.0),
        // ),
        color: Colors.deepOrangeAccent,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                FontAwesome.google,
                color: Colors.white,
              ),
              Text(
                'Sign in With Google',
                style: TextStyle(
                    fontFamily: fonts, color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int preferredTheme;

  Widget _buildLoginBtnApple(
      UserProvider uPro, AllProviders allprov, Languages lang) {
    SharedPreferences.getInstance().then((prefs) {
      preferredTheme = prefs.getInt("theme_preference") ?? 0;
    });
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: logIn,
        padding: EdgeInsets.all(15.0),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(30.0),
        // ),
        color: preferredTheme == 0 ? Colors.black : Colors.white,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                FontAwesome.apple,
                color: preferredTheme == 0 ? Colors.white : Colors.black,
              ),
              Text(
                'Sign in With Apple',
                style: TextStyle(
                    fontFamily: fonts,
                    color: preferredTheme == 0 ? Colors.white : Colors.black,
                    fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => print('Login with Facebook'),
            AssetImage(
              'assets/images/facebook.png',
            ),
          ),
          _buildSocialBtn(
            () => print('Login with Google'),
            AssetImage(
              'assets/images/google.png',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn(Languages lang) {
    return GestureDetector(
      onTap: () {
        setState(() {
          nameController.text = '';
          phoneController.text = '';
          passwordController.text = '';
          isRegister = true;
          controller.animateTo(0.0,
              duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        });
      },
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: lang.translation['DONThaveAccount']
                [Languages.selectedLanguage],
            style: TextStyle(
              fontFamily: fonts,
              color: Theme.of(context).bottomAppBarColor,
              fontSize: 17.0,
              fontWeight: FontWeight.w300,
            ),
          ),
          TextSpan(
            text: lang.translation['registerNow'][Languages.selectedLanguage],
            style: TextStyle(
              fontFamily: fonts,
              color: Colors.green,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildSignupBtn2(Languages lang) {
    return GestureDetector(
      onTap: () {
        setState(() {
          nameController.text = '';
          phoneController.text = '';
          passwordController.text = '';
          isRegister = false;
          controller.animateTo(0.0,
              duration: Duration(milliseconds: 300), curve: Curves.easeInBack);
        });
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: lang.translation['allreadyHaveAccount']
                  [Languages.selectedLanguage],
              style: TextStyle(
                fontFamily: fonts,
                color: Theme.of(context).bottomAppBarColor,
                fontSize: 17.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            TextSpan(
              text: lang.translation['signinTitle'][Languages.selectedLanguage],
              style: TextStyle(
                color: Colors.green,
                fontSize: 20.0,
                fontFamily: fonts,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allPro = Provider.of<AllProviders>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final lang = Provider.of<Languages>(context);
    return WillPopScope(
      onWillPop: () {
        allPro.NavBarShow(true);
        return Future.value(true);
      },
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).bottomAppBarColor,
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  // decoration: BoxDecoration(
                  //   gradient: LinearGradient(
                  //     begin: Alignment.topCenter,
                  //     end: Alignment.bottomCenter,
                  //     colors: [
                  //       Theme.of(context).primaryColor.withOpacity(0.4),
                  //       Theme.of(context).primaryColor.withOpacity(0.6),
                  //       Theme.of(context).primaryColor.withOpacity(0.8),
                  //       Theme.of(context).primaryColor,
                  //     ],
                  //     stops: [0.1, 0.4, 0.7, 0.9],
                  //   ),
                  // ),
                ),
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    controller: controller,
                    physics: AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 120.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        isRegister == false
                            ? Text(
                                lang.translation['signinTitle']
                                    [Languages.selectedLanguage],
                                style: TextStyle(
                                  fontFamily: fonts,
                                  color: Theme.of(context).bottomAppBarColor,
                                  fontSize: 27.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                lang.translation['registerTitle']
                                    [Languages.selectedLanguage],
                                style: TextStyle(
                                  fontFamily: fonts,
                                  color: Theme.of(context).bottomAppBarColor,
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        SizedBox(height: 30.0),
                        isRegister == true ? _buildUserName(lang) : SizedBox(),
                        SizedBox(height: 30.0),
                        // _buildEmailTF(lang),
                        // SizedBox(
                        //   height: 30.0,
                        // ),
                        _buildPhone(lang),
                        _buildPasswordTF(lang),
                        SizedBox(height: 30.0),
                        // isRegister == false
                        //     ? _buildForgotPasswordBtn()
                        //     : SizedBox(),
                        SizedBox(height: 20.0),
                        _buildRememberMeCheckbox(lang),
                        _buildLoginBtn(userProvider, allPro, lang),
                        //_buildSignInWithText(),
                        isRegister == false
                            ? _buildSignupBtn(lang)
                            : _buildSignupBtn2(lang),
                        SizedBox(height: 20.0),
                        allPro.appleEnable == 1
                            ? Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: new LinearGradient(
                                          colors: [
                                            Colors.white10,
                                            Theme.of(context).bottomAppBarColor,
                                          ],
                                          begin:
                                              const FractionalOffset(0.0, 0.0),
                                          end: const FractionalOffset(1.0, 1.0),
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp,
                                        ),
                                      ),
                                      width: 100.0,
                                      height: 1.0,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 15.0, right: 15.0),
                                      child: Text(
                                        Languages.selectedLanguage == 0
                                            ? "أو"
                                            : "Or",
                                        style: TextStyle(
                                          fontFamily: fonts,
                                          color: Theme.of(context)
                                              .bottomAppBarColor,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: new LinearGradient(
                                          colors: [
                                            Theme.of(context).bottomAppBarColor,
                                            Colors.white10,
                                          ],
                                          begin:
                                              const FractionalOffset(0.0, 0.0),
                                          end: const FractionalOffset(1.0, 1.0),
                                          stops: [0.0, 1.0],
                                          tileMode: TileMode.clamp,
                                        ),
                                      ),
                                      width: 100.0,
                                      height: 1.0,
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                        allPro.appleEnable == 1
                            ? _buildLoginBtnFacebook(userProvider, allPro, lang)
                            : SizedBox(),
                        allPro.appleEnable == 1
                            ? _buildLoginBtnGoogle(userProvider, allPro, lang)
                            : SizedBox(),
                        Platform.isIOS
                            ? allPro.appleEnable == 1
                                ? _buildLoginBtnApple(
                                    userProvider, allPro, lang)
                                : SizedBox()
                            : SizedBox(),
                        // Container(
                        //   width: MediaQuery.of(context).size.width / 1.5,
                        //   decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.black, width: 1),
                        //   ),
                        //   child: AppleSignInButton(
                        //     onPressed: logIn,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
