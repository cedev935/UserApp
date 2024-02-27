import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/notification_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/notification/widget/notification_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class NotificationScreen extends StatelessWidget {
  final bool isBacButtonExist;
  const NotificationScreen({Key? key, this.isBacButtonExist = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<NotificationProvider>(context, listen: false).initNotificationList(context);


    return Scaffold(
      body: Column(children: [

        CustomAppBar(title: getTranslated('notification', context), isBackButtonExist: isBacButtonExist),

        Expanded(
          child: Consumer<NotificationProvider>(
            builder: (context, notification, child) {
              return notification.notificationList != null ? notification.notificationList!.isNotEmpty ? RefreshIndicator(
                backgroundColor: Theme.of(context).primaryColor,
                onRefresh: () async {
                  await Provider.of<NotificationProvider>(context, listen: false).initNotificationList(context);
                },
                child: ListView.builder(
                  itemCount: Provider.of<NotificationProvider>(context).notificationList!.length,
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap:() => showDialog(context: context, builder: (context) => NotificationDialog(notificationModel: notification.notificationList![index])),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                        color: Theme.of(context).cardColor,
                        child: ListTile(
                          leading: ClipOval(child: FadeInImage.assetNetwork(
                            placeholder: Images.placeholder, height: 50, width: 50, fit: BoxFit.cover,
                            image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls!.notificationImageUrl}/${notification.notificationList![index].image}',
                            imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 50, width: 50, fit: BoxFit.cover),
                          )),
                          title: Text(notification.notificationList![index].title!, style: titilliumRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                          )),
                          subtitle: Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(notification.notificationList![index].createdAt!)),
                            style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: ColorResources.getHint(context)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ) : const NoInternetOrDataScreen(isNoInternet: false) : const NotificationShimmer();
            },
          ),
        ),

      ]),
    );
  }
}

class NotificationShimmer extends StatelessWidget {
  const NotificationShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      padding: const EdgeInsets.all(0),
      itemBuilder: (context, index) {
        return Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          color: ColorResources.getGrey(context),
          alignment: Alignment.center,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            enabled: Provider.of<NotificationProvider>(context).notificationList == null,
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.notifications)),
              title: Container(height: 20, color: ColorResources.white),
              subtitle: Container(height: 10, width: 50, color: ColorResources.white),
            ),
          ),
        );
      },
    );
  }
}

