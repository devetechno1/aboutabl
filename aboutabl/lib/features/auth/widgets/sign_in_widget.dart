import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/screens/forget_password_screen.dart';
import 'package:flutter_sixvalley_ecommerce/helper/number_checker_helper.dart';
import 'package:flutter_sixvalley_ecommerce/helper/string_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/widgets/social_login_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';

import '../../splash/domain/models/config_model.dart';
import '../domain/models/user_log_data.dart';
import '../enums/from_page.dart';
import '../screens/otp_login_screen.dart';
import 'only_social_login_widget.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({super.key, required this.fromLogout});
  final bool fromLogout;

  @override
  SignInWidgetState createState() => SignInWidgetState();
}

class SignInWidgetState extends State<SignInWidget> {
  final FocusNode _emailNumberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  TextEditingController? _emailPhoneController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;
  String? countryCode;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailPhoneController = TextEditingController();
    _passwordController = TextEditingController();

    final ConfigModel configModel =
        Provider.of<SplashController>(context, listen: false).configModel!;
    final AuthController authController =
        Provider.of<AuthController>(context, listen: false);

    authController.setIsLoading = false;
    authController.setIsPhoneVerificationButttonLoading = false;
    UserLogData? userData = authController.getUserData();
    // authController.toggleIsNumberLogin(value: false, isUpdate: false);

    countryCode =
        CountryCode.fromCountryCode(configModel.countryCode!).dialCode;

    if (userData != null) {
      if (userData.phoneNumber != null) {
        _emailPhoneController!.text = NumberCheckerHelper.getPhoneNumber(
                userData.phoneNumber ?? '', userData.countryCode ?? '') ??
            '';
        // authController.toggleIsNumberLogin(isUpdate: false);
        countryCode ??= userData.countryCode;
      }
      _passwordController!.text = userData.password ?? '';
    }
  }

  @override
  void dispose() {
    _emailPhoneController!.dispose();
    _passwordController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final configModel =
        Provider.of<SplashController>(context, listen: false).configModel!;

    if (configModel.customerLogin!.loginOption!.manualLogin == 0 &&
        configModel.customerLogin!.loginOption!.otpLogin == 0) {
      return OnlySocialLoginWidget(fromLogout: widget.fromLogout);
    }
    if (configModel.customerLogin!.loginOption!.manualLogin == 0) {
      return OtpLoginScreen(fromLogout: widget.fromLogout);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Center(
          child: Container(
            width: width > 700 ? 500 : width,
            padding: width > 700
                ? const EdgeInsets.all(Dimensions.paddingSizeExtraLarge)
                : null,
            decoration: width > 700
                ? BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).shadowColor,
                          blurRadius: 5,
                          spreadRadius: 1)
                    ],
                  )
                : null,
            child: Consumer<AuthController>(
              builder: (context, authProvider, child) => Form(
                key: _formKeyLogin,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 35),

                      CustomTextFieldWidget(
                        countryDialCode: countryCode,
                        showCodePicker: true,
                        hintText: getTranslated('enter_mobile_number', context),
                        onCountryChanged: (CountryCode value) {
                          countryCode = value.dialCode;
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        inputType: TextInputType.phone,
                        //hintText: getTranslated('email/phone', context),
                        //prefixIconUrl: Images.emailPhoneSvg,
                        //isShowPrefixIcon: true,
                        //prefixIconColor: Theme.of(context).primaryColor,
                        isShowBorder: true,
                        focusNode: _emailNumberFocus,
                        nextFocus: _passwordFocus,
                        controller: _emailPhoneController,
                        labelText: getTranslated('phone', context),
                        required: true,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      CustomTextFieldWidget(
                        hintText: getTranslated('password_hint', context),
                        labelText: getTranslated('password', context),
                        isShowBorder: true,
                        required: true,
                        isPassword: true,
                        //isShowSuffixIcon: true,
                        showLabelText: false,
                        focusNode: _passwordFocus,
                        controller: _passwordController,
                        inputAction: TextInputAction.done,
                        prefixIcon: Images.lockSvg,
                        prefixColor: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 22),

                      // for remember me section
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () => authProvider.toggleRememberMe(),
                              child: Row(children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.brightness == Brightness.light? Colors.white : Colors.black,
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: authProvider.isActiveRememberMe
                                      ? Icon(Icons.done,
                                          color: Theme.of(context).primaryColor,
                                          size: 14)
                                      : const SizedBox.shrink(),
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeSmall),
                                Text(
                                  getTranslated('remember', context)!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                              ]),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const ForgetPasswordScreen()));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  getTranslated('forget_password_q', context)!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        fontSize: Dimensions.fontSizeSmall,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                              ),
                            ),
                          ]),

                      // const SizedBox(height: 22),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            authProvider.loginErrorMessage!.isNotEmpty
                                ? CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    radius: 5)
                                : const SizedBox.shrink(),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                authProvider.loginErrorMessage ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      fontSize: Dimensions.fontSizeSmall,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                            ),
                          ]),
                      const SizedBox(height: 10),

                      !authProvider.isLoading &&
                              !authProvider
                                  .isPhoneNumberVerificationButtonLoading
                          ? CustomButton(
                              buttonText: getTranslated('sign_in', context),
                              onTap: () async {
                                String password =
                                    _passwordController!.text.trim();

                                if (_emailPhoneController!.text.isEmpty) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'enter_phone_number', context),
                                      context);
                                } else if (password.isEmpty) {
                                  showCustomSnackBar(
                                      getTranslated('enter_password', context),
                                      context);
                                } else if (password.length < 6) {
                                  showCustomSnackBar(
                                      getTranslated(
                                          'password_should_be', context),
                                      context);
                                } else {
                                  String userInput = _emailPhoneController!
                                      .text.removeZerosInFirst;

                                  userInput = countryCode! + userInput;

                                  String type = 'phone';

                                  await authProvider
                                      .login(
                                    userInput,
                                    password,
                                    type,
                                    FromPage.login,
                                  )
                                      .then((status) async {
                                    await authProvider.clearUserData();
                                    if (status.isSuccess) {
                                      if (authProvider.isActiveRememberMe) {
                                        authProvider.saveUserEmailAndPassword(
                                            UserLogData(
                                          countryCode: countryCode,
                                          phoneNumber: userInput,
                                          email: null,
                                          password: password,
                                        ));
                                      }
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const DashBoardScreen()),
                                          (route) => false);
                                    }
                                  });
                                }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                              ),
                            ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      if (configModel.customerLogin?.loginOption?.otpLogin ==
                          null)
                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                                    color: Theme.of(context).hintColor)),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Text(
                              getTranslated('OR', context)!,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Expanded(
                                child: Divider(
                                    color: Theme.of(context).hintColor)),
                          ],
                        ),

                      if (configModel.customerLogin?.loginOption?.otpLogin ==
                          1) ...[
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        InkWell(
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const OtpLoginScreen())),
                          },
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getTranslated('sign_in_with', context)!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        fontSize: Dimensions.fontSizeDefault,
                                        color: Theme.of(context).hintColor,
                                      ),
                                ),
                                const SizedBox(
                                    width: Dimensions.paddingSizeSmall),
                                Text(
                                  getTranslated('otp', context)!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: Dimensions.fontSizeDefault,
                                        decoration: TextDecoration.underline,
                                        decorationColor:
                                            Theme.of(context).primaryColor,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                              ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                      ],

                      if ((configModel.customerLogin?.loginOption
                                  ?.socialMediaLogin ==
                              1) &&
                          configModel.customerLogin?.loginOption?.otpLogin != 1)
                        Row(
                          children: [
                            Expanded(
                                child: Divider(
                                    color: Theme.of(context).hintColor)),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Text(
                              getTranslated('or_sign_in_with', context)!,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontSize: Dimensions.fontSizeDefault,
                                      color: Theme.of(context).hintColor,
                                      fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeSmall),
                            Expanded(
                                child: Divider(
                                    color: Theme.of(context).hintColor)),
                          ],
                        ),

                      if (configModel
                              .customerLogin?.loginOption?.socialMediaLogin ==
                          1) ...[
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        const Center(child: SocialLoginWidget()),
                      ],
                      //Center(child: Text(getTranslated('OR', context)!, style: poppinsRegular.copyWith(fontSize: 12))),
                      if (!AppConstants.shouldLoginFirst) ...[
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Center(
                          child: InkWell(
                            onTap: () => {
                              if (!authProvider.isLoading)
                                {
                                  authProvider.getGuestIdUrl(),
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const DashBoardScreen()),
                                      (route) => false),
                                }
                            },
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                text:
                                    '${getTranslated('continue_as', context)} ',
                                style: titilliumRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              TextSpan(
                                text: getTranslated('guest', context),
                                style: titilliumRegular.copyWith(
                                  fontSize: Dimensions.fontSizeDefault,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ])),
                          ),
                        ),
                      ]
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
