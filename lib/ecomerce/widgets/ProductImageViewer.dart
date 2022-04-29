import 'package:back_button_interceptor/back_button_interceptor.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/model/Product.dart';
import 'package:new_sahla/ecomerce/model/ProductImage.dart';
import 'package:provider/provider.dart';

class ProductImageViewer extends StatefulWidget {
  final List<ProductImage> pics;
  final Product product;
  final int currentIndex;

  ProductImageViewer({this.pics, this.product, this.currentIndex});

  @override
  State<ProductImageViewer> createState() => _ProductImageViewerState();
}

class _ProductImageViewerState extends State<ProductImageViewer> {
  List<String> images = List<String>();

  @override
  void initState() {
    images = [];
    widget.pics.forEach((element) {
      images.add(element.image);
      print(element.image);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex2 = widget.currentIndex;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.clear, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Text(
              widget.product.name,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
      body: ExtendedImageGesturePageView.builder(
        itemBuilder: (BuildContext context, int index) {
          var item = images[index];
          Widget image = ExtendedImage.network(
            item,
            initGestureConfigHandler: (s) {
              return GestureConfig(
                inPageView: true,
                initialScale: 1.0,
                //you can cache gesture state even though page view page change.
                //remember call clearGestureDetailsCache() method at the right time.(for example,this page dispose)
                cacheGesture: true,
              );
            },
            fit: BoxFit.contain,
            mode: ExtendedImageMode.gesture,
            cache: true,
          );
          image = Container(
            child: image,
          );
          if (index == currentIndex2) {
            return Hero(
              tag: item + index.toString(),
              child: image,
            );
          } else {
            return image;
          }
        },
        itemCount: images.length,
        onPageChanged: (int index) {
          currentIndex2 = index;
          //    rebuild.add(index);
        },
        controller: PageController(
          initialPage: currentIndex2,
        ),
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
