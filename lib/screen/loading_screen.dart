import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../DataLib/InvoiceDBmodel.dart';
import '../components/constant.dart';
import 'itemlist_screen.dart';
import 'main_screen.dart';

class LoadinScreen extends StatefulWidget {
  static String id = 'LoadingScreen';

  @override
  State<LoadinScreen> createState() => _LoadinScreenState();
}

class _LoadinScreenState extends State<LoadinScreen> {
  @override
  void initState() {
    getInvNum();
    timer();
    // fetchdata();

    super.initState();
  }

  // Future fetchdata() async {
  //   final String strData = await rootBundle.loadString("assets/data.dart");
  //   final List<dynamic> json = jsonDecode(strData);
  //   jsonStrData = json.cast<String>();
  //   // setState(() {
  //   //   autoComplateData = jsonStrData;
  //   // });
  // }

  void timer() async {
    try {
      await Future.delayed(const Duration(seconds: 2), () {});
      print("--------------------------------------1");
      Navigator.pushReplacementNamed(
          context,
          //HomeScreen.id,
          ItemList.id);
      print("--------------------------------------2");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitCubeGrid(
              color: xAppBarColor,
              size: 30,
            ),
            Text(
              'EXCEL INFOSYS',
              style: TextStyle(color: xAppBarColor, fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
