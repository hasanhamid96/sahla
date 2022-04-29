import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/model/Pieces.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';

class SizeColorTemplate extends StatefulWidget {
  final Pieces pieces;
  final bool isSelected;
  final BuildContext context2;

  SizeColorTemplate({this.pieces, this.context2, this.isSelected});

  @override
  State<SizeColorTemplate> createState() => _SizeColorTemplateState();
}

class _SizeColorTemplateState extends State<SizeColorTemplate> {
  @override
  Widget build(BuildContext context) {
    var colorCame;
    if (widget.pieces.color != null) {
      colorCame = "0xFF" + widget.pieces.color.replaceAll("#", "");
    }
    return InkWell(
      onTap: () {
        if (widget.isSelected == false) {
          setState(() {
            AllProviders.selectedPiece = widget.pieces;
            Navigator.of(widget.context2).pop();
            print(AllProviders.selectedPiece.size);
          });
        }
      },
      child: Container(
          decoration: BoxDecoration(
              color: colorCame != null
                  ? Color(
                      int.parse(colorCame),
                    ).withOpacity(0.8)
                  : Colors.transparent,
              borderRadius: BorderRadius.all(
                Radius.circular(13),
              ),
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 2,
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  widget.pieces.size != "No Size" ? widget.pieces.size : "",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                        offset: Offset(0.0, 2.0),
                        blurRadius: 5.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
