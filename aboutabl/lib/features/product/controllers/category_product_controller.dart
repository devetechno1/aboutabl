import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/services/product_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';

import '../../category/domain/models/category_model.dart';
import '../screens/category_product_screen.dart';

class CategoryProductController extends ChangeNotifier {
  final ProductServiceInterface? productServiceInterface;
  CategoryProductController({required this.productServiceInterface});

  void initCat(Category newCategory) {
    _category = newCategory;
    _pressedCategory = _category;
    _subCategories = _category.childes;
    _currentIndex = -100;
    pressViewAll();
  }

  int _currentIndex = -1;
  int _currentOffset = 1;

  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;
    _currentOffset = 1;
    notifyListeners();
  }

  void pressViewAll() {
    if (_currentIndex == -1) return;
    _pressedCategory = _category;
    setCurrentIndex(-1);
    getCategoryProductList("${_category.id}");
  }

  void getProductsCatAndSubIndex(
    BuildContext context,
    int index, {
    required Category category,
  }) {
    if (_currentIndex == index) return;

    if (category.childes?.isNotEmpty == true ||
        AppConstants.isSubCategoriesGrid) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryProductScreen(category: category),
        ),
      );
    } else {
      _pressedCategory = category;
      setCurrentIndex(index);
      getCategoryProductList("${_pressedCategory.id}");
    }
  }

  //* --------------category----------------------------------------------------------------------
  late Category _category;
  late Category _pressedCategory;
  List<Category>? _subCategories;
  Category get category => _category;
  List<Category>? get subCategories => _subCategories;

  // void setCategory(Category newCategory) {
  //   _category = newCategory;
  //   notifyListeners();
  // }

  // ------------------------------------------------------------------------------------------------
  // //* --------------SubCategory----------------------------------------------------------------------
  // SubCategory? _subCategory;
  // SubCategory? get subCategory => _subCategory;

  // void setSubCategory(SubCategory? newSubCategory) {
  //   _subCategory = newSubCategory;
  //   notifyListeners();
  // }

  // // ------------------------------------------------------------------------------------------------
  // //* --------------SubSubCategory----------------------------------------------------------------------
  // SubSubCategory? _subSubCategory;
  // SubSubCategory? get subSubCategory => _subSubCategory;

  // void setSubSubCategory(SubSubCategory? newSubSubCategory) {
  //   _subSubCategory = newSubSubCategory;
  //   notifyListeners();
  // }
  // // ------------------------------------------------------------------------------------------------

  final List<Product> _categoryProductList = [];
  List<Product> get categoryProductList => _categoryProductList;

  bool _hasData = true;
  bool get hasData => _hasData;

  int _totalProductLength = 0;
  int get totalProductLength => _totalProductLength;

  bool isLoadingPagination = false;

  Future<void> getCategoryProductList(String id) async {
    _hasData = true;
    _currentOffset = 1;
    ApiResponse apiResponse = await productServiceInterface!
        .getCategoryProductList(id, "$_currentOffset");
    _categoryProductList.clear();

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      if (apiResponse.response!.data is Map<String, dynamic>) {
        _totalProductLength = apiResponse.response!.data["total"] ?? 0;
        apiResponse.response!.data["data"].forEach(
            (product) => _categoryProductList.add(Product.fromJson(product)));
      } else {
        apiResponse.response!.data.forEach(
            (product) => _categoryProductList.add(Product.fromJson(product)));
        _totalProductLength = _categoryProductList.length;
      }
      _hasData = _categoryProductList.length > 1;
      List<Product> products = [];
      products.addAll(_categoryProductList);
      _categoryProductList.clear();
      _categoryProductList.addAll(products);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getCategoryProductMore() async {
    if (_totalProductLength <= _categoryProductList.length ||
        isLoadingPagination) return;
    isLoadingPagination = true;
    notifyListeners();

    ApiResponse apiResponse =
        await productServiceInterface!.getCategoryProductList(
      "${_pressedCategory.id}",
      "${++_currentOffset}",
    );

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _totalProductLength = apiResponse.response!.data["total"] ?? 0;
      apiResponse.response!.data["data"].forEach(
          (product) => _categoryProductList.add(Product.fromJson(product)));
      List<Product> products = [];
      products.addAll(_categoryProductList);
      _categoryProductList.clear();
      _categoryProductList.addAll(products);
    } else {
      ApiChecker.checkApi(apiResponse);
    }
    isLoadingPagination = false;
    notifyListeners();
  }

  Future<void> refreshProducts() {
    return getCategoryProductList("${_pressedCategory.id}");
  }
}
