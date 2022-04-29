import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:new_sahla/first.dart';
import 'package:new_sahla/services/helpers/RestartWidget.dart';
import 'package:new_sahla/services/providers/HappyCenter.dart';
import 'package:new_sahla/services/providers/Offers.dart';
import 'package:new_sahla/services/providers/Orders.dart';
import 'package:new_sahla/services/providers/Sections.dart';
import 'package:new_sahla/services/providers/Services.dart';
import 'package:new_sahla/services/providers/SubAndDoubleSubCategory.dart';
import 'package:new_sahla/services/screens/map_screen.dart';
import 'package:new_sahla/start_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ecomerce/providers/Languages.dart';
import 'ecomerce/providers/Ordering.dart';
import 'ecomerce/providers/ThemeManager.dart';
import 'ecomerce/providers/UserProvider.dart';
import 'ecomerce/providers/AllProviders.dart';
import 'ecomerce/providers/sqfliteCreate.dart';
import 'ecomerce/screens/navigation_files/MainScreen.dart';
import 'services/model/Baner.dart';

void main() async {
//Remove this method to stop OneSignal Debugging
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase();
  // OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  // OneSignal.shared.setRequiresUserPrivacyConsent(true);
  // await OneSignal.shared
  //     .setAppId("0e3c25af-2d44-43a9-85e9-6567880cb548");
  // var ss= await OneSignal.shared.getDeviceState();
  var datatat;
  SharedPreferences.getInstance().then((value) {
    datatat = value.getInt("language");
  });
  runApp(RestartWidget(
    child: MainHome(datatat: datatat),
  ));
}

class MainHome extends StatefulWidget {
  int datatat;

  MainHome({Key key, this.datatat}) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  Future<void> initPlatformState() async {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId(
      "0e3c25af-2d44-43a9-85e9-6567880cb548",
    );
    await OneSignal.shared
        .promptUserForPushNotificationPermission(fallbackToSettings: true);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AllProviders(),
        ),
        ChangeNotifierProvider.value(
          value: HappyCenter(),
        ),
        ChangeNotifierProvider.value(
          value: SubAndDoubleSubCategory(),
        ),
        ChangeNotifierProvider.value(
          value: Sections(),
        ),
        ChangeNotifierProvider.value(
          value: Languages(),
        ),
        ChangeNotifierProvider.value(
          value: UserProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ThemeManager(),
        ),
        ChangeNotifierProvider.value(
          value: Ordering(),
        ),
        ChangeNotifierProvider.value(
          value: Services(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
        ChangeNotifierProvider.value(
          value: Bannsers(),
        ),
        ChangeNotifierProvider.value(
          value: Offers(),
        ),
      ],
      child: Phoenix(
        child: Consumer<ThemeManager>(
          builder: (context, manager, _) {
            // rating(context);
            AllProviders.mainBuid = context;
            Provider.of<AllProviders>(context, listen: false).fetchStyle();
            return Consumer<UserProvider>(builder: (context, auth, _) {
              print(UserProvider.token);
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'SAHLA IQ',
                theme: manager.themeData,
                color: Colors.redAccent,
                home: FutureBuilder(
                    future: auth.checkLogin(),
                    builder: (context, snapshot) =>
                        First(datatat: widget.datatat)),
                routes: {
                  MainScreen.routeName: (ctx) => MainScreen(),
                  MapScreen.routeName: (ctx) => MapScreen(),
                },
              );
            });
          },
        ),
      ),
    );
  }
}
