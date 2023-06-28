// ignore_for_file: use_build_context_synchronously, avoid_function_literals_in_foreach_calls

import 'dart:developer';
import 'dart:io';
import 'package:amazon/controller/provier/rating_provider/rating_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../../constants/common_functions.dart';
import '../../../constants/constants.dart';
import '../../../model/review_model.dart';
import '../../../model/user_product_model.dart';

class RatingServices {
  static Future getImages({required BuildContext context}) async {
    List<File> selectedImages = [];
    final pickedFile = await picker.pickMultiImage(
      imageQuality: 100,
    );
    List<XFile> filePick = pickedFile;

    if (filePick.isNotEmpty) {
      for (var i = 0; i < filePick.length; i++) {
        selectedImages.add(File(filePick[i].path));
      }
    } else {
      CommonFunctions.showWarningToast(
          context: context, message: 'No Image Selected');
    }
    log('The Images are \n${selectedImages.toList().toString()}');
    return selectedImages;
  }

  static uploadImageToFirebaseStorage({
    required List<File> images,
    required BuildContext context,
  }) async {
    List<String> imagesURL = [];
    String sellerUID = auth.currentUser!.phoneNumber!;
    Uuid uuid = const Uuid();

    await Future.forEach(images, (image) async {
      String imageName = '$sellerUID${uuid.v1().toString()}';
      Reference ref = storage.ref().child('Product_Images').child(imageName);
      await ref.putFile(File(image.path));
      String imageURL = await ref.getDownloadURL();
      imagesURL.add(imageURL);
    });

    context.read<RatingProvider>().updateProductImagesURL(imageURLs: imagesURL);
  }

  static Future checkUserPurchasedTheProduct(
      {required String productID}) async {
    bool productPurchased = false;
    try {
      await firestore
          .collection('Orders')
          .doc(auth.currentUser!.phoneNumber)
          .collection('myOrders')
          .where('productID', isEqualTo: productID)
          .get()
          .then((value) {
        value.size > 0 ? productPurchased = true : productPurchased = false;
        log('Product Purchased $productPurchased');
      });
    } catch (e) {
      log(e.toString());
    }

    return productPurchased;
  }

  static Future<bool> checkUserRating({required String productID}) async {
    bool userPresent = false;
    try {
      await firestore
          .collection('ReviewNRatings')
          .doc(productID)
          .collection('rating')
          .where('userID', isEqualTo: auth.currentUser!.phoneNumber)
          .get()
          .then((value) {
        value.size > 0 ? userPresent = true : userPresent = false;
        log(value.toString());
      });
    } catch (e) {
      log(e.toString());
    }
    log(userPresent.toString());
    return userPresent;
  }

  static Stream<List<ReviewModel>> fetchReview({required String productID}) =>
      firestore
          .collection('ReviewNRatings')
          .doc(productID)
          .collection('rating')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                return ReviewModel.fromMap(doc.data());
              }).toList());

  static Future addReview({
    required BuildContext context,
    required String productID,
    required ReviewModel reviewModel,
    required String userID,
  }) async {
    try {
      Uuid uuid = const Uuid();
      await firestore
          .collection('ReviewNRatings')
          .doc(productID)
          .collection('rating')
          .doc(userID + uuid.v1())
          .set(reviewModel.toMap())
          .whenComplete(() {
        log('Data Added');

        // CommonFunctions.showSuccessToast(
        //     context: context, message: 'Product Added Successful');
      });
    } catch (e) {
      log(e.toString());
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }
}
