import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:imart/const/asseth_path.dart';
import 'package:imart/const/my_theme.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({this.title});
  final String? title;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: MyTheme.accent_color),
              child: Center(
                child: Text(
                  'Profile',
                  style: TextStyle(
                      color: MyTheme.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    userName(),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, top: 20),
                        child: Text(
                          'My Information',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    commonListTile(ImagePath.icOrder, 'My Orders', () {}),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        thickness: 1,
                        height: 0,
                      ),
                    ),
                    commonListTile(ImagePath.icOffer, 'Offers', () {}),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        thickness: 1,
                        height: 0,
                      ),
                    ),
                    commonListTile(
                        ImagePath.icCustomerSupport, 'Customer Support', () {}),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        thickness: 1,
                        height: 0,
                      ),
                    ),
                    commonListTile(ImagePath.icPolicy, 'Legal Policies', () {}),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        thickness: 1,
                        height: 0,
                      ),
                    ),
                    commonListTile(ImagePath.icInfo, 'About us', () {}),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        thickness: 1,
                        height: 0,
                      ),
                    ),
                    commonListTile(ImagePath.icLogout, 'Logout', () {}),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Divider(
                        thickness: 1,
                        height: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userName() {
    return ListTile(
      contentPadding: EdgeInsets.all(5),
      horizontalTitleGap: 5,
      leading: Container(
        height: 70,
        width: 70,
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: MyTheme.accent_color),
      ),
      title: const Text('Hello,',
          style:
              TextStyle(fontSize: 13, color: Color.fromRGBO(153, 153, 153, 1))),
      subtitle: const Text('Green House ',
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600)),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(Icons.edit),
      ),
    );
  }

  Widget commonListTile(String? imgPath, String? name, onTap) {
    return ListTile(
      horizontalTitleGap: 0,
      leading: Image.asset(
        imgPath!,
        height: 30,
        width: 30,
        color: MyTheme.accent_color,
      ),
      title: Text(
        name!,
        style: const TextStyle(fontSize: 14, color: Colors.black),
      ),
      trailing: const Icon(
        CupertinoIcons.right_chevron,
        color: Colors.grey,
      ),
      onTap: onTap!,
    );
  }
}
