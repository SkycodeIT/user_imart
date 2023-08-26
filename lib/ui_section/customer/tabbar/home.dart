import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/api/cart_repository.dart';
import 'package:imart/api/product_repository.dart';
import 'package:imart/const/asseth_path.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/const/user_token.dart';
import 'package:imart/model/get_cart_list_response_model.dart';
import 'package:imart/model/get_category_response_model.dart';
import 'package:imart/model/get_product_by_cat_response_model.dart';
import 'package:imart/ui_section/customer/drawer/main_drawer.dart';
import 'package:imart/ui_section/customer/product/product_cart_list.dart';
import 'package:imart/ui_section/customer/product/product_detail.dart';
import 'package:imart/ui_section/customer/product/product_list.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Home extends StatefulWidget {
  Home({this.title});
  final String? title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  List<GetProductbyCatIdResponseData>? allProductList = [];
  List<CategoryResponseData?>? getCatagoryResponseList;

  List<String>? offerList = [
    'assets/image/dummy_offer.png',
    'assets/image/dummy_offer1.png',
  ];

  var userId;
  GetCartListResponseModel? cartResponse;

  @override
  void initState() {
    super.initState();
    getCategoryData();
    print(token);
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(token!);
    userId = jwtDecodeToken['_id'];
    print(jwtDecodeToken);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color.fromRGBO(247, 249, 250, 1.0),
        drawer: const MainDrawer(),
        body: Column(
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
                  Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          ImagePath.icAppbarIcon,
                        ),
                      ),
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
            searchBar(),
            const SizedBox(height: 15),
            Expanded(
              child: _searchController.text.isEmpty
                  ? RefreshIndicator(
                      onRefresh: () async {
                        await getCategoryData();
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            offerSlide(),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, top: 25, bottom: 7),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Categories',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await getCategoryData();
                                      },
                                      icon: const Icon(Icons.replay_rounded),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            categoryList(),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20, top: 5, bottom: 7),
                                child: Text(
                                  'Recommended For You',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            popularProduct(),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    )
                  : productListWidget(),
            ),
          ],
        ),
      ),
    );
  }

  Widget offerSlide() {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 2.5,
        viewportFraction: 1.0,
        autoPlay: true,
      ),
      items: offerList!.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage(i),
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget categoryList() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: getCatagoryResponseList?.length ?? 0,
        itemBuilder: (BuildContext ctx, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListPage(
                    catId: getCatagoryResponseList![index]?.id,
                    title: getCatagoryResponseList![index]?.name ?? '',
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(bottom: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.12,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/image/fruits.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        // index == productCategory!.length ? 'View all' :
                        getCatagoryResponseList![index]?.name ?? '',
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget popularProduct() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
      height: 250,
      child: ListView.builder(
        itemCount: allProductList?.length ?? 0,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          bool p = false;
          int quan = 0;
          int i = 0;
          for (i = 0; i < cartResponse!.data!.length; i++) {
            if (cartResponse?.data?[i].productId ==
                allProductList?[index].productId) {
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
                    id: allProductList?[index].productId,
                  ),
                ),
              );
            },
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(bottom: 10),
              margin: EdgeInsets.only(left: index == 0 ? 0 : 10),
              width: 100,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                        // borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color: Colors.grey),
                        ),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            allProductList?[index].image![0] ?? "",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 25,
                      child: Text(
                        allProductList![index].productName ?? "",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "MRP: ₹${allProductList?[index].mrpPrice}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "₹${allProductList?[index].sellPrice}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  p == true
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.5),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              margin: const EdgeInsets.only(top: 15),
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
                                        cartId: cartResponse?.data?[i].cartId,
                                        productId:
                                            allProductList?[index].productId ??
                                                000,
                                        quantity: quan,
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
                                      "$quan",
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
                                        productId:
                                            allProductList?[index].productId ??
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
                        )
                      : InkWell(
                          onTap: () {
                            callApiAddToCart(
                              productId:
                                  allProductList?[index].productId ?? 000,
                              quantity: 1,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 15),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: MyTheme.accent_color,
                            ),
                            child: const Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget productListWidget() {
    return ListView.builder(
      itemCount: allProductList?.length ?? 0,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return (allProductList?[index].productName!.toLowerCase() ?? '')
                .contains(_searchController.text.toLowerCase())
            ? Container(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  top: 10,
                  left: 8,
                ),
                margin: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
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
                              allProductList?[index].image![0] ?? "",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                id: allProductList?[index].productId,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              allProductList?[index].productName ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '₹${allProductList?[index].mrpPrice ?? ''}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[600],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '₹${allProductList?[index].sellPrice ?? ''}',
                              style: const TextStyle(fontSize: 15),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: MyTheme.accent_color),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "${100 - ((int.parse(allProductList?[index].sellPrice ?? "1") / int.parse(allProductList?[index].mrpPrice ?? "1") * 100)).toInt()}% Off",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: MyTheme.accent_color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            manageWishlist(
                              productName:
                                  allProductList?[index].productName.toString(),
                              i: index,
                              wishList: allProductList?[index].isWishlist == 1
                                  ? 0
                                  : 1,
                            );
                          },
                          child: Icon(
                            allProductList?[index].isWishlist == 1
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: MyTheme.accent_color,
                          ),
                        ),
                        const SizedBox(height: 30),
                        InkWell(
                          onTap: () async {
                            callApiAddToCart(
                              productId:
                                  allProductList![index].productId ?? 000,
                              quantity: 1,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
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
                  ],
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }

  Widget searchBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(right: 20, left: 20, top: 15),
      // padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: _searchController,
        onTap: () {},
        onChanged: (txt) {
          setState(() {});
        },
        onSubmitted: (txt) {},
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Search Product',
          hintStyle: TextStyle(fontSize: 14.0, color: MyTheme.textfield_grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: MyTheme.accent_color, width: 2.0),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.accent_color, width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: MyTheme.accent_color, width: 2.0),
          ),
          prefixIcon: Icon(Icons.search, color: MyTheme.accent_color),
          suffixIcon: Icon(Icons.mic, color: MyTheme.accent_color),
          contentPadding: const EdgeInsets.only(left: 10),
        ),
      ),
    );
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
        allProductList = getSubCatagoryResponseModel.data;
      } else {}
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
    await callApiForGetCart();
    setState(() {});
  }

  callApiForGetCart() async {
    try {
      GetCartListResponseModel responseModel =
          await CartRepository().getCart(userId: userId);
      if (responseModel.status == 1) {
        cartResponse = responseModel;
      } else {}
    } catch (e) {
      print(e);
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
      var response = await ProductRepository()
          .manageWishlist(productName: productName, wishList: wishList);
      await EasyLoading.dismiss();
      if (response['status'] == 1) {
        allProductList?[i!].isWishlist = wishList;
        callApiGetAllProduct();
        setState(() {});
      } else {
        EasyLoading.showToast(response['message']);
      }
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
  }

  callApiAddToCart({int? productId, int? quantity}) async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );
      var response = await CartRepository()
          .addToCart(userId: userId, id: productId, quantity: quantity);
      await EasyLoading.dismiss();
      if (response['status'] == 1) {
        allProductList = [];
        await callApiGetAllProduct();
        setState(() {});
      } else {
        EasyLoading.showToast(response['message']);
      }
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
  }

  getCategoryData() async {
    try {
      await EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
      );

      GetCatagoryResponseModel getCatagoryResponseModel =
          await ProductRepository().getProductCategory();

      await EasyLoading.dismiss();

      if (getCatagoryResponseModel.status == 1) {
        getCatagoryResponseList = getCatagoryResponseModel.data;
      } else {
        print("Data not got");
      }
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
      print(e);
    }
    setState(() {});
    await callApiGetAllProduct();
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
      if (response['status'] == 1) {
        allProductList = [];
        await callApiGetAllProduct();
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
        allProductList = [];
        await callApiGetAllProduct();
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
