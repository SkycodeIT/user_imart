import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/api/cart_repository.dart';
import 'package:imart/api/product_repository.dart';
import 'package:imart/const/asseth_path.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/const/user_token.dart';
import 'package:imart/model/get_cart_list_response_model.dart';
import 'package:imart/model/get_product_by_cat_response_model.dart';
import 'package:imart/ui_section/customer/drawer/main_drawer.dart';
import 'package:imart/ui_section/customer/product/product_cart_list.dart';
import 'package:imart/ui_section/customer/product/product_detail.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class OfferPage extends StatefulWidget {
  OfferPage({this.title});
  final String? title;

  @override
  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<GetProductbyCatIdResponseData>? productsList = [];
  List<GetProductbyCatIdResponseData>? offerLists = [];
  var userId;
  GetCartListResponseModel? cartResponse;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(token!);
    userId = jwtDecodeToken['_id'];
    print(jwtDecodeToken);
    callApi();
  }

  callApi() async {
    try {
      GetProductbyCatIdResponseModel getProductbyCatIdResponseModel =
          await ProductRepository().getAllProductList();
      if (getProductbyCatIdResponseModel.status == 1) {
        productsList = getProductbyCatIdResponseModel.data;
        offerLists = [];
        for (int i = 0; i < productsList!.length; i++) {
          if (100 -
                  ((int.parse(productsList?[i].sellPrice ?? "1") /
                          int.parse(productsList?[i].mrpPrice ?? "1") *
                          100))
                      .toInt() >
              40) {
            offerLists?.add(productsList![i]);
          }
        }
      } else {
        EasyLoading.showToast(
            getProductbyCatIdResponseModel.message.toString());
      }
      GetCartListResponseModel responseModel =
          await CartRepository().getCart(userId: userId);
      if (responseModel.status == 1) {
        cartResponse = responseModel;
      } else {
        EasyLoading.showToast(cartResponse!.message.toString());
      }
    } catch (e) {
      print(e);
      EasyLoading.showToast(e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const MainDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: MyTheme.accent_color),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Image.asset(
                        ImagePath.icDrawer,
                        height: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Offers',
                    style: TextStyle(
                      color: MyTheme.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => const ProductCartList(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Stack(
                        children: [
                          Icon(
                            CupertinoIcons.cart,
                            color: MyTheme.white,
                          ),
                          Positioned(
                            top: -7,
                            right: -4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                cartResponse?.data?.length.toString() ?? '0',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  callApi();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      offers(),
                      const SizedBox(height: 90),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget offers() {
    return offerLists?.length == 0
        ? const Center(
            child: Text(
              'Loading ...',
            ),
          )
        : ListView.builder(
            itemCount: offerLists?.length ?? 0,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              bool p = false;
              int quan = 0;
              int i = 0;
              for (i = 0; i < cartResponse!.data!.length; i++) {
                if (cartResponse?.data?[i].productId ==
                    offerLists?[index].productId) {
                  p = true;
                  quan = cartResponse?.data?[i].quantity ?? 0;
                  break;
                }
              }
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                        id: offerLists?[index].productId,
                      ),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(bottom: 10, top: 10, left: 8),
                      margin: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 10,
                      ),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            width: 70,
                            height: 70,
                            decoration: const BoxDecoration(),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      offerLists?[index].image![0] ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      offerLists?[index].productName ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[200],
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      '${offerLists?[index].unit} ${offerLists?[index].kgOrgm}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'MPR: ₹${offerLists?[index].mrpPrice ?? ''}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[600],
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '₹${offerLists?[index].sellPrice ?? ''}',
                                          style: const TextStyle(
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                    p == true
                                        ? SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                // border: Border.all(
                                                //   color: MyTheme.accent_color,
                                                //   width: 1,
                                                // ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () async {
                                                      await callApidecToCart(
                                                        cartId: cartResponse
                                                            ?.data?[i].cartId,
                                                        productId: offerLists?[
                                                                    index]
                                                                .productId ??
                                                            000,
                                                        quantity: quan,
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  4),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  4),
                                                        ),
                                                        color: MyTheme
                                                            .accent_color,
                                                      ),
                                                      child: const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 4,
                                                        ),
                                                        child: Text(
                                                          '-',
                                                          style: TextStyle(
                                                            fontSize: 25,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 7,
                                                      vertical: 6,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: MyTheme.white,
                                                    ),
                                                    child: Text(
                                                      "$quan",
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  InkWell(
                                                    onTap: () async {
                                                      await callApiIncToCart(
                                                        productId: offerLists?[
                                                                    index]
                                                                .productId ??
                                                            000,
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  4),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  4),
                                                        ),
                                                        color: MyTheme
                                                            .accent_color,
                                                      ),
                                                      child: const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 3,
                                                        ),
                                                        child: Text(
                                                          '+',
                                                          style: TextStyle(
                                                            fontSize: 25,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () async {
                                              callApiAddToCart(
                                                productId: offerLists?[index]
                                                        .productId ??
                                                    000,
                                                quantity: 1,
                                              );
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 6,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: MyTheme.accent_color,
                                              ),
                                              child: const Text(
                                                'Add',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                          ),
                          color: Colors.red,
                        ),
                        child: Text(
                          "${100 - ((int.parse(offerLists?[index].sellPrice ?? "1") / int.parse(offerLists?[index].mrpPrice ?? "1") * 100)).toInt()}% Off",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }

  callApiAddToCart({int? productId, int? quantity}) async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );

      var response = await CartRepository()
          .addToCart(userId: userId, id: productId, quantity: quantity);

      productsList = [];
      await callApi();
      await EasyLoading.dismiss();
      if (response['status'] == 1) {
      } else {
        EasyLoading.showToast(response['message']);
      }
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
  }

  manageWishlist({String? productName, int? wishList, int? i}) async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );
      var response = await ProductRepository().manageWishlist(
        productName: productName,
        wishList: wishList,
      );
      await EasyLoading.dismiss();
      if (response['status'] == 1) {
        productsList?[i!].isWishlist = wishList;
        setState(() {});
      } else {
        EasyLoading.showToast(response['message']);
      }
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
  }

  callApiIncToCart({int? productId}) async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );
      var response = await CartRepository().incToCart(
        userId: userId,
        id: productId,
      );
      await EasyLoading.dismiss();
      if (response['status'] == 1) {
        productsList = [];
        await callApi();
        setState(() {});
      } else {
        EasyLoading.showToast(response['message']);
      }
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
  }

  callApidecToCart({String? cartId, int? productId, int? quantity}) async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );
      var response = quantity == 1
          ? await CartRepository().deleteCart(id: cartId)
          : await CartRepository().decToCart(userId: userId, id: productId);
      await EasyLoading.dismiss();
      if (response['status'] == 1) {
        productsList = [];
        await callApi();
        setState(() {});
      } else {
        EasyLoading.showToast(response['message']);
      }
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
  }
}
