// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Route Cash';

  @override
  String get financialSpace => 'Tu espacio financiero';

  @override
  String get moneyWithMeaning => 'Dinero\ncon propósito.';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signInWithOutlook => 'Iniciar sesión con Outlook';

  @override
  String get signInWithGoogle => 'Iniciar sesión con Google';

  @override
  String get signInWithApple => 'Iniciar sesión con Apple';

  @override
  String get newUserCreateAccount => '¿Nuevo por aquí? Crea una cuenta';

  @override
  String get setupProgress => '3 / 3';

  @override
  String get yourAccountsLabel => 'TUS CUENTAS';

  @override
  String get accountsSetupTitle => 'Todo lo importante,\njunto.';

  @override
  String get accountsSetupDescription => 'Conecta una cuenta o añade una manualmente.\nSiempre puedes hacerlo más tarde.';

  @override
  String get horizonBank => 'Horizon Bank';

  @override
  String get connectSecurely => 'Conectar de forma segura';

  @override
  String get addManually => 'Añadir manualmente';

  @override
  String get manualAccountTypes => 'Efectivo, tarjeta o inversión';

  @override
  String get skipForNow => 'Omitir por ahora';

  @override
  String get bankConnectionMessage => 'Iniciando conexión bancaria segura';

  @override
  String get manualAccountMessage => 'Preparando configuración de cuenta manual';

  @override
  String get invalidEmail => 'Email inválido o dominio no permitido';

  @override
  String get weakPassword => 'La contraseña debe tener al menos 8 caracteres, una mayúscula, un número y un carácter especial';

  @override
  String get passwordsDoNotMatch => 'Las contraseñas no coinciden';

  @override
  String get errorInvalidCredentials => 'Email o contraseña incorrectos';

  @override
  String get errorUserExists => 'Este correo ya está registrado';

  @override
  String get errorUnexpected => 'Ocurrió un error inesperado';

  @override
  String get confirmPasswordLabel => 'Confirmar Contraseña';

  @override
  String get confirmPasswordHint => '••••••••••';

  @override
  String homeGreeting(String name) {
    return 'Hola, $name';
  }

  @override
  String get homeYourRoute => 'Tu ruta';

  @override
  String get availableBalanceLabel => 'SALDO DISPONIBLE';

  @override
  String movementCountLabel(int count) {
    return '$count / TRANSACCIÓN';
  }

  @override
  String balanceMoreThanMonth(num percentage, String month) {
    return '$percentage% más que en $month';
  }

  @override
  String get viewAll => 'Ver todo';

  @override
  String get activitySummary => 'Resumen de actividad';

  @override
  String get navHome => 'Inicio';

  @override
  String get navMovements => 'Transacciones';

  @override
  String get navCards => 'Tarjetas';

  @override
  String get navProfile => 'Perfil';

  @override
  String get loginWelcomeLabel => 'QUÉ BUENO VERTE';

  @override
  String get loginTitle => 'Regresa a\ntu ruta.';

  @override
  String get emailLabel => 'CORREO ELECTRÓNICO';

  @override
  String get passwordLabel => 'CONTRASEÑA';

  @override
  String get forgotPassword => 'Olvidé mi contraseña';

  @override
  String get passwordRecoveryMessage => 'La recuperación de contraseña se abrirá aquí';

  @override
  String get noAccountRegister => '¿No tienes una cuenta? Regístrate';

  @override
  String get onboardingSubtitle => 'Tus finanzas en\nun solo lugar';

  @override
  String get continueButton => 'Continuar';

  @override
  String get registerProgress => '1 / 3';

  @override
  String get firstStepLabel => 'PRIMER PASO';

  @override
  String get registerTitle => 'Empieza\npor ti.';

  @override
  String get registerDescription => 'Crea tu espacio personal para ahorrar y\nentender cada transacción.';

  @override
  String get fullNameLabel => 'NOMBRE COMPLETO';

  @override
  String get termsAndPrivacy => 'Al continuar, aceptas nuestros términos y política de privacidad.';

  @override
  String get selectMonth => 'Seleccionar mes';

  @override
  String get reportTitle => 'Reporte';

  @override
  String get monthInNumbers => 'Tu mes en números.';

  @override
  String get monthlyBalanceLabel => 'SALDO MENSUAL';

  @override
  String get weeklyFlow => 'Flujo semanal';

  @override
  String get expensesAndIncome => 'Gastos / Ingresos';

  @override
  String get mostSpent => 'Mayor gasto';

  @override
  String get viewCategories => 'Ver categorías';

  @override
  String get monthJanuary => 'Enero';

  @override
  String get monthFebruary => 'Febrero';

  @override
  String get monthMarch => 'Marzo';

  @override
  String get monthApril => 'Abril';

  @override
  String get monthMay => 'Mayo';

  @override
  String get monthJune => 'Junio';

  @override
  String get monthJuly => 'Julio';

  @override
  String get monthAugust => 'Agosto';

  @override
  String get monthSeptember => 'Septiembre';

  @override
  String get monthOctober => 'Octubre';

  @override
  String get monthNovember => 'Noviembre';

  @override
  String get monthDecember => 'Diciembre';

  @override
  String get expenseCategoryShopping => 'Compras';

  @override
  String get expenseCategoryHousing => 'Vivienda';

  @override
  String get expenseCategoryFood => 'Comida';

  @override
  String get expenseCategoryTransport => 'Transporte';

  @override
  String get expenseCategoryServices => 'Servicios';

  @override
  String get expenseCategoryEntertainment => 'Entretenimiento';

  @override
  String get movementElectricityPayment => 'Pago de electricidad';

  @override
  String get movementWaterPayment => 'Pago de agua';

  @override
  String get movementRentPayment => 'Pago de alquiler';

  @override
  String movementTodayAt(String time) {
    return 'Hoy · $time';
  }

  @override
  String movementYesterdayAt(String time) {
    return 'Ayer · $time';
  }

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsLabel => 'AJUSTES';

  @override
  String get profileEditTitle => 'Editar Perfil';

  @override
  String get phoneLabel => 'TELÉFONO';

  @override
  String get countryLabel => 'PAÍS';

  @override
  String get stateLabel => 'ESTADO';

  @override
  String get mainCurrencyLabel => 'DIVISA PRINCIPAL';

  @override
  String get saveChanges => 'GUARDAR CAMBIOS';

  @override
  String get accountLinking => 'VINCULACIÓN DE CUENTAS';

  @override
  String get linked => 'Vinculado';

  @override
  String get link => 'Vincular';

  @override
  String get changeAccount => 'Cambiar cuenta';

  @override
  String get security => 'SEGURIDAD';

  @override
  String get verifyPhone => 'Verificar Teléfono';

  @override
  String get notVerified => 'No verificado';

  @override
  String get changePassword => 'Cambiar Contraseña';

  @override
  String get changeEmail => 'Cambiar Correo';

  @override
  String get preferences => 'PREFERENCIAS';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get logout => 'CERRAR SESIÓN';

  @override
  String get verifyingEmailBadge => 'Verificar Correo';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get confirmLanguageChange => '¿Deseas cambiar el idioma de la aplicación?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get currentEmail => 'CORREO ACTUAL';

  @override
  String get newEmail => 'NUEVO CORREO ELECTRÓNICO';

  @override
  String get newPassword => 'NUEVA CONTRASEÑA';

  @override
  String get update => 'ACTUALIZAR';

  @override
  String get successLinking => '¡Éxito!';

  @override
  String get successLinkingMessage => 'Tu cuenta de Google ha sido vinculada correctamente. Ahora puedes iniciar sesión con ella.';

  @override
  String get unlinkAccountTitle => 'Desvincular cuenta';

  @override
  String get unlinkAccountMessage => '¿Estás seguro de que deseas desvincular tu cuenta de Google? Podrás volver a vincularla en cualquier momento.';

  @override
  String get unlink => 'Desvincular';

  @override
  String get enterCode => 'INGRESA EL CÓDIGO';

  @override
  String get verifyYourAccount => 'Verifica\ntu cuenta.';

  @override
  String codeSentTo(String email) {
    return 'Hemos enviado un código a $email';
  }

  @override
  String get sixDigitCode => 'CÓDIGO DE 6 DÍGITOS';

  @override
  String timeRemaining(String time) {
    return 'Tiempo restante: $time';
  }

  @override
  String attemptsRemainingLabel(int count) {
    return 'Intentos disponibles: $count';
  }

  @override
  String get resendCode => 'REENVIAR CÓDIGO';

  @override
  String get resend => 'Reenviar';

  @override
  String get verify => 'Verificar';
}
