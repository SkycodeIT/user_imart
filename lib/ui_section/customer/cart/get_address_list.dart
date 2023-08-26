import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:imart/api/checkout_repository.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/const/user_token.dart';
import 'package:imart/model/get_address_list_response_model.dart';
import 'package:imart/ui_section/customer/cart/add_address_list.dart';
import 'package:imart/ui_section/customer/cart/add_auto_detect_address.dart';
import 'package:imart/ui_section/customer/cart/payment.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class GetAddressList extends StatefulWidget {
  const GetAddressList({
    this.total,
    this.cartProductNames,
    this.eachCartQuantity,
    this.cartMrps,
    this.cartSellPrices,
    this.cartkgOrgm,
    this.cartItemsImages,
    Key? key,
  }) : super(key: key);

  final String? total;
  final List<String?>? cartProductNames;
  final List<int?>? eachCartQuantity;
  final List<String?>? cartMrps;
  final List<String?>? cartSellPrices;
  final List<String?>? cartkgOrgm;
  final List<String?>? cartItemsImages;

  @override
  _GetAddressListState createState() => _GetAddressListState();
}

class _GetAddressListState extends State<GetAddressList> {
  int selected = 1;
  var userId;
  var userName;
  var id;
  List<Placemark> placemarks = [];
  GetAddresResponseModel? addresResponseModel;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(token!);
    userId = jwtDecodeToken['_id'];
    userName = jwtDecodeToken['name'];
    getAllAddressData();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  getLatLong() {
    Future<Position> data = _determinePosition();
    data.then((value) {
      getAddress(value.latitude, value.longitude);
    }).catchError((error) {
      print("Error $error");
    });
  }

  getAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    setState(() {});
    // ignore: use_build_context_synchronously
    var data = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => addAutoDetectAddress(address: placemarks),
      ),
    );
    if (data != null && data == true) {
      getAllAddressData();
    }
  }

  getAllAddressData() async {
    try {
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );

      GetAddresResponseModel responseModel =
          await CheckoutRepository().getAllAddress(userId);

      await EasyLoading.dismiss();

      if (responseModel.status == 1) {
        addresResponseModel = responseModel;
        for (var i = 0; i < addresResponseModel!.data!.length; i++) {
          if (addresResponseModel?.data?[i].isDefault == 1) {
            selected = i + 1;
          }
        }
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
      body: SafeArea(child: _body()),
    );
  }

  Widget _body() {
    return Column(
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
                'Address',
                style: TextStyle(
                  color: MyTheme.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  onTap: () async {
                    var data = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => const AddNewAddress(
                          isEdit: false,
                        ),
                      ),
                    );
                    if (data != null && data == true) {
                      getAllAddressData();
                    }
                  },
                  child: const Icon(
                    CupertinoIcons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        _addressList(),
        addresResponseModel == null
            ? const SizedBox.shrink()
            : addresResponseModel!.data == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: InkWell(
                      onTap: () async {
                        // callApiPlaceOrder();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaymentScreen(
                              addid:
                                  '${addresResponseModel!.data![selected - 1].id}',
                              total: widget.total,
                              cartProductNames: widget.cartProductNames,
                              eachCartQuantity: widget.eachCartQuantity,
                              cartMrps: widget.cartMrps,
                              cartSellPrices: widget.cartSellPrices,
                              cartkgOrgm:widget.cartkgOrgm,
                              cartItemsImages: widget.cartItemsImages,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 75),
                        padding: const EdgeInsets.symmetric(vertical: 15),
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
                  ),
      ],
    );
  }

  Widget _addressList() {
    return Expanded(
      child: addresResponseModel?.data?.length == -1
          ? SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: Text("No Saved Addresses"),
              ),
            )
          : ListView.separated(
              itemCount: (addresResponseModel?.data?.length ?? 0) + 1,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, int index) {
                return index == 0
                    ? GestureDetector(
                        onTap: () {
                          getLatLong();
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: MyTheme.accent_color,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.gps_fixed,
                                color: MyTheme.accent_color,
                                size: 18,
                              ),
                              SizedBox(width: 20),
                              Text(
                                'Detect My Location',
                                style: TextStyle(
                                  color: MyTheme.accent_color,
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Radio<int>(
                            value: index,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            groupValue: selected,
                            activeColor: MyTheme.accent_color,
                            onChanged: (value) {
                              value == 0
                                  ? null
                                  : setState(() {
                                      selected = value!;
                                      id = addresResponseModel
                                          ?.data?[index - 1].id;
                                    });
                            },
                          ),
                          Expanded(
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              clipBehavior: Clip.none,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      selected = index;
                                      id = addresResponseModel
                                          ?.data?[index - 1].id;
                                    });
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          _col(
                                            'Name',
                                            '${addresResponseModel?.data?[index - 1].firstName} ${addresResponseModel?.data?[index - 1].lastName}',
                                          ),
                                          const SizedBox(height: 8),
                                          _col(
                                            'Address',
                                            '${addresResponseModel?.data?[index - 1].address}',
                                          ),
                                          const SizedBox(height: 8),
                                          _col(
                                            'city',
                                            '${addresResponseModel?.data?[index - 1].city}',
                                          ),
                                          const SizedBox(height: 8),
                                          _col(
                                            'Mobile',
                                            '${addresResponseModel?.data?[index - 1].mobileNumber}',
                                          ),
                                          const SizedBox(height: 8),
                                          _col(
                                            'Zip Code',
                                            '${addresResponseModel?.data?[index - 1].zipCode}',
                                          ),
                                          const SizedBox(height: 8),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -20,
                                  child: MaterialButton(
                                    color: MyTheme.accent_color,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60.0),
                                    ),
                                    child: const Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    onPressed: () async {
                                      var data = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (builder) => AddNewAddress(
                                            isEdit: true,
                                            addressResponse: addresResponseModel
                                                ?.data?[index - 1],
                                          ),
                                        ),
                                      );
                                      if (data != null && data == true) {
                                        getAllAddressData();
                                      }
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
              },
            ),
    );
  }

  Widget _col(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(children: [
              TextSpan(
                text: '$title: ',
                style: const TextStyle(color: Colors.black, fontSize: 15),
              ),
              TextSpan(
                text: value,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
