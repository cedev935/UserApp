import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/chat_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/not_loggedin_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/chat_header.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/chat_item_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/inbox_shimmer.dart';
import 'package:provider/provider.dart';


class InboxScreen extends StatefulWidget {
  final bool isBackButtonExist;
  const InboxScreen({Key? key, this.isBackButtonExist = true}) : super(key: key);

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {


  late bool isGuestMode;
  @override
  void initState() {
    bool isFirstTime = true;
    isGuestMode = !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(isFirstTime) {
      if(!isGuestMode) {
        Provider.of<ChatProvider>(context, listen: false).getChatList(context, 1);
      }
      isFirstTime = false;
    }
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Column(children: [
        CustomAppBar(title: getTranslated('inbox', context), isBackButtonExist: false),

        if(!isGuestMode)
        Container(
            height: 100,decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(Dimensions.paddingSizeOverLarge),
                bottomRight: Radius.circular(Dimensions.paddingSizeOverLarge))),
            padding: const EdgeInsets.symmetric(vertical:Dimensions.paddingSizeExtraSmall),
            child:  const Column(
              children:  [
                ChatHeader(),
              ],
            )),


        Expanded(
            child: isGuestMode ? const NotLoggedInWidget() :  RefreshIndicator(
              backgroundColor: Theme.of(context).primaryColor,
              onRefresh: () async {
                await Provider.of<ChatProvider>(context, listen: false).getChatList(context, 1);
              },
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  return !chatProvider.isLoading? chatProvider.chatList!.isNotEmpty ?
                  ListView.builder(
                    itemCount: chatProvider.chatList!.length,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return ChatItemWidget(chat: chatProvider.chatList![index]);
                    },
                  ) : const NoInternetOrDataScreen(isNoInternet: false): const InboxShimmer();
                },
              ),
            ),
          ),
      ]),
    );
  }
}



