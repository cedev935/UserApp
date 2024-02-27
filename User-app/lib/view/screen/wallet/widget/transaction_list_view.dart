import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/transaction_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wallet_transaction_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/wallet/widget/transaction_widget.dart';
import 'package:provider/provider.dart';

class TransactionListView extends StatelessWidget {
  final ScrollController? scrollController;
  const TransactionListView({Key? key,  this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if(scrollController!.position.maxScrollExtent == scrollController!.position.pixels
          && Provider.of<WalletTransactionProvider>(context, listen: false).transactionList.isNotEmpty
          && !Provider.of<WalletTransactionProvider>(context, listen: false).isLoading) {
        int? pageSize;
        pageSize = Provider.of<WalletTransactionProvider>(context, listen: false).transactionPageSize;

        if(offset < pageSize!) {
          offset++;
          if (kDebugMode) {
            print('end of the page');
          }
          Provider.of<WalletTransactionProvider>(context, listen: false).showBottomLoader();
          Provider.of<WalletTransactionProvider>(context, listen: false).getTransactionList(context, offset, reload: false);
        }
      }

    });

    return Consumer<WalletTransactionProvider>(
      builder: (context, transactionProvider, child) {
        List<WalletTransactioList> transactionList;
        transactionList = transactionProvider.transactionList;

        return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [

          const SizedBox(height: Dimensions.paddingSizeLarge,),
          Padding(
            padding: const EdgeInsets.only(left: Dimensions.homePagePadding,right: Dimensions.homePagePadding),
            child: Text('${getTranslated('transaction_history', context)}',
              style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),),
          ),
          !transactionProvider.firstLoading ? (transactionList.isNotEmpty) ?
          ListView.builder(
            shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: transactionList.length,
              itemBuilder: (ctx,index){
                return SizedBox(width: (MediaQuery.of(context).size.width/2)-20,
                    child: TransactionWidget(transactionModel: transactionList[index]));

              }): const SizedBox.shrink() : ProductShimmer(isHomePage: true ,isEnabled: transactionProvider.firstLoading),
          transactionProvider.isLoading ? Center(child: Padding(
            padding: const EdgeInsets.all(Dimensions.iconSizeExtraSmall),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : const SizedBox.shrink(),

        ]);
      },
    );
  }
}

