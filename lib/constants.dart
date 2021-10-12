import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kampoeng_kepiting_mobile/models/payment.dart';

// Colors
const textColor = Color(0xFF343A40);
const primaryColor = Color(0xFF7952B3);
const primaryDarkerColor = Color(0xFF512D6D);
const accentColor = Color(0xFFFFC107);
const primaryBackgrounColor = Color(0XFFEDE9F8);
const whiteBackgrounColor = Color(0XFFEEEEEE);
const inactiveColor = Color(0xFFCABDEB);
const dangerColor = Color(0xFFF8485E);
const acceptColor = Color(0xFF00C1D4);

const kTextColor = Color(0xFF1E2432);
const kTextMediumColor = Color(0xFF53627C);
const kTextLightColor = Color(0xFFACB1C0);
const kPrimaryColor = Color(0xFF0D8E53);
const kBackgroundColor = Color(0xFFFCFCFC);
const kInactiveChartColor = Color(0xFFEAECEF);

// Sizes
const extraSmall = 2.0;
const small = 4.0;
const smallMedium = 6.0;
const medium = 8.0;
const mediumLarge = 12.0;
const large = 16.0;
const extraLarge = 32.0;

// APP Data
final String appName = 'Kampoeng Kepiting';

// API server URL
final String apiUrl = dotenv.env['API_URL'].toString();
final String imageUrl = dotenv.env['IMAGE_URL'].toString();

// STANDARD
final currency = NumberFormat.simpleCurrency(locale: 'id_ID');

String convertToTitleCase(String text) {
  text = text.toLowerCase();

  if (text.length <= 1) {
    return text.toUpperCase();
  }

  // Split string into multiple words
  final List<String> words = text.split(' ');

  // Capitalize first letter of each words
  final capitalizedWords = words.map((word) {
    if (word.trim().isNotEmpty) {
      final String firstLetter = word.trim().substring(0, 1).toUpperCase();
      final String remainingLetters = word.trim().substring(1);

      return '$firstLetter$remainingLetters';
    }
    return '';
  });

  // Join/Merge all words back to one String
  return capitalizedWords.join(' ');
}

const PAYMENT = const [
  Payment(
    provider: 'Mandiri',
    accountID: '1450010678908',
    accountName: 'Agus Diana',
    providerLogo: 'assets/icons/mandiri.svg',
  ),
  Payment(
      provider: 'BNI',
      accountID: '0107213000',
      accountName: 'Agus Diana',
      providerLogo: 'assets/icons/bni.svg'),
  Payment(
    provider: 'BCA',
    accountID: '1461629518',
    accountName: 'Agus Diana',
    providerLogo: 'assets/icons/bca.svg',
  ),
  Payment(
    provider: 'Paypal',
    accountID: 'cybers_romeo@yahoo.com',
    accountName: 'Agus Diana',
    providerLogo: 'assets/icons/paypal.svg',
  ),
];
