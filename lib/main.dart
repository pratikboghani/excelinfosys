import 'package:excelinfosys/screen/itemlist_screen.dart';
import 'package:excelinfosys/screen/priceqnt_screen.dart';
import 'package:flutter/material.dart';
import '../components/constant.dart';
import '../screen/loading_screen.dart';
import '../screen/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoadinScreen.id,
      routes: {
        LoadinScreen.id: (context) => LoadinScreen(),
        MainTabScr.id: (context) => MainTabScr(),
        ItemList.id: (context) => ItemList(),
        PriceQntScr.id: (context) => PriceQntScr(),
      },
    );
  }
}
