import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/api/cart_repository.dart';
import 'package:imart/api/product_repository.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/const/user_token.dart';
import 'package:imart/model/get_cart_list_response_model.dart';
import 'package:imart/model/get_product_by_cat_response_model.dart';
import 'package:imart/ui_section/customer/cart/get_address_list.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ProductCartList extends StatefulWidget {
  const ProductCartList({super.key, this.title});
  final String? title;

  @override
  _ProductCartList createState() => _ProductCartList();
}

class _ProductCartList extends State<ProductCartList>
    with TickerProviderStateMixin {
  GetCartListResponseModel? cartResponse;
  List<GetProductbyCatIdResponseData>? allCartsList = [];
  GetProductbyCatIdResponseModel? productResponse;
  List<GetProductbyCatIdResponseData>? allProductList = [];
  List<int?>? allCartProductIds = [];
  List<String?>? cartProductNames = [];
  List<int?>? eachCartQuantity = [];
  List<String?>? cartMrps = [];
  List<String?>? cartSellPrices = [];
  List<String?>? cartkgOrgm = [];
  List<String?>? cartItemsImages = [];
  var userId;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(token!);
    userId = jwtDecodeToken['_id'];
    callApiForGetCart();
    callApiGetAllProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: allCartsList == null
          ? const SizedBox.shrink()
          : allCartsList!.isEmpty
              ? const SizedBox.shrink()
              : InkWell(
                  onTap: () {
                    int total = 0;
                    for (var i = 0; i < allCartsList!.length; i++) {
                      total = total +
                          (int.parse(allCartsList![i].sellPrice!) *
                              int.parse(eachCartQuantity![i].toString()));
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => GetAddressList(
                          total: total.toString(),
                          cartProductNames: cartProductNames,
                          eachCartQuantity: eachCartQuantity,
                          cartMrps: cartMrps,
                          cartSellPrices: cartSellPrices,
                          cartkgOrgm: cartkgOrgm,
                          cartItemsImages: cartItemsImages,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 80,
                    ),
                    height: 60,
                    decoration: BoxDecoration(
                      color: MyTheme.accent_color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
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
                    'Checkout',
                    style: TextStyle(
                      color: MyTheme.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'No. Of Items: ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "${allCartsList?.length}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            favouriteProduct(),
          ],
        ),
      ),
    );
  }

  Widget favouriteProduct() {
    return allCartsList!.isEmpty
        ? Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(child: Text("Loading...")),
            ),
          )
        : Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                callApiForGetCart();
                callApiGetAllProduct();
              },
              child: ListView.builder(
                primary: true,
                itemCount: allCartsList?.length ?? 0,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        const EdgeInsets.only(bottom: 10, top: 10, left: 8),
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width * 0.5,
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
                          decoration: const BoxDecoration(
                              // borderRadius: BorderRadius.circular(10),
                              // border: Border.all(color: Colors.grey),
                              ),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                  allCartsList?[index].image![0] ?? "",
                                ),
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
                              Text(
                                allCartsList?[index].productName ?? '',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Text(
                                    '${allCartsList?[index].unit} ${allCartsList?[index].kgOrgm} * ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[600],
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Center(
                                        child: Text(
                                          '${eachCartQuantity![index] ?? 0}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  Text(
                                    '${int.parse(allCartsList![index].mrpPrice!) * int.parse(eachCartQuantity![index].toString())} ₹',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: MyTheme.accent_color),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: Text(
                                      '${100 - (((int.parse(allCartsList![index].sellPrice!) * int.parse(eachCartQuantity![index].toString())) / (int.parse(allCartsList![index].mrpPrice!) * int.parse(eachCartQuantity![index].toString())) * 100).toInt())}% Off',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: MyTheme.accent_color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${int.parse(allCartsList![index].sellPrice!) * int.parse(eachCartQuantity![index].toString())} ₹',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                callApiDeleteToCart(
                                  id: cartResponse?.data?[index].cartId,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 7),
                                child: Icon(
                                  Icons.delete,
                                  color: MyTheme.accent_color,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                margin: const EdgeInsets.only(right: 7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  // border: Border.all(
                                  //   color: MyTheme.accent_color,
                                  //   width: 1,
                                  // ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await callApidecToCart(
                                          cartId: cartResponse
                                              ?.data?[index].cartId,
                                          productId: allCartsList?[index]
                                                  .productId ??
                                              000,
                                          quantity: eachCartQuantity?[index],
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            bottomLeft: Radius.circular(4),
                                          ),
                                          color: MyTheme.accent_color,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: MyTheme.white,
                                      ),
                                      child: Text(
                                        "${cartResponse?.data?[index].quantity ?? 0}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    InkWell(
                                      onTap: () async {
                                        await callApiIncToCart(
                                          productId: allCartsList?[index]
                                                  .productId ??
                                              000,
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(4),
                                            bottomRight: Radius.circular(4),
                                          ),
                                          color: MyTheme.accent_color,
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
  }

  callApiForGetCart() async {
    try {
      GetCartListResponseModel responseModel =
          await CartRepository().getCart(userId: userId);
      if (responseModel.status == 1) {
        cartResponse = responseModel;
        allCartProductIds?.clear();
        eachCartQuantity?.clear();
        for (var element in cartResponse!.data!) {
          allCartProductIds!.add(element.productId ?? 000);
          eachCartQuantity!.add(element.quantity ?? 1);
        }
      } else {}
    } catch (e) {
      print(e);
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
    setState(() {});
  }

  callApiGetAllProduct() async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );
      GetProductbyCatIdResponseModel getSubCatagoryResponseModel =
          await ProductRepository().getAllProductList();
      await EasyLoading.dismiss();
      if (getSubCatagoryResponseModel.status == 1) {
        allProductList = [];
        allCartsList?.clear();
        cartProductNames?.clear();
        cartMrps?.clear();
        cartSellPrices?.clear();
        cartkgOrgm?.clear();
        cartItemsImages?.clear();
        allProductList = getSubCatagoryResponseModel.data;

        for (var ele in allCartProductIds!) {
          for (var element in allProductList!) {
            if (ele == element.productId) {
              allCartsList!.add(element);
              cartProductNames!.add(element.productName);
              cartMrps!.add(element.mrpPrice);
              cartSellPrices!.add(element.sellPrice);
              cartkgOrgm!.add(element.kgOrgm);
              cartItemsImages!.add(element.image?[0]);
            }
          }
        }
      } else {}
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
    setState(() {});
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
        allCartsList = [];
        allProductList = [];
        allCartProductIds = [];
        eachCartQuantity = [];
        await callApiForGetCart();
        await callApiGetAllProduct();
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
        allCartsList = [];
        allProductList = [];
        allCartProductIds = [];
        eachCartQuantity = [];
        await callApiForGetCart();
        await callApiGetAllProduct();
        setState(() {});
      }
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
  }

  callApiDeleteToCart({String? id}) async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );
      var response = await CartRepository().deleteCart(id: id);
      await EasyLoading.dismiss();
      // EasyLoading.showToast(response['message']);
      if (response['status'] == 1) {
        allCartsList = [];
        allProductList = [];
        allCartProductIds = [];
        eachCartQuantity = [];
        await callApiForGetCart();
        await callApiGetAllProduct();
        setState(() {});
      }
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
  }
}
