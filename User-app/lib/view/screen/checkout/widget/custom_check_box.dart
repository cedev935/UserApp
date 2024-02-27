import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:provider/provider.dart';

class CustomCheckBox extends StatelessWidget {
  final int index;
  final bool isDigital;
  final String? icon;
  const CustomCheckBox({Key? key,  required this.index, this.isDigital =  false, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) {
        return InkWell(
          onTap: () => order.setPaymentMethod(index),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: order.paymentMethodIndex == index? Theme.of(context).primaryColor.withOpacity(.5) : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeExtraSmall),
                boxShadow: [BoxShadow(color: order.paymentMethodIndex == index?
                Theme.of(context).hintColor.withOpacity(.2):Theme.of(context).hintColor.withOpacity(.1), spreadRadius: 1, blurRadius: 1, offset: const Offset(0,1))]
              ),
              child: Row(children: [
                Checkbox(
                  shape: const CircleBorder(),
                  value: order.paymentMethodIndex == index,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (bool? isChecked) => order.setPaymentMethod(index),
                ),
                SizedBox(width: 100,child: Image.asset(icon!))

              ]),
            ),
          ),
        );
      },
    );
  }
}
