

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/selected_shipping_type.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/error_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/chosen_shipping_method.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/response_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/shipping_method_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/shipping_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/cart_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

class CartProvider extends ChangeNotifier {
  final CartRepo? cartRepo;
  CartProvider({required this.cartRepo});

  List<CartModel> _cartList = [];
  List<ChosenShippingMethodModel> _chosenShippingList = [];
  List<ChosenShippingMethodModel> get chosenShippingList =>_chosenShippingList;
  List<ShippingModel>? _shippingList;
  List<ShippingModel>? get shippingList => _shippingList;
  List<bool> _isSelectedList = [];
  double _amount = 0.0;
  bool _isSelectAll = true;
  bool _isLoading = false;
  bool _isXyz = false;
  bool  get isXyz => _isXyz;
  CartModel? cart;
  String? _updateQuantityErrorText;
  String? get addOrderStatusErrorText => _updateQuantityErrorText;
  bool _getData = true;
  bool _addToCartLoading = false;
  bool get addToCartLoading => _addToCartLoading;

  List<CartModel> get cartList => _cartList;
  List<bool> get isSelectedList => _isSelectedList;
  double get amount => _amount;
  bool get isAllSelect => _isSelectAll;
  bool get isLoading => _isLoading;
  bool get getData => _getData;

  final List<int> _chosenShippingMethodIndex =[];
  List<int> get chosenShippingMethodIndex=>_chosenShippingMethodIndex;


  void getCartData() {
    _cartList = [];
    _isSelectedList = [];
    _isSelectAll = true;
    _cartList.addAll(cartRepo!.getCartList());
    for (var cart in _cartList) {
      _isSelectedList.add(true);
      _amount = _amount + (cart.discountedPrice! * cart.quantity!);
    }
  }

  void addToCart(CartModel cartModel) {
    _cartList.add(cartModel);
    _isSelectedList.add(true);
    cartRepo!.addToCartList(_cartList);
    _amount = _amount + (cartModel.discountedPrice! * cartModel.quantity!);
    notifyListeners();
  }

  void removeFromCart(int index) {
    if(_isSelectedList[index]) {
      _amount = _amount - (_cartList[index].discountedPrice! * _cartList[index].quantity!);
    }
    _cartList.removeAt(index);
    _isSelectedList.removeAt(index);
    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }

  bool isAddedInCart(int id, String variant) {
    for(CartModel cartModel in _cartList) {
      if(cartModel.id == id) {
        if(cartModel.variant == variant) {
          return true;
        }else {
          return false;
        }
      }
    }
    return false;
  }

  void removeCheckoutProduct(List<CartModel> carts) {
    for (var cart in carts) {
      _amount = _amount - (cart.discountedPrice! * cart.quantity!);
      _cartList.removeWhere((cartModel) => cartModel.id == cart.id);
      _isSelectedList.removeWhere((selected) => selected);
    }
    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }

  void setCartData(){
    _getData = true;
  }

  Future<ApiResponse> getCartDataAPI(BuildContext context) async {
    _isXyz = true;
    ApiResponse apiResponse = await cartRepo!.getCartListData();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _cartList = [];
      apiResponse.response!.data.forEach((cart) => _cartList.add(CartModel.fromJson(cart)));
      _isXyz = false;
    } else {
      _isXyz = false;
      if (context.mounted){
        ApiChecker.checkApi( apiResponse);
      }
    }
    _isXyz = false;
    notifyListeners();
    return apiResponse;
  }

  Future<ResponseModel> updateCartProductQuantity(int? key, int quantity, BuildContext context) async{
    _isLoading = true;
    ResponseModel responseModel;
    ApiResponse apiResponse;
    apiResponse = await cartRepo!.updateQuantity(key, quantity);
    _isLoading = false;

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      String message = apiResponse.response!.data['message'].toString();
      responseModel = ResponseModel( message,true);
      if (context.mounted){
        await getCartDataAPI(context);
      }

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
      _updateQuantityErrorText = errorMessage;
      responseModel = ResponseModel( errorMessage,false);
    }
    notifyListeners();
    return responseModel;
  }

  void setQuantity(bool isIncrement, int index) {
    if (isIncrement) {
      _cartList[index].quantity = _cartList[index].quantity! + 1;
      _isSelectedList[index] ? _amount = _amount + _cartList[index].discount! : _amount = _amount;
    } else {
      _cartList[index].quantity = _cartList[index].quantity! - 1;
      _isSelectedList[index] ? _amount = _amount - _cartList[index].discount! : _amount = _amount;
    }
    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }

  void toggleSelected(int index) {
    _isSelectedList[index] = !_isSelectedList[index];
    _amount = 0.0;
    for (int i = 0; i < _isSelectedList.length; i++) {
      if (_isSelectedList[i]) {
        _amount = _amount + (_cartList[i].discount! * _cartList[index].quantity!);
      }
    }

    for (var isSelect in _isSelectedList) {
      isSelect ? null : _isSelectAll = false;
    }

    notifyListeners();
  }

  void toggleAllSelect() {
    _isSelectAll = !_isSelectAll;

    if (_isSelectAll) {
      _amount = 0.0;
      for (int i = 0; i < _isSelectedList.length; i++) {
        _isSelectedList[i] = true;
        _amount = _amount + (_cartList[i].discount! * _cartList[i].quantity!);
      }
    } else {
      _amount = 0.0;
      for (int i = 0; i < _isSelectedList.length; i++) {
        _isSelectedList[i] = false;
      }
    }

    notifyListeners();
  }


  Future<ApiResponse> addToCartAPI(CartModel cart, Function callback, BuildContext context, List<ChoiceOptions> choices, List<int>? variationIndexes) async {
    _addToCartLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await cartRepo!.addToCartListData(cart, choices, variationIndexes);
    _addToCartLoading = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _addToCartLoading = false;
      Map map = apiResponse.response!.data;
      String? message = map["message"];
      callback(true, message);
      if(context.mounted){
        getCartDataAPI(context);
      }


    } else {
      _addToCartLoading = false;
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
      callback(false, errorMessage);

    }
    notifyListeners();
    return apiResponse;
  }


  Future<ResponseModel> removeFromCartAPI(BuildContext context, int? key) async{
    _isLoading = true;
    notifyListeners();
    ResponseModel responseModel;
    ApiResponse apiResponse;
    apiResponse = await cartRepo!.removeFromCart(key);
    if(context.mounted){

    }
    getCartDataAPI(context);
    _isLoading = false;

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      String message = apiResponse.response!.data.toString();
      responseModel = ResponseModel( message,true);
      getCartDataAPI(context);
      getChosenShippingMethod(context);
    } else {
      String? errorMessage = apiResponse.error.toString();
      if (apiResponse.error is String) {
        if (kDebugMode) {
          print(apiResponse.error.toString());
        }
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.errors![0].message;
      }
      _updateQuantityErrorText = errorMessage;
      responseModel = ResponseModel( errorMessage,false);
    }
    notifyListeners();
    return responseModel;
  }

  void getShippingMethod(BuildContext context, List<List<CartModel>> cartProdList) async {
    _isLoading = true;
    _getData = false;
    List<int?> sellerIdList = [];
    List<String?> sellerTypeList = [];
    List<String?> groupList = [];
    _shippingList = [];
    for(List<CartModel> element in cartProdList){
      sellerIdList.add(element[0].sellerId);
      sellerTypeList.add(element[0].sellerIs);
      groupList.add(element[0].cartGroupId);
      _shippingList!.add(ShippingModel(-1, element[0].cartGroupId, []));
    }

    await getChosenShippingMethod(context);
    for(int i=0; i<sellerIdList.length; i++) {
      ApiResponse apiResponse = await cartRepo!.getShippingMethod(sellerIdList[i],sellerTypeList[i] );

      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        List<ShippingMethodModel> shippingMethodList =[];
        apiResponse.response!.data.forEach((shipping) => shippingMethodList.add(ShippingMethodModel.fromJson(shipping)));

        _shippingList![i].shippingMethodList =[];
        _shippingList![i].shippingMethodList!.addAll(shippingMethodList);
        int index = -1;
        int? shipId = -1;
        for(ChosenShippingMethodModel cs in _chosenShippingList) {
          if(cs.cartGroupId == groupList[i]) {
            shipId = cs.shippingMethodId;
            break;
          }
        }
        if(shipId != -1) {
          for(int j=0; j<_shippingList![i].shippingMethodList!.length; j++) {
            if(_shippingList![i].shippingMethodList![j].id == shipId) {
              index = j;
              break;
            }
          }
        }
        _shippingList![i].shippingIndex = index;
      } else {
        if(context.mounted){
        }
        ApiChecker.checkApi( apiResponse);
      }
      _isLoading = false;
      notifyListeners();
    }

  }

  void getAdminShippingMethodList(BuildContext context) async {
    _isLoading = true;
    _getData = false;
    _shippingList = [];
    await getChosenShippingMethod(context);
    ApiResponse apiResponse = await cartRepo!.getShippingMethod(1,'admin');
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _shippingList!.add(ShippingModel(-1, '', []));
      List<ShippingMethodModel> shippingMethodList =[];
      apiResponse.response!.data.forEach((shipping) => shippingMethodList.add(ShippingMethodModel.fromJson(shipping)));

      _shippingList![0].shippingMethodList =[];
      _shippingList![0].shippingMethodList!.addAll(shippingMethodList);
      int index = -1;


      if(_chosenShippingList.isNotEmpty){
        for(int j=0; j<_shippingList![0].shippingMethodList!.length; j++) {
          if(_shippingList![0].shippingMethodList![j].id == _chosenShippingList[0].shippingMethodId) {
            index = j;
            break;
          }
        }
      }

      _shippingList![0].shippingIndex = index;
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    _isLoading = false;
    notifyListeners();

  }


  Future<void> getChosenShippingMethod(BuildContext context) async {
    ApiResponse apiResponse = await cartRepo!.getChosenShippingMethod();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _chosenShippingList = [];
      apiResponse.response!.data.forEach((shipping) => _chosenShippingList.add(ChosenShippingMethodModel.fromJson(shipping)));
      notifyListeners();
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }




  void setSelectedShippingMethod(int? index , int sellerIndex) {
    _shippingList![sellerIndex].shippingIndex = index;
    notifyListeners();
  }


  void initShippingMethodIndexList(int length) {
    _shippingList =[];
    for(int i =0; i< length; i++){
      _shippingList!.add(ShippingModel(0,'', null));
    }

  }





  Future addShippingMethod(BuildContext context, int? id, String? cartGroupId, Function callback) async {
    _isLoading = true;
    notifyListeners();
    ApiResponse apiResponse = await cartRepo!.addShippingMethod(id,cartGroupId);
    _isLoading = false;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      if(context.mounted){

      }
      getChosenShippingMethod(context);
      callback(true, '');
      notifyListeners();
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        ErrorResponse errorResponse = apiResponse.error;
        errorMessage = errorResponse.errors![0].message;
      }
      callback(false, errorMessage);
      notifyListeners();
    }
  }

  Future<void> uploadToServer(BuildContext context) async {
    if(cartRepo!.getCartList().isNotEmpty) {
      for(int index=0; index<cartRepo!.getCartList().length; index++) {
        await addToCartAPI(
          cartRepo!.getCartList()[index], (success, message) {}, context,
          cartRepo!.getCartList()[index].choiceOptions!, cartRepo!.getCartList()[index].variationIndexes,
        );
        if(index == cartRepo!.getCartList().length-1) {
          _cartList = [];
          cartRepo!.addToCartList([]);
          notifyListeners();
        }
      }
    }
  }

  String? _selectedShippingType;
  String? get selectedShippingType=>_selectedShippingType;

  final List<SelectedShippingType> _selectedShippingTypeList = [];
  List<SelectedShippingType> get selectedShippingTypeList => _selectedShippingTypeList;

  Future<void> getSelectedShippingType(BuildContext context, int sellerId, String sellerType) async {
    ApiResponse apiResponse = await cartRepo!.getSelectedShippingType(sellerId, sellerType);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
     _selectedShippingType = apiResponse.response!.data['shipping_type'];
     _selectedShippingTypeList.add(SelectedShippingType(sellerId: sellerId, selectedShippingType: _selectedShippingType));
    } else {
      if(context.mounted){

      }
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

}
