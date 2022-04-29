
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:new_sahla/services/model/offer.dart';
import 'package:new_sahla/services/screens/details_offer.dart';
class OffferItem extends StatelessWidget {
  Offer offer;
  Size mediaQuery;
  OffferItem({Key key,this.offer,this.mediaQuery}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MediaQuery.of(context).size.width*0.9,
      height:MediaQuery.of(context).size.height*0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(4),
        ),),
      margin: EdgeInsets.all(7),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailsOffer(postData: offer,),
          ));
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                    width: double.infinity,
                    height: mediaQuery.height*0.15,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10,),
                        child: Hero(
                            tag: offer.id,
                            child: Image.network(offer.image, fit: BoxFit.cover,)))),
              ),
            ],
          ),
        ),
      ),
    );}}

