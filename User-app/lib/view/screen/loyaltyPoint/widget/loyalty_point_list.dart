import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/loyalty_point_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wallet_transaction_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/loyaltyPoint/widget/loyalty_point_widget.dart';
import 'package:provider/provider.dart';

class LoyaltyPointListView extends StatelessWidget {
  final ScrollController? scrollController;
  const LoyaltyPointListView({Key? key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController!.position.maxScrollExtent == scrollController!.position.pixels
          && Provider.of<WalletTransactionProvider>(context, listen: false).loyaltyPointList.isNotEmpty
          && !Provider.of<WalletTransactionProvider>(context, listen: false).isLoading) {
        int? pageSize;
        pageSize = Provider.of<WalletTransactionProvider>(context, listen: false).loyaltyPointPageSize;

        if(offset < pageSize!) {
          offset++;
          if (kDebugMode) {
            print('end of the page');
          }
          Provider.of<WalletTransactionProvider>(context, listen: false).showBottomLoader();
          Provider.of<WalletTransactionProvider>(context, listen: false).getLoyaltyPointList(context, offset);
        }
      }

    });

    return Consumer<WalletTransactionProvider>(
      builder: (context, loyaltyProvider, child) {
        List<LoyaltyPointList> loyaltyPointList;
        loyaltyPointList = loyaltyProvider.loyaltyPointList;

        return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

          const SizedBox(height: Dimensions.paddingSizeDefault,),
          Padding(
            padding: const EdgeInsets.only(left: Dimensions.homePagePadding,right: Dimensions.homePagePadding),
            child: Text('${getTranslated('transaction_history', context)}',
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
          ),
          !loyaltyProvider.firstLoading ? (loyaltyPointList.isNotEmpty) ?
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: loyaltyPointList.length,
              itemBuilder: (ctx,index){
                return SizedBox(width: (MediaQuery.of(context).size.width/2)-20,
                    child: LoyaltyPointWidget(loyaltyPointModel: loyaltyPointList[index]));

              }): const SizedBox.shrink() : ProductShimmer(isHomePage: true ,isEnabled: loyaltyProvider.firstLoading),
          loyaltyProvider.isLoading ? Center(child: Padding(
            padding: const EdgeInsets.all(Dimensions.iconSizeExtraSmall),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : const SizedBox.shrink(),

        ]);
      },
    );
  }
}
