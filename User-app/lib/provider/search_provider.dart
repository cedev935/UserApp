import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/search_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

class SearchProvider with ChangeNotifier {
  final SearchRepo? searchRepo;
  SearchProvider({required this.searchRepo});

  int _filterIndex = 0;
  List<String> _historyList = [];

  int get filterIndex => _filterIndex;
  List<String> get historyList => _historyList;

  void setFilterIndex(int index) {
    _filterIndex = index;
    notifyListeners();
  }

  void sortSearchList(double startingPrice, double endingPrice) {
    _searchProductList = [];
    if(startingPrice > 0 && endingPrice > startingPrice) {
      _searchProductList!.addAll(_filterProductList!.where((product) =>
      product.unitPrice! > startingPrice && product.unitPrice! < endingPrice).toList());
    }else {
      _searchProductList!.addAll(_filterProductList!);
    }

    if (_filterIndex == 0) {

    } else if (_filterIndex == 1) {
      _searchProductList!.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
    } else if (_filterIndex == 2) {
      _searchProductList!.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      Iterable iterable = _searchProductList!.reversed;
      _searchProductList = iterable.toList() as List<Product>?;
    } else if (_filterIndex == 3) {
      _searchProductList!.sort((a, b) => a.unitPrice!.compareTo(b.unitPrice!));
    } else if (_filterIndex == 4) {
      _searchProductList!.sort((a, b) => a.unitPrice!.compareTo(b.unitPrice!));
      Iterable iterable = _searchProductList!.reversed;
      _searchProductList = iterable.toList() as List<Product>?;
    }

    notifyListeners();
  }

  List<Product>? _searchProductList;
  List<Product>? _filterProductList;
  bool _isClear = true;
  String _searchText = '';

  List<Product>? get searchProductList => _searchProductList;
  List<Product>? get filterProductList => _filterProductList;
  bool get isClear => _isClear;
  String get searchText => _searchText;

  void setSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }

  void cleanSearchProduct() {
    _searchProductList = [];
    _isClear = true;
    _searchText = '';
    // notifyListeners();
  }

  void searchProduct(String query, BuildContext context) async {
    _searchText = query;
    _isClear = false;
    _searchProductList = null;
    _filterProductList = null;
    notifyListeners();

    ApiResponse apiResponse = await searchRepo!.getSearchProductList(query);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if (query.isEmpty) {
        _searchProductList = [];
        _filterProductList = [];
      } else {
        _searchProductList = [];
        if(ProductModel.fromJson(apiResponse.response!.data).products != null){
          _searchProductList!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
          _filterProductList = [];
          _filterProductList!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        }

      }
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  void initHistoryList() {
    _historyList = [];
    _historyList.addAll(searchRepo!.getSearchAddress());

  }

  void saveSearchAddress(String searchAddress) async {
    searchRepo!.saveSearchAddress(searchAddress);
    if (!_historyList.contains(searchAddress)) {
      _historyList.add(searchAddress);
    }
    notifyListeners();
  }

  void clearSearchAddress() async {
    if (kDebugMode) {
      print('search tap');
    }
    searchRepo!.clearSearchAddress();
    _historyList = [];
    notifyListeners();
  }
}
