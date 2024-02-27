import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/category.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/category_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:provider/provider.dart';

import '../data/model/response/product_model.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo? categoryRepo;

  CategoryProvider({required this.categoryRepo});


  final List<Category> _categoryList = [];
  List<Category> _subCategoryList = [];
  List<Product> _categoryProductList = [];
  List<Product> _categoryAllProductList = [];
  Category? _categoryModel;
  int? _categorySelectedIndex;

  List<Category> get categoryList => _categoryList;
  List<Category> get subCategoryList => _subCategoryList;
  List<Product> get categoryProductList => _categoryProductList;
  Category? get categoryModel => _categoryModel;
  int? get categorySelectedIndex => _categorySelectedIndex;

  Future<void> getCategoryList(bool reload) async {
    if (_categoryList.isEmpty || reload) {
      ApiResponse apiResponse = await categoryRepo!.getCategoryList();
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _categoryList.clear();
        apiResponse.response!.data.forEach((category) => _categoryList.add(Category.fromJson(category)));
        _categorySelectedIndex = 0;
      } else {
        ApiChecker.checkApi( apiResponse);
      }
      notifyListeners();
    }
  }
  void getCategory(int id, BuildContext context) async {
    if(_categoryList == null) {
      await getCategoryList(true);
      _categoryModel = _categoryList.firstWhere((category) => category.id == id);
      notifyListeners();
    }else {
      try{
        _categoryModel = _categoryList.firstWhere((category) => category.id == id);
      }catch(e){
        print('error : $e');
      }
    }
  }
  void getSubCategoryList(BuildContext context, String categoryID, String languageCode) async {
    _subCategoryList = [];

    ApiResponse apiResponse = await categoryRepo!.getSubCategoryList(categoryID,languageCode);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _subCategoryList = [];
      apiResponse.response!.data.forEach((category) => _subCategoryList.add(Category.fromJson(category)));
      getCategoryProductList(context, categoryID,languageCode);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }
  void getCategoryProductList(BuildContext context, String categoryID,String languageCode) async {
    _categoryProductList = [];

    ApiResponse apiResponse = await categoryRepo!.getCategoryProductList(categoryID,languageCode);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _categoryProductList = [];
      apiResponse.response!.data.forEach((category) => _categoryProductList.add(Product.fromJson(category)));
      _categoryAllProductList.addAll(_categoryProductList);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  void changeSelectedIndex(int selectedIndex) {
    _categorySelectedIndex = selectedIndex;
    notifyListeners();
  }
}
