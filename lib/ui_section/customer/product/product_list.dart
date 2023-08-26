import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/api/cart_repository.dart';
import 'package:imart/api/product_repository.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/const/user_token.dart';
import 'package:imart/model/get_cart_list_response_model.dart';
import 'package:imart/model/get_product_by_cat_response_model.dart';
import 'package:imart/ui_section/customer/product/product_cart_list.dart';
import 'package:imart/ui_section/customer/product/product_detail.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class ProductListPage extends StatefulWidget {
  ProductListPage({this.title, this.catId});
  final String? title;
  final String? catId;

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage>
    with TickerProviderStateMixin {
  // List<GetSubCategoryResponseData>? filterTagList = [];
  // final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  List<GetProductbyCatIdResponseData>? subCatList = [];
  GetCartListResponseModel? cartResponse;
  // String? selectedCatName = 'All';
  // String? selectedId;
  var userId;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(token!);
    userId = jwtDecodeToken['_id'];
    getproductData();
  }

  getproductData() async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );

      GetProductbyCatIdResponseModel getProductbyCatIdResponseModel =
          await ProductRepository().getProductListByCategory(id: widget.catId);
      if (getProductbyCatIdResponseModel.status == 1) {
        subCatList = getProductbyCatIdResponseModel.data;
      } else {}

      // GetSubCategoryResponseModel getSubCategoryResponseModel =
      //     await ProductRepository().getSubCategory(id: widget.catId);
      // if (getSubCategoryResponseModel.status == 1) {
      //   selectedCatName = 'All';
      //   filterTagList?.add(
      //     GetSubCategoryResponseData(
      //       name: 'All',
      //       categorieId: widget.catId,
      //       description: 'All subcategories',
      //       id: '000',
      //     ),
      //   );
      //   filterTagList!.addAll(getSubCategoryResponseModel.data!);
      // }

      GetCartListResponseModel responseModel =
          await CartRepository().getCart(userId: userId);
      if (responseModel.status == 1) {
        cartResponse = responseModel;
      } else {}
      print(subCatList?.length);
      print(cartResponse?.data?.length);
      await EasyLoading.dismiss();
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
    setState(() {});
  }

  // callApiForGetSubCatData() async {
  //   try {
  //     // await EasyLoading.show(
  //     //   status: 'loading...',
  //     //   maskType: EasyLoadingMaskType.black,
  //     // );
  //     GetProductbyCatIdResponseModel getProductbyCatIdResponseModel =
  //         await ProductRepository().getProductListBySubCategory(
  //       id: widget.catId,
  //       subId: selectedId,
  //     );
  //     await EasyLoading.dismiss();
  //     if (getProductbyCatIdResponseModel.status == 1) {
  //       subCatList = getProductbyCatIdResponseModel.data;
  //     } else {}
  //     GetCartListResponseModel responseModel =
  //         await CartRepository().getCart(userId: userId);
  //     if (responseModel.status == 1) {
  //       cartResponse = responseModel;
  //     } else {}
  //   } catch (e) {
  //     await EasyLoading.dismiss();
  //     EasyLoading.showToast(e.toString());
  //   }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      Navigator.pop(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        CupertinoIcons.left_chevron,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    widget.title!,
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
            const SizedBox(height: 10),
            // filterTag(),
            searchBar(),
            const SizedBox(height: 15),
            Expanded(
              child: subCatList!.isEmpty
                  ? const Center(
                      child: Text('No Items'),
                    )
                  : _searchController.text.isEmpty
                      ? SingleChildScrollView(
                          child: Column(
                            children: [
                              productListWidget(),
                              const SizedBox(height: 90),
                            ],
                          ),
                        )
                      : productListWidget2(),
            ),
          ],
        ),
      ),
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

  Widget productListWidget() {
    return ListView.builder(
      itemCount: subCatList?.length ?? 0,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        bool p = false;
        int quan = 0;
        int i = 0;
        for (i = 0; i < cartResponse!.data!.length; i++) {
          if (cartResponse?.data?[i].productId ==
              subCatList?[index].productId) {
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
                  id: subCatList?[index].productId,
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 10, top: 10, left: 8),
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
                      decoration: const BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          // border: Border.all(color: Colors.grey),
                          ),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                subCatList?[index].image![0] ?? ''),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                subCatList?[index].productName ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  manageWishlist(
                                    productName: subCatList?[index]
                                        .productName
                                        .toString(),
                                    i: index,
                                    wishList: subCatList?[index].isWishlist == 1
                                        ? 0
                                        : 1,
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Icon(
                                    subCatList?[index].isWishlist == 1
                                        ? Icons.favorite
                                        : Icons.favorite_border_outlined,
                                    color: MyTheme.accent_color,
                                  ),
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
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                '${subCatList?[index].unit} ${subCatList?[index].kgOrgm}',
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'MPR: ₹${subCatList?[index].mrpPrice ?? ''}',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[600],
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '₹${subCatList?[index].sellPrice ?? ''}',
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
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                await callApidecToCart(
                                                  cartId: cartResponse
                                                      ?.data?[i].cartId,
                                                  productId: subCatList?[index]
                                                          .productId ??
                                                      000,
                                                  quantity: quan,
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft: Radius.circular(4),
                                                    bottomLeft:
                                                        Radius.circular(4),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: MyTheme.white,
                                              ),
                                              child: Text(
                                                "$quan",
                                                style: TextStyle(
                                                  color: MyTheme.accent_color,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            InkWell(
                                              onTap: () async {
                                                await callApiIncToCart(
                                                  productId: subCatList?[index]
                                                          .productId ??
                                                      000,
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(4),
                                                    bottomRight:
                                                        Radius.circular(4),
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
                                    )
                                  : InkWell(
                                      onTap: () async {
                                        callApiAddToCart(
                                          productId:
                                              subCatList?[index].productId ??
                                                  000,
                                          quantity: 1,
                                        );
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        padding: const EdgeInsets.symmetric(
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
                    "${100 - ((int.parse(subCatList?[index].sellPrice ?? "1") / int.parse(subCatList?[index].mrpPrice ?? "1") * 100)).toInt()}% Off",
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

  Widget productListWidget2() {
    return ListView.builder(
      itemCount: subCatList?.length ?? 0,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        bool p = false;
        int quan = 0;
        int i = 0;
        for (i = 0; i < cartResponse!.data!.length; i++) {
          if (cartResponse?.data?[i].productId ==
              subCatList?[index].productId) {
            p = true;
            quan = cartResponse?.data?[i].quantity ?? 0;
            break;
          }
        }
        return (subCatList?[index].productName!.toLowerCase() ?? '')
                .contains(_searchController.text.toLowerCase())
            ? InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(
                        id: subCatList?[index].productId,
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
                          left: 10, right: 10, bottom: 10),
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
                            decoration: const BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                // border: Border.all(color: Colors.grey),
                                ),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      subCatList?[index].image![0] ?? ''),
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
                                      subCatList?[index].productName ?? '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        manageWishlist(
                                          productName: subCatList?[index]
                                              .productName
                                              .toString(),
                                          i: index,
                                          wishList:
                                              subCatList?[index].isWishlist == 1
                                                  ? 0
                                                  : 1,
                                        );
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Icon(
                                          subCatList?[index].isWishlist == 1
                                              ? Icons.favorite
                                              : Icons.favorite_border_outlined,
                                          color: MyTheme.accent_color,
                                        ),
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
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Text(
                                      '${subCatList?[index].unit} ${subCatList?[index].kgOrgm}',
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
                                          'MPR: ₹${subCatList?[index].mrpPrice ?? ''}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[600],
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '₹${subCatList?[index].sellPrice ?? ''}',
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
                                                  // const SizedBox(width: 5),
                                                  InkWell(
                                                    onTap: () async {
                                                      await callApidecToCart(
                                                        cartId: cartResponse
                                                            ?.data?[i].cartId,
                                                        productId: subCatList?[
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
                                                        productId: subCatList?[
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
                                                productId: subCatList?[index]
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
                          "${100 - ((int.parse(subCatList?[index].sellPrice ?? "1") / int.parse(subCatList?[index].mrpPrice ?? "1") * 100)).toInt()}% Off",
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
              )
            : const SizedBox.shrink();
      },
    );
  }

  // Widget filterTag() {
  //   return Tags(
  //     key: _tagStateKey,
  //     itemCount: filterTagList!.length,
  //     itemBuilder: (int index) {
  //       // final item = filterTagList![index];
  //       return ItemTags(
  //         color: Colors.white,
  //         activeColor: MyTheme.accent_color,
  //         border: Border.all(color: MyTheme.accent_color),
  //         borderRadius: BorderRadius.circular(8),
  //         elevation: 0,
  //         textActiveColor: Colors.white,
  //         key: Key(index.toString()),
  //         index: index,
  //         title: filterTagList![index].name.toString(),
  //         singleItem: true,
  //         textStyle: TextStyle(fontSize: 14, color: MyTheme.accent_color),
  //         combine: ItemTagsCombine.withTextBefore,
  //         onPressed: (item) {
  //           // selectedCatName = filterTagList![index].name;
  //           // selectedId = filterTagList![index].id;
  //           // if (selectedCatName == "All") {
  //           //   filterTagList?.clear();
  //           //   getproductData();
  //           // } else {
  //           //   callApiForGetSubCatData();
  //           // }
  //         },
  //         onLongPressed: (item) => print(item),
  //       );
  //     },
  //   );
  // }

  callApiAddToCart({int? productId, int? quantity}) async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );
      var response = await CartRepository()
          .addToCart(userId: userId, id: productId, quantity: quantity);
      subCatList = [];
      // if (selectedCatName == "All") {
      // filterTagList?.clear();
      await getproductData();
      // } else {
      // await callApiForGetSubCatData();
      //}
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
      var response = await ProductRepository()
          .manageWishlist(productName: productName, wishList: wishList);
      await EasyLoading.dismiss();
      if (response['status'] == 1) {
        subCatList?[i!].isWishlist = wishList;
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
      if (response['status'] == 1) {
        subCatList = [];
        // if (selectedCatName == "All") {
        // filterTagList?.clear();
        await getproductData();
        // } else {
        // await callApiForGetSubCatData();
        // }
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
        subCatList = [];
        // if (selectedCatName == "All") {
        // filterTagList?.clear();
        await getproductData();
        // } else {
        // await callApiForGetSubCatData();
        // }
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
