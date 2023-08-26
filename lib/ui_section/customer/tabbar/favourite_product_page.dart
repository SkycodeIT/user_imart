import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/api/cart_repository.dart';
import 'package:imart/api/product_repository.dart';
import 'package:imart/const/asseth_path.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/const/user_token.dart';
import 'package:imart/model/get_cart_list_response_model.dart';
import 'package:imart/model/get_wishlist_response_model.dart';
import 'package:imart/ui_section/customer/drawer/main_drawer.dart';
import 'package:imart/ui_section/customer/product/product_cart_list.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class FavouriteProductPage extends StatefulWidget {
  const FavouriteProductPage({super.key, this.title});
  final String? title;

  @override
  _FavouriteProductPageState createState() => _FavouriteProductPageState();
}

class _FavouriteProductPageState extends State<FavouriteProductPage>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GetWishlistResponseModel? wishlistResponse;

  var userId;
  GetCartListResponseModel? cartResponse;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(token!);
    userId = jwtDecodeToken['_id'];
    print(jwtDecodeToken);
    getproductData();
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
                    'Favourite',
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
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                cartResponse?.data?.length.toString() ?? '0',
                                style: TextStyle(
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
            favouriteProduct(),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }

  Widget favouriteProduct() {
    return Expanded(
      child: RefreshIndicator(
        color: MyTheme.accent_color,
        onRefresh: () async {
          await getproductData();
        },
        child: ListView.builder(
          itemCount: wishlistResponse?.data?.length ?? 0,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(bottom: 10, top: 10, left: 8),
              margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                    decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color: Colors.grey),
                        ),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            wishlistResponse?.data?[index].image![0] ?? "",
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
                          wishlistResponse?.data?[index].productName ?? '',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 5),
                        const SizedBox(height: 5),
                        Text(
                          '${wishlistResponse?.data?[index].sellPrice ?? ''} ₹',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      manageWishlist(
                        productName: wishlistResponse?.data?[index].productName
                            .toString(),
                        i: index,
                        wishList: 0,
                      );
                    },
                    child: Icon(
                      Icons.favorite,
                      color: MyTheme.accent_color,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  getproductData() async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );

      GetWishlistResponseModel response =
          await ProductRepository().getWishlist();
      await EasyLoading.dismiss();
      if (response.status == 1) {
        wishlistResponse = response;
      } else {}

      GetCartListResponseModel responseModel =
          await CartRepository().getCart(userId: userId);
      if (responseModel.status == 1) {
        cartResponse = responseModel;
      } else {}
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
    if (mounted) setState(() {});
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
        wishlistResponse?.data?.removeAt(i!);
        getproductData();
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
