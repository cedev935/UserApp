import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/widget/order_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/widget/order_type_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/widget/order_widget.dart';
import 'package:provider/provider.dart';


class OrderScreen extends StatefulWidget {
  final bool isBacButtonExist;
  const OrderScreen({Key? key, this.isBacButtonExist = true}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late bool isGuestMode = !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
  @override
  void initState() {
    if(!isGuestMode){
      Provider.of<OrderProvider>(context, listen: false).initOrderList(context);

    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Column(
        children: [
          CustomAppBar(title: getTranslated('ORDER', context), isBackButtonExist: widget.isBacButtonExist),
          isGuestMode ? const SizedBox() :
          Provider.of<OrderProvider>(context).pendingList != null ?
          Consumer<OrderProvider>(
            builder: (context, orderProvider, child) => Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Row(children: [
                OrderTypeButton(text: getTranslated('RUNNING', context), index: 0, orderList: orderProvider.pendingList),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                OrderTypeButton(text: getTranslated('DELIVERED', context), index: 1, orderList: orderProvider.deliveredList),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                OrderTypeButton(text: getTranslated('CANCELED', context), index: 2, orderList: orderProvider.canceledList),
              ],),),) : const SizedBox(),


          isGuestMode ? const Expanded(child: NotLoggedInWidget()) :
          Provider.of<OrderProvider>(context).pendingList != null ?
          Consumer<OrderProvider>(
            builder: (context, order, child) {
              List<OrderModel>? orderList = [];
              if (Provider.of<OrderProvider>(context, listen: false).orderTypeIndex == 0) {
                orderList = order.pendingList;
              }

              else if (Provider.of<OrderProvider>(context, listen: false).orderTypeIndex == 1) {
                orderList = order.deliveredList;
              }

              else if (Provider.of<OrderProvider>(context, listen: false).orderTypeIndex == 2) {
                orderList = order.canceledList;
              }
              return Expanded(
                child: RefreshIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                  onRefresh: () async {
                    await Provider.of<OrderProvider>(context, listen: false).initOrderList(context);
                    },
                  child: ListView.builder(
                    itemCount: orderList!.length,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) => OrderWidget(orderModel: orderList![index]),
                  ),),);},)
              : const Expanded(child: OrderShimmer()),
        ],
      ),
    );
  }
}




