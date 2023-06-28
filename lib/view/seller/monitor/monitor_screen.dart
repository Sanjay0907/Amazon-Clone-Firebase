import 'dart:developer';

import 'package:amazon/constants/common_functions.dart';
import 'package:amazon/controller/provier/product_provider/product_provider.dart';
import 'package:amazon/controller/services/product_services/product_services.dart';
import 'package:amazon/model/product_model.dart';
import 'package:amazon/view/seller/add_product_screen/add_products_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../utils/colors.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SellerProductProvider>().fecthSellerProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                PageTransition(
                    child: const AddProductScreen(),
                    type: PageTransitionType.rightToLeft));
          },
          backgroundColor: amber,
          child: Icon(
            Icons.add,
            color: black,
          ),
        ),
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
        body: Container(
          width: width,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
            vertical: height * 0.02,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer<SellerProductProvider>(
                    builder: (context, sellerProductProvider, child) {
                  if (sellerProductProvider.sellerProductsFetched == false) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (sellerProductProvider.products.isEmpty) {
                    return Center(
                      child: Text(
                        'No Products Found',
                        style: textTheme.bodyMedium,
                      ),
                    );
                  }
                  return ListView.builder(
                      itemCount: sellerProductProvider.products.length,
                      shrinkWrap: true,
                      physics: const PageScrollPhysics(),
                      itemBuilder: (context, index) {
                        ProductModel currentModel =
                            sellerProductProvider.products[index];

                        return StreamBuilder(
                            stream: ProductServices.fetchSalesPerProduct(
                                productID: currentModel.productID!),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data!.isEmpty) {
                                  return SizedBox();
                                } else {
                                  return Container(
                                    height: height * 0.3,
                                    width: width,
                                    margin: EdgeInsets.symmetric(
                                      vertical: height * 0.01,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.02,
                                        vertical: height * 0.01),
                                    decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(
                                        10,
                                      ),
                                      border: Border.all(
                                        color: grey,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        CarouselSlider(
                                          options: CarouselOptions(
                                            height: height * 0.2,
                                            autoPlay: false,
                                            viewportFraction: 1,
                                          ),
                                          items:
                                              currentModel.imagesURL!.map((i) {
                                            return Builder(
                                              builder: (BuildContext context) {
                                                return Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                    color: white,
                                                    image: DecorationImage(
                                                      image: NetworkImage(i),
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }).toList(),
                                        ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 7,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    currentModel.name!,
                                                    style: textTheme.bodyMedium!
                                                        .copyWith(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Revenue: ',
                                                          style: textTheme
                                                              .bodySmall!,
                                                        ),
                                                        TextSpan(
                                                          text: '₹ ${snapshot.data!.fold(
                                                                0.0,
                                                                (previousValue,
                                                                        product) =>
                                                                    previousValue +
                                                                    (product.productCount! *
                                                                        product
                                                                            .discountedPrice!),
                                                              ).toStringAsFixed(0)}',

                                                          // textAlign: TextAlign.justify,
                                                          // maxLines: 2,
                                                          style: textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Qty: ',
                                                          style: textTheme
                                                              .bodySmall!,
                                                        ),
                                                        TextSpan(
                                                          text: snapshot.data!
                                                              .fold(
                                                                0.0,
                                                                (previousValue,
                                                                        product) =>
                                                                    previousValue +
                                                                    (product
                                                                        .productCount!),
                                                              )
                                                              .toStringAsFixed(
                                                                  0),

                                                          // textAlign: TextAlign.justify,
                                                          // maxLines: 2,
                                                          style: textTheme
                                                              .bodySmall!
                                                              .copyWith(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            CommonFunctions.blankSpace(
                                              0,
                                              width * 0.02,
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    '₹ ${currentModel.discountedPrice.toString()}',
                                                    style: textTheme.bodyMedium,
                                                  ),
                                                  Text(
                                                    '₹ ${currentModel.price.toString()}',
                                                    style: textTheme
                                                        .labelMedium!
                                                        .copyWith(
                                                            color: grey,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough),
                                                  ),
                                                  Text(
                                                    currentModel.inStock!
                                                        ? 'in Stock'
                                                        : 'Out of Stock',
                                                    style: textTheme.bodySmall!
                                                        .copyWith(
                                                            color: currentModel
                                                                    .inStock!
                                                                ? teal
                                                                : red),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }
                              if (snapshot.hasError) {
                                return Text(
                                  'Opps! Error Loading Data, Please contact Admin',
                                  style: textTheme.bodyMedium,
                                );
                              } else {
                                return SizedBox();
                              }
                            });
                      });
                })
              ],
            ),
          ),
        ));
  }
}
