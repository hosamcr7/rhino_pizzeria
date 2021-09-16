

import 'package:rhino_pizzeria/constants.dart';

class ProductHelper{
  final String name;
  final String description;
  final String imagePath;
  final List<ModifiersHelper> productModifiers;

  const ProductHelper({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.productModifiers,
  });
}

class ModifiersHelper{
  final String name;
  final Types type;
  final List<Map<String,String>> modifierData;

  const ModifiersHelper({
    required this.name,
    required this.type,
    required this.modifierData,
  });
}

