import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Route Cash'**
  String get appName;

  /// No description provided for @financialSpace.
  ///
  /// In en, this message translates to:
  /// **'Your financial space'**
  String get financialSpace;

  /// No description provided for @moneyWithMeaning.
  ///
  /// In en, this message translates to:
  /// **'Money\nwith purpose.'**
  String get moneyWithMeaning;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signInWithOutlook.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Outlook'**
  String get signInWithOutlook;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @signInWithApple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get signInWithApple;

  /// No description provided for @newUserCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'New here? Create an account'**
  String get newUserCreateAccount;

  /// No description provided for @setupProgress.
  ///
  /// In en, this message translates to:
  /// **'3 / 3'**
  String get setupProgress;

  /// No description provided for @yourAccountsLabel.
  ///
  /// In en, this message translates to:
  /// **'YOUR ACCOUNTS'**
  String get yourAccountsLabel;

  /// No description provided for @accountsSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Everything important,\ntogether.'**
  String get accountsSetupTitle;

  /// No description provided for @accountsSetupDescription.
  ///
  /// In en, this message translates to:
  /// **'Connect an account or add one manually.\nYou can always do it later.'**
  String get accountsSetupDescription;

  /// No description provided for @horizonBank.
  ///
  /// In en, this message translates to:
  /// **'Horizon Bank'**
  String get horizonBank;

  /// No description provided for @connectSecurely.
  ///
  /// In en, this message translates to:
  /// **'Connect securely'**
  String get connectSecurely;

  /// No description provided for @addManually.
  ///
  /// In en, this message translates to:
  /// **'Add manually'**
  String get addManually;

  /// No description provided for @manualAccountTypes.
  ///
  /// In en, this message translates to:
  /// **'Cash, card or investment'**
  String get manualAccountTypes;

  /// No description provided for @skipForNow.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get skipForNow;

  /// No description provided for @bankConnectionMessage.
  ///
  /// In en, this message translates to:
  /// **'Starting secure bank connection'**
  String get bankConnectionMessage;

  /// No description provided for @manualAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'Preparing manual account setup'**
  String get manualAccountMessage;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or domain not allowed'**
  String get invalidEmail;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must have at least 8 characters, one uppercase, one number and one special character'**
  String get weakPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get errorInvalidCredentials;

  /// No description provided for @errorUserExists.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get errorUserExists;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get errorInvalidEmail;

  /// No description provided for @errorPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password is too short'**
  String get errorPasswordTooShort;

  /// No description provided for @errorRegistrationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Registration is temporarily disabled'**
  String get errorRegistrationDisabled;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection'**
  String get errorNetwork;

  /// No description provided for @errorUnexpected.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get errorUnexpected;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••••'**
  String get confirmPasswordHint;

  /// Greeting displayed on the home screen
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeYourRoute.
  ///
  /// In en, this message translates to:
  /// **'Your route'**
  String get homeYourRoute;

  /// No description provided for @availableBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE BALANCE'**
  String get availableBalanceLabel;

  /// Number of transactions displayed on the home screen
  ///
  /// In en, this message translates to:
  /// **'{count} / TRANSACTION'**
  String movementCountLabel(int count);

  /// Balance comparison with another month
  ///
  /// In en, this message translates to:
  /// **'{percentage}% more than {month}'**
  String balanceMoreThanMonth(num percentage, String month);

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @activitySummary.
  ///
  /// In en, this message translates to:
  /// **'Activity summary'**
  String get activitySummary;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navMovements.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get navMovements;

  /// No description provided for @navCards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get navCards;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @loginWelcomeLabel.
  ///
  /// In en, this message translates to:
  /// **'GOOD TO SEE YOU'**
  String get loginWelcomeLabel;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Return to\nyour route.'**
  String get loginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'EMAIL ADDRESS'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get passwordLabel;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'I forgot my password'**
  String get forgotPassword;

  /// No description provided for @passwordRecoveryMessage.
  ///
  /// In en, this message translates to:
  /// **'Password recovery will open here'**
  String get passwordRecoveryMessage;

  /// No description provided for @noAccountRegister.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get noAccountRegister;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your finances in\none place'**
  String get onboardingSubtitle;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @registerProgress.
  ///
  /// In en, this message translates to:
  /// **'1 / 3'**
  String get registerProgress;

  /// No description provided for @firstStepLabel.
  ///
  /// In en, this message translates to:
  /// **'FIRST STEP'**
  String get firstStepLabel;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'It starts\nwith you.'**
  String get registerTitle;

  /// No description provided for @registerDescription.
  ///
  /// In en, this message translates to:
  /// **'Create your personal space to save and\nunderstand every transaction.'**
  String get registerDescription;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'FULL NAME'**
  String get fullNameLabel;

  /// No description provided for @termsAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you accept our terms and privacy policy.'**
  String get termsAndPrivacy;

  /// No description provided for @selectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select month'**
  String get selectMonth;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get reportTitle;

  /// No description provided for @monthInNumbers.
  ///
  /// In en, this message translates to:
  /// **'Your month in numbers.'**
  String get monthInNumbers;

  /// No description provided for @monthlyBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'MONTHLY BALANCE'**
  String get monthlyBalanceLabel;

  /// No description provided for @weeklyFlow.
  ///
  /// In en, this message translates to:
  /// **'Weekly flow'**
  String get weeklyFlow;

  /// No description provided for @expensesAndIncome.
  ///
  /// In en, this message translates to:
  /// **'Expenses / Income'**
  String get expensesAndIncome;

  /// No description provided for @mostSpent.
  ///
  /// In en, this message translates to:
  /// **'Top spending'**
  String get mostSpent;

  /// No description provided for @viewCategories.
  ///
  /// In en, this message translates to:
  /// **'View categories'**
  String get viewCategories;

  /// No description provided for @monthJanuary.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get monthJanuary;

  /// No description provided for @monthFebruary.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get monthFebruary;

  /// No description provided for @monthMarch.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMarch;

  /// No description provided for @monthApril.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApril;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJune.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJune;

  /// No description provided for @monthJuly.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJuly;

  /// No description provided for @monthAugust.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get monthAugust;

  /// No description provided for @monthSeptember.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get monthSeptember;

  /// No description provided for @monthOctober.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get monthOctober;

  /// No description provided for @monthNovember.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get monthNovember;

  /// No description provided for @monthDecember.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get monthDecember;

  /// No description provided for @expenseCategoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get expenseCategoryShopping;

  /// No description provided for @expenseCategoryHousing.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get expenseCategoryHousing;

  /// No description provided for @expenseCategoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get expenseCategoryFood;

  /// No description provided for @expenseCategoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get expenseCategoryTransport;

  /// No description provided for @expenseCategoryServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get expenseCategoryServices;

  /// No description provided for @expenseCategoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get expenseCategoryEntertainment;

  /// No description provided for @movementElectricityPayment.
  ///
  /// In en, this message translates to:
  /// **'Electricity payment'**
  String get movementElectricityPayment;

  /// No description provided for @movementWaterPayment.
  ///
  /// In en, this message translates to:
  /// **'Water payment'**
  String get movementWaterPayment;

  /// No description provided for @movementRentPayment.
  ///
  /// In en, this message translates to:
  /// **'Rent payment'**
  String get movementRentPayment;

  /// Date of a transaction made today
  ///
  /// In en, this message translates to:
  /// **'Today · {time}'**
  String movementTodayAt(String time);

  /// Date of a transaction made yesterday
  ///
  /// In en, this message translates to:
  /// **'Yesterday · {time}'**
  String movementYesterdayAt(String time);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLabel.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsLabel;

  /// No description provided for @profileEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profileEditTitle;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'PHONE'**
  String get phoneLabel;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'COUNTRY'**
  String get countryLabel;

  /// No description provided for @stateLabel.
  ///
  /// In en, this message translates to:
  /// **'STATE'**
  String get stateLabel;

  /// No description provided for @mainCurrencyLabel.
  ///
  /// In en, this message translates to:
  /// **'MAIN CURRENCY'**
  String get mainCurrencyLabel;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'SAVE CHANGES'**
  String get saveChanges;

  /// No description provided for @accountLinking.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT LINKING'**
  String get accountLinking;

  /// No description provided for @linked.
  ///
  /// In en, this message translates to:
  /// **'Linked'**
  String get linked;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @changeAccount.
  ///
  /// In en, this message translates to:
  /// **'Change account'**
  String get changeAccount;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'SECURITY'**
  String get security;

  /// No description provided for @verifyPhone.
  ///
  /// In en, this message translates to:
  /// **'Verify Phone'**
  String get verifyPhone;

  /// No description provided for @notVerified.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get notVerified;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmail;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get preferences;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'LOG OUT'**
  String get logout;

  /// No description provided for @verifyingEmailBadge.
  ///
  /// In en, this message translates to:
  /// **'Verify Email'**
  String get verifyingEmailBadge;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @confirmLanguageChange.
  ///
  /// In en, this message translates to:
  /// **'Do you want to change the application language?'**
  String get confirmLanguageChange;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @currentEmail.
  ///
  /// In en, this message translates to:
  /// **'CURRENT EMAIL'**
  String get currentEmail;

  /// No description provided for @newEmail.
  ///
  /// In en, this message translates to:
  /// **'NEW EMAIL'**
  String get newEmail;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'NEW PASSWORD'**
  String get newPassword;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'UPDATE'**
  String get update;

  /// No description provided for @successLinking.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get successLinking;

  /// No description provided for @successLinkingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your Google account has been successfully linked. You can now sign in with it.'**
  String get successLinkingMessage;

  /// No description provided for @unlinkAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlink account'**
  String get unlinkAccountTitle;

  /// No description provided for @unlinkAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unlink your Google account? You can relink it at any time.'**
  String get unlinkAccountMessage;

  /// No description provided for @unlink.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get unlink;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'ENTER THE CODE'**
  String get enterCode;

  /// No description provided for @verifyYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Verify\nyour account.'**
  String get verifyYourAccount;

  /// No description provided for @codeSentTo.
  ///
  /// In en, this message translates to:
  /// **'We have sent a code to {email}'**
  String codeSentTo(String email);

  /// No description provided for @sixDigitCode.
  ///
  /// In en, this message translates to:
  /// **'6-DIGIT CODE'**
  String get sixDigitCode;

  /// No description provided for @timeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time remaining: {time}'**
  String timeRemaining(String time);

  /// No description provided for @attemptsRemaining.
  ///
  /// In en, this message translates to:
  /// **'Attempts remaining: {count}'**
  String attemptsRemainingLabel(int count);

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'RESEND CODE'**
  String get resendCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @nfcStatusIdle.
  ///
  /// In en, this message translates to:
  /// **'Bring the card closer to the reader...'**
  String get nfcStatusIdle;

  /// No description provided for @nfcStatusDetected.
  ///
  /// In en, this message translates to:
  /// **'Card detected! Keep the card held...'**
  String get nfcStatusDetected;

  /// No description provided for @nfcStatusReadingConfig.
  ///
  /// In en, this message translates to:
  /// **'Reading configuration... Do not remove the card.'**
  String get nfcStatusReadingConfig;

  /// No description provided for @nfcStatusRetrievingData.
  ///
  /// In en, this message translates to:
  /// **'Retrieving data... Almost done.'**
  String get nfcStatusRetrievingData;

  /// No description provided for @nfcStatusSuccess.
  ///
  /// In en, this message translates to:
  /// **'Reading completed successfully.'**
  String get nfcStatusSuccess;

  /// No description provided for @nfcErrorAvailability.
  ///
  /// In en, this message translates to:
  /// **'NFC is not available or is disabled.'**
  String get nfcErrorAvailability;

  /// No description provided for @nfcErrorSessionActive.
  ///
  /// In en, this message translates to:
  /// **'A reading is already in progress.'**
  String get nfcErrorSessionActive;

  /// No description provided for @nfcErrorPpse.
  ///
  /// In en, this message translates to:
  /// **'Error initiating contact with the card.'**
  String get nfcErrorPpse;

  /// No description provided for @nfcErrorIncompatible.
  ///
  /// In en, this message translates to:
  /// **'This card is not compatible with the payment standard.'**
  String get nfcErrorIncompatible;

  /// No description provided for @nfcErrorNoAid.
  ///
  /// In en, this message translates to:
  /// **'No compatible payment application found.'**
  String get nfcErrorNoAid;

  /// No description provided for @nfcErrorAidAccess.
  ///
  /// In en, this message translates to:
  /// **'The card did not allow access to the data.'**
  String get nfcErrorAidAccess;

  /// No description provided for @nfcErrorRetrieveFail.
  ///
  /// In en, this message translates to:
  /// **'Could not retrieve the data, please try again.'**
  String get nfcErrorRetrieveFail;

  /// No description provided for @nfcTimeout.
  ///
  /// In en, this message translates to:
  /// **'Time out. Please bring the card closer again.'**
  String get nfcTimeout;

  /// No description provided for @nfcCancel.
  ///
  /// In en, this message translates to:
  /// **'NFC reading canceled.'**
  String get nfcCancel;

  /// No description provided for @selectBank.
  ///
  /// In en, this message translates to:
  /// **'Select your bank'**
  String get selectBank;

  /// No description provided for @selectAccountType.
  ///
  /// In en, this message translates to:
  /// **'Select account type'**
  String get selectAccountType;

  /// No description provided for @cardNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get cardNumberLabel;

  /// No description provided for @expiryDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDateLabel;

  /// No description provided for @saveCard.
  ///
  /// In en, this message translates to:
  /// **'Save Card'**
  String get saveCard;

  /// No description provided for @invalidCardNumber.
  ///
  /// In en, this message translates to:
  /// **'The card number is invalid.'**
  String get invalidCardNumber;

  /// No description provided for @invalidExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'The expiry date is invalid.'**
  String get invalidExpiryDate;

  /// No description provided for @errorRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'You must complete all fields to continue.'**
  String get errorRequiredFields;

  /// No description provided for @stepLabel.
  ///
  /// In en, this message translates to:
  /// **'STEP {current} OF {total}'**
  String stepLabel(int current, int total);

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Start with\nyou.'**
  String get step1Title;

  /// No description provided for @step1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your personal information to create your space.'**
  String get step1Subtitle;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Where are you\njoining from?'**
  String get step2Title;

  /// No description provided for @step2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'We will adapt rates and formats to your region.'**
  String get step2Subtitle;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'Security and\npreferences.'**
  String get step3Title;

  /// No description provided for @step3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Last step to secure your financial route.'**
  String get step3Subtitle;

  /// No description provided for @fullNamePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g. Andrea Moreno'**
  String get fullNamePlaceholder;

  /// No description provided for @emailPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'email@example.com'**
  String get emailPlaceholder;

  /// No description provided for @phonePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'123456789'**
  String get phonePlaceholder;

  /// No description provided for @phoneCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'CODE'**
  String get phoneCodeLabel;

  /// No description provided for @passwordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'••••••••••'**
  String get passwordPlaceholder;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'NEXT STEP'**
  String get nextStep;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'CREATE MY ACCOUNT'**
  String get createAccount;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhone;

  /// No description provided for @reqMinLength.
  ///
  /// In en, this message translates to:
  /// **'8+ characters'**
  String get reqMinLength;

  /// No description provided for @reqUppercase.
  ///
  /// In en, this message translates to:
  /// **'One uppercase letter'**
  String get reqUppercase;

  /// No description provided for @reqNumber.
  ///
  /// In en, this message translates to:
  /// **'One number'**
  String get reqNumber;

  /// No description provided for @reqSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'Special character (!@#\$)'**
  String get reqSpecialChar;

  /// No description provided for @reqMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords match'**
  String get reqMatch;

  /// No description provided for @changeEmailDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your current email and the new address where you want to receive your notifications.'**
  String get changeEmailDescription;

  /// No description provided for @emailExamplePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailExamplePlaceholder;

  /// No description provided for @newEmailExamplePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'new@email.com'**
  String get newEmailExamplePlaceholder;

  /// No description provided for @keepMeLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'Keep me logged in'**
  String get keepMeLoggedIn;

  /// No description provided for @appleNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Apple sign-in not yet available'**
  String get appleNotConfigured;

  /// No description provided for @googleSessionError.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in with Google'**
  String get googleSessionError;

  /// No description provided for @microsoftSessionError.
  ///
  /// In en, this message translates to:
  /// **'Could not sign in with Outlook'**
  String get microsoftSessionError;

  /// No description provided for @errorGoogleAuth.
  ///
  /// In en, this message translates to:
  /// **'Error connecting with Google: {error}'**
  String errorGoogleAuth(String error);

  /// No description provided for @errorMicrosoftAuth.
  ///
  /// In en, this message translates to:
  /// **'Error connecting with Outlook: {error}'**
  String errorMicrosoftAuth(String error);

  /// No description provided for @errorAuthCancelled.
  ///
  /// In en, this message translates to:
  /// **'Operation cancelled'**
  String get errorAuthCancelled;

  /// No description provided for @errorAuthCancelledDetail.
  ///
  /// In en, this message translates to:
  /// **'You cancelled the sign-in. Try again when you are ready.'**
  String get errorAuthCancelledDetail;

  /// No description provided for @optionalLabel.
  ///
  /// In en, this message translates to:
  /// **'OPTIONAL'**
  String get optionalLabel;

  /// No description provided for @errorCompleteRegistration.
  ///
  /// In en, this message translates to:
  /// **'Please complete your profile to continue.'**
  String get errorCompleteRegistration;

  /// No description provided for @errorNoSession.
  ///
  /// In en, this message translates to:
  /// **'No active session'**
  String get errorNoSession;

  /// No description provided for @errorOldEmailMismatch.
  ///
  /// In en, this message translates to:
  /// **'The old email does not match the registered one'**
  String get errorOldEmailMismatch;

  /// No description provided for @errorInvalidNewEmail.
  ///
  /// In en, this message translates to:
  /// **'The format of the new email is invalid'**
  String get errorInvalidNewEmail;

  /// No description provided for @errorUnlinkOnlyMethod.
  ///
  /// In en, this message translates to:
  /// **'You cannot unlink your only access method. Set up a password first.'**
  String get errorUnlinkOnlyMethod;

  /// No description provided for @errorGoogleLinkExists.
  ///
  /// In en, this message translates to:
  /// **'This Google account is already linked to another user'**
  String get errorGoogleLinkExists;

  /// No description provided for @errorEmailUpdate.
  ///
  /// In en, this message translates to:
  /// **'Error updating email'**
  String get errorEmailUpdate;

  /// No description provided for @errorPasswordUpdate.
  ///
  /// In en, this message translates to:
  /// **'Error updating password'**
  String get errorPasswordUpdate;

  /// No description provided for @errorProfileUpdate.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile'**
  String get errorProfileUpdate;

  /// No description provided for @errorLinkAccount.
  ///
  /// In en, this message translates to:
  /// **'Error linking account'**
  String get errorLinkAccount;

  /// No description provided for @errorUnlinkAccount.
  ///
  /// In en, this message translates to:
  /// **'Error unlinking account'**
  String get errorUnlinkAccount;

  /// No description provided for @errorDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Error deleting account'**
  String get errorDeleteAccount;

  /// No description provided for @successProfileUpdate.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get successProfileUpdate;

  /// No description provided for @successEmailChange.
  ///
  /// In en, this message translates to:
  /// **'Email updated successfully'**
  String get successEmailChange;

  /// No description provided for @successPasswordUpdate.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get successPasswordUpdate;

  /// No description provided for @successAccountLinked.
  ///
  /// In en, this message translates to:
  /// **'Account linked successfully'**
  String get successAccountLinked;

  /// No description provided for @successAccountUnlinked.
  ///
  /// In en, this message translates to:
  /// **'Account unlinked successfully'**
  String get successAccountUnlinked;

  /// No description provided for @providerLabelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get providerLabelEmail;

  /// No description provided for @providerLabelGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get providerLabelGoogle;

  /// No description provided for @providerLabelMicrosoft.
  ///
  /// In en, this message translates to:
  /// **'Microsoft'**
  String get providerLabelMicrosoft;

  /// No description provided for @otpSentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent successfully'**
  String get otpSentSuccess;

  /// No description provided for @verificationLabel.
  ///
  /// In en, this message translates to:
  /// **'VERIFICATION'**
  String get verificationLabel;

  /// No description provided for @confirmAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm your account.'**
  String get confirmAccountTitle;

  /// No description provided for @weWillSendCode.
  ///
  /// In en, this message translates to:
  /// **'We will send a security code to:'**
  String get weWillSendCode;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @successTitle.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get successTitle;

  /// No description provided for @successAccountVerified.
  ///
  /// In en, this message translates to:
  /// **'Your account has been successfully verified. You can now sign in.'**
  String get successAccountVerified;

  /// No description provided for @successAccountLinkedMsg.
  ///
  /// In en, this message translates to:
  /// **'Your account has been successfully linked. You can continue using the application.'**
  String get successAccountLinkedMsg;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get goToLogin;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
