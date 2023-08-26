import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tags_x/flutter_tags_x.dart';
import 'package:imart/api/cart_repository.dart';
import 'package:imart/const/asseth_path.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/const/user_token.dart';
import 'package:imart/model/get_cart_list_response_model.dart';
import 'package:imart/model/get_order_list_response_model.dart';
import 'package:imart/ui_section/customer/drawer/main_drawer.dart';
import 'package:imart/ui_section/customer/order/order_detail.dart';
import 'package:imart/ui_section/customer/product/product_cart_list.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  GetOrderResponseModel? allOrdersResponceModel;
  var userId;
  var userName;
  GetCartListResponseModel? cartResponse;
  String? filterStatus = "All";

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(token!);
    userId = jwtDecodeToken['_id'];
    userName = jwtDecodeToken['name'];
    getAllOrdersData();
  }

  getAllOrdersData() async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );

      GetOrderResponseModel responseModel =
          await CartRepository().allUserOrders(userId: userId);

      await EasyLoading.dismiss();

      if (responseModel.status == 1) {
        allOrdersResponceModel = responseModel;
      } else {}

      GetCartListResponseModel responseModel1 =
          await CartRepository().getCart(userId: userId);
      if (responseModel.status == 1) {
        cartResponse = responseModel1;
      } else {}
      
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
    setState(() {});
  }

  getSpecificOrderData(String item) async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );

      GetOrderResponseModel responseModel =
          await CartRepository().allUserOrders(userId: userId);

      await EasyLoading.dismiss();
      allOrdersResponceModel?.data?.clear();
      if (responseModel.status == 1) {
        final data = responseModel.data;
        if (data != null) {
          for (int i = 0; i < data.length; i++) {
            if (data[i].status == item) {
              allOrdersResponceModel?.data?.add(data[i]);
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

  List<String>? filterTagList = ['All', 'shipped', 'delivered'];

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
                    'Orders',
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
            searchBar(),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: filterTag()),
                  IconButton(
                    onPressed: () async {
                      if (filterStatus == "All") {
                        await getAllOrdersData();
                      } else {
                        await getSpecificOrderData(filterStatus ?? "All");
                      }
                      setState(() {});
                    },
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    orderListWidget(),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderListWidget() {
    return allOrdersResponceModel?.data?.length == 0
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width,
            child: const Center(child: Text("No Orders")),
          )
        : ListView.builder(
            itemCount: allOrdersResponceModel?.data?.length ?? 0,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (builder) => OrderDetailPage(
                        getOrderResponseData:
                            allOrdersResponceModel?.data?[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10, top: 10, left: 8),
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Order id: ${allOrdersResponceModel!.data![index].id}',
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Row(
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
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/image/apple.jpg'),
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
                                    const Text(
                                      'Sold to',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        "${allOrdersResponceModel!.data![index].name}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Order date ',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        "${allOrdersResponceModel!.data![index].date}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total ',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        "${allOrdersResponceModel!.data![index].grandTotal}",
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Status',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        "${allOrdersResponceModel!.data![index].status}",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget searchBar() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(right: 10, left: 10, top: 15),
      child: TextField(
        controller: _searchController,
        onTap: () {},
        onChanged: (txt) {},
        onSubmitted: (txt) {},
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Search Product',
            hintStyle: TextStyle(fontSize: 14.0, color: MyTheme.textfield_grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: MyTheme.accent_color,
                width: 1.0,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Icon(Icons.mic, color: MyTheme.accent_color),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.accent_color, width: 1.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: MyTheme.accent_color, width: 1.0),
            ),
            prefixIcon: Icon(Icons.search, color: MyTheme.accent_color),
            contentPadding: const EdgeInsets.only(left: 10)),
      ),
    );
  }

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
  Widget filterTag() {
    return Tags(
      key: _tagStateKey,
      itemCount: filterTagList!.length,
      itemBuilder: (int index) {
        // final item = filterTagList![index];
        return ItemTags(
          color: Colors.white,
          activeColor: MyTheme.accent_color,
          border: Border.all(color: MyTheme.accent_color),
          borderRadius: BorderRadius.circular(8),
          elevation: 0,
          textActiveColor: Colors.white,
          key: Key(index.toString()),
          index: index,
          title: filterTagList![index],
          textStyle: TextStyle(fontSize: 14, color: MyTheme.accent_color),
          combine: ItemTagsCombine.withTextBefore,
          singleItem: true,
          onPressed: (item) {
            print(item);
            filterStatus = item.title;
            if (filterStatus == "All") {
              getAllOrdersData();
            } else {
              getSpecificOrderData(filterStatus ?? "All");
            }
          },
          onLongPressed: (item) => print(item),
        );
      },
    );
  }
}
