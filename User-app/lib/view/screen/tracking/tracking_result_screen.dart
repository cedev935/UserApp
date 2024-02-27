import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_loader.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/tracking/painter/line_dashed_painter.dart';
import 'package:provider/provider.dart';

class TrackingResultScreen extends StatelessWidget {
  final String orderID;
  const TrackingResultScreen({Key? key, required this.orderID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderProvider>(context, listen: false).initTrackingInfo(orderID);
    List<String> statusList = ['pending', 'confirmed', 'processing', 'out_for_delivery', 'delivered'];


    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Column(
        children: [
          CustomAppBar(title: getTranslated('DELIVERY_STATUS', context)),

          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, tracking, child) {
                String? status = tracking.trackingModel != null ? tracking.trackingModel!.orderStatus : '';
                return tracking.trackingModel != null ? statusList.contains(status) ?
                ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Container(
                      margin: const EdgeInsets.all(Dimensions.marginSizeDefault),
                      decoration: BoxDecoration(color: Theme.of(context).highlightColor, borderRadius: BorderRadius.circular(5)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,
                              vertical: Dimensions.paddingSizeExtraSmall),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(getTranslated('PARCEL_STATUS', context)!, style: titilliumSemiBold),
                                RichText(text: TextSpan(text: getTranslated('ORDER_ID', context),
                                  style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                  children: <TextSpan>[
                                    TextSpan(text: orderID, style: titilliumSemiBold),],
                                ),)
                              ],
                            ),
                          ),
                          Container(width: double.infinity, height: 1,
                            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            color: ColorResources.getPrimary(context),),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                                // Steppers
                          CustomStepper(title: status == 'pending' ?
                          getTranslated('processing', context) : getTranslated('ORDER_PLACED_PREPARING', context),
                              color: ColorResources.getHarlequin(context)),


                          CustomStepper(title: status == 'pending' ?
                          getTranslated('pending', context) :
                          status == 'confirmed' ? getTranslated('processing', context) :
                          getTranslated('ORDER_PICKED_SENDING', context), color: ColorResources.getCheris(context)),


                          CustomStepper(title: status == 'pending' ?
                          getTranslated('pending', context) :
                          status == 'confirmed' ? getTranslated('pending', context) :
                          status == 'processing' ? getTranslated('processing', context) :
                          getTranslated('RECEIVED_LOCAL_WAREHOUSE', context), color: ColorResources.getColombiaBlue(context)),


                          CustomStepper(title:status == 'pending' ?
                          getTranslated('pending', context) : status == 'confirmed' ?
                          getTranslated('pending', context) : status == 'processing' ?
                          getTranslated('pending', context) : status == 'out_for_delivery' ?
                          getTranslated('processing', context) : getTranslated('DELIVERED', context),
                              color: Theme.of(context).primaryColor, isLastItem: true),
                              ],
                            ),
                          ),
                        ],
                      ) :

                status == AppConstants.failed ?
                const Center(child: Text('Failed')) : status == AppConstants.returned ?
                const Center(child: Text('Returned')) :
                const Center(child: Text('Cancelled')) : Center(child: CustomLoader(color: Theme.of(context).primaryColor));
              },
            ),
          ),

          // for footer button
          Container(
            height: 45,
            margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            decoration: BoxDecoration(color: ColorResources.getImageBg(context), borderRadius: BorderRadius.circular(6)),
            child: TextButton(
              style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
              onPressed: () =>
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const DashBoardScreen()), (route) => false),
              child: Container(width: double.infinity,
                alignment: Alignment.center,
                child: Text(getTranslated('ORDER_MORE', context)!,
                  style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge,
                      color: ColorResources.getPrimary(context)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomStepper extends StatelessWidget {
  final String? title;
  final Color color;
  final bool isLastItem;
  const CustomStepper({Key? key, required this.title, required this.color, this.isLastItem = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color myColor;
    if (title == getTranslated('processing', context) || title == getTranslated('pending', context)) {
      myColor = ColorResources.grey;
    } else {
      myColor = color;
    }
    return Container(
      height: isLastItem ? 50 : 100,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: CircleAvatar(backgroundColor: myColor, radius: 10.0),
              ),
              Text(title!, style: titilliumRegular)
            ],
          ),
          isLastItem
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall, left: Dimensions.paddingSizeLarge),
                  child: CustomPaint(painter: LineDashedPainter(myColor)),
                ),
        ],
      ),
    );
  }
}
