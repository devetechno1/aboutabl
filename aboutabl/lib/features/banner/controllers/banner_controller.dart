import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/domain/models/banner_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/domain/services/banner_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/domain/models/seller_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/screens/shop_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../common/basewidget/show_custom_snakbar_widget.dart';
import '../../../main.dart';
import '../../../utill/app_constants.dart';
import '../../product/screens/category_product_screen.dart';
import '../../support/screens/support_ticket_screen.dart';

class BannerController extends ChangeNotifier {
  final BannerServiceInterface? bannerServiceInterface;
  BannerController({required this.bannerServiceInterface});

  List<BannerModel>? _mainBannerList;
  List<BannerModel>? _footerBannerList;
  List<BannerModel>? _subMainBannerList;
  BannerModel? mainSectionBanner;
  BannerModel? sideBarBanner;
  Product? _product;
  int? _currentIndex;
  int? _footerBannerIndex;
  List<BannerModel>? get mainBannerList => _mainBannerList;
  List<BannerModel>? get footerBannerList => _footerBannerList;
  List<BannerModel>? get subMainBannerList => _subMainBannerList;

  Product? get product => _product;
  int? get currentIndex => _currentIndex;
  int? get footerBannerIndex => _footerBannerIndex;

  BannerModel? promoBannerMiddleTop;
  BannerModel? promoBannerRight;
  BannerModel? promoBannerMiddleBottom;
  BannerModel? promoBannerLeft;
  BannerModel? promoBannerBottom;
  BannerModel? sideBarBannerBottom;
  BannerModel? topSideBarBannerBottom;

  Future<void> getBannerList(bool reload) async {
    ApiResponse apiResponse = await bannerServiceInterface!.getList();
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      _mainBannerList = [];
      _footerBannerList = [];
      _subMainBannerList = [];

      apiResponse.response!.data.forEach((bannerModel) {
        if (bannerModel['banner_type'] == 'Main Banner') {
          _mainBannerList!.add(BannerModel.fromJson(bannerModel));
        } else if (bannerModel['banner_type'] == 'Promo Banner Middle Top') {
          promoBannerMiddleTop = BannerModel.fromJson(bannerModel);
        } else if (bannerModel['banner_type'] == 'Promo Banner Right') {
          promoBannerRight = BannerModel.fromJson(bannerModel);
        } else if (bannerModel['banner_type'] == 'Promo Banner Middle Bottom') {
          promoBannerMiddleBottom = BannerModel.fromJson(bannerModel);
        } else if (bannerModel['banner_type'] == 'Promo Banner Bottom') {
          promoBannerBottom = BannerModel.fromJson(bannerModel);
        } else if (bannerModel['banner_type'] == 'Promo Banner Left') {
          promoBannerLeft = BannerModel.fromJson(bannerModel);
        } else if (bannerModel['banner_type'] == 'Sidebar Banner') {
          sideBarBanner = BannerModel.fromJson(bannerModel);
        } else if (bannerModel['banner_type'] == 'Top Side Banner') {
          topSideBarBannerBottom = BannerModel.fromJson(bannerModel);
        } else if (bannerModel['banner_type'] == 'Footer Banner') {
          _footerBannerList?.add(BannerModel.fromJson(bannerModel));
        } else if (bannerModel['banner_type'] == 'Sub Main Banner') {
          _subMainBannerList?.add(BannerModel.fromJson(bannerModel));
        } else if (bannerModel['banner_type'] == 'Main Section Banner') {
          mainSectionBanner = BannerModel.fromJson(bannerModel);
        }
      });

      _currentIndex = 0;
      notifyListeners();
    } else {
      ApiChecker.checkApi(apiResponse);
    }
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void onChangeFooterBannerIndex(int index) {
    _footerBannerIndex = index;
    notifyListeners();
  }

  void clickBannerRedirect(BuildContext context, int? id, Product? product,
      String? type, String? url) {
    if (type == 'category') {
      final cIndex = Provider.of<CategoryController>(context, listen: false)
          .categoryList
          .indexWhere((element) => element.id == id);
      if (cIndex != -1) {
        if (Provider.of<CategoryController>(context, listen: false)
                .categoryList[cIndex]
                .name !=
            null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CategoryProductScreen(
                        category: Provider.of<CategoryController>(context,
                                listen: false)
                            .categoryList[cIndex],
                      )));
        }
      }
    } else if (type == 'product') {
      if (product != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    ProductDetails(productId: product.id, slug: product.slug)));
      }
    } else if (type == 'brand') {
      final bIndex = Provider.of<BrandController>(context, listen: false)
          .brandList
          .indexWhere((element) => element.id == id);
      if (bIndex != -1) {
        if (Provider.of<BrandController>(context, listen: false)
                .brandList[bIndex]
                .name !=
            null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => BrandAndCategoryProductScreen(
                        isBrand: true,
                        id: id.toString(),
                        name:
                            '${Provider.of<BrandController>(context, listen: false).brandList[bIndex].name}',
                      )));
        }
      }
    } else if (type == 'shop') {
      final tIndex = Provider.of<ShopController>(context, listen: false)
          .sellerModel!
          .sellers!
          .indexWhere((element) => element.id == id);
      final ShopController c =
          Provider.of<ShopController>(context, listen: false);
      if (tIndex != -1) {
        final Shop? s = c.sellerModel?.sellers?[tIndex].shop;
        if (s?.name != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => TopSellerProductScreen(
                        sellerId: id,
                        temporaryClose: s?.temporaryClose,
                        vacationStatus: s?.vacationStatus,
                        vacationEndDate: s?.vacationEndDate,
                        vacationStartDate: s?.vacationStartDate,
                        name: s?.name,
                        banner: s?.bannerFullUrl?.path,
                        image: s?.imageFullUrl?.path,
                      )));
        }
      }
    } else if (type == 'bannerurl') {
      if (url?.trim() == "${AppConstants.baseUrl}/account-tickets") {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const SupportTicketScreen()));
      } else {
        _launchUrlString(url ?? '');
      }
    }
  }

  _launchUrlString(String url) async {
    if (await canLaunchUrlString(url)) {
      launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      showCustomSnackBar(
          '${getTranslated('can_not_launch', Get.context!)}  $url',
          Get.context!);
    }
  }
}
