import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/services/model/Service.dart';
import 'package:new_sahla/services/screens/detail_service.dart';

class ServiceItem extends StatelessWidget {
  Service service;
  Size mediaQuery;

  ServiceItem({Key key, this.service, this.mediaQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1),
      width: mediaQuery.width * 0.48,
      height: mediaQuery.height * 0.3,
      child: Stack(
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                if (service.isActive)
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DetailService(
                      service: service,
                    ),
                  ));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        height: mediaQuery.height * 0.15,
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10)),
                            child: Image.network(
                              service.image,
                              fit: BoxFit.cover,
                            ))),
                  ),
                  Container(
                    width: mediaQuery.width * 0.45,
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      '${service.name}',
                      style: Theme.of(context).textTheme.headline5,
                      textAlign: Languages.selectedLanguage == 0
                          ? TextAlign.right
                          : TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      textDirection: Languages.selectedLanguage == 0
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                  ),
                  Container(
                    width: mediaQuery.width * 0.45,
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      '${service.price} ${service.inMinutes == 0 ? Languages.selectedLanguage == 1 ? 'IQD' : 'دينار' : Languages.selectedLanguage == 1 ? 'IQD/min' : ' دينار / دقيقة'}',
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontFamily: fonts),
                      overflow: TextOverflow.ellipsis,
                      textAlign: Languages.selectedLanguage == 0
                          ? TextAlign.right
                          : TextAlign.left,
                      textDirection: Languages.selectedLanguage == 0
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!service.isActive)
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              height: mediaQuery.height * 0.39,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black26.withOpacity(0.5),
              ),
              child: Center(
                child: Text(
                  Languages.selectedLanguage == 0
                      ? 'الخدمة غير متوفرة'
                      : 'service not available',
                  style: TextStyle(
                      color: Colors.white, fontFamily: fonts, fontSize: 16),
                ),
              ),
            )
        ],
      ),
    );
  }
}
