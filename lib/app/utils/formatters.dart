import 'package:intl/intl.dart';

String formatCurrency(double? value) {
  final number = value ?? 0;
  final format = NumberFormat.currency(locale: 'fr_FR', symbol: 'FCFA', decimalDigits: 0);
  return format.format(number);
}
