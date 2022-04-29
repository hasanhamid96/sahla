import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/services/providers/Sections.dart';
import 'package:new_sahla/services/templetes/section_item.dart';
import 'package:provider/provider.dart';

class MoreCategories extends StatelessWidget {
  const MoreCategories({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Languages>(context);
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
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
        title: Text(
          lang.translation['categories'][Languages.selectedLanguage],
        ),
      ),
      body: Consumer<Sections>(builder: (ctx, sec, _) {
        return Container(
          child: GridView.builder(
              scrollDirection: Axis.vertical,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: sec.sectionItems.length,
              itemBuilder: (context, index) => SectionItem(
                    mediaQuery: mediaQuery,
                    section: sec.sectionItems[index],
                  )),
        );
      }),
    );
  }
}
