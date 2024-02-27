
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_textfield.dart';
import 'package:provider/provider.dart';

class RefundBottomSheet extends StatefulWidget {
  final Product? product;
  final int? orderDetailsId;
  const RefundBottomSheet({Key? key, required this.product, required this.orderDetailsId}) : super(key: key);

  @override
  RefundBottomSheetState createState() => RefundBottomSheetState();
}

class RefundBottomSheetState extends State<RefundBottomSheet> {
  final TextEditingController _refundReasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    Provider.of<OrderProvider>(context, listen: false).getRefundReqInfo(widget.orderDetailsId);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBar(title: getTranslated('refund_request', context)),

            SingleChildScrollView(
              child: Consumer<OrderProvider>(
                builder: (context,refundReq,_) {
                  return Padding(padding: mediaQueryData.viewInsets,
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                      ),
                      child: Column(mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Consumer<OrderProvider>(
                              builder: (context, refund,_) {
                                return Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RichText(text: TextSpan(text: '', style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: getTranslated('total_price', context), style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                              TextSpan(text: PriceConverter.convertPrice(context,
                                                  refund.refundInfoModel!.refund!.productPrice!*refund.refundInfoModel!.refund!.quntity! ),
                                                  style: const TextStyle(fontWeight: FontWeight.w200)),
                                            ],
                                          ),
                                        ),

                                        RichText(
                                          text: TextSpan(text: '', style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: getTranslated('product_discount', context),
                                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: PriceConverter.convertPrice(context,
                                                  refund.refundInfoModel!.refund!.productTotalDiscount),
                                                  style: const TextStyle(fontWeight: FontWeight.w200)),
                                            ],
                                          ),
                                        ),

                                        RichText(
                                          text: TextSpan(text: '', style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: getTranslated('tax', context), style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                              TextSpan(text: PriceConverter.convertPrice(context,
                                                  refund.refundInfoModel!.refund!.productTotalTax),
                                                  style: const TextStyle(fontWeight: FontWeight.w200)),
                                            ],
                                          ),
                                        ),
                                        const Divider(),


                                        RichText(
                                          text: TextSpan(text: '', style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: getTranslated('sub_total', context),
                                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: PriceConverter.convertPrice(context,
                                                  refund.refundInfoModel!.refund!.subtotal),
                                                  style: const TextStyle(fontWeight: FontWeight.w300)),
                                            ],
                                          ),
                                        ),


                                        RichText(text: TextSpan(text: '', style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: getTranslated('coupon_discount', context),
                                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: PriceConverter.convertPrice(context,
                                                  refund.refundInfoModel!.refund!.couponDiscount),
                                                  style: const TextStyle(fontWeight: FontWeight.w300)),
                                            ],
                                          ),
                                        ),
                                        const Divider(),


                                        RichText(
                                          text: TextSpan(text: '', style: DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(text: getTranslated('total_refund_amount', context),
                                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                                              TextSpan(text: PriceConverter.convertPrice(context,
                                                  refund.refundInfoModel!.refund!.refundAmount),
                                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ]),
                                );
                              }
                            ),

                        Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: CustomTextField(
                            maxLine: 4,
                            hintText: getTranslated('refund_reason', context),
                            controller: _refundReasonController,
                            textInputAction: TextInputAction.done,
                            fillColor: ColorResources.getLowGreen(context),
                          ),
                        ),

                        Consumer<OrderProvider>(
                            builder: (context, refundProvider,_) {
                              return refundProvider.refundImage.isNotEmpty?
                              SizedBox(height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: refundProvider.refundImage.length,
                                  itemBuilder: (BuildContext context, index){
                                    return  refundProvider.refundImage.isNotEmpty?
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Stack(
                                        children: [
                                          Container(width: 100, height: 100,
                                            decoration: const BoxDecoration(color: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault)),
                                              child: Image.file(File(refundProvider.refundImage[index]!.path), width: 100, height: 100,
                                                fit: BoxFit.cover,
                                              ),
                                            ) ,
                                          ),
                                          Positioned(
                                            top:0,right:0,
                                            child: InkWell(
                                              onTap :() => refundProvider.removeImage(index),
                                              child: Container(
                                                  decoration: const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.all(Radius.circular(Dimensions.paddingSizeDefault))
                                                  ),
                                                  child: const Padding(
                                                    padding: EdgeInsets.all(4.0),
                                                    child: Icon(Icons.clear,color: Colors.red,size: 15,),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ):const SizedBox();
                                    },),
                              ):const SizedBox();
                            }
                        ),


                        Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          child: InkWell(
                            onTap: () => Provider.of<OrderProvider>(context, listen: false).pickImage(false),
                            child: SizedBox(height: 30,
                                child: Row(mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(getTranslated('upload_image', context)!),
                                    const SizedBox(width: Dimensions.paddingSizeDefault),
                                    Image.asset(Images.uploadImage),
                                  ],
                                )),
                          ),
                        ),


                            CustomButton(
                              buttonText: getTranslated('submit', context),
                              onTap: () {
                                String reason  = _refundReasonController.text.trim().toString();
                                if(reason.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(getTranslated('reason_required', context)!),
                                    backgroundColor: Colors.red,
                                  ));
                                }else {
                                  refundReq.refundRequest(context, widget.orderDetailsId,
                                      refundReq.refundInfoModel!.refund!.refundAmount,reason,
                                      Provider.of<AuthProvider>(context, listen: false).getUserToken()).
                                  then((value) {
                                    if(value.statusCode==200){
                                      refundReq.getRefundReqInfo(widget.orderDetailsId);
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(getTranslated('successfully_requested_for_refund', context)!),
                                        backgroundColor: Colors.green,
                                      ));
                                      Navigator.pop(context);
                                    }
                                  });
                                }
                              },
                            ),

                      ]),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}


