import 'package:phone_repair_service_199/util.dart';

class Accessory {
  final String name;
  final AccessoryCategory category;
  final String desc;
  final List<String> imgUrlList;
  final String price;
  final bool inStock;

  const Accessory(
      {required this.name,
      required this.category,
      required this.desc,
      required this.price,
      required this.inStock,
      this.imgUrlList = const []});

  factory Accessory.fromMap(Map<String, dynamic> map) {
    return Accessory(
      name: map['name'],
      category: AccessoryCategory.values.byName(map['category']),
      desc: map['desc'],
      price: map['price'],
      inStock: map['inStock'],
      imgUrlList: map['imgUrlList'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category.name,
      'desc': desc,
      'price': price,
      'instock': inStock,
      'imgUrlList': imgUrlList,
    };
  }
}
