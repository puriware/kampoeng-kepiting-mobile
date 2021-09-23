import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../models/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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

final dataProducts = [
  Product(
    code: 'P001',
    name: 'Tour Canoing',
    description:
        'Mollit proident dolor non in nisi laboris. Eiusmod eu fugiat labore excepteur nisi aute mollit laboris irure. Ex proident mollit duis reprehenderit ipsum aliquip nisi id labore. Nulla commodo sit sint sint deserunt ullamco eiusmod id cillum enim dolor quis. Officia eu ullamco esse est eiusmod ipsum veniam qui.',
    feature: 'feature',
    price: 25000,
    image: 'https://puriware.com/assets/ekowisata/001.jpg',
    createBy: 1,
    visibility: 'Visible',
  ),
  Product(
    code: 'P002',
    name: 'Tour Mangrove',
    description:
        'Berupa tour keliling perairan teluk benoa menggunakan perahu traditional nelayan untuk mengantar tamu berkeliling menyisir pohon mangrove berwisata di teluk benoa. ',
    feature: 'feature',
    price: 25000,
    image: 'https://puriware.com/assets/ekowisata/002.jpg',
    createBy: 1,
    visibility: 'Visible',
  ),
  Product(
    code: 'P003',
    name: 'Fishing Trip',
    description:
        'Mollit proident dolor non in nisi laboris. Eiusmod eu fugiat labore excepteur nisi aute mollit laboris irure. Ex proident mollit duis reprehenderit ipsum aliquip nisi id labore. Nulla commodo sit sint sint deserunt ullamco eiusmod id cillum enim dolor quis. Officia eu ullamco esse est eiusmod ipsum veniam qui.',
    feature: 'feature',
    price: 25000,
    image: 'https://puriware.com/assets/ekowisata/003.jpg',
    createBy: 1,
    visibility: 'Visible',
  ),
  Product(
    code: 'P004',
    name: 'Wisata Budaya',
    description:
        'Mollit proident dolor non in nisi laboris. Eiusmod eu fugiat labore excepteur nisi aute mollit laboris irure. Ex proident mollit duis reprehenderit ipsum aliquip nisi id labore. Nulla commodo sit sint sint deserunt ullamco eiusmod id cillum enim dolor quis. Officia eu ullamco esse est eiusmod ipsum veniam qui.',
    feature: 'feature',
    price: 25000,
    image: 'https://puriware.com/assets/ekowisata/004.jpg',
    createBy: 1,
    visibility: 'Visible',
  ),
  Product(
    code: 'P005',
    name: 'Tour Keramba Kepiting',
    description:
        'Mollit proident dolor non in nisi laboris. Eiusmod eu fugiat labore excepteur nisi aute mollit laboris irure. Ex proident mollit duis reprehenderit ipsum aliquip nisi id labore. Nulla commodo sit sint sint deserunt ullamco eiusmod id cillum enim dolor quis. Officia eu ullamco esse est eiusmod ipsum veniam qui.',
    feature: 'feature',
    price: 25000,
    image: 'https://puriware.com/assets/ekowisata/005.jpg',
    createBy: 1,
    visibility: 'Visible',
  ),
  Product(
    code: 'P006',
    name: 'Mangrove Plantation',
    description:
        'Mollit proident dolor non in nisi laboris. Eiusmod eu fugiat labore excepteur nisi aute mollit laboris irure. Ex proident mollit duis reprehenderit ipsum aliquip nisi id labore. Nulla commodo sit sint sint deserunt ullamco eiusmod id cillum enim dolor quis. Officia eu ullamco esse est eiusmod ipsum veniam qui.',
    feature: 'feature',
    price: 25000,
    image: 'https://puriware.com/assets/ekowisata/006.jpg',
    createBy: 1,
    visibility: 'Visible',
  ),
  Product(
    code: 'P007',
    name: 'Cooking Class',
    description:
        'Mollit proident dolor non in nisi laboris. Eiusmod eu fugiat labore excepteur nisi aute mollit laboris irure. Ex proident mollit duis reprehenderit ipsum aliquip nisi id labore. Nulla commodo sit sint sint deserunt ullamco eiusmod id cillum enim dolor quis. Officia eu ullamco esse est eiusmod ipsum veniam qui.',
    feature: 'feature',
    price: 25000,
    image: 'https://puriware.com/assets/ekowisata/007.jpg',
    createBy: 1,
    visibility: 'Visible',
  ),
  Product(
    code: 'P008',
    name: 'Tour Canoing',
    description:
        'Mollit proident dolor non in nisi laboris. Eiusmod eu fugiat labore excepteur nisi aute mollit laboris irure. Ex proident mollit duis reprehenderit ipsum aliquip nisi id labore. Nulla commodo sit sint sint deserunt ullamco eiusmod id cillum enim dolor quis. Officia eu ullamco esse est eiusmod ipsum veniam qui.',
    feature: 'feature',
    price: 25000,
    image: 'https://puriware.com/assets/ekowisata/001.jpg',
    createBy: 1,
    visibility: 'Visible',
  ),
];

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
