
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/helpers/font.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/services/templetes/category_template_from_more.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
class CategoriesScreen extends StatefulWidget {

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  PageController controller = PageController();

  int selectedCategory = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
  final allPro = Provider.of<AllProviders>(context);
  final lang = Provider.of<Languages>(context);
  //final dummyData = Provider.of<DummyData>(context,listen: false);
  return Directionality(
  textDirection:Languages.selectedLanguage==1?TextDirection.rtl:TextDirection.ltr ,
  child: Scaffold(
  appBar: AppBar(
  backgroundColor: Theme.of(context).appBarTheme.color,
  title:  Text(
  lang.translation['categoriesTitle']
  [Languages.selectedLanguage],
  textAlign: Languages.selectedLanguage == 0
  ? TextAlign.right
      : TextAlign.left,
  style: TextStyle(
  fontSize: 20,
  fontFamily: fonts,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  ),
  ),
  centerTitle: true,
  leading: IconButton(onPressed: () {
  Navigator.pop(context);
  },icon: Icon(Icons.arrow_back_ios,
  color: Colors.white,),),
  ),
  body: Container(
  width: MediaQuery.of(context).size.width,
  height: MediaQuery.of(context).size.height,
  child:  SafeArea(
  child: SingleChildScrollView(
  child: Column(
  children: <Widget>[
  SizedBox(height: 20,),
  Consumer<AllProviders>(
  builder: (context, setPro, _) {
  if (setPro.isCategoryOffline == true) {
  return Shimmer.fromColors(
  baseColor: Colors.grey.withOpacity(0.5),
  highlightColor: Colors.white,
  period: Duration(milliseconds: 700),
  child: Container(
  width: MediaQuery.of(context).size.width / 1.1,
  child: GridView.builder(
  physics: NeverScrollableScrollPhysics(),
  shrinkWrap: true,
  gridDelegate:
  SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent:
  setPro.catMainStyle == 0 ? 300 : 150,
  childAspectRatio: 1 / 1.6,
  crossAxisSpacing: 5.0,
  mainAxisSpacing: 5.0,
  ),
  itemCount: 5,
  itemBuilder: (context, index) {
  return ClipRRect(
  borderRadius:
  BorderRadius.all(Radius.circular(10)),
  clipBehavior: Clip.antiAlias,
  child: Container(
  decoration: BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(
  Radius.circular(10),
  ),
  boxShadow: [
  BoxShadow(
  color:
  Colors.white.withOpacity(0.1),
  blurRadius: 0.0,
  spreadRadius:
  0.1, // has the effect of extending the shadow
  offset: Offset(
  0, // horizontal, move right 10
  0, // vertical, move down 10
  ),
  )
  ],
  ),
  ),
  );
  },
  ),
  ),
  );
  } else {
  return Container(
  width: MediaQuery.of(context).size.width / 1.1,
  //height: MediaQuery.of(context).size.height / 1.1,
  child: GridView.builder(
  physics: NeverScrollableScrollPhysics(),
  shrinkWrap: true,
  gridDelegate:
  SliverGridDelegateWithMaxCrossAxisExtent(
  maxCrossAxisExtent:
  setPro.catMainStyle == 0 ? 300 : 200,
  childAspectRatio: 1 / 1,
  crossAxisSpacing: 5.0,
  mainAxisSpacing: 5.0,
  ),
  itemCount: setPro.categories.length,
  itemBuilder: (context, index) {
  return CategoryTemplateFromMore(
  category: setPro.categories[index],
  controller: controller,
  );
  },
  ),
  );
  }
  },
  ),
  SizedBox(
  height: 90,
  )
  ],
  ),
  ),
  ),
  ),
  ),
  );}}