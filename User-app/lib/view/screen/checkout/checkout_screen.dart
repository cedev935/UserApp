import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/order_place_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/coupon_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/amount_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/my_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/address/saved_address_list_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/address/saved_billing_address_list_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/widget/custom_check_box.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/widget/offline_payment.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/widget/wallet_payment.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/payment/payment_screen.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  final bool fromProductDetails;
  final double totalOrderAmount;
  final double shippingFee;
  final double discount;
  final double tax;
  final int? sellerId;
  final bool onlyDigital;

  const CheckoutScreen({Key? key, required this.cartList, this.fromProductDetails = false,
    required this.discount, required this.tax, required this.totalOrderAmount, required this.shippingFee, this.sellerId, this.onlyDigital = false}) : super(key: key);


  @override
  CheckoutScreenState createState() => CheckoutScreenState();
}

class CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _orderNoteController = TextEditingController();
  final FocusNode _orderNoteNode = FocusNode();
  double _order = 0;
  bool? _digitalPayment;
  bool? _cod;
  late bool _billingAddress;
  double? _couponDiscount;


  TextEditingController paymentByController = TextEditingController();
  TextEditingController transactionIdController = TextEditingController();
  TextEditingController paymentNoteController = TextEditingController();



  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).initAddressList();
    Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
    Provider.of<CouponProvider>(context, listen: false).removePrevCouponData();
    Provider.of<CartProvider>(context, listen: false).getCartDataAPI(context);
    Provider.of<CartProvider>(context, listen: false).getChosenShippingMethod(context);
    _digitalPayment = Provider.of<SplashProvider>(context, listen: false).configModel!.digitalPayment;
    _cod = Provider.of<SplashProvider>(context, listen: false).configModel!.cod;
    _billingAddress = Provider.of<SplashProvider>(context, listen: false).configModel!.billingAddress == 1;

  }

  @override
  Widget build(BuildContext context) {

    _order = widget.totalOrderAmount+widget.discount;


    List<PaymentMethod> paymentMethods = [
      if(_cod! && !widget.onlyDigital)
      PaymentMethod('cash_on_delivery', Images.cod),
      if(_digitalPayment! && Provider.of<SplashProvider>(context, listen: false).configModel!.paymentMethods!.bkash!)
        PaymentMethod('bkash', Images.bKash),
      if(_digitalPayment! && Provider.of<SplashProvider>(context, listen: false).configModel!.paymentMethods!.liqpay!)
        PaymentMethod('liqpay', Images.liqpay),
      if(_digitalPayment! && Provider.of<SplashProvider>(context, listen: false).configModel!.paymentMethods!.mercadopago!)
        PaymentMethod('mercadopago', Images.mercadopago),
      if(_digitalPayment! && Provider.of<SplashProvider>(context, listen: false).configModel!.paymentMethods!.paymobAccept!)
        PaymentMethod('paymob_accept', Images.paymob),
      if(_digitalPayment! && Provider.of<SplashProvider>(context, listen: false).configModel!.paymentMethods!.paystack!)
        PaymentMethod('paystack', Images.paystack),
      if(_digitalPayment! && Provider.of<SplashProvider>(context, listen: false).configModel!.paymentMethods!.paytabs!)
        PaymentMethod('paytabs', Images.paytabs),
      if(_digitalPayment! && Provider.of<SplashProvider>(context, listen: false).configModel!.paymentMethods!.razorPay!)
        PaymentMethod('razor_pay', Images.razorpay),
      if(_digitalPayment! && Provider.of<SplashProvider>(context, listen: false).configModel!.paymentMethods!.paypal!)
        PaymentMethod('paypal', Images.paypal),
      if(_digitalPayment! && Provider.of<SplashProvider>(context, listen: false).configModel!.paymentMethods!.senangPay!)
        PaymentMethod('senang_pay', Images.snangpay),
      if(_digitalPayment! && Provider.of<SplashProvider>(context, listen: false).configModel!.paymentMethods!.sslCommerzPayment!)
        PaymentMethod('ssl_commerz_payment', Images.sslCommerz),
      if(_digitalPayment! && Provider.of<SplashProvider>(context, listen: false).configModel!.paymentMethods!.stripe!)
        PaymentMethod('stripe', Images.stripe),
      if(_digitalPayment! && Provider.of<SplashProvider>(context, listen: false).configModel!.paymentMethods!.flutterwave!)
        PaymentMethod('flutterwave', Images.flutterwave),
      if(_digitalPayment! && Provider.of<SplashProvider>(context, listen: false).configModel!.paymentMethods!.fawryPay!)
        PaymentMethod('fawry_pay', Images.fawryPay),
      if(_digitalPayment! && Provider.of<SplashProvider>(context, listen: false).configModel!.paymentMethods!.offlinePayment!)
        PaymentMethod('offline_payment', Images.offlinePay),
      if(_digitalPayment! && Provider.of<SplashProvider>(context, listen: false).configModel!.walletStatus == 1)
        PaymentMethod('wallet', Images.walletPay),

    ];



    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,

      bottomNavigationBar: Consumer<OrderProvider>(
        builder: (context, order, child) {
          return InkWell(
            onTap: () async {
              if(order.addressIndex == null && !widget.onlyDigital) {
                showCustomSnackBar(getTranslated('select_a_shipping_address', context), context, isToaster: true);

              }else if(order.billingAddressIndex == null && _billingAddress){
                showCustomSnackBar(getTranslated('select_a_billing_address', context), context, isToaster: true);

              }

              else {
                List<CartModel> cartList = [];
                cartList.addAll(widget.cartList);

                for(int index=0; index<widget.cartList.length; index++) {
                  for(int i=0; i<Provider.of<CartProvider>(context, listen: false).chosenShippingList.length; i++) {
                    if(Provider.of<CartProvider>(context, listen: false).chosenShippingList[i].cartGroupId == widget.cartList[index].cartGroupId) {
                      cartList[index].shippingMethodId = Provider.of<CartProvider>(context, listen: false).chosenShippingList[i].id;
                      break;
                    }
                  }
                }

                String orderNote = _orderNoteController.text.trim();
                double? couponDiscount = Provider.of<CouponProvider>(context, listen: false).discount ?? 0;
                String couponCode =Provider.of<CouponProvider>(context, listen: false).discount != null &&
                    Provider.of<CouponProvider>(context, listen: false).discount != 0?
                Provider.of<CouponProvider>(context, listen: false).couponCode : '';
                String couponCodeAmount =Provider.of<CouponProvider>(context, listen: false).discount != null &&
                    Provider.of<CouponProvider>(context, listen: false).discount != 0?
                Provider.of<CouponProvider>(context, listen: false).discount.toString() : '0';

                if(paymentMethods[order.paymentMethodIndex].name == 'cash_on_delivery' && !widget.onlyDigital) {

                  Provider.of<OrderProvider>(context, listen: false).placeOrder(OrderPlaceModel(
                    'cash_on_delivery' , couponDiscount,
                  ), _callback,
                      widget.onlyDigital ? '':
                      Provider.of<ProfileProvider>(context, listen: false).addressList[order.addressIndex!].id.toString(),
                      couponCode,
                      couponCodeAmount,
                      _billingAddress?
                      Provider.of<ProfileProvider>(context, listen: false).billingAddressList[order.billingAddressIndex!].id.toString():
                      widget.onlyDigital ? '':
                      Provider.of<ProfileProvider>(context, listen: false).addressList[order.addressIndex!].id.toString(),
                      orderNote, paymentByController.text, transactionIdController.text, paymentNoteController.text
                  );
                }
                else  if(paymentMethods[order.paymentMethodIndex].name == 'offline_payment'){
                  showAnimatedDialog(context, OfflinePaymentDialog(
                    paymentBy: paymentByController,
                    transactionId: transactionIdController,
                    paymentNote: paymentNoteController,
                    onTap: (){

                      if(paymentByController.text.isEmpty){
                        showCustomSnackBar(getTranslated('payment_by_is_required', context), context, isToaster: true);
                      }else if(transactionIdController.text.isEmpty){
                        showCustomSnackBar(getTranslated('transaction_id_is_required', context), context, isToaster: true);
                      }else{
                        Navigator.of(context).pop();
                        order.placeOrder(OrderPlaceModel(
                          'offline_payment', couponDiscount,
                        ), _callback,
                            widget.onlyDigital ? '':
                            Provider.of<ProfileProvider>(context, listen: false).addressList[order.addressIndex!].id.toString(),
                            couponCode,
                            couponCodeAmount,
                            _billingAddress?
                            Provider.of<ProfileProvider>(context, listen: false).billingAddressList[order.billingAddressIndex!].id.toString():
                            widget.onlyDigital ? '':
                            Provider.of<ProfileProvider>(context, listen: false).addressList[order.addressIndex!].id.toString(),
                            orderNote, paymentByController.text, transactionIdController.text, paymentNoteController.text, isfOffline: true);
                      }

                    },
                  ), dismissible: false, isFlip: true);
                }else if(paymentMethods[order.paymentMethodIndex].name == 'wallet'){

                  showAnimatedDialog(context, Consumer<ProfileProvider>(
                    builder: (context, profile,_) {
                      return WalletPayment(
                        currentBalance: profile.balance,
                        orderAmount: _order + widget.shippingFee - widget.discount - _couponDiscount! + widget.tax,
                        onTap: (){
                          if(profile.balance! < (_order + widget.shippingFee - widget.discount - _couponDiscount! + widget.tax)){
                            showCustomSnackBar(getTranslated('insufficient_balance', context), context, isToaster: true);
                          }else{
                            Navigator.pop(context);
                            order.placeOrder(OrderPlaceModel(
                              'pay_by_wallet', couponDiscount,
                            ), _callback,
                                widget.onlyDigital ? '':
                                Provider.of<ProfileProvider>(context, listen: false).addressList[order.addressIndex!].id.toString(),
                                couponCode,
                                couponCodeAmount,
                                _billingAddress?
                                Provider.of<ProfileProvider>(context, listen: false).billingAddressList[order.billingAddressIndex!].id.toString():
                                widget.onlyDigital ? '':
                                Provider.of<ProfileProvider>(context, listen: false).addressList[order.addressIndex!].id.toString(),
                                orderNote, paymentByController.text, transactionIdController.text, paymentNoteController.text, wallet: true);
                          }

                        },
                      );
                    }
                  ), dismissible: false, isFlip: true);
                }
                else {
                  String userID = await Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
                  Navigator.pushReplacement(Get.context!, MaterialPageRoute(builder: (_) => PaymentScreen(
                    customerID: userID,
                    addressID: widget.onlyDigital ? '':
                    Provider.of<ProfileProvider>(context, listen: false).addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex!].id.toString(),
                    couponCode: couponCode,
                    couponCodeAmount: couponCodeAmount,
                    billingId: _billingAddress?
                    Provider.of<ProfileProvider>(context, listen: false).billingAddressList[Provider.of<OrderProvider>(context, listen: false).billingAddressIndex!].id.toString():
                    widget.onlyDigital ? '':
                    Provider.of<ProfileProvider>(context, listen: false).addressList[Provider.of<OrderProvider>(context, listen: false).addressIndex!].id.toString(),
                    orderNote: orderNote,
                    paymentMethod: paymentMethods[order.paymentMethodIndex].name,

                  )));
                }
              }
            },
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
              decoration: BoxDecoration(
                color: ColorResources.getPrimary(context),
               ),
              child: Center(
                child: Consumer<OrderProvider>(
                  builder: (context, order, child) {
                  return !Provider.of<OrderProvider>(context).isLoading ? Builder(
                    builder: (context) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/2.9),
                      child: Text(getTranslated('proceed', context)!, style: titilliumSemiBold.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge,
                        color: Theme.of(context).cardColor,
                      )),
                    ),
                  ) : Container(
                    height: 30,width: 30 ,alignment: Alignment.center,
                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).highlightColor)),
                  );
                  },
                ),
              ),
            ),
          );
        }
      ),

      body: Column(
        children: [

          CustomAppBar(title: getTranslated('checkout', context)),

          Expanded(
            child: ListView(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.all(0), children: [

              // Shipping Details
              Consumer<OrderProvider>(
                builder: (context, shipping,_) {
                  return Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          !widget.onlyDigital?
                          Card(
                            child: Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                                color: Theme.of(context).cardColor,
                              ),
                              child: Column(crossAxisAlignment:CrossAxisAlignment.start,
                                children: [
                                  Row(mainAxisAlignment:MainAxisAlignment.start, crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: Text('${getTranslated('shipping_address', context)}',
                                          style: titilliumRegular.copyWith(fontWeight: FontWeight.w600))),


                                      InkWell(
                                        onTap: () => Navigator.of(context).push(
                                            MaterialPageRoute(builder: (BuildContext context) => const SavedAddressListScreen())),
                                        child: Image.asset(Images.address, scale: 3),
                                      ),

                                    ],
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeDefault,),

                                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Provider.of<OrderProvider>(context,listen: false).addressIndex == null ?
                                        '${getTranslated('address_type', context)}' :
                                        Provider.of<ProfileProvider>(context, listen: false).addressList[
                                        Provider.of<OrderProvider>(context, listen: false).addressIndex!].addressType!,
                                        style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                                        maxLines: 3, overflow: TextOverflow.fade,
                                      ),
                                      const Divider(),


                                      Text(
                                        Provider.of<OrderProvider>(context,listen: false).addressIndex == null ?
                                        getTranslated('add_your_address', context)! :
                                        Provider.of<ProfileProvider>(context, listen: false).addressList[
                                          shipping.addressIndex!].address!,
                                        style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                        maxLines: 3, overflow: TextOverflow.fade,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ): const SizedBox(),

                          SizedBox(height: !widget.onlyDigital? Dimensions.paddingSizeSmall:0),
                          _billingAddress?
                          Card(
                            child: Container(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
                                color: Theme.of(context).cardColor,
                              ),
                              child: Column(crossAxisAlignment:CrossAxisAlignment.start,
                                children: [
                                  Row(mainAxisAlignment:MainAxisAlignment.start, crossAxisAlignment:CrossAxisAlignment.start,
                                    children: [
                                      Expanded(child: Text('${getTranslated('billing_address', context)}',
                                          style: titilliumRegular.copyWith(fontWeight: FontWeight.w600))),


                                      InkWell(
                                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                            builder: (BuildContext context) => const SavedBillingAddressListScreen())),
                                        child: Image.asset(Images.address, scale: 3),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: Dimensions.paddingSizeDefault,),
                                  Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        Provider.of<OrderProvider>(context).billingAddressIndex == null ? '${getTranslated('address_type', context)}'
                                            : Provider.of<ProfileProvider>(context, listen: false).billingAddressList[
                                        Provider.of<OrderProvider>(context, listen: false).billingAddressIndex!].addressType!,
                                        style: titilliumBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                                        maxLines: 1, overflow: TextOverflow.fade,
                                      ),
                                      const Divider(),
                                      Text(
                                        Provider.of<OrderProvider>(context).billingAddressIndex == null ? getTranslated('add_your_address', context)!
                                            : Provider.of<ProfileProvider>(context, listen: false).billingAddressList[
                                              shipping.billingAddressIndex!].address!,
                                        style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                                        maxLines: 3, overflow: TextOverflow.fade,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ):const SizedBox(),
                    ]),
                  );
                }
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),
              // Order Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                child: Text(getTranslated('ORDER_DETAILS', context)!,style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
              ),
              Container(
                transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: Provider.of<CartProvider>(context,listen: false).cartList.length,
                    itemBuilder: (ctx,index){
                      return Padding(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Row(children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: .5, color: Theme.of(context).primaryColor.withOpacity(.25)),
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraExtraSmall),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraExtraSmall),
                              child: FadeInImage.assetNetwork(
                                placeholder: Images.placeholder, fit: BoxFit.cover, width: 50, height: 50,
                                image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls!.productThumbnailUrl}'
                                    '/${Provider.of<CartProvider>(context,listen: false).cartList[index].thumbnail}',
                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, fit: BoxFit.cover, width: 50, height: 50),
                              ),
                            ),
                          ),
                          const SizedBox(width: Dimensions.marginSizeDefault),
                          Expanded(
                            flex: 3,
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      Provider.of<CartProvider>(context,listen: false).cartList[index].name!,
                                      style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                                          color: ColorResources.getPrimary(context)),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: Dimensions.paddingSizeSmall,),
                                  Text(PriceConverter.convertPrice(context, Provider.of<CartProvider>(context,listen: false).cartList[index].price),
                                    style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),),

                                ],
                              ),
                              const SizedBox(height: Dimensions.marginSizeExtraSmall),

                              Row(children: [

                                Text('${getTranslated('qty', context)} -  ${Provider.of<CartProvider>(context,listen: false).cartList[index].quantity}',
                                    style: titilliumRegular.copyWith()),

                              ]),
                            ]),
                          ),
                        ]),
                      );

                    }),
              ),
              // Coupon
              Padding(
                padding: const EdgeInsets.only(left:Dimensions.paddingSizeDefault,right:Dimensions.paddingSizeDefault,
                    bottom: Dimensions.paddingSizeDefault),
                child: Container(height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: ColorResources.couponColor(context).withOpacity(.5),
                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                      border: Border.all(width: .5, color: Theme.of(context).primaryColor.withOpacity(.9))
                  ),
                  child: Row(children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: Padding(
                          padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall,bottom: 5),
                          child: Center(
                            child: TextField(controller: _controller, decoration: InputDecoration(
                              hintText: 'Have a coupon?',
                              hintStyle: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                              filled: false,
                              fillColor: ColorResources.getIconBg(context),
                              border: InputBorder.none,
                            )),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),
                    !Provider.of<CouponProvider>(context).isLoading ? InkWell(
                      onTap: () {
                        if(_controller.text.isNotEmpty) {
                          Provider.of<CouponProvider>(context, listen: false).initCoupon(context,_controller.text, _order);
                        }
                      },
                      child: Container(width: 100,height: 60,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(Dimensions.paddingSizeExtraSmall),
                                  topRight: Radius.circular(Dimensions.paddingSizeExtraSmall))

                          ),
                          child: Center(child: Text(getTranslated('APPLY', context)!,
                            style: titleRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeLarge),
                          ))),
                    ) : Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: SizedBox(width: 30,height: 30,child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                    ),
                  ]),
                ),
              ),

              const SizedBox(height: Dimensions.paddingSizeSmall,),

              Container(
                height: 40,width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(.055),
                ),
                child: Center(child: Text(getTranslated('order_summary', context)!,
                  style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),)),
              ),
              // Total bill
              Container(
                margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                color: Theme.of(context).highlightColor,
                child: Consumer<OrderProvider>(
                  builder: (context, order, child) {
                     _couponDiscount = Provider.of<CouponProvider>(context).discount ?? 0;

                    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      AmountWidget(title: getTranslated('sub_total', context), amount: PriceConverter.convertPrice(context, _order)),
                      AmountWidget(title: getTranslated('SHIPPING_FEE', context), amount: PriceConverter.convertPrice(context, widget.shippingFee)),
                      AmountWidget(title: getTranslated('DISCOUNT', context), amount: PriceConverter.convertPrice(context, widget.discount)),
                      AmountWidget(title: getTranslated('coupon_voucher', context), amount: PriceConverter.convertPrice(context, _couponDiscount)),
                      AmountWidget(title: getTranslated('TAX', context), amount: PriceConverter.convertPrice(context, widget.tax)),
                      Divider(height: 5, color: Theme.of(context).hintColor),
                      AmountWidget(title: getTranslated('TOTAL_PAYABLE', context), amount: PriceConverter.convertPrice(context,
                          (_order + widget.shippingFee - widget.discount - _couponDiscount! + widget.tax))),
                    ]);
                  },
                ),
              ),

              // Payment Method
              Container(
                height: 150,
                margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                color: Theme.of(context).highlightColor,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(getTranslated('payment_method', context)!, style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                  SizedBox(height: 100,
                      child: ListView.builder(
                        itemCount: paymentMethods.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index){
                          return  CustomCheckBox(index: index, icon: paymentMethods[index].image);
                        },
                        )
                  ),
                ]),
              ),


              Container(
                margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                color: Theme.of(context).highlightColor,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(
                    children: [
                      Text(
                        '${getTranslated('order_note', context)}',
                        style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge),),
                      Text(
                        '${getTranslated('extra_inst', context)}',
                        style: robotoRegular.copyWith(color: ColorResources.getHint(context)),),
                    ],
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),
                  CustomTextField(
                    hintText: getTranslated('enter_note', context),
                    textInputType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    maxLine: 3,
                    focusNode: _orderNoteNode,
                    controller: _orderNoteController,
                  ),
                ]),
              ),



            ]),
          ),
        ],
      ),
    );
  }

  void _callback(bool isSuccess, String message, String orderID) async {
    if(isSuccess) {
      Provider.of<ProductProvider>(context, listen: false).getLatestProductList(1, reload: true,);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const DashBoardScreen()), (route) => false);
        showAnimatedDialog(context, MyDialog(
          icon: Icons.check,
          title: getTranslated('order_placed', context),
          description: getTranslated('your_order_placed', context),
          isFailed: false,
        ), dismissible: false, isFlip: true);

      Provider.of<OrderProvider>(context, listen: false).stopLoader();
    }else {
      showCustomSnackBar(message, context, isToaster: true);
    }
  }
}

class PaymentButton extends StatelessWidget {
  final String image;
  final Function? onTap;
  const PaymentButton({Key? key, required this.image, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        height: 45,
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: ColorResources.getGrey(context)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(image),
      ),
    );
  }
}


class PaymentMethod{
  String name;
  String image;
  PaymentMethod(this.name, this.image);

}