import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/shipping_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/guest_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/widget/cart_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/checkout_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/widget/shipping_method_bottom_sheet.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final bool fromCheckout;
  final int sellerId;
  const CartScreen({Key? key, this.fromCheckout = false, this.sellerId = 1}) : super(key: key);

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  Future<void> _loadData()async{
    if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
     await Provider.of<CartProvider>(context, listen: false).getCartDataAPI(context);
     if(context.mounted){}
      Provider.of<CartProvider>(Get.context!, listen: false).setCartData();

      if( Provider.of<SplashProvider>(Get.context!,listen: false).configModel!.shippingMethod != 'sellerwise_shipping'){
        Provider.of<CartProvider>(Get.context!, listen: false).getAdminShippingMethodList(Get.context!);
      }

    }
  }
  List<bool> chooseShipping = [];

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cart, child) {
      double amount = 0.0;
      double shippingAmount = 0.0;
      double discount = 0.0;
      double tax = 0.0;
      bool onlyDigital= true;
      List<bool> sellerWiseOnlyDigital = [];
      List<CartModel> cartList = [];
      cartList.addAll(cart.cartList);

      for(CartModel cart in cartList) {
        if(cart.productType == "physical"){
          onlyDigital = false;
          if (kDebugMode) {
            print('is digital product only?====>$onlyDigital');
          }
        }
      }

      List<String?> orderTypeShipping = [];
      List<String?> sellerList = [];
      List<List<String>> productType = [];
      List<CartModel> sellerGroupList = [];
      List<List<CartModel>> cartProductList = [];
      List<List<int>> cartProductIndexList = [];
      for(CartModel cart in cartList) {
        if(!sellerList.contains(cart.cartGroupId)) {
          sellerList.add(cart.cartGroupId);
          sellerGroupList.add(cart);
        }
      }



      for(String? seller in sellerList) {
        List<CartModel> cartLists = [];
        List<int> indexList = [];
        List<String> productTypeList = [];
        for(CartModel cart in cartList) {
          if(seller == cart.cartGroupId) {
            cartLists.add(cart);
            indexList.add(cartList.indexOf(cart));
            productTypeList.add(cart.productType!);
          }
        }
        cartProductList.add(cartLists);
        productType.add(productTypeList);
        cartProductIndexList.add(indexList);
      }

      for (var seller in sellerGroupList) {
        if(seller.shippingType == 'order_wise'){
          orderTypeShipping.add(seller.shippingType);
        }
      }


      if(cart.getData && Provider.of<AuthProvider>(context, listen: false).isLoggedIn() && Provider.of<SplashProvider>(context,listen: false).configModel!.shippingMethod =='sellerwise_shipping') {
        Provider.of<CartProvider>(context, listen: false).getShippingMethod(context, cartProductList);
      }

      for(int i=0;i<cart.cartList.length;i++){
        amount += (cart.cartList[i].price! - cart.cartList[i].discount!) * cart.cartList[i].quantity!;
        discount += cart.cartList[i].discount! * cart.cartList[i].quantity!;
        if (kDebugMode) {
          print('====TaxModel == ${cart.cartList[i].taxModel}');
        }
        if(cart.cartList[i].taxModel == "exclude"){
          tax += cart.cartList[i].tax! * cart.cartList[i].quantity!;
        }

      }
      for(int i=0;i<cart.chosenShippingList.length;i++){
        shippingAmount += cart.chosenShippingList[i].shippingCost!;
      }
      for(int j = 0; j< cartList.length; j++){
        shippingAmount += cart.cartList[j].shippingCost??0;

      }


      return Scaffold(
        bottomNavigationBar: (!widget.fromCheckout && !cart.isLoading)
            ? Container(height: 80, padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge,
            vertical: Dimensions.paddingSizeDefault),

          decoration: BoxDecoration(color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
          ),
          child: cartList.isNotEmpty ?
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Center(
                        child: Row(
                          children: [
                            Text('${getTranslated('total_price', context)}', style: titilliumSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeDefault),
                            ),
                            Text(PriceConverter.convertPrice(context, amount+shippingAmount), style: titilliumSemiBold.copyWith(
                                color: Theme.of(context).primaryColor,fontSize: Dimensions.fontSizeLarge),
                            ),
                          ],
                        ))),
                Builder(
                  builder: (context) => InkWell(
                    onTap: () {
                      for(ShippingModel shipping in Provider.of<CartProvider>(context, listen: false).shippingList!) {
                        print('------:${shipping.shippingIndex}/${shipping.groupId}/${shipping.shippingMethodList}');
                      }
                      if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                        bool hasNull = false;
                        for(int index = 0; index < cartProductList.length; index++) {
                          for(CartModel cart in cartProductList[index]) {
                            if(cart.productType == 'physical' && Provider.of<CartProvider>(context, listen: false).shippingList![index].shippingIndex == -1) {
                              hasNull = true;
                              break;
                            }
                          }
                        }
                        if (cart.cartList.isEmpty) {
                          showCustomSnackBar(getTranslated('select_at_least_one_product', context), context);
                        }
                        else if(hasNull &&
                            Provider.of<SplashProvider>(context,listen: false).configModel!.shippingMethod =='sellerwise_shipping' &&
                            !onlyDigital){

                          showCustomSnackBar(getTranslated('select_all_shipping_method', context), context);
                        }

                        else if(cart.chosenShippingList.isEmpty &&
                            Provider.of<SplashProvider>(context,listen: false).configModel!.shippingMethod !='sellerwise_shipping' &&
                            Provider.of<SplashProvider>(context,listen: false).configModel!.inHouseSelectedShippingType =='order_wise' && !onlyDigital){
                          showCustomSnackBar(getTranslated('select_all_shipping_method', context), context);
                        }



                        else {

                          Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutScreen(
                            cartList: cartList,totalOrderAmount: amount,shippingFee: shippingAmount, discount: discount,
                            tax: tax, onlyDigital: onlyDigital,
                          )));

                        }
                      } else {showAnimatedDialog(context, const GuestDialog(), isFlip: true);}
                    },

                    child: Container(width: MediaQuery.of(context).size.width/3.5,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,
                              vertical: Dimensions.fontSizeSmall),
                          child: Text(getTranslated('checkout', context)!,
                              style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault,
                                color: Theme.of(context).cardColor,
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ]):const SizedBox(),
        )
            : null,
        body: Column(
            children: [
              CustomAppBar(title: getTranslated('CART', context)),

              cart.isXyz ? Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: Center(child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                ),
              ) :sellerList.isNotEmpty ? Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                            await Provider.of<CartProvider>(context, listen: false).getCartDataAPI(context);
                          }
                        },
                        child: ListView.builder(
                          itemCount: sellerList.length,
                          padding: const EdgeInsets.all(0),
                          itemBuilder: (context, index) {
                            bool hasPhysical = false;
                            for(CartModel cart in cartProductList[index]) {
                              if(cart.productType == 'physical') {
                                hasPhysical = true;
                                break;
                              }
                            }


                            return Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                sellerGroupList[index].shopInfo!.isNotEmpty ?
                                Padding(padding: const EdgeInsets.all(8.0),
                                    child: Text(sellerGroupList[index].shopInfo!,
                                          textAlign: TextAlign.end, style: titilliumSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge))) : const SizedBox(),


                                Card(child: Container(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
                                  decoration: BoxDecoration(color: Theme.of(context).highlightColor),
                                  child: Column(children: [
                                    ListView.builder(physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(0),
                                      itemCount: cartProductList[index].length,
                                      itemBuilder: (context, i) {

                                      return CartWidget(cartModel: cartProductList[index][i],
                                        index: cartProductIndexList[index][i],
                                        fromCheckout: widget.fromCheckout,
                                      );
                                      },
                                    ),


                                    Provider.of<SplashProvider>(context,listen: false).configModel!.shippingMethod =='sellerwise_shipping' &&
                                        sellerGroupList[index].shippingType == 'order_wise' && hasPhysical ?
                                    Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                                      child: InkWell(onTap: () {
                                        if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                                          showModalBottomSheet(
                                            context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                                            builder: (context) => ShippingMethodBottomSheet(groupId: sellerGroupList[index].cartGroupId,sellerIndex: index, sellerId: sellerGroupList[index].id),
                                          );
                                        }else {
                                          showCustomSnackBar('not_logged_in', context);
                                        }
                                        },


                                        child: Container(decoration: BoxDecoration(
                                            border: Border.all(width: 0.5,color: Colors.grey),
                                            borderRadius: const BorderRadius.all(Radius.circular(10))),
                                          child: Padding(padding: const EdgeInsets.all(8.0),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                              Text(getTranslated('SHIPPING_PARTNER', context)!, style: titilliumRegular),
                                              Flexible(child: Text((cart.shippingList == null || cart.shippingList![index].shippingMethodList == null || cart.chosenShippingList.isEmpty || cart.shippingList![index].shippingIndex == -1) ? ''
                                                  : cart.shippingList![index].shippingMethodList![cart.shippingList![index].shippingIndex!].title.toString(),
                                                style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context)),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,textAlign: TextAlign.end)),

                                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                              Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
                                            ]),
                                          ),
                                        ),
                                      ),
                                    ) :const SizedBox(),
                                  ],
                                  ),
                                ),
                                ),
                              ]),
                            );
                          },
                        ),
                      ),
                    ),
                    Provider.of<SplashProvider>(context,listen: false).configModel!.shippingMethod !='sellerwise_shipping' && Provider.of<SplashProvider>(context,listen: false).configModel!.inHouseSelectedShippingType =='order_wise'?
                    InkWell(
                      onTap: () {
                        if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                          showModalBottomSheet(
                            context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
                            builder: (context) => const ShippingMethodBottomSheet(groupId: 'all_cart_group',sellerIndex: 0, sellerId: 1),
                          );
                        }else {
                          showCustomSnackBar('not_logged_in', context);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5,color: Colors.grey),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(getTranslated('SHIPPING_PARTNER', context)!, style: titilliumRegular),
                            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                              Text(
                                (cart.shippingList == null ||cart.chosenShippingList.isEmpty || cart.shippingList!.isEmpty || cart.shippingList![0].shippingMethodList == null ||  cart.shippingList![0].shippingIndex == -1) ? ''
                                    : cart.shippingList![0].shippingMethodList![cart.shippingList![0].shippingIndex!].title.toString(),
                                style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                              Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
                            ]),
                          ]),
                        ),
                      ),
                    ):const SizedBox(),


                  ],
                ),
              ) : const Expanded(child: NoInternetOrDataScreen(isNoInternet: false)),
            ]),
      );
    });
  }
}
