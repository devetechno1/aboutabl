import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/aster_theme_home_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/screens/fashion_theme_home_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:provider/provider.dart';

import '../../home/screens/home_screens.dart';

class SelectLanguageBottomSheetWidget extends StatefulWidget {
  const SelectLanguageBottomSheetWidget({super.key});

  @override
  State<SelectLanguageBottomSheetWidget> createState() =>
      _SelectLanguageBottomSheetWidgetState();
}

class _SelectLanguageBottomSheetWidgetState
    extends State<SelectLanguageBottomSheetWidget> {
  int selectedIndex = 0;
  @override
  void initState() {
    selectedIndex = Provider.of<LocalizationController>(context, listen: false)
        .languageIndex!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocalizationController>(
        builder: (context, localizationProvider, _) {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(bottom: 40, top: 15),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(Dimensions.paddingSizeDefault))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Theme.of(context).hintColor.withOpacity(.5),
                      borderRadius: BorderRadius.circular(20))),
              const SizedBox(
                height: 40,
              ),
              Text(
                getTranslated('select_language', context)!,
                style: textBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: Dimensions.paddingSizeSmall,
                    bottom: Dimensions.paddingSizeLarge),
                child: Text(
                    '${getTranslated('choose_your_language_to_proceed', context)}'),
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: AppConstants.languages.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                Dimensions.paddingSizeDefault,
                                0,
                                Dimensions.paddingSizeDefault,
                                Dimensions.paddingSizeSmall),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.paddingSizeExtraSmall),
                                    color: selectedIndex == index
                                        ? Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.1)
                                        : Theme.of(context).cardColor),
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeDefault,
                                        vertical: Dimensions.paddingSizeSmall),
                                    child: Row(children: [
                                      SizedBox(
                                          width: 25,
                                          child: Image.asset(AppConstants
                                              .languages[index].imageUrl!)),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.paddingSizeSmall),
                                          child: Text(AppConstants
                                              .languages[index].languageName!))
                                    ])))));
                  }),
              Padding(
                  padding: const EdgeInsets.fromLTRB(
                      Dimensions.paddingSizeSmall,
                      Dimensions.paddingSizeSmall,
                      Dimensions.paddingSizeSmall,
                      0),
                  child: CustomButton(
                    buttonText: '${getTranslated('select', context)}',
                    onTap: () {
                      Provider.of<LocalizationController>(context,
                              listen: false)
                          .setLanguage(Locale(
                              AppConstants
                                  .languages[selectedIndex].languageCode!,
                              AppConstants
                                  .languages[selectedIndex].countryCode));
                      final SplashController splashController =
                        Provider.of<SplashController>(context, listen: false);
                      if (splashController.configModel!.activeTheme == "default") {
                        HomePage.loadData(true);
                      } else if (splashController.configModel!.activeTheme == "theme_aster") {
                        AsterThemeHomeScreen.loadData(true);
                      } else {
                        FashionThemeHomePage.loadData(true);
                      }
                      Navigator.pop(context);
                    },
                  ))
            ],
          ),
        ),
      );
    });
  }
}
