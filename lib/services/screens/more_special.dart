import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/services/providers/Services.dart';
import 'package:new_sahla/services/templetes/service_item.dart';
import 'package:provider/provider.dart';

class MoreSpecial extends StatelessWidget {
  const MoreSpecial({Key key}) : super(key: key);

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
          lang.translation['mostUsed'][Languages.selectedLanguage],
        ),
      ),
      body: Consumer<Services>(builder: (ctx, pers, _) {
        return Container(
            child: StaggeredGridView.countBuilder(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                itemCount: pers.servicesMostUsed.length,
                itemBuilder: (context, index) => ServiceItem(
                      mediaQuery: mediaQuery,
                      service: pers.servicesMostUsed[index],
                    )));
      }),
    );
  }
}
