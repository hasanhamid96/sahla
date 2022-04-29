import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:new_sahla/start_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ecomerce/helpers/app_themes.dart';
import 'ecomerce/providers/Languages.dart';

class Intialize extends StatefulWidget {
  BuildContext context;
  Intialize(this.context);

  @override
  State<Intialize> createState() => _IntializeState();
}

class _IntializeState extends State<Intialize> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listPagesViewModel = [
      PageViewModel(
        title:'',
        // body: Languages.selectedLanguage==1?
        // "get any service you want with  low cost":
        // "
        decoration: PageDecoration(
            bodyAlignment: Alignment.topCenter,contentMargin: EdgeInsets.all(0),
            titlePadding: EdgeInsets.all(0),
            bodyFlex: 2000
          // bodyTextStyle:  TextStyle(fontWeight: FontWeight.w600,fontFamily: fonts,fontSize: 15,color: Colors.lightBlueAccent),
          // titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontFamily: fonts,fontSize: 25)
        ),
        bodyWidget: Image.asset('assets/images/ElectronicShopping.jpg',
          height: MediaQuery.of(widget.context).size.height*0.95,),
        // image:  Center(child:Image.asset('assets/images/Electronic  shopping .jpg')),
      ),
      PageViewModel(
        title:
        "",
        bodyWidget: Center(child:Image.asset('assets/images/yourServices.jpg',
          height: MediaQuery.of(widget.context).size.height*0.95,)),
        decoration: PageDecoration(
            bodyAlignment: Alignment.topCenter,contentMargin: EdgeInsets.all(0),
            titlePadding: EdgeInsets.all(0),
            bodyFlex: 2000
          // bodyTextStyle:  TextStyle(fontWeight: FontWeight.w600,fontFamily: fonts,fontSize: 15,color: Colors.lightBlueAccent),
          // titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontFamily: fonts,fontSize: 25)
        ),
        // body:Languages.selectedLanguage==1?
        // "now you can shopping any tools or stuff you like with competitive price":
        // "
        // image:  Center(child:Image.asset('assets/images/your services 3.jpg')),
        // footer: ElevatedButton(
        //   onPressed: () {
        //     // On button presed
        //   },
        //   child: const Text("Let's Go !"),
        // ),
      ),
      // PageViewModel(
      //   title: "",
      //   body: "Here you can write the description of the page, to explain someting...",
      //   image:  Center(child:Image.asset('assets/images/3.jpeg')),
      // ),
    ];}

  List<PageViewModel> listPagesViewModel = [ ];

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => IntroductionScreen(
          color: Colors.blue,
          globalBackgroundColor: Colors.white,
          pages: listPagesViewModel,
          done:  Text('Done',
              style: TextStyle(fontWeight: FontWeight.w600,fontFamily: fonts)),
      onDone: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>StartScreen() ,));
      },
      next: Text('next',
          style: TextStyle(fontWeight: FontWeight.w600,fontFamily: fonts)),
      onSkip: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>StartScreen() ,));
      },
      showSkipButton: true,
      isProgressTap: true,
      isProgress: true,
      skip:   Text('skip',
          style: TextStyle(fontWeight: FontWeight.w600,fontFamily: fonts)),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0)
          )
      ),
    )//M
    );}}





class First extends StatefulWidget {
  static var routeName = 'first';

  First({datatat});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  int datatat;

  bool isFirstTme = false;

  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('${prefs.getBool('first_time')}');
    bool firstTime = prefs.getBool('first_time');
    if (firstTime != null && !firstTime) {
      setState(() {
        isFirstTme = false;
      }); // Not first time
      return navigationPageHome(context);
    } else {
      // First time
      prefs.setBool('first_time', false);
      setState(() {
        isFirstTme = true;
      });
      return navigationPageWel(context);
    }
  }

  void navigationPageHome(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
            !isFirstTme ?
            StartScreen()
                : Intialize(context)
        ));
  }

  void navigationPageWel(BuildContext context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Intialize(context),
        ));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return
      !isFirstTme ?
      StartScreen()
          : Intialize(context);
  }
}