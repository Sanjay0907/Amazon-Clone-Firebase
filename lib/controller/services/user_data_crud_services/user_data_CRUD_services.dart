// ignore_for_file: file_names, unused_local_variable, avoid_function_literals_in_foreach_calls

import 'dart:developer';

import 'package:amazon/constants/common_functions.dart';
import 'package:amazon/constants/constants.dart';
import 'package:amazon/model/address_model.dart';
import 'package:amazon/model/user_model.dart';
import 'package:amazon/view/auth_screen/signInLogic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class UserDataCRUD {
  static Future addNewUser({
    required UserModel userModel,
    required BuildContext context,
  }) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.phoneNumber)
          .set(userModel.toMap())
          .whenComplete(() {
        log('Data Added');
        CommonFunctions.showSuccessToast(
            context: context, message: 'User Added Successful');
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: const SignInLogic(),
                type: PageTransitionType.rightToLeft),
            (route) => false);
      });
    } catch (e) {
      log(e.toString());
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }

  static Future<bool> checkUser() async {
    bool userPresent = false;
    try {
      await firestore
          .collection('users')
          .where('mobileNum', isEqualTo: auth.currentUser!.phoneNumber)
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

  static Future<bool> userIsSeller() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('users')
          .doc(auth.currentUser!.phoneNumber)
          .get();
      if (snapshot.exists) {
        UserModel userModel = UserModel.fromMap(snapshot.data()!);
        log('User Type is: ${userModel.userType!}');
        if (userModel.userType != 'user') {
          return true;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  static Future addUserAddress(
      {required BuildContext context,
      required AddressModel addressModel,
      required String docID}) async {
    try {
      await firestore
          .collection('Address')
          .doc(auth.currentUser!.phoneNumber)
          .collection('address')
          .doc(docID)
          .set(addressModel.toMap())
          .whenComplete(() {
        log('Data Added');
        CommonFunctions.showSuccessToast(
            context: context, message: 'Address Added Successful');
        Navigator.pop(context);
      });
    } catch (e) {
      log(e.toString());
      CommonFunctions.showErrorToast(context: context, message: e.toString());
    }
  }

  static Future<bool> checkUsersAddress() async {
    bool addressPresent = false;
    try {
      await firestore
          .collection('Address')
          .doc(auth.currentUser!.phoneNumber)
          .collection('address')
          .get()
          .then((value) =>
              value.size > 0 ? addressPresent = true : addressPresent = false);
    } catch (e) {
      log(e.toString());
    }
    log(addressPresent.toString());
    return addressPresent;
  }

  static Future<List<AddressModel>> getAllAddress() async {
    List<AddressModel> allAddress = [];
    AddressModel defaultAddress = AddressModel();
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Address')
          .doc(auth.currentUser!.phoneNumber)
          .collection('address')
          .get();

      snapshot.docs.forEach((element) {
        allAddress.add(AddressModel.fromMap(element.data()));
        AddressModel currentAddresss = AddressModel.fromMap(element.data());
        if (currentAddresss.isDefault == true) {
          defaultAddress = currentAddresss;
        }
      });
    } catch (e) {
      log('error Found');
      log(e.toString());
    }
    for (var data in allAddress) {
      log(data.toMap().toString());
    }
    return allAddress;
  }

  static Future getCurrentSelectedAddress() async {
    AddressModel defaultAddress = AddressModel();
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Address')
          .doc(auth.currentUser!.phoneNumber)
          .collection('address')
          .get();

      snapshot.docs.forEach((element) {
        AddressModel currentAddresss = AddressModel.fromMap(element.data());
        if (currentAddresss.isDefault == true) {
          defaultAddress = currentAddresss;
        }
      });
    } catch (e) {
      log('error Found');
      log(e.toString());
    }
    return defaultAddress;
  }
}
