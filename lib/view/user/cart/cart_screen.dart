// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:amazon/constants/common_functions.dart';
import 'package:amazon/controller/services/users_product_services/users_product_services.dart';
import 'package:amazon/model/user_product_model.dart';
import 'package:amazon/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../../constants/constants.dart';
import '../../../controller/services/product_services/product_services.dart';
import '../home/home_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
// ! RAZORPAY CODES (Payment Gateway)
  final razorpay = Razorpay();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    });
  }

  @override
  void dispose() {
    super.dispose();
    razorpay.clear();
  }
  //!
  //! RAZORPAY HANDLE EVENTS
  //!

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    List<UserProductModel> cartItems = await UsersProductService.fetchCart();
    DateTime currentTime = DateTime.now();

    for (var product in cartItems) {
      UserProductModel model = UserProductModel(
        imagesURL: product.imagesURL,
        name: product.name,
        category: product.category,
        description: product.description,
        brandName: product.brandName,
        manufacturerName: product.manufacturerName,
        countryOfOrigin: product.countryOfOrigin,
        specifications: product.specifications,
        price: product.price,
        discountedPrice: product.discountedPrice,
        productID: product.productID,
        productSellerID: product.productSellerID,
        inStock: product.inStock,
        discountPercentage: product.discountPercentage,
        productCount: product.productCount,
        time: currentTime,
      );
      await ProductServices.addSalesData(
        context: context,
        productModel: model,
        userID: auth.currentUser!.phoneNumber!,
      );
      await UsersProductService.addOrder(
        context: context,
        productModel: model,
      );
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    CommonFunctions.showErrorToast(
      context: context,
      message: 'Opps! Product Purchase Failed',
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  executePayment() {
    var options = {
      'key': keyID,
      // 'amount': widget.productModel.discountedPrice! * 100,
      'amount': 1 * 100, // Amount is rs 1,
      // here amount * 100 because razorpay counts amount in paisa
      //i.e 100 paisa = 1 Rupee
      // 'image' : '<YOUR BUISNESS EMAIL>'
      'name': 'Multiple Product',
      'description': 'Multiple Product',
      'prefill': {
        'contact': auth.currentUser!.phoneNumber, //<USERS CONTACT NO.>
        'email': 'test@razorpay.com' // <USERS EMAIL NO.>
      }
    };

    razorpay.open(options);
  }

// !
// !
// !

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(width * 1, height * 0.1),
          child: HomePageAppBar(width: width, height: height)),
      body: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
          vertical: height * 0.02,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                  stream: UsersProductService.fetchCartProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'Opps! No Product Added To Cart',
                          style: textTheme.bodyMedium,
                        ),
                      );
                    }
                    if (snapshot.hasData) {
                      List<UserProductModel> cartProducts = snapshot.data!;
                      log(cartProducts.length.toString());
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Subtotal ',
                                  style: textTheme.bodyLarge,
                                ),
                                TextSpan(
                                  text:
                                      '₹ ${cartProducts.fold(0.0, (previousValue, product) => previousValue + (product.productCount! * product.discountedPrice!)).toStringAsFixed(0)}',
                                  style: textTheme.displaySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CommonFunctions.blankSpace(
                            height * 0.01,
                            0,
                          ),
                          SizedBox(
                            height: height * 0.06,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: teal,
                                ),
                                CommonFunctions.blankSpace(
                                  0,
                                  width * 0.01,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      RichText(
                                          textAlign: TextAlign.justify,
                                          text: TextSpan(children: [
                                            TextSpan(
                                              text:
                                                  'Your Order is eligible for FREE Delivery. ',
                                              style:
                                                  textTheme.bodySmall!.copyWith(
                                                color: teal,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  'Select this option at checkout.',
                                              style: textTheme.bodySmall,
                                            ),
                                          ]))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              executePayment();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              backgroundColor: amber,
                              minimumSize: Size(
                                width,
                                height * 0.06,
                              ),
                            ),
                            child: Text(
                              'Proceed to Buy',
                              style: textTheme.bodyMedium,
                            ),
                          ),
                          CommonFunctions.blankSpace(
                            height * 0.02,
                            0,
                          ),
                          CommonFunctions.divider(),
                          CommonFunctions.blankSpace(
                            height * 0.02,
                            0,
                          ),
                          ListView.builder(
                              itemCount: cartProducts.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                UserProductModel currenProduct =
                                    cartProducts[index];
                                return Container(
                                  // height: height * 0.2,
                                  width: width,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.02,
                                      vertical: height * 0.01),
                                  margin: EdgeInsets.symmetric(
                                    vertical: height * 0.01,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                    color: greyShade1,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image(
                                              image: NetworkImage(
                                                  currenProduct.imagesURL![0]),
                                              fit: BoxFit.contain,
                                            ),
                                            CommonFunctions.blankSpace(
                                              height * 0.01,
                                              0,
                                            ),
                                            Container(
                                              height: height * 0.06,
                                              width: width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  10,
                                                ),
                                                border: Border.all(
                                                  color: greyShade3,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      flex: 2,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          if (currenProduct
                                                                  .productCount ==
                                                              1) {
                                                            await UsersProductService
                                                                .removeProductfromCart(
                                                              productId:
                                                                  currenProduct
                                                                      .productID!,
                                                              context: context,
                                                            );
                                                          }
                                                          await UsersProductService
                                                              .updateCountCartProduct(
                                                            productId:
                                                                currenProduct
                                                                    .productID!,
                                                            newCount: currenProduct
                                                                    .productCount! -
                                                                1,
                                                            context: context,
                                                          );
                                                        },
                                                        child: Container(
                                                            height:
                                                                double.infinity,
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border(
                                                                right:
                                                                    BorderSide(
                                                                  color:
                                                                      greyShade3,
                                                                ),
                                                              ),
                                                            ),
                                                            child: Icon(
                                                              Icons.remove,
                                                              color: black,
                                                            )),
                                                      )),
                                                  Expanded(
                                                      flex: 3,
                                                      child: Container(
                                                          color: white,
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                              currenProduct
                                                                  .productCount
                                                                  .toString()))),
                                                  Expanded(
                                                      flex: 2,
                                                      child: InkWell(
                                                        onTap: () async {
                                                          await UsersProductService
                                                              .updateCountCartProduct(
                                                            productId:
                                                                currenProduct
                                                                    .productID!,
                                                            newCount: currenProduct
                                                                    .productCount! +
                                                                1,
                                                            context: context,
                                                          );
                                                        },
                                                        child: Container(
                                                            height:
                                                                double.infinity,
                                                            width:
                                                                double.infinity,
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border(
                                                                left:
                                                                    BorderSide(
                                                                  color:
                                                                      greyShade3,
                                                                ),
                                                              ),
                                                            ),
                                                            child: Icon(
                                                              Icons.add,
                                                              color: black,
                                                            )),
                                                      ))
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      CommonFunctions.blankSpace(
                                        0,
                                        width * 0.02,
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              currenProduct.name!,
                                              maxLines: 3,
                                              style: textTheme.bodyMedium,
                                            ),
                                            CommonFunctions.blankSpace(
                                              height * 0.01,
                                              0,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '₹ ${currenProduct.discountedPrice!.toStringAsFixed(0)}',
                                                  style: textTheme
                                                      .displayMedium!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                Text(
                                                  '\tMRP: ₹',
                                                  style: textTheme.bodySmall!
                                                      .copyWith(
                                                    color: grey,
                                                  ),
                                                ),
                                                Text(
                                                  ' ${currenProduct.price!.toStringAsFixed(0)}',
                                                  style: textTheme.bodySmall!
                                                      .copyWith(
                                                          color: grey,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough),
                                                ),
                                              ],
                                            ),
                                            CommonFunctions.blankSpace(
                                              height * 0.005,
                                              0,
                                            ),
                                            Text(
                                              currenProduct.discountedPrice! >
                                                      499
                                                  ? 'Eligible for Free Shipping'
                                                  : 'Extra Delivery Charges Applied',
                                              style: textTheme.bodySmall!
                                                  .copyWith(color: grey),
                                            ),
                                            CommonFunctions.blankSpace(
                                              height * 0.005,
                                              0,
                                            ),
                                            Text(
                                              'In Stock',
                                              style: textTheme.bodySmall!
                                                  .copyWith(color: teal),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () async {
                                                      await UsersProductService
                                                          .removeProductfromCart(
                                                        productId: currenProduct
                                                            .productID!,
                                                        context: context,
                                                      );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: white,
                                                      side: BorderSide(
                                                        color: greyShade3,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Delete',
                                                      style:
                                                          textTheme.bodySmall,
                                                    )),
                                                ElevatedButton(
                                                    onPressed: () {},
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: white,
                                                      side: BorderSide(
                                                        color: greyShade3,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Save for Later',
                                                      style:
                                                          textTheme.bodySmall,
                                                    ))
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })
                        ],
                      );
                    }
                    if (snapshot.hasError) {
                      return const Text('Opps! Error Found');
                    } else {
                      return const Text('Opps! No Product Added To Cart');
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
