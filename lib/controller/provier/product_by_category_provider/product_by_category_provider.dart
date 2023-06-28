import 'package:flutter/material.dart';

import '../../../model/product_model.dart';
import '../../services/users_product_services/users_product_services.dart';

class ProductsBasedOnCategoryProvider extends ChangeNotifier {
  List<ProductModel> products = [];
  bool productsFetched = false;

  fetchProducts({required String category}) async {
    products = [];
    products = await UsersProductService.fetchProductBasedOnCategory(
        category: category);
    productsFetched = true;
    notifyListeners();
  }
}
