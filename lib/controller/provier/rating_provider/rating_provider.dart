import 'dart:io';

import 'package:amazon/controller/services/rating_services/rating_services.dart';
import 'package:amazon/model/user_product_model.dart';
import 'package:flutter/material.dart';

class RatingProvider extends ChangeNotifier {
  List<File> productImages = [];
  List<String> productImagesURL = [];
  bool productPurchased = false;
  bool userRatedTheProduct = false;
  fetchProductImagesFromGallery({required BuildContext context}) async {
    productImages = await RatingServices.getImages(context: context);
    notifyListeners();
  }

  updateProductImagesURL({required List<String> imageURLs}) async {
    productImagesURL = imageURLs;
    notifyListeners();
  }

  checkProductPurchase({required String productID}) async {
    productPurchased =
        await RatingServices.checkUserPurchasedTheProduct(productID: productID);

    notifyListeners();
  }

  reset() {
    productImages = [];
    productImagesURL = [];
    userRatedTheProduct = false;
    productPurchased = false;

    notifyListeners();
  }

  checkUserRating({required String productID}) async {
    userRatedTheProduct =
        await RatingServices.checkUserRating(productID: productID);
    notifyListeners();
  }
}
