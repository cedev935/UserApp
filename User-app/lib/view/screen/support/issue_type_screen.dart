
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_expanded_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/support/add_ticket_screen.dart';

class IssueTypeScreen extends StatelessWidget {
  const IssueTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> issueTypeList = ['Website Problem', 'Partner request', 'Complaint', 'Info inquiry'];


    return CustomExpandedAppBar(
      title: getTranslated('support_ticket', context),
      isGuestCheck: true,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      Padding(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge, left: Dimensions.paddingSizeLarge),
        child: Text(getTranslated('add_new_ticket', context)!, style: titilliumSemiBold.copyWith(fontSize: 20)),
      ),

      Padding(
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeLarge),
        child: Text(getTranslated('select_your_category', context)!, style: titilliumRegular),
      ),

      Expanded(child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeExtraSmall),
        itemCount: issueTypeList.length,
        itemBuilder: (context, index) {
          return Container(
            color: ColorResources.getLowGreen(context),
            margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
            child: ListTile(
              leading: Icon(Icons.query_builder, color: ColorResources.getPrimary(context)),
              title: Text(issueTypeList[index], style: robotoBold),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AddTicketScreen(type: issueTypeList[index])));
              },
            ),
          );
        },
      )),
    ]),
    );
  }
}
