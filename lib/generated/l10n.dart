// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Mini E-Commerce`
  String get AppName {
    return Intl.message(
      'Mini E-Commerce',
      name: 'AppName',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message(
      'Pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `add`
  String get adding {
    return Intl.message(
      'add',
      name: 'adding',
      desc: '',
      args: [],
    );
  }

  /// `Update Available`
  String get updateAvailable {
    return Intl.message(
      'Update Available',
      name: 'updateAvailable',
      desc: '',
      args: [],
    );
  }

  /// `You must update the app to continue using it.`
  String get youMustupdate {
    return Intl.message(
      'You must update the app to continue using it.',
      name: 'youMustupdate',
      desc: '',
      args: [],
    );
  }

  /// `Update Now`
  String get updateNow {
    return Intl.message(
      'Update Now',
      name: 'updateNow',
      desc: '',
      args: [],
    );
  }

  /// `Contact the Seller`
  String get contactTheSeller {
    return Intl.message(
      'Contact the Seller',
      name: 'contactTheSeller',
      desc: '',
      args: [],
    );
  }

  /// `Continue as Guest`
  String get guest {
    return Intl.message(
      'Continue as Guest',
      name: 'guest',
      desc: '',
      args: [],
    );
  }

  /// `Your Wish List`
  String get yourWishList {
    return Intl.message(
      'Your Wish List',
      name: 'yourWishList',
      desc: '',
      args: [],
    );
  }

  /// `You must log in`
  String get youmustlogin {
    return Intl.message(
      'You must log in',
      name: 'youmustlogin',
      desc: '',
      args: [],
    );
  }

  /// `Add to Cart`
  String get addToCart {
    return Intl.message(
      'Add to Cart',
      name: 'addToCart',
      desc: '',
      args: [],
    );
  }

  /// `ON SALE`
  String get onsale {
    return Intl.message(
      'ON SALE',
      name: 'onsale',
      desc: '',
      args: [],
    );
  }

  /// `pieces for`
  String get piecesFor {
    return Intl.message(
      'pieces for',
      name: 'piecesFor',
      desc: '',
      args: [],
    );
  }

  /// `% OFF ON SALE`
  String get off {
    return Intl.message(
      '% OFF ON SALE',
      name: 'off',
      desc: '',
      args: [],
    );
  }

  /// `EGP`
  String get EGP {
    return Intl.message(
      'EGP',
      name: 'EGP',
      desc: '',
      args: [],
    );
  }

  /// `Your order is yet to be delivered`
  String get yourorderisyettobedelivered {
    return Intl.message(
      'Your order is yet to be delivered',
      name: 'yourorderisyettobedelivered',
      desc: '',
      args: [],
    );
  }

  /// `Your order has been delivered, you are yet to sign.`
  String get yourorderhasbeendelivered {
    return Intl.message(
      'Your order has been delivered, you are yet to sign.',
      name: 'yourorderhasbeendelivered',
      desc: '',
      args: [],
    );
  }

  /// `Received`
  String get received {
    return Intl.message(
      'Received',
      name: 'received',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message(
      'Completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get delivered {
    return Intl.message(
      'Delivered',
      name: 'delivered',
      desc: '',
      args: [],
    );
  }

  /// `Your order has been delivered and signed by you`
  String get yourorderhas {
    return Intl.message(
      'Your order has been delivered and signed by you',
      name: 'yourorderhas',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'readandsignedbyyou!' key

  /// `Contact information`
  String get UserInformation {
    return Intl.message(
      'Contact information',
      name: 'UserInformation',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email`
  String get EnteraValidEmail {
    return Intl.message(
      'Enter a valid email',
      name: 'EnteraValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get Favorites {
    return Intl.message(
      'Favorites',
      name: 'Favorites',
      desc: '',
      args: [],
    );
  }

  /// `Requests`
  String get requests {
    return Intl.message(
      'Requests',
      name: 'requests',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `account`
  String get account {
    return Intl.message(
      'account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Hello World`
  String get helloWorld {
    return Intl.message(
      'Hello World',
      name: 'helloWorld',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get login {
    return Intl.message(
      'Sign In',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signup {
    return Intl.message(
      'Sign Up',
      name: 'signup',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Pay`
  String get pay {
    return Intl.message(
      'Pay',
      name: 'pay',
      desc: '',
      args: [],
    );
  }

  /// `Search Ana Falah `
  String get SearchAnaFalaheg {
    return Intl.message(
      'Search Ana Falah ',
      name: 'SearchAnaFalaheg',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `See All Orders`
  String get seeAll {
    return Intl.message(
      'See All Orders',
      name: 'seeAll',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enterEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `Your Cart Is Empty`
  String get yourCartIsEmpty {
    return Intl.message(
      'Your Cart Is Empty',
      name: 'yourCartIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get wallet {
    return Intl.message(
      'Wallet',
      name: 'wallet',
      desc: '',
      args: [],
    );
  }

  /// `Transactions`
  String get transactions {
    return Intl.message(
      'Transactions',
      name: 'transactions',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message(
      'Dark Mode',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Light Mode`
  String get lightMode {
    return Intl.message(
      'Light Mode',
      name: 'lightMode',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message(
      'About Us',
      name: 'aboutUs',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message(
      'Contact Us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Service`
  String get termsOfService {
    return Intl.message(
      'Terms of Service',
      name: 'termsOfService',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `No orders listed now`
  String get noOrdersListedNow {
    return Intl.message(
      'No orders listed now',
      name: 'noOrdersListedNow',
      desc: '',
      args: [],
    );
  }

  /// `All orders are done`
  String get allOrdersAreDone {
    return Intl.message(
      'All orders are done',
      name: 'allOrdersAreDone',
      desc: '',
      args: [],
    );
  }

  /// `My Orders`
  String get orders {
    return Intl.message(
      'My Orders',
      name: 'orders',
      desc: '',
      args: [],
    );
  }

  /// `My Wallet`
  String get myWallet {
    return Intl.message(
      'My Wallet',
      name: 'myWallet',
      desc: '',
      args: [],
    );
  }

  /// `Wallet balance`
  String get walletBalance {
    return Intl.message(
      'Wallet balance',
      name: 'walletBalance',
      desc: '',
      args: [],
    );
  }

  /// `Recent Transactions`
  String get recentTransactions {
    return Intl.message(
      'Recent Transactions',
      name: 'recentTransactions',
      desc: '',
      args: [],
    );
  }

  /// `Add Money`
  String get addMoney {
    return Intl.message(
      'Add Money',
      name: 'addMoney',
      desc: '',
      args: [],
    );
  }

  /// `Transfer Money`
  String get transferMoney {
    return Intl.message(
      'Transfer Money',
      name: 'transferMoney',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure that you will deliver the ORDER?`
  String get areYouSureDeliverOrder {
    return Intl.message(
      'Are you sure that you will deliver the ORDER?',
      name: 'areYouSureDeliverOrder',
      desc: '',
      args: [],
    );
  }

  /// `Veiw order detials`
  String get veiwOrderDetials {
    return Intl.message(
      'Veiw order detials',
      name: 'veiwOrderDetials',
      desc: '',
      args: [],
    );
  }

  /// `Order Date`
  String get orderDate {
    return Intl.message(
      'Order Date',
      name: 'orderDate',
      desc: '',
      args: [],
    );
  }

  /// `Order Id`
  String get orderId {
    return Intl.message(
      'Order Id',
      name: 'orderId',
      desc: '',
      args: [],
    );
  }

  /// `EGP`
  String get egp {
    return Intl.message(
      'EGP',
      name: 'egp',
      desc: '',
      args: [],
    );
  }

  /// `Price:`
  String get price {
    return Intl.message(
      'Price:',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Address:`
  String get address {
    return Intl.message(
      'Address:',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get product {
    return Intl.message(
      'Products',
      name: 'product',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Detials`
  String get purchaseDetials {
    return Intl.message(
      'Purchase Detials',
      name: 'purchaseDetials',
      desc: '',
      args: [],
    );
  }

  /// `Tracking`
  String get tracking {
    return Intl.message(
      'Tracking',
      name: 'tracking',
      desc: '',
      args: [],
    );
  }

  /// `km`
  String get km {
    return Intl.message(
      'km',
      name: 'km',
      desc: '',
      args: [],
    );
  }

  /// `Qty`
  String get qty {
    return Intl.message(
      'Qty',
      name: 'qty',
      desc: '',
      args: [],
    );
  }

  /// `Login failed`
  String get loginFailed {
    return Intl.message(
      'Login failed',
      name: 'loginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load balance`
  String get failedToLoadBalance {
    return Intl.message(
      'Failed to load balance',
      name: 'failedToLoadBalance',
      desc: '',
      args: [],
    );
  }

  /// `Transaction`
  String get transaction {
    return Intl.message(
      'Transaction',
      name: 'transaction',
      desc: '',
      args: [],
    );
  }

  /// `Transaction Details`
  String get transactionDetails {
    return Intl.message(
      'Transaction Details',
      name: 'transactionDetails',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `The Image has been uploaded successfully`
  String get imageUploadedSuccessfully {
    return Intl.message(
      'The Image has been uploaded successfully',
      name: 'imageUploadedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Driver Signup`
  String get driverSignup {
    return Intl.message(
      'Driver Signup',
      name: 'driverSignup',
      desc: '',
      args: [],
    );
  }

  /// `ID number`
  String get idNumber {
    return Intl.message(
      'ID number',
      name: 'idNumber',
      desc: '',
      args: [],
    );
  }

  /// `Add Front of ID photo`
  String get addFrontIdPhoto {
    return Intl.message(
      'Add Front of ID photo',
      name: 'addFrontIdPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Add Back of ID photo`
  String get addBackIdPhoto {
    return Intl.message(
      'Add Back of ID photo',
      name: 'addBackIdPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Add Driving License photo`
  String get addDrivingLicensePhoto {
    return Intl.message(
      'Add Driving License photo',
      name: 'addDrivingLicensePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Go to Sign In Page`
  String get goToSignInPage {
    return Intl.message(
      'Go to Sign In Page',
      name: 'goToSignInPage',
      desc: '',
      args: [],
    );
  }

  /// `By creating an account, you agree to our Privacy policy and Terms of use.`
  String get agreePrivacyPolicyTerms {
    return Intl.message(
      'By creating an account, you agree to our Privacy policy and Terms of use.',
      name: 'agreePrivacyPolicyTerms',
      desc: '',
      args: [],
    );
  }

  /// `Rate App`
  String get rateApp {
    return Intl.message(
      'Rate App',
      name: 'rateApp',
      desc: '',
      args: [],
    );
  }

  /// `+20`
  String get plus20 {
    return Intl.message(
      '+20',
      name: 'plus20',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the code sent to`
  String get pleaseEnterCodeSentTo {
    return Intl.message(
      'Please enter the code sent to',
      name: 'pleaseEnterCodeSentTo',
      desc: '',
      args: [],
    );
  }

  /// `Choose Image Source`
  String get chooseImageSource {
    return Intl.message(
      'Choose Image Source',
      name: 'chooseImageSource',
      desc: '',
      args: [],
    );
  }

  /// `Take Photo`
  String get takePhoto {
    return Intl.message(
      'Take Photo',
      name: 'takePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Choose from Gallery`
  String get chooseFromGallery {
    return Intl.message(
      'Choose from Gallery',
      name: 'chooseFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Name is very short`
  String get nameIsVeryShort {
    return Intl.message(
      'Name is very short',
      name: 'nameIsVeryShort',
      desc: '',
      args: [],
    );
  }

  /// `Please enter more than 8 characters`
  String get pleaseEnterMoreThan8Characters {
    return Intl.message(
      'Please enter more than 8 characters',
      name: 'pleaseEnterMoreThan8Characters',
      desc: '',
      args: [],
    );
  }

  /// `Resend code after`
  String get resendCodeAfter {
    return Intl.message(
      'Resend code after',
      name: 'resendCodeAfter',
      desc: '',
      args: [],
    );
  }

  /// `Short Password`
  String get shortPassword {
    return Intl.message(
      'Short Password',
      name: 'shortPassword',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Order placed successfully`
  String get successOrder {
    return Intl.message(
      'Order placed successfully',
      name: 'successOrder',
      desc: '',
      args: [],
    );
  }

  /// `Name can only contain letters and spaces.`
  String get nameCanOnlyContainLettersAndSpaces {
    return Intl.message(
      'Name can only contain letters and spaces.',
      name: 'nameCanOnlyContainLettersAndSpaces',
      desc: '',
      args: [],
    );
  }

  /// `Name must be at least 2 characters long.`
  String get nameMustBeAtLeast2CharactersLong {
    return Intl.message(
      'Name must be at least 2 characters long.',
      name: 'nameMustBeAtLeast2CharactersLong',
      desc: '',
      args: [],
    );
  }

  /// `Address must be at least 10 characters long.`
  String get addressMustBeAtLeast10CharactersLong {
    return Intl.message(
      'Address must be at least 10 characters long.',
      name: 'addressMustBeAtLeast10CharactersLong',
      desc: '',
      args: [],
    );
  }

  /// `Name is required.`
  String get nameIsRequired {
    return Intl.message(
      'Name is required.',
      name: 'nameIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty.`
  String get passwordCannotBeEmpty {
    return Intl.message(
      'Password cannot be empty.',
      name: 'passwordCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters long.`
  String get passwordMustBeAtLeast8CharactersLong {
    return Intl.message(
      'Password must be at least 8 characters long.',
      name: 'passwordMustBeAtLeast8CharactersLong',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one uppercase letter.`
  String get passwordMustContainAtLeastOneUppercaseLetter {
    return Intl.message(
      'Password must contain at least one uppercase letter.',
      name: 'passwordMustContainAtLeastOneUppercaseLetter',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one lowercase letter.`
  String get passwordMustContainAtLeastOneLowercaseLetter {
    return Intl.message(
      'Password must contain at least one lowercase letter.',
      name: 'passwordMustContainAtLeastOneLowercaseLetter',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one number.`
  String get passwordMustContainAtLeastOneNumber {
    return Intl.message(
      'Password must contain at least one number.',
      name: 'passwordMustContainAtLeastOneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Password must contain at least one special character.`
  String get passwordMustContainAtLeastOneSpecialCharacter {
    return Intl.message(
      'Password must contain at least one special character.',
      name: 'passwordMustContainAtLeastOneSpecialCharacter',
      desc: '',
      args: [],
    );
  }

  /// `Action confirmed!`
  String get actionConfirmed {
    return Intl.message(
      'Action confirmed!',
      name: 'actionConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match.`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match.',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `National ID must be 14 digits.`
  String get nationalIdMustBe14Digits {
    return Intl.message(
      'National ID must be 14 digits.',
      name: 'nationalIdMustBe14Digits',
      desc: '',
      args: [],
    );
  }

  /// `National ID is required.`
  String get nationalIdIsRequired {
    return Intl.message(
      'National ID is required.',
      name: 'nationalIdIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `Please upload all required images.`
  String get pleaseUploadAllImages {
    return Intl.message(
      'Please upload all required images.',
      name: 'pleaseUploadAllImages',
      desc: '',
      args: [],
    );
  }

  /// `Image size should not exceed`
  String get imageTooLarge {
    return Intl.message(
      'Image size should not exceed',
      name: 'imageTooLarge',
      desc: '',
      args: [],
    );
  }

  /// `MB`
  String get mb {
    return Intl.message(
      'MB',
      name: 'mb',
      desc: '',
      args: [],
    );
  }

  /// `Request Cashout`
  String get requestCashout {
    return Intl.message(
      'Request Cashout',
      name: 'requestCashout',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Account Number`
  String get accountNumber {
    return Intl.message(
      'Account Number',
      name: 'accountNumber',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Number`
  String get receiverNumber {
    return Intl.message(
      'Receiver Number',
      name: 'receiverNumber',
      desc: '',
      args: [],
    );
  }

  /// `Receiver Name`
  String get receiverName {
    return Intl.message(
      'Receiver Name',
      name: 'receiverName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter amount`
  String get pleaseEnterAmount {
    return Intl.message(
      'Please enter amount',
      name: 'pleaseEnterAmount',
      desc: '',
      args: [],
    );
  }

  /// `Please select payment method`
  String get pleaseSelectPaymentMethod {
    return Intl.message(
      'Please select payment method',
      name: 'pleaseSelectPaymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Account Number (optional)`
  String get accountNumberOptional {
    return Intl.message(
      'Account Number (optional)',
      name: 'accountNumberOptional',
      desc: '',
      args: [],
    );
  }

  /// `Please enter receiver number`
  String get pleaseEnterReceiverNumber {
    return Intl.message(
      'Please enter receiver number',
      name: 'pleaseEnterReceiverNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter receiver name`
  String get pleaseEnterReceiverName {
    return Intl.message(
      'Please enter receiver name',
      name: 'pleaseEnterReceiverName',
      desc: '',
      args: [],
    );
  }

  /// `No transactions available`
  String get noTransactionsAvailable {
    return Intl.message(
      'No transactions available',
      name: 'noTransactionsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Type:`
  String get transactionType {
    return Intl.message(
      'Type:',
      name: 'transactionType',
      desc: '',
      args: [],
    );
  }

  /// `Status:`
  String get transactionStatus {
    return Intl.message(
      'Status:',
      name: 'transactionStatus',
      desc: '',
      args: [],
    );
  }

  /// `Date:`
  String get transactionDate {
    return Intl.message(
      'Date:',
      name: 'transactionDate',
      desc: '',
      args: [],
    );
  }

  /// `Cash On Delivery`
  String get cashOnDelivery {
    return Intl.message(
      'Cash On Delivery',
      name: 'cashOnDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get paid {
    return Intl.message(
      'Paid',
      name: 'paid',
      desc: '',
      args: [],
    );
  }

  /// `Card`
  String get card {
    return Intl.message(
      'Card',
      name: 'card',
      desc: '',
      args: [],
    );
  }

  /// `OTP must be exactly 6 digits`
  String get OTPmustBeExactly6Digits {
    return Intl.message(
      'OTP must be exactly 6 digits',
      name: 'OTPmustBeExactly6Digits',
      desc: '',
      args: [],
    );
  }

  /// `OTP must contain only numbers`
  String get OTPmustContainOnlynumbers {
    return Intl.message(
      'OTP must contain only numbers',
      name: 'OTPmustContainOnlynumbers',
      desc: '',
      args: [],
    );
  }

  /// `Phone number cannot be empty`
  String get PhoneNumberCannotBeEmpty {
    return Intl.message(
      'Phone number cannot be empty',
      name: 'PhoneNumberCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Phone number must be between 11 and 13 digits and contain only numbers`
  String get PhoneNumberNotMatched {
    return Intl.message(
      'Phone number must be between 11 and 13 digits and contain only numbers',
      name: 'PhoneNumberNotMatched',
      desc: '',
      args: [],
    );
  }

  /// `Email is too long`
  String get EmailIsTooLong {
    return Intl.message(
      'Email is too long',
      name: 'EmailIsTooLong',
      desc: '',
      args: [],
    );
  }

  /// `share`
  String get Share {
    return Intl.message(
      'share',
      name: 'Share',
      desc: '',
      args: [],
    );
  }

  /// `Today's prices`
  String get TodayPrices {
    return Intl.message(
      'Today\'s prices',
      name: 'TodayPrices',
      desc: '',
      args: [],
    );
  }

  /// `Today's price`
  String get TodayPrice {
    return Intl.message(
      'Today\'s price',
      name: 'TodayPrice',
      desc: '',
      args: [],
    );
  }

  /// `Write your comment...`
  String get WriteYourComment {
    return Intl.message(
      'Write your comment...',
      name: 'WriteYourComment',
      desc: '',
      args: [],
    );
  }

  /// `price`
  String get Pricing {
    return Intl.message(
      'price',
      name: 'Pricing',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to ShopLocal`
  String get welcomeToShopLocal {
    return Intl.message(
      'Welcome to ShopLocal',
      name: 'welcomeToShopLocal',
      desc: '',
      args: [],
    );
  }

  /// `Discover local stores, order groceries, and get fast delivery to your doorstep.`
  String get discoverLocalStores {
    return Intl.message(
      'Discover local stores, order groceries, and get fast delivery to your doorstep.',
      name: 'discoverLocalStores',
      desc: '',
      args: [],
    );
  }

  /// `Start Shopping`
  String get startShopping {
    return Intl.message(
      'Start Shopping',
      name: 'startShopping',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message(
      'Sign in',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Shop by Category`
  String get shopByCategory {
    return Intl.message(
      'Shop by Category',
      name: 'shopByCategory',
      desc: '',
      args: [],
    );
  }

  /// `Featured Stores`
  String get featuredStores {
    return Intl.message(
      'Featured Stores',
      name: 'featuredStores',
      desc: '',
      args: [],
    );
  }

  /// `Quick Actions`
  String get quickActions {
    return Intl.message(
      'Quick Actions',
      name: 'quickActions',
      desc: '',
      args: [],
    );
  }

  /// `Deals`
  String get deals {
    return Intl.message(
      'Deals',
      name: 'deals',
      desc: '',
      args: [],
    );
  }

  /// `Special offers`
  String get specialOffers {
    return Intl.message(
      'Special offers',
      name: 'specialOffers',
      desc: '',
      args: [],
    );
  }

  /// `Top Rated`
  String get topRated {
    return Intl.message(
      'Top Rated',
      name: 'topRated',
      desc: '',
      args: [],
    );
  }

  /// `Best stores`
  String get bestStores {
    return Intl.message(
      'Best stores',
      name: 'bestStores',
      desc: '',
      args: [],
    );
  }

  /// `Fast Delivery`
  String get fastDelivery {
    return Intl.message(
      'Fast Delivery',
      name: 'fastDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Quick service`
  String get quickService {
    return Intl.message(
      'Quick service',
      name: 'quickService',
      desc: '',
      args: [],
    );
  }

  /// `My Orders`
  String get myOrders {
    return Intl.message(
      'My Orders',
      name: 'myOrders',
      desc: '',
      args: [],
    );
  }

  /// `Search orders...`
  String get searchOrders {
    return Intl.message(
      'Search orders...',
      name: 'searchOrders',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Sort by`
  String get sortBy {
    return Intl.message(
      'Sort by',
      name: 'sortBy',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Filter by Status`
  String get filterByStatus {
    return Intl.message(
      'Filter by Status',
      name: 'filterByStatus',
      desc: '',
      args: [],
    );
  }

  /// `All Statuses`
  String get allStatuses {
    return Intl.message(
      'All Statuses',
      name: 'allStatuses',
      desc: '',
      args: [],
    );
  }

  /// `Sort Orders`
  String get sortOrders {
    return Intl.message(
      'Sort Orders',
      name: 'sortOrders',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Order`
  String get order {
    return Intl.message(
      'Order',
      name: 'order',
      desc: '',
      args: [],
    );
  }

  /// `Ascending`
  String get ascending {
    return Intl.message(
      'Ascending',
      name: 'ascending',
      desc: '',
      args: [],
    );
  }

  /// `Descending`
  String get descending {
    return Intl.message(
      'Descending',
      name: 'descending',
      desc: '',
      args: [],
    );
  }

  /// `No orders match your filters`
  String get noOrdersMatchFilters {
    return Intl.message(
      'No orders match your filters',
      name: 'noOrdersMatchFilters',
      desc: '',
      args: [],
    );
  }

  /// `Try adjusting your search or filters`
  String get tryAdjustingFilters {
    return Intl.message(
      'Try adjusting your search or filters',
      name: 'tryAdjustingFilters',
      desc: '',
      args: [],
    );
  }

  /// `Order #`
  String get orderNumber {
    return Intl.message(
      'Order #',
      name: 'orderNumber',
      desc: '',
      args: [],
    );
  }

  /// `items`
  String get items {
    return Intl.message(
      'items',
      name: 'items',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Order Information`
  String get orderInformation {
    return Intl.message(
      'Order Information',
      name: 'orderInformation',
      desc: '',
      args: [],
    );
  }

  /// `Order Items`
  String get orderItems {
    return Intl.message(
      'Order Items',
      name: 'orderItems',
      desc: '',
      args: [],
    );
  }

  /// `Pricing`
  String get pricing {
    return Intl.message(
      'Pricing',
      name: 'pricing',
      desc: '',
      args: [],
    );
  }

  /// `Subtotal`
  String get subtotal {
    return Intl.message(
      'Subtotal',
      name: 'subtotal',
      desc: '',
      args: [],
    );
  }

  /// `Shipping`
  String get shipping {
    return Intl.message(
      'Shipping',
      name: 'shipping',
      desc: '',
      args: [],
    );
  }

  /// `Tax`
  String get tax {
    return Intl.message(
      'Tax',
      name: 'tax',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Information`
  String get deliveryInformation {
    return Intl.message(
      'Delivery Information',
      name: 'deliveryInformation',
      desc: '',
      args: [],
    );
  }

  /// `Estimated Delivery`
  String get estimatedDelivery {
    return Intl.message(
      'Estimated Delivery',
      name: 'estimatedDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Rejection Reason`
  String get rejectionReason {
    return Intl.message(
      'Rejection Reason',
      name: 'rejectionReason',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to view your orders`
  String get signInToViewOrders {
    return Intl.message(
      'Sign in to view your orders',
      name: 'signInToViewOrders',
      desc: '',
      args: [],
    );
  }

  /// `Please sign in to access your order history`
  String get pleaseSignInToAccess {
    return Intl.message(
      'Please sign in to access your order history',
      name: 'pleaseSignInToAccess',
      desc: '',
      args: [],
    );
  }

  /// `No orders yet`
  String get noOrdersYet {
    return Intl.message(
      'No orders yet',
      name: 'noOrdersYet',
      desc: '',
      args: [],
    );
  }

  /// `Start shopping to see your orders here`
  String get startShoppingToSeeOrders {
    return Intl.message(
      'Start shopping to see your orders here',
      name: 'startShoppingToSeeOrders',
      desc: '',
      args: [],
    );
  }

  /// `No orders match your filters`
  String get noOrdersMatchYourFilters {
    return Intl.message(
      'No orders match your filters',
      name: 'noOrdersMatchYourFilters',
      desc: '',
      args: [],
    );
  }

  /// `Try adjusting your search or filters`
  String get tryAdjustingSearchOrFilters {
    return Intl.message(
      'Try adjusting your search or filters',
      name: 'tryAdjustingSearchOrFilters',
      desc: '',
      args: [],
    );
  }

  /// `Hello Again!`
  String get helloAgain {
    return Intl.message(
      'Hello Again!',
      name: 'helloAgain',
      desc: '',
      args: [],
    );
  }

  /// `Let's get you shopping`
  String get letsGetYouShopping {
    return Intl.message(
      'Let\'s get you shopping',
      name: 'letsGetYouShopping',
      desc: '',
      args: [],
    );
  }

  /// `Enter valid email`
  String get enterValidEmail {
    return Intl.message(
      'Enter valid email',
      name: 'enterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Minimum 6 characters`
  String get minimum6Characters {
    return Intl.message(
      'Minimum 6 characters',
      name: 'minimum6Characters',
      desc: '',
      args: [],
    );
  }

  /// `Or login with`
  String get orLoginWith {
    return Intl.message(
      'Or login with',
      name: 'orLoginWith',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get signInWithGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'signInWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Continue as a guest`
  String get continueAsGuest {
    return Intl.message(
      'Continue as a guest',
      name: 'continueAsGuest',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message(
      'Sign up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Guest users cannot place orders. Please sign in to continue.`
  String get guestUsersCannotPlaceOrders {
    return Intl.message(
      'Guest users cannot place orders. Please sign in to continue.',
      name: 'guestUsersCannotPlaceOrders',
      desc: '',
      args: [],
    );
  }

  /// `Guest login successful with ID:`
  String get guestLoginSuccessful {
    return Intl.message(
      'Guest login successful with ID:',
      name: 'guestLoginSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Guest login failed:`
  String get guestLoginFailed {
    return Intl.message(
      'Guest login failed:',
      name: 'guestLoginFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please sign in to access your order history`
  String get pleaseSignInToAccessOrderHistory {
    return Intl.message(
      'Please sign in to access your order history',
      name: 'pleaseSignInToAccessOrderHistory',
      desc: '',
      args: [],
    );
  }

  /// `Start shopping to see your orders here`
  String get startShoppingToSeeOrdersHere {
    return Intl.message(
      'Start shopping to see your orders here',
      name: 'startShoppingToSeeOrdersHere',
      desc: '',
      args: [],
    );
  }

  /// `Accepted`
  String get accepted {
    return Intl.message(
      'Accepted',
      name: 'accepted',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get rejected {
    return Intl.message(
      'Rejected',
      name: 'rejected',
      desc: '',
      args: [],
    );
  }

  /// `Preparing`
  String get preparing {
    return Intl.message(
      'Preparing',
      name: 'preparing',
      desc: '',
      args: [],
    );
  }

  /// `Out for Delivery`
  String get outForDelivery {
    return Intl.message(
      'Out for Delivery',
      name: 'outForDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get cancelled {
    return Intl.message(
      'Cancelled',
      name: 'cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up to get started`
  String get signUpToGetStarted {
    return Intl.message(
      'Sign up to get started',
      name: 'signUpToGetStarted',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Enter name`
  String get enterName {
    return Intl.message(
      'Enter name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Or sign up with`
  String get orSignUpWith {
    return Intl.message(
      'Or sign up with',
      name: 'orSignUpWith',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Email is already in use.`
  String get emailAlreadyInUse {
    return Intl.message(
      'Email is already in use.',
      name: 'emailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `Password should be at least 6 characters.`
  String get weakPassword {
    return Intl.message(
      'Password should be at least 6 characters.',
      name: 'weakPassword',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email address.`
  String get invalidEmail {
    return Intl.message(
      'Invalid email address.',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get anErrorOccurred {
    return Intl.message(
      'An error occurred',
      name: 'anErrorOccurred',
      desc: '',
      args: [],
    );
  }

  /// `Google`
  String get google {
    return Intl.message(
      'Google',
      name: 'google',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
