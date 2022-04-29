import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/services/providers/Services.dart';
import 'package:provider/provider.dart';
import 'detail_service.dart';

class FavServiceScreen extends StatefulWidget {
  const FavServiceScreen({Key key}) : super(key: key);

  @override
  State<FavServiceScreen> createState() => _FavServiceScreenState();
}

class _FavServiceScreenState extends State<FavServiceScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<Services>(context, listen: false).getfav();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme.headline1;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Languages.selectedLanguage == 1
              ? 'My Favorite services'
              : "خدماتي المفضلة",
        ),
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
      ),
      body: Consumer<Services>(
        builder: (context, fav, child) => fav.favService.length == 0
            ? Center(
                child: Text(
                  Languages.selectedLanguage == 1
                      ? 'No Favorite services'
                      : 'لا توجد خدمات مفضلة',
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListView.builder(
                  itemCount: fav.favService.length,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.only(top: 3),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(248, 160, 205, 0.6),
                        borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  DetailService(service: fav.favService[index]),
                            ));
                      },
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(fav.favService[index].image),
                        radius: 40,
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () => Provider.of<Services>(context,
                                    listen: false)
                                .deleteFav(fav.favService[index].id, context),
                            child: CircleAvatar(
                              child: Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                              radius: 12,
                              backgroundColor: Colors.white70,
                            ),
                          ),
                          Text(
                              '${fav.favService[index].price}'
                              '${Languages.selectedLanguage == 0 ? 'دينار عراقي' : 'IQD'}',
                              style: textTheme,
                              textDirection: TextDirection.rtl),
                        ],
                      ),
                      title: Text(fav.favService[index].name,
                          style: textTheme, textDirection: TextDirection.ltr),
                      subtitle: Text(
                        '${fav.favService[index].description}',
                        style: textTheme,
                        textDirection: TextDirection.ltr,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
