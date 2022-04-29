import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/services/helpers/shimmerSection.dart';
import 'package:new_sahla/services/providers/Offers.dart';
import 'package:new_sahla/services/templetes/offfer_Item.dart';
import 'package:provider/provider.dart';

class ListOffer extends StatelessWidget {
  ListOffer({Key key}) : super(key: key);

  bool isLoadingBanner = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(Languages.selectedLanguage == 0 ? 'عروض' : 'offers'),
      ),
      body: Consumer<Offers>(
        builder: (ctx, off, _) {
          return Container(
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: off.items.length,
                itemBuilder: (context, index) {
                  if (isLoadingBanner == true) {
                    return SectionShimmer(mediaQuery: mediaQuery);
                  } else {
                    return OffferItem(
                        mediaQuery: mediaQuery, offer: off.items[index]);
                  }
                }),
          );
        },
      ),
    );
  }
}
