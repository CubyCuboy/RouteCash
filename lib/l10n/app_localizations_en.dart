// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Route Cash';

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
  String get invalidEmail => 'Invalid email or domain not allowed';

  @override
  String get weakPassword => 'Password must have at least 8 characters, one uppercase, one number and one special character';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get errorInvalidCredentials => 'Invalid email or password';

  @override
  String get errorUserExists => 'User already exists';

  @override
  String get errorUnexpected => 'An unexpected error occurred';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordHint => '••••••••••';

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

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLabel => 'SETTINGS';

  @override
  String get profileEditTitle => 'Edit Profile';

  @override
  String get phoneLabel => 'PHONE';

  @override
  String get countryLabel => 'COUNTRY';

  @override
  String get stateLabel => 'STATE';

  @override
  String get mainCurrencyLabel => 'MAIN CURRENCY';

  @override
  String get saveChanges => 'SAVE CHANGES';

  @override
  String get accountLinking => 'ACCOUNT LINKING';

  @override
  String get linked => 'Linked';

  @override
  String get link => 'Link';

  @override
  String get changeAccount => 'Change account';

  @override
  String get security => 'SECURITY';

  @override
  String get verifyPhone => 'Verify Phone';

  @override
  String get notVerified => 'Not verified';

  @override
  String get changePassword => 'Change Password';

  @override
  String get changeEmail => 'Change Email';

  @override
  String get preferences => 'PREFERENCES';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get logout => 'LOG OUT';

  @override
  String get verifyingEmailBadge => 'Verify Email';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get confirmLanguageChange => 'Do you want to change the application language?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get currentEmail => 'CURRENT EMAIL';

  @override
  String get newEmail => 'NEW EMAIL';

  @override
  String get newPassword => 'NEW PASSWORD';

  @override
  String get update => 'UPDATE';

  @override
  String get successLinking => 'Success!';

  @override
  String get successLinkingMessage => 'Your Google account has been successfully linked. You can now sign in with it.';

  @override
  String get unlinkAccountTitle => 'Unlink account';

  @override
  String get unlinkAccountMessage => 'Are you sure you want to unlink your Google account? You can relink it at any time.';

  @override
  String get unlink => 'Unlink';

  @override
  String get enterCode => 'ENTER THE CODE';

  @override
  String get verifyYourAccount => 'Verify\nyour account.';

  @override
  String codeSentTo(String email) {
    return 'We have sent a code to $email';
  }

  @override
  String get sixDigitCode => '6-DIGIT CODE';

  @override
  String timeRemaining(String time) {
    return 'Time remaining: $time';
  }

  @override
  String attemptsRemainingLabel(int count) {
    return 'Attempts remaining: $count';
  }

  @override
  String get resendCode => 'RESEND CODE';

  @override
  String get resend => 'Resend';

  @override
  String get verify => 'Verify';

  @override
  String get nfcStatusIdle => 'Bring the card closer to the reader...';

  @override
  String get nfcStatusDetected => 'Card detected! Keep the card held...';

  @override
  String get nfcStatusReadingConfig => 'Reading configuration... Do not remove the card.';

  @override
  String get nfcStatusRetrievingData => 'Retrieving data... Almost done.';

  @override
  String get nfcStatusSuccess => 'Reading completed successfully.';

  @override
  String get nfcErrorAvailability => 'NFC is not available or is disabled.';

  @override
  String get nfcErrorSessionActive => 'A reading is already in progress.';

  @override
  String get nfcErrorPpse => 'Error initiating contact with the card.';

  @override
  String get nfcErrorIncompatible => 'This card is not compatible with the payment standard.';

  @override
  String get nfcErrorNoAid => 'No compatible payment application found.';

  @override
  String get nfcErrorAidAccess => 'The card did not allow access to the data.';

  @override
  String get nfcErrorRetrieveFail => 'Could not retrieve the data, please try again.';

  @override
  String get nfcTimeout => 'Time out. Please bring the card closer again.';

  @override
  String get nfcCancel => 'NFC reading canceled.';

  @override
  String get selectBank => 'Select your bank';

  @override
  String get selectAccountType => 'Select account type';

  @override
  String get cardNumberLabel => 'Card Number';

  @override
  String get expiryDateLabel => 'Expiry Date';

  @override
  String get saveCard => 'Save Card';

  @override
  String get invalidCardNumber => 'The card number is invalid.';

  @override
  String get invalidExpiryDate => 'The expiry date is invalid.';

  @override
  String get errorRequiredFields => 'You must complete all fields to continue.';
}
