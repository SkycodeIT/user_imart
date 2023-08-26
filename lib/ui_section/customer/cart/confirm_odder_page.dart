import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imart/const/my_theme.dart';
import 'package:imart/ui_section/customer/cart/success_order.dart';

class ConfirmYourOrderPage extends StatelessWidget {
  final String? addressId;
  final String? total;
  const ConfirmYourOrderPage({this.addressId, this.total, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColor.trans,

      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
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
                    'Confirm Order',
                    style: TextStyle(
                        color: MyTheme.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(),
                ],
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  itemCount: 10,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, int index) {
                    return Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.grey,
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.8,
                            ),
                          ),
                          // child:
                          //  CachedNetworkImage(
                          //   imageUrl: prod.thumb,
                          //   fit: BoxFit.fill,
                          //   placeholder: (context, url) => Center(
                          //     child: Indicators().indicatorWidget(),
                          //   ),
                          //   errorWidget: (context, url, error) {
                          //     return const Center(child: Icon(Icons.error));
                          //   },
                          // ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Banana',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '250 gm',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    '70₹',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Quantity:3',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Total')),
                      Text(
                        '250₹',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => SuccessOrderPage()));
                },
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, bottom: 80),
                  // height: 60,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: MyTheme.accent_color,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    'Confirm',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
