import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/product_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/helper/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';

class ProductProvider extends ChangeNotifier {
  final ProductRepo? productRepo;
  ProductProvider({required this.productRepo});

  // Latest products
  List<Product>? _latestProductList = [];
  List<Product> _lProductList = [];
  List<Product> get lProductList=> _lProductList;
  List<Product> _featuredProductList = [];


  ProductType _productType = ProductType.newArrival;
  String? _title = 'xyz';

  bool _filterIsLoading = false;
  bool _filterFirstLoading = true;

  bool _isLoading = false;
  bool _isFeaturedLoading = false;
  bool get isFeaturedLoading => _isFeaturedLoading;
  bool _firstFeaturedLoading = true;
  bool _firstLoading = true;
  int? _latestPageSize = 1;
  int _lOffset = 1;
  int _sellerOffset = 1;
  int? _lPageSize;
  int? get lPageSize=> _lPageSize;
  int? _featuredPageSize;

  ProductType get productType => _productType;
  String? get title => _title;
  int get lOffset => _lOffset;
  int get sellerOffset => _sellerOffset;

  List<int> _offsetList = [];
  List<String> _lOffsetList = [];
  List<String> get lOffsetList=>_lOffsetList;
  List<String> _featuredOffsetList = [];

  List<Product>? get latestProductList => _latestProductList;
  List<Product> get featuredProductList => _featuredProductList;

  Product? _recommendedProduct;
  Product? get recommendedProduct=> _recommendedProduct;

  bool get filterIsLoading => _filterIsLoading;
  bool get filterFirstLoading => _filterFirstLoading;
  bool get isLoading => _isLoading;
  bool get firstFeaturedLoading => _firstFeaturedLoading;
  bool get firstLoading => _firstLoading;
  int? get latestPageSize => _latestPageSize;
  int? get featuredPageSize => _featuredPageSize;




  //latest product
  Future<void> getLatestProductList(int offset, {bool reload = false}) async {
    if(reload) {
      _offsetList = [];
      _latestProductList = [];
    }
    _lOffset = offset;
    if(!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      ApiResponse apiResponse = await productRepo!.getLatestProductList(Get.context!, offset.toString(), productType, title);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        if(ProductModel.fromJson(apiResponse.response!.data).products != null){
          _latestProductList!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
          _latestPageSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
          _filterFirstLoading = false;
          _filterIsLoading = false;
        }else{
          _filterIsLoading = false;
          removeFirstLoading();
        }

      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }else {
      if(_filterIsLoading) {
        _filterIsLoading = false;
        notifyListeners();
      }
    }

  }
  //latest product
  Future<void> getLProductList(String offset, {bool reload = false}) async {
    if(reload) {
      _lOffsetList = [];
      _lProductList = [];
    }
    if(!_lOffsetList.contains(offset)) {
      _lOffsetList.add(offset);
      ApiResponse apiResponse = await productRepo!.getLProductList(offset);
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _lProductList.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        _lPageSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
        _firstLoading = false;
        _isLoading = false;
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }else {
      if(_isLoading) {
        _isLoading = false;
        notifyListeners();
      }
    }

  }


  Future<int?> getLatestOffset(BuildContext context) async {
    ApiResponse apiResponse = await productRepo!.getLatestProductList(context,'1', productType, title);
    return ProductModel.fromJson(apiResponse.response!.data).totalSize;
  }

 void changeTypeOfProduct(ProductType type, String? title){
    _productType = type;
    _title = title;
    _latestProductList = null;
    _latestPageSize = 1;
    _filterFirstLoading = true;
    _filterIsLoading = true;
    notifyListeners();
 }

  void showBottomLoader() {
    _isLoading = true;
    _filterIsLoading = true;
    notifyListeners();
  }

  void removeFirstLoading() {
    _firstLoading = true;
    notifyListeners();
  }

  // Seller products
  List<Product> _sellerAllProductList = [];
  List<Product> _sellerProductList = [];
  int? _sellerPageSize;
  List<Product> get sellerProductList => _sellerProductList;
  int? get sellerPageSize => _sellerPageSize;

  TextEditingController sellerProductSearch = TextEditingController();

  void clearSearchField( String id){
    sellerProductSearch.clear();
    notifyListeners();
  }


  Future <ApiResponse> initSellerProductList(String sellerId, int offset, BuildContext context, {bool reload = true, String search = ''}) async {

    _firstLoading = true;
    if(reload) {
      _offsetList = [];
      _sellerProductList = [];
      _sellerAllProductList = [];
      _isLoading = true;
    }
    _sellerOffset = offset;

    ApiResponse apiResponse = await productRepo!.getSellerProductList(sellerId, offset.toString(), search);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(reload){
        _sellerAllProductList=[];
        _sellerProductList = [];
      }
      if(ProductModel.fromJson(apiResponse.response!.data).products != null){
        _sellerProductList.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        _sellerAllProductList.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
        _sellerPageSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
      }

      _firstLoading = false;
      _filterIsLoading = false;
      _isLoading = false;
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
    return apiResponse;

  }

  void filterData(String newText) {
    _sellerProductList =[];
    if(newText.isNotEmpty) {
      _sellerProductList = [];
      for (var product in _sellerAllProductList) {
        if (product.name!.toLowerCase().contains(newText.toLowerCase())) {
          _sellerProductList.add(product);
        }
      }
    }else {
      _sellerProductList = [];
      _sellerProductList.addAll(_sellerAllProductList);
    }
    notifyListeners();
  }

  void clearSellerData() {
    _sellerProductList = [];
    _sellerAllProductList = [];

    //notifyListeners();
  }

  // Brand and category products
  final List<Product> _brandOrCategoryProductList = [];
  bool? _hasData;

  List<Product> get brandOrCategoryProductList => _brandOrCategoryProductList;
  bool? get hasData => _hasData;

  void initBrandOrCategoryProductList(bool isBrand, String id, BuildContext context) async {
    _brandOrCategoryProductList.clear();
    _hasData = true;
    ApiResponse apiResponse = await productRepo!.getBrandOrCategoryProductList(isBrand, id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      apiResponse.response!.data.forEach((product) => _brandOrCategoryProductList.add(Product.fromJson(product)));
      _hasData = _brandOrCategoryProductList.length > 1;
      List<Product> products = [];
      products.addAll(_brandOrCategoryProductList);
      _brandOrCategoryProductList.clear();
      _brandOrCategoryProductList.addAll(products.reversed);
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  // Related products
  List<Product>? _relatedProductList;
  List<Product>? get relatedProductList => _relatedProductList;

  void initRelatedProductList(String id, BuildContext context) async {
    ApiResponse apiResponse = await productRepo!.getRelatedProductList(id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _relatedProductList = [];
      apiResponse.response!.data.forEach((product) => _relatedProductList!.add(Product.fromJson(product)));
    } else {
      ApiChecker.checkApi( apiResponse);
    }
    notifyListeners();
  }

  void removePrevRelatedProduct() {
    _relatedProductList = null;
  }

  //featured product
  Future<void> getFeaturedProductList(String offset, {bool reload = false}) async {
    if(reload) {
      _featuredOffsetList = [];
      _featuredProductList = [];
    }
    if(!_featuredOffsetList.contains(offset)) {
      _featuredOffsetList.add(offset);
      ApiResponse apiResponse = await productRepo!.getFeaturedProductList(offset);
      if (apiResponse.response != null  && apiResponse.response!.statusCode == 200) {
        if(apiResponse.response!.data['products'] != null){
          _featuredProductList.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);
          _featuredPageSize = ProductModel.fromJson(apiResponse.response!.data).totalSize;
        }

        _firstFeaturedLoading = false;
        _isFeaturedLoading = false;
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }else {
      if(_isFeaturedLoading) {
        _isFeaturedLoading = false;
        notifyListeners();
      }
    }

  }


  Future<void> getRecommendedProduct() async {
    ApiResponse apiResponse = await productRepo!.getRecommendedProduct();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _recommendedProduct = Product.fromJson(apiResponse.response!.data);

      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();


  }
}
