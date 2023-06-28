import 'package:amazon/controller/services/users_product_services/users_product_services.dart';
import 'package:amazon/model/user_product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:page_transition/page_transition.dart';

import '../../../model/product_model.dart';
import '../../../utils/colors.dart';
import '../product_screen/product_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.1),
        child: Container(
          padding: EdgeInsets.only(
              left: width * 0.03,
              right: width * 0.03,
              bottom: height * 0.012,
              top: height * 0.045),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: appBarGradientColor,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              Image(
                image: const AssetImage(
                  'assets/images/amazon_black_logo.png',
                ),
                height: height * 0.04,
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_none,
                  color: black,
                  size: height * 0.035,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: black,
                  size: height * 0.035,
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<List<UserProductModel>>(
          stream: UsersProductService.fetchOrders(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'Please order Something',
                    style: textTheme.bodyMedium,
                  ),
                );
              } else {
                List<UserProductModel> orders = snapshot.data!;
                return ListView.builder(
                    itemCount: orders.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      UserProductModel currentProduct = orders[index];
                      return InkWell(
                        onTap: () {
                          ProductModel product = ProductModel(
                              imagesURL: currentProduct.imagesURL,
                              name: currentProduct.name,
                              category: currentProduct.category,
                              description: currentProduct.description,
                              brandName: currentProduct.brandName,
                              manufacturerName: currentProduct.manufacturerName,
                              countryOfOrigin: currentProduct.countryOfOrigin,
                              specifications: currentProduct.specifications,
                              price: currentProduct.price,
                              discountedPrice: currentProduct.discountedPrice,
                              productID: currentProduct.productID,
                              productSellerID: currentProduct.productSellerID,
                              inStock: currentProduct.inStock,
                              uploadedAt: currentProduct.time,
                              discountPercentage:
                                  currentProduct.discountPercentage);

                          Navigator.push(
                            context,
                            PageTransition(
                              child: ProductScreen(productModel: product),
                              type: PageTransitionType.rightToLeft,
                            ),
                          );
                        },
                        child: Container(
                          height: height * 0.1,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                            border: Border.all(
                              color: grey,
                            ),
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: width * 0.03,
                              vertical: height * 0.01),
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.03,
                              vertical: height * 0.01),
                          child: Row(
                            children: [
                              Image(
                                image:
                                    NetworkImage(currentProduct.imagesURL![0]),
                                fit: BoxFit.fitHeight,
                              ),
                              const Spacer(),
                              Text(
                                currentProduct.productCount!.toStringAsFixed(
                                  0,
                                ),
                                style: textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Opps! There is an Error',
                  style: textTheme.bodyMedium,
                ),
              );
            } else {
              return Center(
                child: Text(
                  'Opps! Unable to fetch Orders',
                  style: textTheme.bodyMedium,
                ),
              );
            }
          }),
    );
  }
}
