
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:new_sahla/ecomerce/helpers/app_themes.dart';
import 'package:new_sahla/ecomerce/helpers/ecommerce_icons_icons.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/services/templetes/service_item.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
class SearchService extends StatefulWidget {
  final String searchInitial;
  SearchService({this.searchInitial});

  @override
  State<SearchService> createState() => _SearchServiceState();
}

class _SearchServiceState extends State<SearchService>  with WidgetsBindingObserver{
  TextEditingController myController = TextEditingController();

  bool isLoading = false;

  bool isKeyBoardShow=WidgetsBinding.instance.window.viewInsets.bottom>0.0;

  @override
  void initState() {
  // TODO: implement initState
  super.initState();
  WidgetsBinding.instance.addObserver(this);}

  @override
  void dispose() {
  // TODO: implement dispose
  super.dispose();
  WidgetsBinding.instance.removeObserver(this);}

  @override
  Widget build(BuildContext context) {
  final lang = Provider.of<Languages>(context, listen: false);
  final appProvider = Provider.of<AllProviders>(context, listen: false);
  return Scaffold(
  appBar: AppBar(
  elevation: 1,
  centerTitle: true,
  automaticallyImplyLeading: false,
  title:Text(
  lang.translation['searchTitle'][Languages.selectedLanguage],
  textAlign: Languages.selectedLanguage == 0
  ? TextAlign.right
      : TextAlign.left,
  style: TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  ),
  ),
  ),
  body: SingleChildScrollView(
  child: Column(
  children: <Widget>[
  Container(
  alignment: Alignment.topCenter,
  margin: EdgeInsets.all(10),
  padding: EdgeInsets.all(4),
  decoration: BoxDecoration(
  color: Theme.of(context).bottomAppBarColor.withOpacity(0.3),
  borderRadius: BorderRadius.all(Radius.circular(6))),
  width: MediaQuery.of(context).size.width*1,
  child: TextField(
  controller: myController,
  textInputAction: TextInputAction.search,
  onSubmitted: (value) {
  setState(() {
  isLoading = true;
  });
  appProvider.searchService(value, context, lang).then((value) {
  setState(() {
  isLoading = false;
  });
  });
  },
  onChanged: (value) {
  if (value == "") {
  //appProvider.searchResult();
  appProvider.searchService(value, context, lang);
  }
  },
  onEditingComplete: () {
  // appProvider.search(value, context);
  },
  textAlign: Languages.selectedLanguage == 1
  ? TextAlign.left
      : TextAlign.right,
  style: TextStyle(
  fontFamily: fonts,
  color: Theme.of(context).bottomAppBarColor,
  ),
  decoration: new InputDecoration(
  border: InputBorder.none,
  hintText: lang.translation['searchThousndOfService']
  [Languages.selectedLanguage],
  hintStyle: TextStyle(
  fontFamily: fonts,
  color: Theme.of(context).bottomAppBarColor,
  ),
  labelStyle: TextStyle(fontFamily: fonts,fontSize: 23),
  suffixIcon: Languages.selectedLanguage == 1
  ? isLoading == false
  ? Icon(
  EcommerceIcons.magnifying_glass,
  color: Theme.of(context).bottomAppBarColor,
  size: 20,
  )
      : CircularProgressIndicator()
      : SizedBox(),
  prefixIcon: Languages.selectedLanguage == 0
  ? isLoading == false
  ? Icon(
  EcommerceIcons.magnifying_glass,
  color: Theme.of(context).bottomAppBarColor,
  size: 20,
  )
      : CircularProgressIndicator()
      : SizedBox(),
  suffixStyle:
  TextStyle(fontFamily: fonts,color: Theme.of(context).primaryColor)),
  ),
  ),
  appProvider.searchServices.length != 0
  ? Column(
  children: <Widget>[
  Container(
  alignment: Alignment.topCenter,
  width: MediaQuery.of(context).size.width / 1.1,
  //height: MediaQuery.of(context).size.height / 4.1,
  child: GridView.builder(
  itemCount: appProvider.searchServices.length,
  gridDelegate:
  SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  childAspectRatio: 0.6 / 1,
  crossAxisSpacing: 10,
  mainAxisSpacing: 15,
  // crossAxisSpacing: 0,
  // mainAxisSpacing: 0,
  ),
  itemBuilder: (ctx, index) {
  return ServiceItem(
  service:  appProvider.searchServices[index],
  mediaQuery: MediaQuery.of(context).size,
  );
  },
  physics: NeverScrollableScrollPhysics(),
  shrinkWrap: true,
  ),
  ),
  SizedBox(
  height: 20,
  ),
  ],
  )
      :  Container(
  width: MediaQuery.of(context).size.width / 1.6,
  height: 200,
  alignment: Alignment.topCenter,
  child: Center(
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
  Icon(
  Icons.search,
  size: 80,
  color: Theme.of(context)
      .bottomAppBarColor
      .withOpacity(0.2),
  ),
  Text(
  lang.translation['youDidNotSearchService']
  [Languages.selectedLanguage],
  textDirection: TextDirection.rtl,
  textAlign: TextAlign.center,
  style: TextStyle(
  fontFamily: fonts,
  fontSize: 20,
  color: Theme.of(context)
      .bottomAppBarColor
      .withOpacity(0.4),
  ),
  ),
  ],
  ),
  ),
  ),
  SizedBox(
  height: 100,
  ),
  ],
  ),
  ),
  );}}