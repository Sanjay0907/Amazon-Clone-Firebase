import 'package:amazon/controller/services/users_product_services/users_product_services.dart';
import 'package:amazon/model/product_model.dart';
import 'package:flutter/material.dart';

class DealOfTheDayProvider extends ChangeNotifier {
  List<ProductModel> deals = [];
  bool dealsFetched = false;

  fetchTodaysDeal() async {
    deals = [];
    deals = await UsersProductService.featchDealOfTheDay();
    dealsFetched = true;
    notifyListeners();
  }
}
