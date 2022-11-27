import '../components/constant.dart';
import '../db/database_helper.dart';
import '../model/note.dart';

late DatabaseHelper dbHelper;

getInvNum() async {
  dbHelper = DatabaseHelper.instance;

  List<InvoiceData> x = await dbHelper.fetchInvoice();

  for (var i in x) {
    invYear = int.parse(i.iYear);
    invNumber = int.parse(i.iNumber);
  }
}

updateInvNum() async {
  await getInvNum();
  // if (invYear < DateTime.now().year) {
  //   invNumber = 1;
  // } else {

  invNumber = invNumber + 1;

  // }
  await dbHelper.updateInvoice(InvoiceData(
      iNumber: invNumber.toString(), iYear: DateTime.now().year.toString()));
}

updateInvNumManually() async {
  await dbHelper.updateInvoice(InvoiceData(
      iNumber: invNumber.toString(), iYear: DateTime.now().year.toString()));
}
