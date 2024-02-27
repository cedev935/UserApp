import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/notification_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/notification_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepo? notificationRepo;

  NotificationProvider({required this.notificationRepo});

  List<NotificationModel>? _notificationList;
  List<NotificationModel>? get notificationList => _notificationList;

  Future<void> initNotificationList(BuildContext context) async {
    ApiResponse apiResponse = await notificationRepo!.getNotificationList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _notificationList = [];
      apiResponse.response!.data.forEach((notification) => _notificationList!.add(NotificationModel.fromJson(notification)));
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }
}
