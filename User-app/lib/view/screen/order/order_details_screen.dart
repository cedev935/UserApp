import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/provider/localization_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/shimmer_loading.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/widget/cal_chat_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/widget/cancel_and_support_center.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/widget/ordered_product_list.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/widget/payment_info.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/widget/seller_section.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/widget/shipping_info.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/amount_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final bool isNotification;
  final int? orderId;
  final String? orderType;
  final double? extraDiscount;
  final String? extraDiscountType;
  const OrderDetailsScreen({Key? key, required this.orderId, required this.orderType,
    this.extraDiscount, this.extraDiscountType, this.isNotification = false}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {


  void _loadData(BuildContext context) async {
    await Provider.of<OrderProvider>(Get.context!, listen: false).initTrackingInfo(widget.orderId.toString());
    await Provider.of<OrderProvider>(Get.context!, listen: false).getOrderFromOrderId(widget.orderId.toString());
    await Provider.of<OrderProvider>(Get.context!, listen: false).getOrderDetails(widget.orderId.toString(),
      Provider.of<LocalizationProvider>(Get.context!, listen: false).locale.countryCode,
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData(context);
    Provider.of<OrderProvider>(context, listen: false).digitalOnly(true);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        widget.isNotification?
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen())):Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorResources.getIconBg(context),
        appBar: AppBar(iconTheme: IconThemeData(color: ColorResources.getTextTitle(context)),
          backgroundColor: Theme.of(context).cardColor,leading: InkWell(
              onTap: (){
                widget.isNotification?
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => const DashBoardScreen())):Navigator.pop(context);
              },
              child: const Icon(Icons.keyboard_backspace)),title: Text(getTranslated('ORDER_DETAILS', context)!,
              style: robotoRegular.copyWith(color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.fontSizeLarge),)),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              child: Consumer<OrderProvider>(
                builder: (context, orderProvider, child) {

                  double order = 0;
                  double discount = 0;
                  double? eeDiscount = 0;
                  double tax = 0;



                  if (orderProvider.orderDetails != null) {
                    for (var orderDetails in orderProvider.orderDetails!) {
                      if(orderDetails.productDetails?.productType != null && orderDetails.productDetails!.productType != "physical" ){
                        orderProvider.digitalOnly(false, isUpdate: false);
                      }
                    }



                    for (var orderDetails in orderProvider.orderDetails!) {
                      if (kDebugMode) {
                        print('---> ${orderDetails.taxModel}');
                      }
                      order = order + (orderDetails.price! * orderDetails.qty!);
                      discount = discount + orderDetails.discount!;
                        tax = tax + orderDetails.tax!;


                    }


                    if(widget.orderType == 'POS'){
                      if(widget.extraDiscountType == 'percent'){
                        eeDiscount = order * (widget.extraDiscount!/100);
                      }else{
                        eeDiscount = widget.extraDiscount;
                      }
                    }


                  }


                  return orderProvider.orderDetails != null ?
                  ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    children: [
                      const SizedBox(height: Dimensions.paddingSizeDefault,),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: Dimensions.paddingSizeDefault,
                            horizontal: Dimensions.paddingSizeSmall),
                        child: Row(
                          children: [RichText(text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: getTranslated('ORDER_ID', context),
                                  style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                                    color: Theme.of(context).textTheme.bodyLarge!.color,)),
                              TextSpan(text: orderProvider.trackingModel!.id.toString(),
                                  style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeLarge,
                                      color: ColorResources.getPrimary(context))),
                                ],
                              ),
                            ),
                            const Expanded(child: SizedBox()),


                            Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(orderProvider.trackingModel!.createdAt!)),
                                style: titilliumRegular.copyWith(color: ColorResources.getHint(context),
                                    fontSize: Dimensions.fontSizeSmall)),
                          ],
                        ),
                      ),

                      Container(
                        padding:
                        const EdgeInsets.all(Dimensions.marginSizeSmall),
                        decoration: BoxDecoration(color: Theme.of(context).highlightColor),
                        child: Column(
                          children: [
                            widget.orderType == 'POS' ?
                            Text(getTranslated('pos_order', context)!):
                            Row(mainAxisAlignment:MainAxisAlignment.start, crossAxisAlignment:CrossAxisAlignment.start,
                                children: [

                                  orderProvider.onlyDigital?
                                  Text('${getTranslated('SHIPPING_TO', context)} : ',
                                      style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault)):const SizedBox(),

                                  orderProvider.onlyDigital?
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 1),
                                    child: Text(' ${orderProvider.orderModel !=null  && orderProvider.orderModel!.shippingAddressData != null ?
                                    orderProvider.orderModel!.shippingAddressData!.address :''}', maxLines: 3, overflow: TextOverflow.ellipsis,
                                        style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                  )):const SizedBox(),

                                ]),
                            SizedBox(height: orderProvider.onlyDigital? Dimensions.paddingSizeLarge:0),


                            orderProvider.orderModel !=null && orderProvider.orderModel!.billingAddressData != null?
                            Row(mainAxisAlignment:MainAxisAlignment.start, crossAxisAlignment:CrossAxisAlignment.start,
                              children: [
                                Text('${getTranslated('billing_address', context)} :',
                                    style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 1),
                                  child: Text(' ${orderProvider.orderModel!.billingAddressData != null ? orderProvider.orderModel!.billingAddressData!.address : ''}',
                                      maxLines: 3, overflow: TextOverflow.ellipsis, style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                                )),
                              ],
                            ):const SizedBox(),

                          ],
                        ),
                      ),

                      orderProvider.orderModel != null && orderProvider.orderModel!.orderNote != null?
                      Padding(padding : const EdgeInsets.all(Dimensions.marginSizeSmall),
                        child: Text.rich(
                          TextSpan(children: [
                            TextSpan(text: '${getTranslated('order_note', context)} : ',
                                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge,
                                  color: ColorResources.getReviewRattingColor(context))),

                            TextSpan(text:  orderProvider.orderModel!.orderNote != null? orderProvider.orderModel!.orderNote ?? '': "",
                                style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                            ],
                          ),
                        ),
                      ):const SizedBox(),
                      const SizedBox(height: Dimensions.paddingSizeSmall),



                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault,
                            vertical: Dimensions.paddingSizeDefault),
                        child: Text(getTranslated('ORDERED_PRODUCT', context)!, style: titilliumSemiBold.copyWith()),
                      ),


                      SellerSection(order: orderProvider),


                      OrderProductList(order: orderProvider,orderType: widget.orderType),


                      const SizedBox(height: Dimensions.marginSizeDefault),

                      // Amounts
                      Container(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        color: Theme.of(context).highlightColor,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                                child: TitleRow(title: getTranslated('TOTAL', context)),
                              ),
                              AmountWidget(title: getTranslated('ORDER', context),
                                  amount: PriceConverter.convertPrice(context, order)),


                              widget.orderType == "POS"?const SizedBox():
                              AmountWidget(title: getTranslated('SHIPPING_FEE', context),
                                  amount: PriceConverter.convertPrice(context, orderProvider.trackingModel!.shippingCost)),


                              AmountWidget(title: getTranslated('DISCOUNT', context),
                                  amount: PriceConverter.convertPrice(context, discount)),


                              widget.orderType == "POS"?
                              AmountWidget(title: getTranslated('EXTRA_DISCOUNT', context),
                                  amount: PriceConverter.convertPrice(context, eeDiscount)):const SizedBox(),


                              AmountWidget(title: getTranslated('coupon_voucher', context),
                                amount: PriceConverter.convertPrice(context, orderProvider.trackingModel!.discountAmount),),


                              AmountWidget(title: getTranslated('TAX', context),
                                  amount: PriceConverter.convertPrice(context, tax)),


                              const Padding(padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                                child: Divider(height: 2, color: ColorResources.hintTextColor),),


                              AmountWidget(title: getTranslated('TOTAL_PAYABLE', context),
                                amount: PriceConverter.convertPrice(context,
                                    (order + orderProvider.trackingModel!.shippingCost! - eeDiscount! -
                                        orderProvider.trackingModel!.discountAmount! - discount  + tax)),),
                            ]),
                      ),




                      const SizedBox(height: Dimensions.paddingSizeSmall,),

                      orderProvider.trackingModel!.deliveryMan != null?
                      Container(padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(color: Theme.of(context).highlightColor,
                          boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.2), spreadRadius:2, blurRadius: 10)],
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text('${getTranslated('shipping_info', context)}', style: robotoBold),
                          const SizedBox(height: Dimensions.marginSizeExtraSmall),



                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('${getTranslated('delivery_man', context)} : ',
                                style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),


                            Text((orderProvider.trackingModel!.deliveryMan != null ) ?
                            '${orderProvider.trackingModel!.deliveryMan!.fName} ${orderProvider.trackingModel!.deliveryMan!.lName}':'',
                              style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall),),


                          ]),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          Row(mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CallAndChatWidget(orderProvider: orderProvider, orderModel: orderProvider.trackingModel),
                            ],
                          )
                        ]),
                      ):
                          //third party
                      orderProvider.trackingModel!.thirdPartyServiceName != null?
                      ShippingInfo(order: orderProvider):const SizedBox(),


                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      // Payment
                      PaymentInfo(order: orderProvider),

                      const SizedBox(height: Dimensions.paddingSizeSmall),


                      CancelAndSupport(orderModel: orderProvider.orderModel),

                    ],
                  ) : const LoadingPage();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
