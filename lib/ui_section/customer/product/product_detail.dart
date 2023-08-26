import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/api/cart_repository.dart';
import 'package:imart/api/product_repository.dart';
import 'package:imart/const/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:imart/const/user_token.dart';
import 'package:imart/model/get_cart_detail_response_model.dart';
import 'package:imart/model/get_product_detail_response_model.dart';
import 'package:imart/ui_section/customer/product/product_cart_list.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ProductDetailPage extends StatefulWidget {
  ProductDetailPage({this.id});
  final int? id;

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ProductDetailResponseModel? productDetail;
  GetCartDetailResponseModel? cartDetails;

  List<String>? offerList = [
    'assets/image/banana1.png',
    'assets/image/banana2.jpg',
  ];

  var userId;
  var isExistInCart = false;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(token!);
    userId = jwtDecodeToken['_id'];
    getproductData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        CupertinoIcons.left_chevron,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    productDetail?.data?.productName ?? '',
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
                      child: Icon(
                        CupertinoIcons.cart,
                        color: MyTheme.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            productDetail == null
                ? const SizedBox()
                : Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: offerSlide(),
                          ),
                          productPrice(),
                          isExistInCart
                              ? Container(
                                  margin: const EdgeInsets.only(
                                    top: 15,
                                    left: 20,
                                    right: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: MyTheme.accent_color,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 5),
                                      InkWell(
                                        onTap: () async {
                                          await callApidecToCart(
                                            cartId: cartDetails?.data?.cartId,
                                            productId: widget.id ?? 000,
                                            quantity:
                                                cartDetails?.data?.quantity,
                                          );
                                        },
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: const Center(
                                            child: Text(
                                              '-',
                                              style: TextStyle(fontSize: 30),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: MyTheme.accent_color,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${cartDetails?.data?.quantity ?? 0}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      InkWell(
                                        onTap: () async {
                                          await callApiIncToCart(
                                            productId: widget.id ?? 000,
                                          );
                                        },
                                        child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: const Center(
                                            child: Text(
                                              '+',
                                              style: TextStyle(fontSize: 30),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : addCartBtn(),
                          productDescription(),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget offerSlide() {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 1.2,
        viewportFraction: 1.0,
        autoPlay: true,
      ),
      items: productDetail?.data?.image?.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(i, fit: BoxFit.fill),
            );
          },
        );
      }).toList(),
    );
  }

  Widget productPrice() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${productDetail?.data?.sellPrice} ₹',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            '${productDetail?.data?.productName} - ${productDetail?.data?.unit}${productDetail?.data?.kgOrgm}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget addCartBtn() {
    return InkWell(
      onTap: () {
        callApiAddToCart(
          productId: productDetail?.data?.productId ?? 000,
          quantity: 1,
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.only(left: 20, right: 20, top: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: MyTheme.accent_color,
        ),
        child: const Center(
          child: Text(
            'Add to Cart',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget productDescription() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Description',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(color: Colors.grey, thickness: 1.5),
          Text(
            '${productDetail?.data?.description}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  getproductData() async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );

      ProductDetailResponseModel productDetailResponseModel =
          await ProductRepository().getProductDetail(id: widget.id);

      await EasyLoading.dismiss();

      if (productDetailResponseModel.status == 1) {
        productDetail = productDetailResponseModel;
      } else {}
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
    await checkExistInCart(productId: widget.id);
    setState(() {});
  }

  checkExistInCart({int? productId}) async {
    isExistInCart = true;
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );

      GetCartDetailResponseModel getCartDetailResponseModel =
          await CartRepository().checkExistInCart(
        userId: userId,
        productId: productId,
      );

      await EasyLoading.dismiss();

      if (getCartDetailResponseModel.status == 1) {
        if (getCartDetailResponseModel.message == "Exist in Cart") {
          isExistInCart = true;
        } else {
          isExistInCart = false;
        }
        cartDetails = getCartDetailResponseModel;
      } else {
        isExistInCart = false;
      }
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
    setState(() {});
  }

  callApiAddToCart({int? productId, int? quantity}) async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );

      var response = await CartRepository().addToCart(
        userId: userId,
        id: productId,
        quantity: quantity,
      );

      await EasyLoading.dismiss();

      if (response['status'] == 1) {
        checkExistInCart(productId: productId);
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
      var response =
          await CartRepository().incToCart(userId: userId, id: productId);
      await EasyLoading.dismiss();
      // EasyLoading.showToast(response['message']);
      if (response['status'] == 1) {
        checkExistInCart(productId: productId);
        setState(() {});
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
      // EasyLoading.showToast(response['message']);
      if (response['status'] == 1) {
        checkExistInCart(productId: productId);
        setState(() {});
      }
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
  }
}
