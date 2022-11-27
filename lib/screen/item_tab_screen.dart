import 'package:flutter/material.dart';

import '../components/constant.dart';
import '../db/database_helper.dart';
import '../model/main_card.dart';
import '../model/note.dart';
import 'itemlist_screen.dart';

class ItemTab extends StatefulWidget {
  const ItemTab({Key? key}) : super(key: key);

  @override
  State<ItemTab> createState() => _ItemTabState();
}

class _ItemTabState extends State<ItemTab> {
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
    autoComplateData.clear();
    for (var i in x) {
      autoComplateData.add(i.iName);
    }
  }

  void addCards(int index) {
    setState(() {
      listitemnames.add(itemList[index].iName);

      listqntControllers.add(new TextEditingController());
      listpriceControllers.add(new TextEditingController());
      cards.add(
        MainCard(
            ItemName: listitemnames[cards.length],
            QntController: listqntControllers[cards.length],
            PriceController: listpriceControllers[cards.length]),
      );
    });
  }

  @override
  void initState() {
    itemList = [Item(iName: 'iName')];
    //addCards();
    // listselecteditem = List.generate(itemList.length, (i) => false);

    super.initState();
    setState(() {
      dbHelper = DatabaseHelper.instance;
      _refreshItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    //elevation: 2,
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(itemList[index].iName),
                    ),
                    onTap: () {
                      //print(itemList[index].iName);
                      setState(() {
                        if (listselecteditem[index] == false) {
                          addCards(index);
                        } else {
                          cards.removeAt(index);

                          listitemnames.removeAt(index);
                          listqntControllers.removeAt(index);
                          listpriceControllers.removeAt(index);
                        }

                        listselecteditem[index] = !listselecteditem[index];
                        print(index);
                        print(listselecteditem[index]);
                        print('----------------------------1');

                        print(listselecteditem);

                        // itemController.text = itemList[index].iName;
                        //dbHelper.delete(itemList[index].iName);
                        _refreshItems();
                        final snackBar = SnackBar(
                          backgroundColor: xAppBarColor,
                          behavior: SnackBarBehavior.floating,
                          margin:
                              EdgeInsets.only(left: 10, right: 90, bottom: 16),
                          content: Container(
                              decoration: BoxDecoration(color: xAppBarColor),
                              child:
                                  Text('' + itemList[index].iName + ' added!')),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    },
                    trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            dbHelper.delete(itemList[index].iName);
                            _refreshItems();
                          });
                        }),
                    tileColor: listselecteditem[index] ? xAppBarColor : null,
                  ),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: itemController,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2, color: xAppBarColor),
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
                    // Navigator.pushReplacementNamed(
                    //     context,
                    //     //HomeScreen.id,
                    //     ItemList.id);
                    await dbHelper.insert(Item(iName: itemController.text));
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
      ],
    );
  }
}
