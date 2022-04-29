

import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/services/helpers/toast_gf.dart';
import 'package:new_sahla/services/providers/Orders.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:in_app_review/in_app_review.dart';
class Rating{
  static Future<void> showRatingDialog(context,String serverId,{isService:true,orderId}) {
    final lang=Provider.of<Languages>(context,listen: false);
    final _dialog = RatingDialog(
      // your app's name?
      title:Text( lang.translation['Rating Dialog'][Languages.selectedLanguage],
        style: TextStyle(fontSize: 18),
        textDirection:Languages.selectedLanguage==0? TextDirection.rtl:TextDirection.ltr,),
      // encourage your user to leave a high rating?
      message:Text(
        lang.translation['pressToRate'][Languages.selectedLanguage],
        style: TextStyle(fontSize: 14),
        textDirection:Languages.selectedLanguage==0? TextDirection.rtl:TextDirection.ltr,),
      // your app's logo?
      image: const Icon(Icons.rate_review_outlined,size: 100,color: Colors.black54,),
      submitButtonText: lang.translation['Submit'][Languages.selectedLanguage],
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        print('rating: ${response.rating}, comment: ${response.comment}');
        Provider.of<Orders>(context, listen: false).sendRating(
            rating:response.rating.toInt(),
            comment:response.comment,
            serverId:serverId,
            orderId:orderId,
            isService:isService
        ).then((value){
          if(value==true)
            ToastGF.showMessage(context, 'rated');
          else
          ToastGF.showError(context, 'not rated'
          );
          });
        // TODO: add your own logic
        if (response.rating < 3.0) {
          // send their comments to your email or anywhere you wish
          // ask the user to contact you instead of leaving a bad review
        } else {
          // rateAndReviewApp();
        }
      },
    );
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: true, // set to false if you want to force a rating
      builder: (context) => _dialog,
    );}
    static void rateAndReviewApp() async {
      final _inAppReview = InAppReview.instance;
      if (await _inAppReview.isAvailable()) {
        print('request actual review from store');
        _inAppReview.requestReview();
      } else {
        print('open actual store listing');
        // TODO: use your own store ids
        _inAppReview.openStoreListing(
          appStoreId: '<your app store id>',
          microsoftStoreId: '<your microsoft store id>',
        );
      }}}