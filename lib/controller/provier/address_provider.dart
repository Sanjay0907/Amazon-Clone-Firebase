import 'package:amazon/controller/services/user_data_crud_services/user_data_CRUD_services.dart';
import 'package:flutter/material.dart';

import '../../model/address_model.dart';

class AddressProvider extends ChangeNotifier {
  List<AddressModel> allAdressModel = [];
  AddressModel currentSelectedAddress = AddressModel();
  bool fetchedCurrentSelectedAddress = false;
  bool fetchedAllAddress = false;
  bool addressPresent = false;

  getAllAddress() async {
    allAdressModel = await UserDataCRUD.getAllAddress();
    fetchedAllAddress = true;
    notifyListeners();
  }

  getCurrentSelectedAddress() async {
    currentSelectedAddress = await UserDataCRUD.getCurrentSelectedAddress();
    addressPresent = await UserDataCRUD.checkUsersAddress();
    fetchedCurrentSelectedAddress = true;
    
    notifyListeners();
  }
}
