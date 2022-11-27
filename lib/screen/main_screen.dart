import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import '../components/constant.dart';
import '../screen/entry_tab_screen.dart';

import '../DataLib/InvoiceDBmodel.dart';
import 'item_tab_screen.dart';

class MainTabScr extends StatefulWidget {
  static String id = 'MainTabScr';

  @override
  State<MainTabScr> createState() => _MainTabScrState();
}

class _MainTabScrState extends State<MainTabScr> {
  void changeColor(Color color) {}
  final InvNumberController =
      new TextEditingController(text: (invNumber).toString());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: xAppBarColor,
            title: Text('EXCEL INFOSYS'),
            bottom: TabBar(
              indicatorColor: xAppBarColor,
              tabs: [
                Tab(
                  text: 'Items',
                ),
                Tab(text: 'Entry')
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ItemTab(),
              EntryTab(),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: xAppBarColor,
                  ),
                  accountName: Text('Jeet Boghani'),
                  accountEmail: Text(''),
                  currentAccountPicture: CircleAvatar(
                    child: Text(
                      'J',
                      style: TextStyle(fontSize: 45, color: xAppBarColor),
                    ),
                    backgroundColor: xCardBackgroundColor,
                  ),
                ),
                ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Theme'),
                            content: SingleChildScrollView(
                              child: MaterialColorPicker(
                                  selectedColor: xAppBarColor,
                                  onColorChange: (Color color) {
                                    setState(() => xAppBarColor = color);
                                  }),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'OK',
                                  ))
                            ],
                          );
                        });
                  },
                  leading: Icon(Icons.color_lens_rounded),
                  title: Text('Theme'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                ),
                ListTile(
                  onTap: () {
                    InvNumberController.text = invNumber.toString();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Settings'),
                            content: SingleChildScrollView(
                                child: Row(
                              children: [
                                Expanded(child: Text('Invoice Number')),
                                Expanded(
                                    child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  //initialValue: (invNumber + 1).toString(),
                                  controller: InvNumberController,
                                )),
                              ],
                            )),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    invNumber =
                                        int.parse(InvNumberController.text);

                                    updateInvNumManually();

                                    getInvNum();

                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'OK',
                                  ))
                            ],
                          );
                        });
                  },
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.info),
                  title: Text('About'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
