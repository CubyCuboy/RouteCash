// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Route Cash';

  @override
  String get financialSpace => 'Seu espaço financeiro';

  @override
  String get moneyWithMeaning => 'Dinheiro\ncom propósito.';

  @override
  String get signIn => 'Entrar';

  @override
  String get signInWithOutlook => 'Entrar com Outlook';

  @override
  String get signInWithGoogle => 'Entrar com Google';

  @override
  String get signInWithApple => 'Entrar com Apple';

  @override
  String get newUserCreateAccount => 'Novo aqui? Crie uma conta';

  @override
  String get setupProgress => '3 / 3';

  @override
  String get yourAccountsLabel => 'SUAS CONTAS';

  @override
  String get accountsSetupTitle => 'Tudo o que é importante,\njunto.';

  @override
  String get accountsSetupDescription => 'Conecte uma conta ou adicione uma manualmente.\nVocê sempre pode fazer isso mais tarde.';

  @override
  String get horizonBank => 'Horizon Bank';

  @override
  String get connectSecurely => 'Conectar com segurança';

  @override
  String get addManually => 'Adicionar manualmente';

  @override
  String get manualAccountTypes => 'Dinheiro, cartão ou investimento';

  @override
  String get skipForNow => 'Pular por enquanto';

  @override
  String get bankConnectionMessage => 'Iniciando conexão bancária segura';

  @override
  String get manualAccountMessage => 'Preparando configuração de conta manual';

  @override
  String get invalidEmail => 'E-mail inválido ou domínio não permitido';

  @override
  String get weakPassword => 'A senha deve ter pelo menos 8 caracteres, uma letra maiúscula, um número e um caractere especial';

  @override
  String get passwordsDoNotMatch => 'As senhas não coincidem';

  @override
  String get errorInvalidCredentials => 'E-mail ou senha inválidos';

  @override
  String get errorUserExists => 'O usuário já existe';

  @override
  String get errorUnexpected => 'Ocorreu um erro inesperado';

  @override
  String get confirmPasswordLabel => 'Confirmar Senha';

  @override
  String get confirmPasswordHint => '••••••••••';

  @override
  String homeGreeting(String name) {
    return 'Olá, $name';
  }

  @override
  String get homeYourRoute => 'Sua rota';

  @override
  String get availableBalanceLabel => 'SALDO DISPONÍVEL';

  @override
  String movementCountLabel(int count) {
    return '$count / TRANSAÇÃO';
  }

  @override
  String balanceMoreThanMonth(num percentage, String month) {
    return '$percentage% mais que em $month';
  }

  @override
  String get viewAll => 'Ver tudo';

  @override
  String get activitySummary => 'Resumo de atividade';

  @override
  String get navHome => 'Início';

  @override
  String get navMovements => 'Transações';

  @override
  String get navCards => 'Cartões';

  @override
  String get navProfile => 'Perfil';

  @override
  String get loginWelcomeLabel => 'BOM TE VER';

  @override
  String get loginTitle => 'Retorne à\nsua rota.';

  @override
  String get emailLabel => 'ENDEREÇO DE E-MAIL';

  @override
  String get passwordLabel => 'SENHA';

  @override
  String get forgotPassword => 'Esqueci minha senha';

  @override
  String get passwordRecoveryMessage => 'A recuperação de senha será aberta aqui';

  @override
  String get noAccountRegister => 'Não tem uma conta? Cadastre-se';

  @override
  String get onboardingSubtitle => 'Suas finanças em\num só lugar';

  @override
  String get continueButton => 'Continuar';

  @override
  String get registerProgress => '1 / 3';

  @override
  String get firstStepLabel => 'PRIMEIRO PASSO';

  @override
  String get registerTitle => 'Começa\ncom você.';

  @override
  String get registerDescription => 'Crie seu espaço pessoal para economizar e\nentender cada transação.';

  @override
  String get fullNameLabel => 'NOME COMPLETO';

  @override
  String get termsAndPrivacy => 'Ao continuar, você aceita nossos termos e política de privacidade.';

  @override
  String get selectMonth => 'Selecionar mês';

  @override
  String get reportTitle => 'Relatório';

  @override
  String get monthInNumbers => 'Seu mês em números.';

  @override
  String get monthlyBalanceLabel => 'SALDO MENSAL';

  @override
  String get weeklyFlow => 'Fluxo semanal';

  @override
  String get expensesAndIncome => 'Despesas / Receitas';

  @override
  String get mostSpent => 'Maiores gastos';

  @override
  String get viewCategories => 'Ver categorias';

  @override
  String get monthJanuary => 'Janeiro';

  @override
  String get monthFebruary => 'Fevereiro';

  @override
  String get monthMarch => 'Março';

  @override
  String get monthApril => 'Abril';

  @override
  String get monthMay => 'Maio';

  @override
  String get monthJune => 'Junho';

  @override
  String get monthJuly => 'Julho';

  @override
  String get monthAugust => 'Agosto';

  @override
  String get monthSeptember => 'Setembro';

  @override
  String get monthOctober => 'Outubro';

  @override
  String get monthNovember => 'Novembro';

  @override
  String get monthDecember => 'Dezembro';

  @override
  String get expenseCategoryShopping => 'Compras';

  @override
  String get expenseCategoryHousing => 'Habitação';

  @override
  String get expenseCategoryFood => 'Alimentação';

  @override
  String get expenseCategoryTransport => 'Transporte';

  @override
  String get expenseCategoryServices => 'Serviços';

  @override
  String get expenseCategoryEntertainment => 'Entretenimento';

  @override
  String get movementElectricityPayment => 'Pagamento de eletricidade';

  @override
  String get movementWaterPayment => 'Pagamento de água';

  @override
  String get movementRentPayment => 'Pagamento de aluguel';

  @override
  String movementTodayAt(String time) {
    return 'Hoje · $time';
  }

  @override
  String movementYesterdayAt(String time) {
    return 'Ontem · $time';
  }

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsLabel => 'CONFIGURAÇÕES';

  @override
  String get profileEditTitle => 'Editar Perfil';

  @override
  String get phoneLabel => 'TELEFONE';

  @override
  String get countryLabel => 'PAÍS';

  @override
  String get stateLabel => 'ESTADO';

  @override
  String get mainCurrencyLabel => 'MOEDA PRINCIPAL';

  @override
  String get saveChanges => 'SALVAR ALTERAÇÕES';

  @override
  String get accountLinking => 'VINCULAÇÃO DE CONTAS';

  @override
  String get linked => 'Vinculado';

  @override
  String get link => 'Vincular';

  @override
  String get changeAccount => 'Alterar conta';

  @override
  String get security => 'SEGURANÇA';

  @override
  String get verifyPhone => 'Verificar Telefone';

  @override
  String get notVerified => 'Não verificado';

  @override
  String get changePassword => 'Alterar Senha';

  @override
  String get changeEmail => 'Alterar E-mail';

  @override
  String get preferences => 'PREFERÊNCIAS';

  @override
  String get darkMode => 'Modo Escuro';

  @override
  String get language => 'Idioma';

  @override
  String get logout => 'SAIR';

  @override
  String get verifyingEmailBadge => 'Verificar E-mail';

  @override
  String get selectLanguage => 'Selecionar Idioma';

  @override
  String get confirmLanguageChange => 'Deseja alterar o idioma do aplicativo?';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get currentEmail => 'E-MAIL ATUAL';

  @override
  String get newEmail => 'NOVO E-MAIL';

  @override
  String get newPassword => 'NOVA SENHA';

  @override
  String get update => 'ATUALIZAR';

  @override
  String get successLinking => 'Sucesso!';

  @override
  String get successLinkingMessage => 'Sua conta do Google foi vinculada com sucesso. Agora você pode entrar com ela.';

  @override
  String get unlinkAccountTitle => 'Desvincular conta';

  @override
  String get unlinkAccountMessage => 'Tem certeza de que deseja desvincular sua conta do Google? Você poderá vinculá-la novamente a qualquer momento.';

  @override
  String get unlink => 'Desvincular';

  @override
  String get enterCode => 'INSIRA O CÓDIGO';

  @override
  String get verifyYourAccount => 'Verifique\nsua conta.';

  @override
  String codeSentTo(String email) {
    return 'Enviamos um código para $email';
  }

  @override
  String get sixDigitCode => 'CÓDIGO DE 6 DÍGITOS';

  @override
  String timeRemaining(String time) {
    return 'Tempo restante: $time';
  }

  @override
  String attemptsRemainingLabel(int count) {
    return 'Tentativas restantes: $count';
  }

  @override
  String get resendCode => 'REENVIAR CÓDIGO';

  @override
  String get resend => 'Reenviar';

  @override
  String get verify => 'Verificar';

  @override
  String get nfcStatusIdle => 'Aproxime o cartão do leitor...';

  @override
  String get nfcStatusDetected => 'Cartão detectado! Mantenha o cartão firme...';

  @override
  String get nfcStatusReadingConfig => 'Lendo configuração... Não retire o cartão.';

  @override
  String get nfcStatusRetrievingData => 'Resgatando dados... Quase pronto.';

  @override
  String get nfcStatusSuccess => 'Leitura concluída com sucesso.';

  @override
  String get nfcErrorAvailability => 'NFC não está disponível ou está desativado.';

  @override
  String get nfcErrorSessionActive => 'Já existe uma leitura em curso.';

  @override
  String get nfcErrorPpse => 'Erro ao iniciar contato com o cartão.';

  @override
  String get nfcErrorIncompatible => 'Este cartão não é compatível com o padrão de pagamento.';

  @override
  String get nfcErrorNoAid => 'Nenhum aplicativo de pagamento compatível encontrado.';

  @override
  String get nfcErrorAidAccess => 'O cartão não permitiu o acesso aos dados.';

  @override
  String get nfcErrorRetrieveFail => 'Não foi possível resgatar os datos, tente novamente.';

  @override
  String get nfcTimeout => 'Tempo esgotado. Por favor, aproxime o cartão novamente.';

  @override
  String get nfcCancel => 'Leitura NFC cancelada.';

  @override
  String get selectBank => 'Selecione seu banco';

  @override
  String get selectAccountType => 'Selecione o tipo de conta';

  @override
  String get cardNumberLabel => 'Número do Cartão';

  @override
  String get expiryDateLabel => 'Data de Validade';

  @override
  String get saveCard => 'Salvar Cartão';

  @override
  String get invalidCardNumber => 'Número de cartão inválido.';

  @override
  String get invalidExpiryDate => 'Data de validade inválida.';

  @override
  String get errorRequiredFields => 'Você deve preencher todos os campos para continuar.';
}
