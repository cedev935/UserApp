import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/address_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/error_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/response_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/user_info_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/profile_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'order_provider.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileRepo? profileRepo;
  ProfileProvider({required this.profileRepo});

  final List<String> _addressTypeList = [];
  String? _addressType = '';
  UserInfoModel? _userInfoModel;
  bool _isLoading = false;
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;
  List<AddressModel> _addressList =[];
  List<AddressModel> _billingAddressList = [];
  List<AddressModel> _shippingAddressList = [];
  bool? _hasData;
  bool _isHomeAddress = true;
  String? _addAddressErrorText;
  double? _balance;
  double? get balance =>_balance;

  List<String> get addressTypeList => _addressTypeList;
  String? get addressType => _addressType;
  UserInfoModel? get userInfoModel => _userInfoModel;
  bool get isLoading => _isLoading;
  List<AddressModel> get addressList => _addressList;
  List<AddressModel> get billingAddressList => _billingAddressList;
  List<AddressModel> get shippingAddressList => _shippingAddressList;
  bool? get hasData => _hasData;
  bool get isHomeAddress => _isHomeAddress;
  String? get addAddressErrorText => _addAddressErrorText;

  void setAddAddressErrorText(String errorText) {
    _addAddressErrorText = errorText;
    // notifyListeners();
  }

  void updateAddressCondition(bool value) {
    _isHomeAddress = value;
    notifyListeners();
  }

  bool _checkHomeAddress=false;
  bool get checkHomeAddress=>_checkHomeAddress;

  bool _checkOfficeAddress=false;
  bool get checkOfficeAddress=>_checkOfficeAddress;

  void setHomeAddress() {
    _checkHomeAddress = true;
    _checkOfficeAddress = false;
    notifyListeners();
  }

  void setOfficeAddress() {
    _checkHomeAddress = false;
    _checkOfficeAddress = true;
    notifyListeners();
  }


  updateCountryCode(String value) {
    _addressType = value;
    notifyListeners();
  }

  Future<void> initAddressList() async {
    ApiResponse apiResponse = await profileRepo!.getAllAddress();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _addressList = [];
      _billingAddressList =[];
      _shippingAddressList =[];
      apiResponse.response!.data.forEach((address) {
        AddressModel addressModel = AddressModel.fromJson(address);
        if(addressModel.isBilling == 1){
          _billingAddressList.add(addressModel);
        }else if(addressModel.isBilling == 0){
          _addressList.add(addressModel);
        }
          _shippingAddressList.add(addressModel);


      });
     // apiResponse.response.data.forEach((address) => _addressList.add(AddressModel.fromJson(address)));
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void removeAddressById(int? id, int index, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await profileRepo!.removeAddressByID(id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _addressList.removeAt(index);
      Map map = apiResponse.response!.data;
      String message = map["message"];
      initAddressList();
      Provider.of<OrderProvider>(Get.context!, listen: false).shippingAddressNull();
      Provider.of<OrderProvider>(Get.context!, listen: false).billingAddressNull();
      showCustomSnackBar(message, Get.context!, isError: false);
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  Future<String> getUserInfo(BuildContext context) async {
    String userID = '-1';
    ApiResponse apiResponse = await profileRepo!.getUserInfo();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _userInfoModel = UserInfoModel.fromJson(apiResponse.response!.data);
      userID = _userInfoModel!.id.toString();
      _balance = _userInfoModel!.walletBalance;
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return userID;
  }


  Future<ApiResponse> deleteCustomerAccount(BuildContext context, int? customerId) async {
    _isDeleting = true;
    notifyListeners();
    ApiResponse apiResponse = await profileRepo!.deleteUserAccount(customerId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      Map map = apiResponse.response!.data;
      String message = map ['message'];
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Theme.of(Get.context!).primaryColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }



  void initAddressTypeList(BuildContext context) async {
    if (_addressTypeList.isEmpty) {
      ApiResponse apiResponse = await profileRepo!.getAddressTypeList();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _addressTypeList.clear();
        _addressTypeList.addAll(apiResponse.response!.data);
        _addressType = apiResponse.response!.data[0];
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }
  }

  Future addAddress(AddressModel addressModel, Function callback) async {
    _isLoading = true;
    notifyListeners();

    ApiResponse apiResponse = await profileRepo!.addAddress(addressModel);
    _isLoading = false;

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      _addressList.add(addressModel);
      String? message = map["message"];
      callback(true, message);
    } else {
      String? errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        if (kDebugMode) {
          print(apiResponse.error.toString());
        }
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        if (kDebugMode) {
          print(errorResponse.errors![0].message);
        }
        errorMessage = errorResponse.errors![0].message;
      }
      callback(false, errorMessage);
    }
    notifyListeners();
  }

  Future<ResponseModel> updateUserInfo(UserInfoModel updateUserModel, String pass, File? file, String token) async {
    _isLoading = true;
    notifyListeners();

    ResponseModel responseModel;
    http.StreamedResponse response = await profileRepo!.updateProfile(updateUserModel, pass, file, token);
    _isLoading = false;
    if (response.statusCode == 200) {
      Map map = jsonDecode(await response.stream.bytesToString());
      String? message = map["message"];
      _userInfoModel = updateUserModel;
      responseModel = ResponseModel(message, true);
      if (kDebugMode) {
        print(message);
      }
    } else {
      if (kDebugMode) {
        print('${response.statusCode} ${response.reasonPhrase}');
      }
      responseModel = ResponseModel('${response.statusCode} ${response.reasonPhrase}', false);
    }
    notifyListeners();
    return responseModel;
  }

  // save office and home address
  void saveHomeAddress(String homeAddress) {
    profileRepo!.saveHomeAddress(homeAddress).then((_) {
      notifyListeners();
    });
  }

  void saveOfficeAddress(String officeAddress) {
    profileRepo!.saveOfficeAddress(officeAddress).then((_) {
      notifyListeners();
    });
  }

  // for home Address Section
  String getHomeAddress() {
    return profileRepo!.getHomeAddress();
  }

  Future<bool> clearHomeAddress() async {
    return await profileRepo!.clearHomeAddress();
  }

  // for office Address Section
  String getOfficeAddress() {
    return profileRepo!.getOfficeAddress();
  }

  Future<bool> clearOfficeAddress() async {
    return await profileRepo!.clearOfficeAddress();
  }
}
