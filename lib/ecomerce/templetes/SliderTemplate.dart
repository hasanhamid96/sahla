import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/ecomerce/screens/pressedScreen/pressedProduct.dart';
import 'package:new_sahla/services/helpers/toast_gf.dart';
import 'package:new_sahla/services/model/Baner.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
class SliderTemplate extends StatefulWidget {

  @override
  State<SliderTemplate> createState() => _SliderTemplateState();
}

class _SliderTemplateState extends State<SliderTemplate> {
  List<String> sliders = [];

  @override
  Widget build(BuildContext context) {
  final allPosts = Provider.of<AllProviders>(context, listen: false);
  return CarouselSlider.builder(
  options: CarouselOptions(
  height: 230,
  aspectRatio: 16 / 9,
  viewportFraction: 1.05,
  initialPage: 0,
  enableInfiniteScroll: true,
  reverse: false,
  autoPlay: true,
  autoPlayInterval: Duration(seconds: 3),
  autoPlayAnimationDuration: Duration(milliseconds: 800),
  autoPlayCurve: Curves.easeIn,
  enlargeCenterPage: false,
  scrollDirection: Axis.horizontal,
  ),
  itemCount: allPosts.sliders.length,
  itemBuilder: (context, itemIndex, realIndex) =>
      InkWell(
        onTap: () async {
          var id = allPosts.sliders[itemIndex].productid;
          print(id);
          if (id != 0) {
            setState(() {
              allPosts.NavBarShow(false);
            });
            allPosts.fetchDataProduct(id);
            AllProviders.isProductSimilarMainOk = false;
            AllProviders.onceSimilar = false;
            AllProviders.isProductOk = false;
            AllProviders.selectedPiece = null;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PressedProduct(
                      isMain: false,
                    ),
              ),
            );
          }
        },
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: "${allPosts.sliders[itemIndex].image}",
            placeholder: (context, url) =>Image.asset(
                "assets/images/placeholder.png",
                fit: BoxFit.cover),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          // decoration: BoxDecoration(
          //   color: Theme.of(context).primaryColor,
          //   image: DecorationImage(
          //     image: //AssetImage(sliders[itemIndex]),
          //         NetworkImage(
          //       "${allPosts.sliders[itemIndex].image}",
          //     ),
          //     fit: BoxFit.cover,
          //   ),
          // ),
        ),
      ),
  );}}


  class Banners extends StatefulWidget {
  const Banners({Key key}) : super(key: key);

  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  List<String> sliders = [
  'assets/images/slider1.jpg',
  "assets/images/banner2.png",
  'assets/images/banner3.jpg'
  ];

  int selIndex=0;

  @override
  Widget build(BuildContext context) {
  final baner = Provider.of<Bannsers>(context, listen: false);
  return Container(
  height: 230,
  width: MediaQuery.of(context).size.width,
  child: Stack(
  children: [
  CarouselSlider.builder(
  options: CarouselOptions(
  onPageChanged: (index, next) {
  setState(() {
  selIndex=index;
  });
  },
  height: 230,
  aspectRatio: 16 / 9,
  viewportFraction: 1.05,
  initialPage: 0,
  enableInfiniteScroll: true,
  reverse: false,
  autoPlay: true,
  autoPlayInterval: Duration(seconds: 3),
  autoPlayAnimationDuration:
  Duration(milliseconds: 800),
  autoPlayCurve: Curves.easeIn,
  enlargeCenterPage: false,
  scrollDirection: Axis.horizontal,
  ),
  itemCount: baner.banner.length,
  itemBuilder: (BuildContext context, int itemIndex,int realIndex) =>
  InkWell(
  onTap: () async {
  if(baner.banner[itemIndex].url!=null){
  await launch('${baner.banner[itemIndex].url}').catchError((onError) {
  ToastGF.showError(context,"error"); });}
  else
  ToastGF.showError(context,"error");
  // Navigator.push(
  //   context,
  //   MaterialPageRoute(kk
  //     builder: (context) =>
  //         DetailService(
  //           servceId:baner.banner[itemIndex].userService_id,
  //         ),
  //   ),);
  },
  child: Container(
  width: MediaQuery
      .of(context)
      .size
      .width,
  margin: EdgeInsets.symmetric(horizontal: 5.0),
  child: CachedNetworkImage(
  fit: BoxFit.cover,
  imageUrl: "${baner.banner[itemIndex].image}",
  placeholder: (context, url) {
  return Image.asset(
  "assets/images/placeholder.png",
  fit: BoxFit.cover,
  );
  },
  errorWidget: (context, url, error) => Icon(Icons.error),
  ),
  // decoration: BoxDecoration(
  //   color: Theme.of(context).primaryColor,
  //   image: DecorationImage(
  //     image: //AssetImage(sliders[itemIndex]),
  //         NetworkImage(
  //       "${allPosts.sliders[itemIndex].image}",
  //     ),
  //     fit: BoxFit.cover,
  //   ),
  // ),
  ),
  ),
  ),
  Positioned(
  bottom: 20,
  right: 20,
  child: Row(
  children: [
  for(int i=0;i< baner.banner.length;i++)
  AnimatedContainer(
  margin: EdgeInsets.all(3),
  width: selIndex==i?23:5,
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(2),
  color: selIndex!=i?Colors.white:Colors.blue,
  ),
  height: 4,
  duration: Duration(seconds:1, ),
  curve: Curves.easeOutQuint,),
  ],
  ),
  ),
  ],
  ),
  );}}