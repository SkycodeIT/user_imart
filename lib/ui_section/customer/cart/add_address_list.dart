import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:imart/api/checkout_repository.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/const/text_field.dart';
import 'package:imart/const/user_token.dart';
import 'package:imart/model/get_address_list_response_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AddNewAddress extends StatefulWidget {
  final bool? isEdit;
  final GetAddresResponseData? addressResponse;
  const AddNewAddress({
    this.isEdit = false,
    this.addressResponse,
    Key? key,
  }) : super(key: key);

  @override
  _AddNewAddressState createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  TextEditingController? _firstName = TextEditingController();
  TextEditingController? _lastName = TextEditingController();
  TextEditingController? _contryCode = TextEditingController();
  TextEditingController? _state = TextEditingController();
  TextEditingController? _address1 = TextEditingController();
  TextEditingController? _city = TextEditingController();
  TextEditingController? _postCode = TextEditingController();
  TextEditingController? _telephone = TextEditingController();

  int defaultAdd = 1;
  var userId;
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(token!);
    userId = jwtDecodeToken['_id'];
    if (widget.isEdit == true) {
      _firstName =
          TextEditingController(text: widget.addressResponse?.firstName ?? '');
      _lastName =
          TextEditingController(text: widget.addressResponse?.lastName ?? '');
      _contryCode =
          TextEditingController(text: widget.addressResponse?.country ?? '');
      _state = TextEditingController(text: widget.addressResponse?.state ?? '');
      _address1 =
          TextEditingController(text: widget.addressResponse?.address ?? '');
      _city = TextEditingController(text: widget.addressResponse?.city ?? '');
      _postCode =
          TextEditingController(text: widget.addressResponse?.zipCode ?? '');
      _telephone = TextEditingController(
          text: widget.addressResponse?.mobileNumber ?? '');
    }
  }

  @override
  void dispose() {
    _firstName?.dispose();
    _lastName?.dispose();
    _contryCode?.dispose();
    _state?.dispose();
    _address1?.dispose();
    _city?.dispose();
    _postCode?.dispose();
    _telephone?.dispose();

    super.dispose();
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
                    widget.isEdit! ? 'Update Address' : 'Add Address',
                    style: TextStyle(
                      color: MyTheme.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox()
                ],
              ),
            ),
            _addressList(),
            _addUpdateButton()
          ],
        ),
      ),
    );
  }

  Widget _addressList() {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CustomTextField().secondaryTextField(
                context,
                controller: _firstName,
                headline: 'First Name',
                hintText: 'Enter First Name',
              ),
              CustomTextField().secondaryTextField(
                context,
                controller: _lastName,
                headline: 'Last Name',
                hintText: 'Enter Last Name',
              ),
              CustomTextField().secondaryTextField(
                context,
                controller: _address1,
                headline: 'Address',
                hintText: 'Enter your address',
              ),
              CustomTextField().secondaryTextField(
                context,
                controller: _city,
                headline: 'City',
                hintText: 'Enter Your City',
              ),
              CustomTextField().secondaryTextField(
                context,
                controller: _postCode,
                headline: 'Zipcode',
                hintText: 'Enter Your Zipcode',
              ),
              CustomTextField().secondaryTextField(
                context,
                controller: _state,
                headline: 'State',
                hintText: 'Enter Your State',
              ),
              CustomTextField().secondaryTextField(
                context,
                controller: _contryCode,
                headline: 'Country',
                hintText: 'Enter Your Country',
              ),
              CustomTextField().secondaryTextField(
                context,
                controller: _telephone,
                keyboardType: TextInputType.number,
                maxLength: 13,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                headline: 'Phone Number',
                hintText: 'Enter phone number',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addUpdateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () async {
          await callApiForNewAdd();
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (builder) => ConfirmYourOrderPage()));
        },
        child: Container(
          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 70),
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
              color: MyTheme.accent_color,
              borderRadius: BorderRadius.circular(10)),
          child: Center(
              child: Text(
            widget.isEdit! ? 'Update' : 'Add',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          )),
        ),
      ),
    );
  }

  callApiForNewAdd() async {
    if (_firstName!.text.isEmpty) {
      EasyLoading.showToast('Please enter your fullname');
    } else if (_lastName!.text.isEmpty) {
      EasyLoading.showToast('Please enter your lastname');
    } else if (_address1!.text.isEmpty) {
      EasyLoading.showToast('Please enter your address');
    } else if (_city!.text.isEmpty) {
      EasyLoading.showToast('Please enter your city');
    } else if (_postCode!.text.isEmpty) {
      EasyLoading.showToast('Please enter your zip code');
    } else if (_state!.text.isEmpty) {
      EasyLoading.showToast('Please enter your state');
    }
     else if (_contryCode!.text.isEmpty) {
      EasyLoading.showToast('Please enter your country');
    }
    else if (_telephone!.text.isEmpty || _telephone!.text.length < 10) {
      EasyLoading.showToast('Please enter phone number');
    } else {
      var json = {
        'id': widget.isEdit! ? widget.addressResponse?.id : null,
        'userId': userId,
        'firstName': _firstName?.text,
        'lastName': _lastName?.text,
        'mobileNumber': _telephone?.text,
        'address': _address1?.text,
        'city': _city?.text,
        'state': _state?.text,
        'country': _contryCode?.text,
        'zipCode': _postCode?.text,
        'isDefault': 1,
      };
      // await EasyLoading.show(
      //   status: 'loading...',
      //   maskType: EasyLoadingMaskType.black,
      // );
      var response = await CheckoutRepository().setAddress(jsonData: json);
      await EasyLoading.dismiss();
      print(response['status']);
      if (response['status'] == 1) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
      } else {
        EasyLoading.showToast(response['message']);
      }
    }
  }
}
