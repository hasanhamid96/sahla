import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:image_picker/image_picker.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/services/helpers/toast_gf.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class ProfileThreePage extends StatefulWidget {
  @override
  State<ProfileThreePage> createState() => _ProfileThreePageState();
}

class _ProfileThreePageState extends State<ProfileThreePage> {
  final image = 'assets/images/placeholder.png';
  var name = '';
  var username = '';
  var phone = '';
  var photo = '';
  var password = '';
  var _key = GlobalKey<FormState>();
  bool isLoading = false;
  bool isChangeImage = false;
  bool isImageUploaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    Provider.of<UserProvider>(context, listen: false)
        .getProfile()
        .then((value) {
      setState(() {
        // name = UserProvider.name;
        name = UserProvider.userName;
        phone = UserProvider.userPhone;
        photo = UserProvider.userImage;
        isLoading = false;
      });
    });
  }

  bool once = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Languages>(context);
    final userPro = Provider.of<UserProvider>(context);
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          color: Colors.white38,
          elevation: 0,
          child: IconButton(
              splashRadius: 24,
              icon: RotatedBox(
                quarterTurns: 2,
                child: Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 30,
                  color: Colors.black54,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ),
      ),
      body: isLoading
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 60,
                  ),
                  //image
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    alignment: Alignment.center,
                    child: Container(
                      alignment: Alignment.center,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(140)),
                        color: Colors.grey[400],
                        child: Consumer<UserProvider>(
                          builder: (context, user, child) => InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () async {
                              once = true;
                              _image = null;
                              await showCameraAndLibrary(
                                  _scaffoldKey.currentContext, userPro);
                            },
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(2.5),
                                  child: Stack(
                                    children: [
                                      if (_image == null)
                                        CircleAvatar(
                                          backgroundColor:
                                              Color.fromRGBO(106, 96, 83, 0.8),
                                          radius: 65,
                                          backgroundImage: photo != null
                                              ? NetworkImage(photo)
                                              : null,
                                          child: photo == null
                                              ? Text(
                                                  '${name[0]}',
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.white),
                                                )
                                              : null,
                                        ),
                                      if (_image != null)
                                        CircleAvatar(
                                          backgroundColor:
                                              Color.fromRGBO(106, 96, 83, 0.8),
                                          radius: 65,
                                          backgroundImage: FileImage(_image),
                                        ),
                                    ],
                                  ),
                                ),
                                Positioned.fill(
                                  child: Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(140)),
                                      color: Theme.of(context).primaryColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        Form(
                          key: _key,
                          child: Directionality(
                            textDirection: ui.TextDirection.rtl,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      lang.translation["UserInformation"]
                                          [Languages.selectedLanguage],
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                    ),
                                  ),
                                  Divider(),
                                  CupertinoTextFormFieldRow(
                                    placeholder: lang.translation["username"]
                                        [Languages.selectedLanguage],
                                    initialValue: name,
                                    onSaved: (newValue) => name = newValue,
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                    placeholderStyle: TextStyle(
                                        fontFamily: fonts,
                                        color: Colors.black26),
                                    prefix: Icon(Icons.person,
                                        color: Colors.black26),
                                  ),
                                  Divider(),
                                  CupertinoTextFormFieldRow(
                                    placeholder: lang.translation["phoneTitle"]
                                        [Languages.selectedLanguage],
                                    initialValue: phone,
                                    onSaved: (newValue) => phone = newValue,
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                    placeholderStyle: TextStyle(
                                        fontFamily: fonts,
                                        color: Colors.black26),
                                    prefix: Icon(Icons.phone,
                                        color: Colors.black26),
                                  ),
                                  Divider(),
                                  CupertinoTextFormFieldRow(
                                    placeholder:
                                        lang.translation["passwordTitle"]
                                            [Languages.selectedLanguage],
                                    initialValue: password,
                                    onSaved: (newValue) => password = newValue,
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                    placeholderStyle: TextStyle(
                                        fontFamily: fonts,
                                        color: Colors.black26),
                                    prefix: Icon(
                                        Icons.admin_panel_settings_sharp,
                                        color: Colors.black26),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        RaisedButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)),
                          child: isChangeImage
                              ? CupertinoActivityIndicator()
                              : Text(
                                  lang.translation['UpdateProfile']
                                      [Languages.selectedLanguage],
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                          onPressed: () {
                            if (_key.currentState.validate()) {
                              _key.currentState.save();
                              setState(() {
                                isChangeImage = true;
                              });
                              var userPro = Provider.of<UserProvider>(context,
                                  listen: false);
                              userPro.getOnceProfile = true;
                              userPro
                                  .editProfile(
                                      file: _image,
                                      name: name,
                                      phone: phone,
                                      password: password)
                                  .then((value) {
                                setState(() {
                                  if (value == true) {
                                    ToastGF.showMessage(
                                        context,
                                        Languages.selectedLanguage == 1
                                            ? 'update successfully'
                                            : "التحديث بنجاح");
                                    isChangeImage = false;
                                    isImageUploaded = true;
                                  } else
                                    ToastGF.showError(
                                        context,
                                        Languages.selectedLanguage == 1
                                            ? ' not updated'
                                            : 'لم يتم تحديته');
                                  isChangeImage = false;
                                });
                              }).catchError((e) {
                                setState(() {
                                  isChangeImage = false;
                                  ToastGF.showError(
                                      context,
                                      Languages.selectedLanguage == 1
                                          ? ' not updated'
                                          : 'لم يتم تحديته');
                                });
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  File _image;

  Future picked(int type) async {
    var _imagePick = await ImagePicker.platform.pickImage(
        source: type == 1 ? ImageSource.camera : ImageSource.gallery,
        maxHeight: 720,
        maxWidth: 720);
    if (_imagePick != null)
      setState(() {
        _image = File(_imagePick.path);
      });
  }

  Future<void> showCameraAndLibrary(context, UserProvider userPro) async {
    return await showModalBottomSheet(
      elevation: 21,
      context: context,
      builder: (context) => Container(
        child: Wrap(
          children: [
            ListTile(
              onTap: () async {
                // Navigator.of(context).pop();
                await picked(1).then((value) {
                  if (_image != null)
                    _cropImage().then((value) {
                      if (_image != null)
                        userPro.editProfile(file: _image).catchError((onError) {
                          ToastGF.showError(
                            context,
                            'error photo',
                          );
                        }).then((value) {
                          Navigator.of(context).pop();
                          if (value)
                            ToastGF.showMessage(
                              context,
                              'success',
                            );
                        });
                    });
                });
              },
              leading: Icon(
                Icons.camera_alt,
                color: Colors.brown,
              ),
              title: Text(
                'camera',
                style: Theme.of(context).textTheme.headline3,
                // style: Theme.of(
                //     context)
                //     .textTheme
                //     .headline2,
              ),
            ),
            Divider(
              height: 0,
              color: Colors.grey[200],
            ),
            ListTile(
              onTap: () async {
                // Navigator.of(context).pop();
                await picked(0).then((value) {
                  if (_image != null)
                    _cropImage().then((value) {
                      if (_image != null)
                        userPro.editProfile(file: _image).catchError((onError) {
                          ToastGF.showError(
                            context,
                            'error photo',
                          );
                        }).then((value) {
                          Navigator.of(context).pop();
                          if (value)
                            ToastGF.showMessage(
                              context,
                              'success ',
                            );
                        });
                    });
                });
              },
              leading: Icon(
                Icons.panorama,
                color: Colors.green,
              ),
              title: Text(
                'gallery',
                style: Theme.of(context).textTheme.headline3,
                // style: Theme.of(
                //     context)
                //     .textTheme
                //     .headline2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper().cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      setState(() {
        _image = croppedFile;
      });
    }
  }
}
