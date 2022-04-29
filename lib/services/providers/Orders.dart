import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart'as http;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:new_sahla/ecomerce/providers/Languages.dart';
import 'package:new_sahla/ecomerce/providers/UserProvider.dart';
import 'package:new_sahla/ecomerce/providers/AllProviders.dart';
import 'package:new_sahla/services/model/Order.dart';
import 'package:new_sahla/services/model/Service.dart';
class Orders with ChangeNotifier{

  List<Order>_recentServiceOrder=[];

  List<Order>get recentServiceOrder{
    return[..._recentServiceOrder];}

    List<Order>_pastServiceOrder=[];

    List<Order>get pastServiceOrder{
      return[..._pastServiceOrder];}

      Future<bool> addOrder({name,phone,desc,lat,long,serviceId,schadule}) async {
        var url;
        url = '${AllProviders.hostName}/api/v1/request/services';
        try {
          final response = await http.post(Uri.parse(url), headers: {
            'Accept': 'application/json',
            'Authorization':UserProvider.token
          },body: {
            if(desc!=null)
              'description':desc,
            'service_id':serviceId.toString(),
            'lat':lat.toString(),
            'long':long.toString(),
            'preorder':schadule
          });
          final extractAdd=jsonDecode(response.body);
          notifyListeners();
          if(extractAdd['status']==true)
            return true;
          else
            return false;
        } catch (e) {
          print('$e fetch service error');
          throw e;
        }}

        int get pendingOrder{
          return _recentServiceOrder.length;}

          Future<List<Order>> fetchMyOrders() async {
            _pastServiceOrder = [];
            _recentServiceOrder = [];
            var url;
            url = '${AllProviders.hostName}/api/v1/request/services';
            // try {
                {
              final response = await http.get(Uri.parse(url), headers: {
                'Accept': 'application/json',
                "Authorization": '${UserProvider.token}',
              });
              var data4 = json.decode(response.body);
              final List<Order> loadedOrders = [];
              if (data4['status'] == false) {
                return null;
              }
              if (data4['status'] == true) {
                data4['Service_request'].forEach((items) {
                  var list = items['request_service_photo'];
                  List<String> images = [];
                  if (list != null)
                    list.forEach((photos) {
                      photos['photo'].forEach((photo) {
                        images.add(photo);
                      });
                    });
                  print('wwwwww ${items['rate']}');
                  loadedOrders.add(Order(
                      id: items['id'],
                      user_id: items['user_id'],
                      lat: items['lat'],
                      long: items['long'],
                      description: items['description'],
                      notes: items['notes'],
                      rate: items['rate'] == null ? 0.0 : double.parse(
                          items['rate']['stars'].toString()),
                      status: items['status'],
                      additionalPrice: double.parse(
                          items['additional_cost'].toString() ?? 0.0),
                      total: double.parse(items['total'].toString() ?? 0.0),
                      operator: items['type'],
                      providerNotes: items['provider_note'],
                      service_id: items['service_id'],
                      service_start: items['service_start'],
                      service_end: items['service_end'],
                      status_description: items['status_description'],
                      status_date: items['status_date'],
                      service_end_user_approval: items['service_end_user_approval']
                          .toString() ?? null,
                      user_name: items['user'] == null
                          ? null
                          : items['user']['name'],
                      user_phone: items['user'] == null
                          ? null
                          : items['user']['phone'],
                      server_id: items['server'] == null
                          ? null
                          : items['server']['id'],
                      server_name: items['server'] == null
                          ? null
                          : items['server']['name'],
                      server_phone: items['server'] == null
                          ? null
                          : items['server']['phone'],
                      duration: items['duration'].toString() ?? '1',
                      preorder: items['preorder'],
                      service: Service(
                          id: items['service']['id'],
                          name: items['service']['name_${Languages
                              .selectedLanguageStr}'],
                          description: items['service']
                          ['description_${Languages.selectedLanguageStr}'],
                          image: items['service']['photo'],
                          price: items['service']['price'],
                          inMinutes: items['service']['in_minutes'],
                          special: items['service']['special']
                      ),
                      request_service_photo: images
                    // request_service_photo: ,: items['description'],
                  ));
                });
                loadedOrders.forEach((element) {
                  if (element.status == 'finished' || element.status == 'end' ||
                      element.status == 'reject') {
                    _pastServiceOrder.add(element);
                    print('wwwww ${element.id}');
                  }
                  else
                    _recentServiceOrder.add(element);
                });
                notifyListeners();
              }
              notifyListeners();
            }
            // }
            // catch (e) {
            //   print('$e fetch my service  error');
            //   throw e;
            // }
          }

            Future<bool> sendImages({List<File> files, notes, ordersId,status}) async {
              var pic;
              var url;
              url = '${AllProviders.hostName}/api/v1/request/services/update';
              try {
                http.MultipartRequest request = await http.MultipartRequest(
                  'POST',
                  Uri.parse(url),
                );
                request.headers.addAll({
                  'Accept': 'application/json',
                  "Authorization": UserProvider.token,
                });
                request.fields['service_request_id'] = ordersId.toString();
                // request.fields['status'] = notes.toString();
                request.fields['status'] = status.toString();
                if (files != null) {
                  for (int i = 0; i < files.length; i++) {
                    pic = await http.MultipartFile.fromPath("photo[$i]", files[i].path);
                    request.files.add(pic);
                  }
                }
                var response = await request.send();
                //Get the response from the server
                var responseData = await response.stream.toBytes();
                var responseString = String.fromCharCodes(responseData);
                if (response.statusCode == 200)
                  return Future.value(true);
                else
                  return Future.value(false);
              } catch (e) {
                return Future.value(false);
              }}

              Future<void> startEnd({status, serviceId}) async {
                var url;
                url =
                '${AllProviders.hostName}/v1/request/services/changestatus/$serviceId';
                try {
                  final response = await http.post(Uri.parse(url), body: {
                    'status': '$status',
                    if (status == 'start')
                      'start': DateFormat('yy-MM-dd kk:mm:ss').format(DateTime.now()),
                    if (status == 'end')
                      'end': DateFormat('yy-MM-dd kk:mm:ss').format(DateTime.now()),
                  }, headers: {
                    'Accept': 'application/json',
                    "Authorization": UserProvider.token,
                  });
                  var data4 = json.decode(response.body);
                } catch (e) {}}

                Future<bool> cancelOrder({ orderId,isFromProduct:false}) async {
                  var url;
                  if(isFromProduct)
                    url =
                    '${AllProviders.hostName}/api/v1/orders/status/$orderId';
                  else
                    url =
                    '${AllProviders.hostName}/api/v1/request/services/delete/$orderId';
                  try {
                    final response = await http.post(Uri.parse(url), body: {
                      if(isFromProduct)
                        'status':'canceled'
                    }, headers: {'Accept': 'application/json', "Authorization": UserProvider.token,});
                    if(!isFromProduct)
                      _recentServiceOrder.removeWhere((element) => element.id==orderId);
                    notifyListeners();
                    var data4 = json.decode(response.body);
                    if(data4['status']==true)
                      return true;
                    else
                      return false;
                  } on PlatformException{
                    return false;
                  } catch (e) {
                    return false;
                  }}
                  Future<bool> userApproval({
                    @required approval, @required time, @required type, @required orderId,approvalType,ctx}) async {
                    var url;
                    url = '${AllProviders.hostName}/api/v1/user/approval/$orderId';
                    try {
                      final response = await http.post(Uri.parse(url), headers: {
                        'Accept': 'application/json',
                        'Authorization':UserProvider.token
                      },
                          body: {
                            if(approvalType=='service')
                              'approval':approval.toString(),
                            'type':type.toString(),
                            if(approvalType=='service')
                              'time': DateFormat('yyyy-MM-dd').format(time).toString(),
                            'approval_type': approvalType
                          });
                      final extractAdd=jsonDecode(response.body);
                      if(extractAdd['status']==true) {
                        // ToastGF.showInSnackBar('
                        // ', ctx);
                        return true;
                      }
                      else
                        return false;
                    } catch (e) {
                      print('$e post approval error');
                      throw e;
                    }}
                    Future<bool> sendRating({
                      @required int  rating, @required String comment, @required String serverId,isService,orderId }) async {
                      var url;
                      if(isService) {
                        url = '${AllProviders.hostName}/api/v1/rating';
                        int index=    _pastServiceOrder.indexWhere((element) => element.server_id==int.parse(serverId));
                        print(index);
                        _pastServiceOrder[index].rate=double.parse(rating.toString());
                        notifyListeners();
                      }
                      else
                        url = '${AllProviders.hostName}/api/v1/orders/rate/$serverId';
                      try {
                        final response = await http.post(Uri.parse(url),
                            headers: {
                              'Accept': 'application/json',
                              'Authorization':UserProvider.token
                            },body: {
                              if(!isService)
                                'rate':rating.toString(),
                              if(isService)
                                'server_id':serverId.toString(),
                              if(isService)
                                'stars':rating.toString(),
                              if(isService)
                                'service_request_id':orderId.toString(),
                              'comment':comment.toString().length==0? 'no comment'.toString():comment,
                            });
                        final extractAdd=jsonDecode(response.body);
                        print(extractAdd);
                        notifyListeners();
                        if(extractAdd['status']==true)
                          return true;
                        else
                          return false;
                      } catch (e) {
                        print('$e post rating error');
                        throw e;
                      }}}