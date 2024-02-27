import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/support_ticket_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/support_ticket_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_expanded_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/support/support_conversation_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'issue_type_screen.dart';

// ignore: must_be_immutable
class SupportTicketScreen extends StatelessWidget {
  bool first = true;

  SupportTicketScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if(first) {
      first = false;
      if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
        Provider.of<SupportTicketProvider>(context, listen: false).getSupportTicketList();
      }
    }

    return CustomExpandedAppBar(
      title: getTranslated('support_ticket', context),
      isGuestCheck: true,

      bottomChild: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const IssueTypeScreen())),
        child: Material(color: ColorResources.getColombiaBlue(context),
          elevation: 5,
          borderRadius: BorderRadius.circular(50),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Container(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              decoration: BoxDecoration(color: ColorResources.getFloatingBtn(context),
                shape: BoxShape.circle,),
              child: const Icon(Icons.add, color: Colors.white, size: 35),),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Text(getTranslated('new_ticket', context)!,
                  style: titilliumSemiBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge)),),
          ]),
        ),
      ),

      child: Provider.of<SupportTicketProvider>(context).supportTicketList != null
          ? Provider.of<SupportTicketProvider>(context).supportTicketList!.isNotEmpty
          ? Consumer<SupportTicketProvider>(
          builder: (context, support, child) {
            List<SupportTicketModel> supportTicketList = support.supportTicketList!.reversed.toList();
            return RefreshIndicator(
              backgroundColor: Theme.of(context).primaryColor,
              onRefresh: () async {
                await support.getSupportTicketList();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                itemCount: supportTicketList.length,
                itemBuilder: (context, index) {

                  return InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SupportConversationScreen(
                        supportTicketModel: supportTicketList[index],))),
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: ColorResources.getImageBg(context),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: ColorResources.getSellerTxt(context), width: 2),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Place date: ${DateConverter.localDateToIsoStringAMPM(DateTime.parse(supportTicketList[index].createdAt!))}',
                          style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                        ),
                        Text(supportTicketList[index].subject!, style: titilliumSemiBold),


                        Row(children: [
                          Icon(Icons.notifications, color: ColorResources.getPrimary(context), size: 20),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Expanded(child: Text(supportTicketList[index].type!, style: titilliumSemiBold)),
                          TextButton(onPressed: null,
                            style: TextButton.styleFrom(
                              backgroundColor: supportTicketList[index].status == 'open' ?
                              ColorResources.getGreen(context) : Theme.of(context).primaryColor,),

                            child: Text(
                              supportTicketList[index].status == 'pending' ?
                              getTranslated('pending', context)! : getTranslated('solved', context)!,
                              style: titilliumSemiBold.copyWith(color: Colors.white),
                            ),
                          ),
                        ]),
                      ]),
                    ),
                  );

                },
              ),
            );
          },
        ) : const NoInternetOrDataScreen(isNoInternet: false) : const SupportTicketShimmer(),
      );
  }
}

class SupportTicketShimmer extends StatelessWidget {
  const SupportTicketShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      itemCount: 10,
      itemBuilder: (context, index) {

        return Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
          decoration: BoxDecoration(
            color: ColorResources.imageBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorResources.sellerText, width: 2),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            enabled: Provider.of<SupportTicketProvider>(context).supportTicketList == null,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(height: 10, width: 100, color: ColorResources.white),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Container(height: 15, color: ColorResources.white),
              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
              Row(children: [
                Container(height: 15, width: 15, color: ColorResources.white),
                const SizedBox(width: Dimensions.paddingSizeSmall),
                Container(height: 15, width: 50, color: ColorResources.white),
                const Expanded(child: SizedBox.shrink()),
                Container(height: 30, width: 70, color: ColorResources.white),
              ]),
            ]),
          ),
        );

      },
    );
  }
}

