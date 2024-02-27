import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/message_body.dart';
import 'package:flutter_sixvalley_ecommerce/provider/chat_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/paginated_list_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/widget/message_bubble.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final int? id;
  final String? name;
  const ChatScreen({Key? key,  this.id, required this.name}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    Provider.of<ChatProvider>(context, listen: false).getMessageList( context, widget.id, 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return RefreshIndicator(
      onRefresh: ()async{
        Provider.of<ChatProvider>(context, listen: false).getChatList(context,1);
      },
      child: Scaffold(
        backgroundColor: ColorResources.getIconBg(context),
        body: Consumer<ChatProvider>(
            builder: (context, chatProvider,child) {
            return Column(children: [
              CustomAppBar(title: widget.name),

              chatProvider.messageModel != null? (chatProvider.messageModel!.message != null && chatProvider.messageModel!.message!.isNotEmpty)?
              Expanded(
                child:  SingleChildScrollView(controller: scrollController,
                    child: Padding(padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      child: PaginatedListView(
                        reverse: true,
                        scrollController: scrollController,
                        onPaginate: (int? offset) => chatProvider.getChatList(context,offset!, reload: false),
                        totalSize: chatProvider.messageModel!.totalSize,
                        offset: int.parse(chatProvider.messageModel!.offset!),
                        enabledPagination: chatProvider.messageModel == null,
                        itemView: ListView.builder(
                          itemCount: chatProvider.messageModel!.message!.length,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return  MessageBubble(message: chatProvider.messageModel!.message![index]);
                          },
                        ),
                      ),
                    )),
              ) : const Expanded(child: NoInternetOrDataScreen(isNoInternet: false)): const Expanded(child: Center(child: CircularProgressIndicator())),


              // Bottom TextField
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(
                    height: 70,
                    child: Card(
                      color: Theme.of(context).highlightColor,
                      shadowColor: Colors.grey[200],
                      elevation: 2,
                      margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        child: Row(children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              style: titilliumRegular,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              expands: true,
                              decoration: InputDecoration(
                                hintText: 'Type here...',
                                hintStyle: titilliumRegular.copyWith(color: ColorResources.hintTextColor),
                                border: InputBorder.none,
                              ),
                              onChanged: (String newText) {
                                if(newText.isNotEmpty && !Provider.of<ChatProvider>(context, listen: false).isSendButtonActive) {
                                  Provider.of<ChatProvider>(context, listen: false).toggleSendButtonActivity();
                                }else if(newText.isEmpty && Provider.of<ChatProvider>(context, listen: false).isSendButtonActive) {
                                  Provider.of<ChatProvider>(context, listen: false).toggleSendButtonActivity();
                                }
                              },
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              if(Provider.of<ChatProvider>(context, listen: false).isSendButtonActive){
                                MessageBody messageBody = MessageBody(id : widget.id,  message: _controller.text);
                                Provider.of<ChatProvider>(context, listen: false).sendMessage(messageBody, context).then((value){
                                  _controller.text = '';
                                  scrollController.jumpTo(scrollController.position.maxScrollExtent);

                                });

                              }
                            },
                            child: Icon(
                              Icons.send,
                              color: Provider.of<ChatProvider>(context).isSendButtonActive ? Theme.of(context).primaryColor : ColorResources.hintTextColor,
                              size: Dimensions.iconSizeDefault,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),

                ],
              ),
            ]);
          }
        ),
      ),
    );
  }
}



