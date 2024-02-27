import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/order_place_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/error_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/order_details.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/refund_info_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/refund_result_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/shipping_method_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/order_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class OrderProvider with ChangeNotifier {
  final OrderRepo? orderRepo;
  OrderProvider({required this.orderRepo});

  List<OrderModel>? _pendingList;
  List<OrderModel>? _deliveredList;
  List<OrderModel>? _canceledList;
  int? _addressIndex;
  int? _billingAddressIndex;
  int? get billingAddressIndex => _billingAddressIndex;
  int? _shippingIndex;
  bool _isLoading = false;
  bool _isRefund = false;
  bool get isRefund => _isRefund;
  List<ShippingMethodModel>? _shippingList;
  int _paymentMethodIndex = 0;
  bool _onlyDigital = true;
  bool get onlyDigital => _onlyDigital;

  List<OrderModel>? get pendingList => _pendingList != null ? _pendingList!.reversed.toList() : _pendingList;
  List<OrderModel>? get deliveredList => _deliveredList != null ? _deliveredList!.reversed.toList() : _deliveredList;
  List<OrderModel>? get canceledList => _canceledList != null ? _canceledList!.reversed.toList() : _canceledList;
  int? get addressIndex => _addressIndex;
  int? get shippingIndex => _shippingIndex;
  bool get isLoading => _isLoading;
  List<ShippingMethodModel>? get shippingList => _shippingList;
  int get paymentMethodIndex => _paymentMethodIndex;
  XFile? _imageFile;
  XFile? get imageFile => _imageFile;
  List <XFile?>_refundImage = [];
  List<XFile?> get refundImage => _refundImage;

  RefundInfoModel? _refundInfoModel;
  RefundInfoModel? get refundInfoModel => _refundInfoModel;
  RefundResultModel? _refundResultModel;
  RefundResultModel? get refundResultModel => _refundResultModel;




  Future<void> initOrderList(BuildContext context) async {
    ApiResponse apiResponse = await orderRepo!.getOrderList();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _pendingList = [];
      _deliveredList = [];
      _canceledList = [];
      apiResponse.response!.data.forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        if (orderModel.orderStatus == AppConstants.pending || orderModel.orderStatus == AppConstants.confirmed || orderModel.orderStatus ==AppConstants.outForDelivery
            || orderModel.orderStatus == AppConstants.processing || orderModel.orderStatus == AppConstants.processed) {
          _pendingList!.add(orderModel);
        } else if (orderModel.orderStatus == AppConstants.delivered) {
          _deliveredList!.add(orderModel);
        } else if (orderModel.orderStatus == AppConstants.cancelled || orderModel.orderStatus == AppConstants.failed
            || orderModel.orderStatus == AppConstants.returned) {
          _canceledList!.add(orderModel);
        }
      });
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  int _orderTypeIndex = 0;
  int get orderTypeIndex => _orderTypeIndex;

  void setIndex(int index) {
    _orderTypeIndex = index;
    notifyListeners();
  }

  List<OrderDetailsModel>? _orderDetails;
  List<OrderDetailsModel>? get orderDetails => _orderDetails;

  Future <void> getOrderDetails(String orderID, String? languageCode) async {
    _orderDetails = null;
    notifyListeners();
    ApiResponse apiResponse = await orderRepo!.getOrderDetails(orderID, languageCode);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _orderDetails = [];
      apiResponse.response!.data.forEach((order) => _orderDetails!.add(OrderDetailsModel.fromJson(order)));
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }


  OrderModel? _orderModel;
  OrderModel? get orderModel => _orderModel;

  Future <void> getOrderFromOrderId(String orderID) async {
    ApiResponse apiResponse = await orderRepo!.getOrderFromOrderId(orderID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _orderModel = OrderModel.fromJson(apiResponse.response!.data);
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  Future<void> placeOrder(OrderPlaceModel orderPlaceModel, Function callback,  String addressID, String couponCode,String couponAmount, String billingAddressId, String orderNote,String paymentBy, String transactionId, String paymentNote,{bool isfOffline = false, bool wallet = false}) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse;
     isfOffline?
     apiResponse = await orderRepo!.offlinePaymentPlaceOrder(addressID, couponCode,couponAmount, billingAddressId, orderNote,paymentBy,transactionId,paymentNote):
     wallet?
     apiResponse = await orderRepo!.walletPaymentPlaceOrder(addressID, couponCode,couponAmount, billingAddressId, orderNote):
     apiResponse = await orderRepo!.placeOrder(addressID, couponCode,couponAmount, billingAddressId, orderNote);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _addressIndex = null;
      _billingAddressIndex = null;

      String message = apiResponse.response!.data.toString();
      callback(true, message, '');
    } else {
      String? errorMessage;
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
      callback(false, errorMessage, '-1');
    }
    notifyListeners();
  }


  void stopLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setAddressIndex(int index) {
    _addressIndex = index;
    notifyListeners();
  }
  void setBillingAddressIndex(int index) {
    _billingAddressIndex = index;
    notifyListeners();
  }

  Future<void> initShippingList(BuildContext context, int sellerID) async {
    _paymentMethodIndex = 0;
    _shippingIndex = null;
    _addressIndex = null;
    ApiResponse apiResponse = await orderRepo!.getShippingMethod(sellerID);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _shippingList = [];
      apiResponse.response!.data.forEach((shippingMethod) => _shippingList!.add(ShippingMethodModel.fromJson(shippingMethod)));
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  void shippingAddressNull(){
    _addressIndex = null;
    notifyListeners();
  }

  void billingAddressNull(){
    _billingAddressIndex = null;
    notifyListeners();
  }

  void setSelectedShippingAddress(int index) {
    _shippingIndex = index;
    notifyListeners();
  }
  void setSelectedBillingAddress(int index) {
    _billingAddressIndex = index;
    notifyListeners();
  }

  OrderModel? _trackingModel;
  OrderModel? get trackingModel => _trackingModel;

  Future<void> initTrackingInfo(String orderID) async {
      ApiResponse apiResponse = await orderRepo!.getTrackingInfo(orderID);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _trackingModel = OrderModel.fromJson(apiResponse.response!.data);
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
  }


  void setPaymentMethod(int index) {
    _paymentMethodIndex = index;
    notifyListeners();
  }
  void pickImage(bool isRemove) async {
    if(isRemove) {
      _imageFile = null;
      _refundImage = [];
    }else {
      _imageFile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 20);
      if (_imageFile != null) {
        _refundImage.add(_imageFile);

      }
    }
    notifyListeners();
  }
  void removeImage(int index){
    refundImage.removeAt(index);
    notifyListeners();
  }

  Future<http.StreamedResponse> refundRequest(BuildContext context, int? orderDetailsId, double? amount, String refundReason, String token) async {
    _isLoading = true;
    notifyListeners();
    http.StreamedResponse response = await orderRepo!.refundRequest(orderDetailsId, amount, refundReason,refundImage, token);
    if (response.statusCode == 200) {
      getRefundReqInfo(orderDetailsId);
      _imageFile = null;
      _refundImage = [];
      _isLoading = false;

    } else {
      _isLoading = false;

    }
    _imageFile = null;
    _refundImage = [];
    _isLoading = false;
    notifyListeners();
    return response;
  }
  Future<ApiResponse> getRefundReqInfo(int? orderDetailId) async {
    _isRefund = true;
    ApiResponse apiResponse = await orderRepo!.getRefundInfo(orderDetailId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _refundInfoModel = RefundInfoModel.fromJson(apiResponse.response!.data);
      _isRefund = false;
    } else if(apiResponse.response!.statusCode == 202){
      _isRefund = false;
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        backgroundColor:Colors.red,
        content: Text('${apiResponse.response!.data['message']}'),
      ));
    }
    else {
      _isRefund = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> getRefundResult(BuildContext context, int? orderDetailId) async {
    _isLoading =true;

    ApiResponse apiResponse = await orderRepo!.getRefundResult(orderDetailId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoading = false;
      _refundResultModel = RefundResultModel.fromJson(apiResponse.response!.data);
    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }

  Future<ApiResponse> cancelOrder(BuildContext context, int? orderId) async {
    _isLoading = true;
    ApiResponse apiResponse = await orderRepo!.cancelOrder(orderId);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isLoading = false;

    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;
  }


  void downloadFile(String url, String dir) async {
    await FlutterDownloader.enqueue(
      url: url,
      savedDir: dir,
      showNotification: true,
      saveInPublicStorage: true,
      openFileFromNotification: true,
    );
  }

  void digitalOnly(bool value, {bool isUpdate = false}){
    _onlyDigital = value;
    if(isUpdate){
      notifyListeners();
    }

}

}
