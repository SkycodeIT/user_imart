import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/api/cart_repository.dart';
import 'package:imart/api/checkout_repository.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/const/user_token.dart';
import 'package:imart/model/get_address_list_response_model.dart';
import 'package:imart/model/get_order_detail_response_model.dart';
import 'package:imart/ui_section/customer/cart/success_order.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    this.total,
    this.addid,
    this.cartProductNames,
    this.eachCartQuantity,
    this.cartMrps,
    this.cartSellPrices,
    this.cartkgOrgm,
    this.cartItemsImages,
    super.key,
  });

  final String? total;
  final String? addid;
  final List<String?>? cartProductNames;
  final List<int?>? eachCartQuantity;
  final List<String?>? cartMrps;
  final List<String?>? cartSellPrices;
  final List<String?>? cartkgOrgm;
  final List<String?>? cartItemsImages;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var userId;
  var userName;
  var id;
  String level = "Cash On delivery";
  GetAddresResponseModel? addresResponseModel;
  TextEditingController nameCont = TextEditingController();
  TextEditingController phoneCont = TextEditingController();
  TextEditingController upiCont = TextEditingController();
  AddressDetailResponseData? addressDetailResponseData;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(token!);
    userId = jwtDecodeToken['_id'];
    userName = jwtDecodeToken['name'];
    getSpecificAddress();
  }

  getSpecificAddress() async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );

      AddressDetailResponseModel responseModel =
          await CheckoutRepository().getSpecificAddress(id: widget.addid);

      await EasyLoading.dismiss();

      if (responseModel.status == 1) {
        addressDetailResponseData = responseModel.data;
        nameCont = TextEditingController(
          text:
              '${addressDetailResponseData?.firstName} ${addressDetailResponseData?.lastName}',
        );
        phoneCont = TextEditingController(
          text: addressDetailResponseData?.mobileNumber,
        );
        print(addressDetailResponseData?.address);
      } else {}
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
    setState(() {});
  }

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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    paymentBody(),
                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: InkWell(
                onTap: () async {
                  callApiPlaceOrder();
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 75),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: MyTheme.accent_color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Pay ₹${widget.total}",
                      style: const TextStyle(
                        wordSpacing: 2,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paymentBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 40,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              "Payment Details",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 40),
          TextField(
            controller: nameCont,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(),
              label: Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.green.shade900,
                  ),
                  Text(
                    " Name ",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.green.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          TextField(
            controller: phoneCont,
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(),
              label: Row(
                children: [
                  Icon(
                    Icons.call,
                    size: 20,
                    color: Colors.green.shade900,
                  ),
                  Text(
                    " Phone Number ",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.green.shade900,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "Payment Type: ",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Radio(
                value: "Cash On delivery",
                groupValue: level,
                onChanged: (value) {
                  setState(() {
                    level = value.toString();
                  });
                },
                activeColor: Colors.green.shade900,
              ),
              const SizedBox(width: 5),
              TextButton(
                onPressed: () {
                  setState(() {
                    level = "Cash On delivery";
                  });
                },
                child: const Text(
                  "Cash On delivery",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Radio(
                value: "UPI",
                groupValue: level,
                onChanged: (value) {
                  setState(() {
                    level = value.toString();
                  });
                },
                activeColor: Colors.green.shade900,
              ),
              const SizedBox(width: 5),
              TextButton(
                onPressed: () {
                  setState(() {
                    level = "UPI";
                  });
                },
                child: const Text(
                  "UPI",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          level == "UPI"
              ? TextField(
                  controller: upiCont,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(),
                    label: Row(
                      children: [
                        Icon(
                          Icons.payments,
                          size: 20,
                          color: Colors.green.shade900,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          " UPI ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.green.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  callApiPlaceOrder() async {
    try {
      await EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
      );
      var response = await CheckoutRepository().updateDefaultAdress(id, userId);
      var response1 = await CartRepository().placeOrder(
        userId: userId,
        addid: widget.addid,
        name: nameCont.text,
        total: widget.total,
        payment: level.toLowerCase(),
        mobile: phoneCont.text,
      );
      if (response['status'] == 1 && response1['status'] == 1) {
        print(response1['data']['_id']);
        var response3 = await CartRepository().addOrderItems(
          orderId: response1['data']['_id'],
          productName: widget.cartProductNames,
          quantity: widget.eachCartQuantity,
          mrpPrice: widget.cartMrps,
          sellPrice: widget.cartSellPrices,
          kgOrgm: widget.cartkgOrgm,
          image: widget.cartItemsImages,
        );
        if (response3['status'] == 1) {
          EasyLoading.showToast(response1['message']);
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (builder) => const SuccessOrderPage(),
            ),
            (route) => false,
          );
        } else {
          EasyLoading.showToast(response3['message']);
        }
      } else {
        EasyLoading.showToast(response1['message']);
      }
      await EasyLoading.dismiss();
    } catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showToast(e.toString());
    }
  }
}
