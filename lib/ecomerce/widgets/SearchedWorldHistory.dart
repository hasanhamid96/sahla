
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:provider/provider.dart';
class SearchedWorldHistory extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final BuildContext context;
  SearchedWorldHistory({this.text, this.controller, this.context});

  @override
  State<SearchedWorldHistory> createState() => _SearchedWorldHistoryState();
}

class _SearchedWorldHistoryState extends State<SearchedWorldHistory> {
  @override
  Widget build(BuildContext context) {
  final appProvider = Provider.of<AllProviders>(context, listen: true);
  final lang = Provider.of<Languages>(context);
  return InkWell(
  onTap: () {
  setState(() {
  widget.controller.text = widget.text;
  appProvider.search(widget.text, widget.context, lang);
  });
  },
  child: Container(
  padding: EdgeInsets.all(15),
  alignment: Languages.selectedLanguage == 0
  ? Alignment.centerRight
      : Alignment.centerLeft,
  width: MediaQuery.of(context).size.width / 1.1,
  child: Text(
  widget.text,
  style: TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.w300,
  color: Theme.of(context).bottomAppBarColor,
  ),
  ),
  ),
  );}}