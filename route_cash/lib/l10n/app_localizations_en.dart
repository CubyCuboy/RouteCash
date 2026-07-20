// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'RouteCash';

  @override
  String get financialSpace => 'Your financial space';

  @override
  String get moneyWithMeaning => 'Money\nwith purpose.';

  @override
  String get signIn => 'Sign in';

  @override
  String get signInWithOutlook => 'Sign in with Outlook';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get signInWithApple => 'Sign in with Apple';

  @override
  String get newUserCreateAccount => 'New here? Create an account';

  @override
  String get setupProgress => '3 / 3';

  @override
  String get yourAccountsLabel => 'YOUR ACCOUNTS';

  @override
  String get accountsSetupTitle => 'Everything important,\ntogether.';

  @override
  String get accountsSetupDescription => 'Connect an account or add one manually.\nYou can always do it later.';

  @override
  String get horizonBank => 'Horizon Bank';

  @override
  String get connectSecurely => 'Connect securely';

  @override
  String get addManually => 'Add manually';

  @override
  String get manualAccountTypes => 'Cash, card or investment';

  @override
  String get skipForNow => 'Skip for now';

  @override
  String get bankConnectionMessage => 'Starting secure bank connection';

  @override
  String get manualAccountMessage => 'Preparing manual account setup';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get homeYourRoute => 'Your route';

  @override
  String get availableBalanceLabel => 'AVAILABLE BALANCE';

  @override
  String movementCountLabel(int count) {
    return '$count / TRANSACTION';
  }

  @override
  String balanceMoreThanMonth(num percentage, String month) {
    return '$percentage% more than $month';
  }

  @override
  String get viewAll => 'View all';

  @override
  String get activitySummary => 'Activity summary';

  @override
  String get navHome => 'Home';

  @override
  String get navMovements => 'Transactions';

  @override
  String get navCards => 'Cards';

  @override
  String get navProfile => 'Profile';

  @override
  String get loginWelcomeLabel => 'GOOD TO SEE YOU';

  @override
  String get loginTitle => 'Return to\nyour route.';

  @override
  String get emailLabel => 'EMAIL ADDRESS';

  @override
  String get passwordLabel => 'PASSWORD';

  @override
  String get forgotPassword => 'I forgot my password';

  @override
  String get passwordRecoveryMessage => 'Password recovery will open here';

  @override
  String get noAccountRegister => 'Don\'t have an account? Sign up';

  @override
  String get onboardingSubtitle => 'Your finances in\none place';

  @override
  String get continueButton => 'Continue';

  @override
  String get registerProgress => '1 / 3';

  @override
  String get firstStepLabel => 'FIRST STEP';

  @override
  String get registerTitle => 'It starts\nwith you.';

  @override
  String get registerDescription => 'Create your personal space to save and\nunderstand every transaction.';

  @override
  String get fullNameLabel => 'FULL NAME';

  @override
  String get termsAndPrivacy => 'By continuing, you accept our terms and privacy policy.';

  @override
  String get selectMonth => 'Select month';

  @override
  String get reportTitle => 'Report';

  @override
  String get monthInNumbers => 'Your month in numbers.';

  @override
  String get monthlyBalanceLabel => 'MONTHLY BALANCE';

  @override
  String get weeklyFlow => 'Weekly flow';

  @override
  String get expensesAndIncome => 'Expenses / Income';

  @override
  String get mostSpent => 'Top spending';

  @override
  String get viewCategories => 'View categories';

  @override
  String get monthJanuary => 'January';

  @override
  String get monthFebruary => 'February';

  @override
  String get monthMarch => 'March';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'May';

  @override
  String get monthJune => 'June';

  @override
  String get monthJuly => 'July';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'October';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'December';

  @override
  String get expenseCategoryShopping => 'Shopping';

  @override
  String get expenseCategoryHousing => 'Housing';

  @override
  String get expenseCategoryFood => 'Food';

  @override
  String get expenseCategoryTransport => 'Transport';

  @override
  String get expenseCategoryServices => 'Services';

  @override
  String get expenseCategoryEntertainment => 'Entertainment';

  @override
  String get movementElectricityPayment => 'Electricity payment';

  @override
  String get movementWaterPayment => 'Water payment';

  @override
  String get movementRentPayment => 'Rent payment';

  @override
  String movementTodayAt(String time) {
    return 'Today · $time';
  }

  @override
  String movementYesterdayAt(String time) {
    return 'Yesterday · $time';
  }
}
