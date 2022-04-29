import 'package:badges/badges.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:provider/provider.dart';

class DrawerItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final Function inkWell;
  bool isPoints;
  bool isCart;
  final AnimationController animation;

  DrawerItem(
      {Key key,
      @required this.title,
      @required this.icon,
      @required this.inkWell,
      this.animation,
      this.isPoints: false,
      this.isCart: false})
      : super(key: key);

  @override
  State<DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  @override
  Widget build(BuildContext context) {
    AllProviders pro = Provider.of<AllProviders>(context, listen: false);
    return InkWell(
      onTap: widget.inkWell,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Icon(
                      widget.icon,
                      color: Theme.of(context).textTheme.headline4.color,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: 17,
                          color: Theme.of(context).textTheme.headline4.color,
                          fontWeight: FontWeight.bold,
                          fontFamily: fonts),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.isPoints && !widget.isCart)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Badge(
                  badgeColor: Colors.orange,
                  badgeContent: Text(UserProvider.points),
                ),
              ),
            if (!widget.isPoints && widget.isCart)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Badge(
                  badgeColor: Colors.orange,
                  badgeContent: Text(pro.cartItemCount.toString()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
