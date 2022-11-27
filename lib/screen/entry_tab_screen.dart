import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import '../components/utils.dart';
import '../model/main_card.dart';
import '../model/note.dart';

import '../DataLib/InvoiceDBmodel.dart';
import '../components/constant.dart';
import '../components/pdf_maker.dart';
import '../db/database_helper.dart';
import '../model/MyInputField.dart';

class EntryTab extends StatefulWidget {
  @override
  State<EntryTab> createState() => _EntryTabState();
}

class _EntryTabState extends State<EntryTab>
    with SingleTickerProviderStateMixin {
  late var itemNameController = TextEditingController();
  final itemPriceController = TextEditingController();
  final itemQuantityController = TextEditingController();
  final CustomerNameController = TextEditingController();
  final CustomerAddressController = TextEditingController();
  late AnimateIconController _animationController;

  // void addToList() {
  //   setState(() {
  //     iname.add(itemNameController.text);
  //     iquantity.add(itemQuantityController.text);
  //     iprice.add(itemPriceController.text);
  //   });
  // }

  // void clearController() {
  //   setState(() {
  //     itemNameController.clear();
  //     itemPriceController.clear();
  //     itemQuantityController.clear();
  //     CustomerNameController.clear();
  //     CustomerAddressController.clear();
  //   });
  // }

  // void deleteitem(int index) {
  //   iname.removeAt(index);
  //   iquantity.removeAt(index);
  //   iprice.removeAt(index);
  // }

  // void clearList() {
  //   setState(() {
  //     iname.clear();
  //     iquantity.clear();
  //     iprice.clear();
  //   });
  // }

  // final itemController = TextEditingController();

  // void addCards() {
  //   setState(() {
  //     listqntControllers.add(new TextEditingController());
  //     listpriceControllers.add(new TextEditingController());
  //     cards.add(
  //       MainCard(
  //           // tev: _tev[cards.length],
  //           QntController: listqntControllers[cards.length],
  //           PriceController: listpriceControllers[cards.length]),
  //     );
  //   });
  // }

  void disposeController() {
    for (int i = 0; i < listqntControllers.length; i++) {
      // _nameControllers[i].dispose();
      itemNameList.removeAt(i);
      //_tev.removeAt(i);
      listqntControllers[i].dispose();
      listpriceControllers[i].dispose();
    }
  }

  @override
  void initState() {
    setState(() {
      dbHelper = DatabaseHelper.instance;

      _animationController = AnimateIconController();
      //_updateInvData();
    });
    super.initState();
  }

  // bool isAnimating = false;
  //
  // void changeIcon() {
  //   setState(() {
  //     isAnimating = !isAnimating;
  //
  //     isAnimating
  //         ? _animationController.forward()
  //         : _animationController.reverse();
  //   });
  // }
  // bool onAddIconPress(BuildContext context) {
  //   if (itemNameController.text.isEmpty ||
  //       itemQuantityController.text.isEmpty ||
  //       itemPriceController.text.isEmpty) {
  //     final snackBar = SnackBar(
  //       content: Text('Enter Valid Inputs'),
  //       duration: Duration(milliseconds: 500),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   } else {
  //     addToList();
  //   }
  //   clearController();
  //   return true;
  // }

  void showPopUp() {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      elevation: 10,
      enableDrag: true,
      isDismissible: false,
      isScrollControlled: true,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(35.0),
      // ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.5,
          decoration: BoxDecoration(
              borderRadius:
                  new BorderRadius.vertical(top: const Radius.circular(35.0)),
              color: xAppBarTextColor),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 7.0),
                child: Row(
                  children: [
                    Expanded(
                      child: MyInputField(
                        myController: CustomerNameController,
                        labelText: 'Customer',
                        hintText: 'Estimate for',
                        keyboardType: TextInputType.text,
                        inputFormate: [],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FloatingActionButton(
                        heroTag: "pdfgo",
                        backgroundColor: xAppBarColor,
                        onPressed: () async {
                          //addCards();
                          //showPopUp();

                          await getInvNum();
                          print("-------------------------------------1");
                          print(listitemnames);
                          generatePDF(
                              listitemnames,
                              listpriceControllers,
                              listqntControllers,
                              CustomerNameController.text,
                              CustomerAddressController.text);
                          Navigator.pop(context);
                          updateInvNum();
                        },
                        child: Text('GO'),
                      ),
                    ),
                  ],
                ),
              ),
              MyInputField(
                myController: CustomerAddressController,
                labelText: 'Address',
                hintText: 'Customer address',
                keyboardType: TextInputType.text,
                inputFormate: [],
              ),

              // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Autocomplete(
          //   onSelected: (String Selection) {
          //     //itemNameList.insert(cards.length - 1, Selection);
          //   },
          //   optionsBuilder: (tev) {
          //     if (tev.text.isEmpty) {
          //       return const Iterable<String>.empty();
          //     } else {
          //       return autoComplateData.where((word) =>
          //           word.toLowerCase().contains(tev.text.toLowerCase()));
          //     }
          //   },
          //   fieldViewBuilder:
          //       (context, controller, focusNode, onEditingComplete) {
          //     itemNameController = controller;
          //     return Padding(
          //       padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          //       child: TextField(
          //         style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          //         controller: itemNameController,
          //         focusNode: focusNode,
          //         onEditingComplete: onEditingComplete,
          //         decoration: InputDecoration(
          //           border: OutlineInputBorder(
          //             borderRadius: BorderRadius.circular(50),
          //           ),
          //           focusedBorder: OutlineInputBorder(
          //             borderSide: BorderSide(width: 2, color: xAppBarColor),
          //           ),
          //           labelText: 'Item Name',
          //           hintText: "Enter item name",
          //           counterText: '',
          //           hintStyle: TextStyle(fontSize: 15),
          //           labelStyle: TextStyle(color: xAppBarColor),
          //         ),
          //       ),
          //     );
          //   },
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: MyInputField(
          //           myController: itemQuantityController,
          //           labelText: 'Quantity',
          //           hintText: 'Enter quantity.',
          //           keyboardType: TextInputType.numberWithOptions(
          //               signed: false, decimal: false),
          //           inputFormate: [],
          //         ),
          //       ),
          //       Expanded(
          //         child: MyInputField(
          //           myController: itemPriceController,
          //           labelText: 'Price',
          //           hintText: 'Enter price.',
          //           keyboardType: TextInputType.numberWithOptions(
          //               signed: false, decimal: false),
          //           inputFormate: [],
          //         ),
          //       ),
          //       FloatingActionButton(
          //         heroTag: "popupgo",
          //         backgroundColor: xAppBarColor,
          //         onPressed: () {
          //           //addCards();
          //           if (listitemnames.isEmpty) {
          //             final snackBar = SnackBar(
          //               content: Text('Item List is Empty'),
          //             );
          //             ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //           } else {
          //             showPopUp();
          //           }
          //           //generatePDF(iname, iprice, iquantity);
          //         },
          //         child: Text('GO'),
          //       ),
          //       SizedBox(
          //         width: 8,
          //       ),
          //       FloatingActionButton(
          //         heroTag: "additem",
          //         backgroundColor: xAppBarColor,
          //         onPressed: () {
          //           //addCards();
          //         },
          //         child: AnimateIcons(
          //           duration: Duration(milliseconds: 500),
          //           startIconColor: xAppBarTextColor,
          //           endIconColor: xAppBarTextColor,
          //           startIcon: Icons.add,
          //           endIcon: Icons.add,
          //           controller: _animationController,
          //           onEndIconPress: () => onAddIconPress(context),
          //           onStartIconPress: () => onAddIconPress(context),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return Card(
                    color: xCardBackgroundColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Center(
                                  child: Text(
                                    (index + 1).toString(),
                                    style: TextStyle(
                                      color: xAppBarTextColor,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: xAppBarColor,
                                    shape: BoxShape.circle),
                                height: 20,
                                width: 20,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                listitemnames[index],
                                style: TextStyle(color: xAppBarColor),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    cards.removeAt(index);
                                    listitemnames.removeAt(index);
                                    listqntControllers.removeAt(index);
                                    listpriceControllers.removeAt(index);
                                  });
                                  //deleteitem(index);
                                },
                                icon: Icon(
                                  Icons.delete_rounded,
                                  color: xAppBarColor,
                                ))
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: MyInputField(
                                  myController: listqntControllers[index],
                                  labelText: "Quantity",
                                  hintText: "Quantity",
                                  keyboardType: TextInputType.number,
                                  inputFormate: []),
                              flex: 1,
                            ),
                            Expanded(
                              child: MyInputField(
                                  myController: listpriceControllers[index],
                                  labelText: "Price",
                                  hintText: "Price",
                                  keyboardType: TextInputType.number,
                                  inputFormate: []),
                              flex: 1,
                            ),
                          ],
                        ),
                      ],
                    ));
                //return cards[index];
              },
            ),
            //child: Text('Hekk'),
            // child: ListView.builder(
            //   shrinkWrap: true,
            //   physics: AlwaysScrollableScrollPhysics(),
            //   itemCount: iname.length,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       //elevation: 2,
            //
            //       title: Padding(
            //         padding: const EdgeInsets.only(left: 8.0),
            //         child: Text(iname[index]),
            //       ),
            //
            //       onTap: () {
            //         setState(() {
            //           //print(iname[index].toString());
            //           // itemController.text = itemList[index].iName;
            //           //dbHelper.delete(itemList[index].iName);
            //           //_refreshItems();
            //         });
            //       },
            //
            //       trailing: IconButton(
            //           icon: Icon(Icons.delete),
            //           onPressed: () {
            //             setState(() {
            //               // dbHelper.delete(itemList[index].iName);
            //               // _refreshItems();
            //               deleteitem(index);
            //             });
            //           }),
            //       subtitle: Padding(
            //         padding: const EdgeInsets.only(left: 8.0),
            //         child: Text(
            //             '${iquantity[index]} * ₹${iprice[index]} = ₹${int.parse(iquantity[index]) * int.parse(iprice[index])}'),
            //       ),
            //     );
            //   },
            // ),
          ),
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "openpdf",
        backgroundColor: xAppBarColor,
        onPressed: () {
          bool cnt = true;
          for (int i = 0; i < listitemnames.length; i++) {
            if (listqntControllers[i].text.isEmpty ||
                listpriceControllers[i].text.isEmpty) {
              cnt = false;
            }
          }
          if (cnt) {
            showPopUp();
          } else {
            final snackBar = SnackBar(
              backgroundColor: xAppBarColor,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(left: 10, right: 77, bottom: 22),
              content: Container(
                  decoration: BoxDecoration(color: xAppBarColor),
                  child: Text('Enter valid Quantity and Price')),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }

          //addCards();
          //clearList();
          //clearController();
        },
        child: Icon(Icons.arrow_forward_ios_rounded),
      ),
    );
  }

  @override
  void dispose() {
    disposeController();
    // _animationController.dispose();
    super.dispose();
  }
}
