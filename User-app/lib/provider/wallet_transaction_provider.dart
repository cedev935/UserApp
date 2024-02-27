import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/loyalty_point_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/transaction_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/wallet_transaction_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';

class WalletTransactionProvider extends ChangeNotifier {
  final WalletTransactionRepo? transactionRepo;
  bool _isLoading = false;
  bool _firstLoading = false;
  bool _isConvert = false;
  bool get isConvert => _isConvert;
  bool get isLoading => _isLoading;
  bool get firstLoading => _firstLoading;
  int? _transactionPageSize;
  int? get transactionPageSize=> _transactionPageSize;
  TransactionModel? _walletBalance;
  TransactionModel? get walletBalance => _walletBalance;

  int? _loyaltyPointPageSize;
  int? get loyaltyPointPageSize=> _loyaltyPointPageSize;

  WalletTransactionProvider({required this.transactionRepo});

  List<WalletTransactioList> _transactionList = [];
  List<WalletTransactioList> get transactionList => _transactionList;

  List<LoyaltyPointList> _loyaltyPointList = [];
  List<LoyaltyPointList> get loyaltyPointList => _loyaltyPointList;

  Future<void> getTransactionList(BuildContext context, int offset, {bool reload = true}) async {
    if(reload){
      _transactionList = [];
    }
    _isLoading = true;
    ApiResponse apiResponse = await transactionRepo!.getWalletTransactionList(offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _walletBalance = TransactionModel.fromJson(apiResponse.response!.data);
      _transactionList.addAll(TransactionModel.fromJson(apiResponse.response!.data).walletTransactioList!);
      _transactionPageSize = TransactionModel.fromJson(apiResponse.response!.data).totalWalletTransactio;
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }


  Future<void> getLoyaltyPointList(BuildContext context, int offset, {bool reload = false}) async {
    if(reload){
      _loyaltyPointList = [];
    }
    _isLoading = true;
    ApiResponse apiResponse = await transactionRepo!.getLoyaltyPointList(offset);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _loyaltyPointList.addAll(LoyaltyPointModel.fromJson(apiResponse.response!.data).loyaltyPointList!);
      _loyaltyPointPageSize = LoyaltyPointModel.fromJson(apiResponse.response!.data).totalLoyaltyPoint;
      _isLoading = false;
    } else {
      _isLoading = false;
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }


  Future convertPointToCurrency(BuildContext context, int point) async {
    _isConvert = true;
    notifyListeners();
    ApiResponse apiResponse = await transactionRepo!.convertPointToCurrency(point);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _isConvert = false;
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        backgroundColor:Colors.green,
        content: Text('${getTranslated('point_converted_successfully', Get.context!)}'),
      ));
    }else{
      _isConvert = false;
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        backgroundColor:Colors.green,
        content: Text('${getTranslated('point_converted_failed', Get.context!)}'),
      ));
    }
    notifyListeners();
  }

  void showBottomLoader() {
    _isLoading = true;
    notifyListeners();
  }

  void removeFirstLoading() {
    _firstLoading = true;
    notifyListeners();
  }
}
