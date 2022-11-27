import 'package:excelinfosys/screen/priceqnt_screen.dart';
import 'package:flutter/material.dart';
import '../components/constant.dart';
import '../db/database_helper.dart';
import '../model/drawer.dart';
import '../model/main_card.dart';
import '../model/note.dart';

class ItemList extends StatefulWidget {
  static String id = 'ItemListScr';

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  late DatabaseHelper dbHelper;
  final itemController = TextEditingController();

  _refreshItems() async {
    List<Item> x = await dbHelper.fetchItems();

    setState(() {
      itemList = x;

      if (listselecteditem.isEmpty) {
        listselecteditem = List.generate(itemList.length, (i) => false);
      }
    });
    // autoComplateData.clear();
    // for (var i in x) {
    //   autoComplateData.add(i.iName);
    // }
  }

  void addCards() {
    cards.clear();

    listitemnames.clear();
    listqntControllers.clear();
    listpriceControllers.clear();
    setState(() {
      for (int i = 0; i < listselecteditem.length; i++) {
        if (listselecteditem[i]) {
          listitemnames.add(itemList[i].iName);

          listqntControllers.add(new TextEditingController());
          listpriceControllers.add(new TextEditingController());
          cards.add(
            MainCard(
                ItemName: listitemnames[cards.length],
                QntController: listqntControllers[cards.length],
                PriceController: listpriceControllers[cards.length]),
          );
        }
      }
    });
  }

  Future<bool?> showwarning(BuildContext context) async => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Do you want to exit app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'No',
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
  @override
  void initState() {
    itemList = [Item(iName: 'iName')];

    // TODO: implement initState
    super.initState();
    setState(() {
      dbHelper = DatabaseHelper.instance;
      _refreshItems();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          final shouldpop = await showwarning(context);
          return shouldpop ?? false;
        },
        child: Scaffold(
          drawer: MyDrawer(),
          appBar: AppBar(
            backgroundColor: xAppBarColor,
            title: Text('EXCEL INFOSYS'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: itemController,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: xAppBarColor),
                          ),
                          labelText: 'Item Name',
                          hintText: 'Enter name',
                          counterText: '',
                          hintStyle: TextStyle(fontSize: 15),
                          labelStyle: TextStyle(color: xAppBarColor),
                        ),
                      ),
                    ),
                    Expanded(
                      child: FloatingActionButton(
                        heroTag: "additem",
                        onPressed: () async {
                          await dbHelper
                              .insert(Item(iName: itemController.text));
                          _refreshItems();
                          listselecteditem.add(false);
                          setState(() {
                            itemController.clear();
                          });
                        },
                        backgroundColor: xAppBarColor,
                        child: Icon(Icons.add),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Dismissible(
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                'Delete',
                                style: TextStyle(color: xAppBarTextColor),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ),
                          key: UniqueKey(),
                          confirmDismiss: (DismissDirection direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm"),
                                  content: const Text(
                                      "Are you sure you wish to delete this item?"),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text(
                                        "CANCEL",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          dbHelper
                                              .delete(itemList[index].iName);
                                          _refreshItems();

                                          Navigator.pop(context, true);
                                        });
                                      },
                                      child: const Text(
                                        "DELETE",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          // onDismissed: (DismissDirection direction) {
                          //   setState(() {
                          //     dbHelper.delete(itemList[index].iName);
                          //     _refreshItems();
                          //   });
                          // },
                          child: ListTile(
                            //elevation: 2,
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                itemList[index].iName,
                                style: TextStyle(
                                  color: listselecteditem[index]
                                      ? xAppBarTextColor
                                      : null,
                                ),
                              ),
                            ),
                            onTap: () {
                              //print(itemList[index].iName);
                              setState(() {
                                listselecteditem[index] =
                                    !listselecteditem[index];

                                // itemController.text = itemList[index].iName;
                                //dbHelper.delete(itemList[index].iName);
                                _refreshItems();
                                // final snackBar = SnackBar(
                                //   backgroundColor: xAppBarColor,
                                //   behavior: SnackBarBehavior.floating,
                                //   margin: EdgeInsets.only(
                                //       left: 10, right: 90, bottom: 16),
                                //   content: Container(
                                //       decoration: BoxDecoration(color: xAppBarColor),
                                //       child: Text(
                                //           '' + itemList[index].iName + ' added!')),
                                // );
                                // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              });
                            },
                            // trailing: IconButton(
                            //     icon: Icon(Icons.delete),
                            //     onPressed: () {
                            //       setState(() {
                            //         dbHelper.delete(itemList[index].iName);
                            //         _refreshItems();
                            //       });
                            //     }),
                            tileColor:
                                listselecteditem[index] ? xAppBarColor : null,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: FloatingActionButton(
                  onPressed: () {
                    addCards();
                    _refreshItems();
                    if (cards.isEmpty) {
                      final snackBar = SnackBar(
                        duration: Duration(seconds: 1),
                        backgroundColor: xAppBarColor,
                        behavior: SnackBarBehavior.floating,
                        margin:
                            EdgeInsets.only(left: 10, right: 90, bottom: 16),
                        content: Container(
                            decoration: BoxDecoration(color: xAppBarColor),
                            child: Text('Please select items')),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      Navigator.pushNamed(
                          context,
                          //HomeScreen.id,
                          PriceQntScr.id);
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios_rounded),
                  backgroundColor: xAppBarColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
