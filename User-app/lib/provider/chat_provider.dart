import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/message_body.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/chat_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/message_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/chat_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';


class ChatProvider extends ChangeNotifier {
  final ChatRepo? chatRepo;
  ChatProvider({required this.chatRepo});


  bool _isSendButtonActive = false;
  bool get isSendButtonActive => _isSendButtonActive;
  List<Chat>? _chatList;
  List<Chat>? get chatList => _chatList;
  bool _isSearching = false;
  bool get isSearching => _isSearching;
  File? _imageFile;
  File? get imageFile => _imageFile;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _userTypeIndex = 0;
  int get userTypeIndex =>  _userTypeIndex;
  ChatModel? chatModel;




  Future<void> getChatList(BuildContext context, int offset, {bool reload = true}) async {
    if(reload){
      _chatList = [];
    }
    _isLoading = true;
    ApiResponse apiResponse = await chatRepo!.getChatList(_userTypeIndex == 0? 'seller' : 'delivery-man', offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _chatList = ChatModel.fromJson(apiResponse.response!.data).chat;
    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchChat(BuildContext context, String search) async {
    _isLoading = true;
    _chatList = [];
    ApiResponse apiResponse = await chatRepo!.searchChat(_userTypeIndex == 0? 'seller' : 'delivery-man', search);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      chatModel = ChatModel(totalSize: 1, limit: '1', offset: '1', chat: []);
      apiResponse.response!.data.forEach((chat) {
        chatModel!.chat!.add(Chat.fromJson(chat));
      });
      _chatList = chatModel!.chat;

    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }


  MessageModel? messageModel;
  Future<void> getMessageList(BuildContext context, int? id, int offset, {bool reload = true}) async {
    if(reload){
      messageModel = null;
    }
    _isLoading = true;
    ApiResponse apiResponse = await chatRepo!.getMessageList(_userTypeIndex == 0? 'seller' : 'delivery-man', id, offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      if(offset == 1) {
        messageModel = null;
        messageModel = MessageModel.fromJson(apiResponse.response!.data);
      }else {
        messageModel!.totalSize = MessageModel.fromJson(apiResponse.response!.data).totalSize;
        messageModel!.offset = MessageModel.fromJson(apiResponse.response!.data).offset;
        messageModel!.message!.addAll(MessageModel.fromJson(apiResponse.response!.data).message!);
      }


    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    _isLoading = false;
    notifyListeners();
  }



  Future<ApiResponse> sendMessage(MessageBody messageBody, BuildContext context) async {
    _isSendButtonActive = true;
    ApiResponse apiResponse = await chatRepo!.sendMessage(messageBody, _userTypeIndex == 0? 'seller' : 'delivery-man');
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      getMessageList(Get.context!, messageBody.id, 1);

    } else {
      _isSendButtonActive = false;
      ApiChecker.checkApi( apiResponse);
    }
    _isSendButtonActive = false;
    notifyListeners();
    return apiResponse;
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  void setImage(File image) {
    _imageFile = image;
    _isSendButtonActive = true;
    notifyListeners();
  }

  void removeImage(String text) {
    _imageFile = null;
    text.isEmpty ? _isSendButtonActive = false : _isSendButtonActive = true;
    notifyListeners();
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    notifyListeners();
  }
  void setUserTypeIndex(BuildContext context, int index) {
    _userTypeIndex = index;
    getChatList(context, 1);
    notifyListeners();
  }

}
