part of 'widgets.dart';

class OutBalance extends StatefulWidget {
  @override
  State<OutBalance> createState() => _OutBalanceState();
}

class _OutBalanceState extends State<OutBalance> {
  TextEditingController credit = TextEditingController();
  TextEditingController catatan = TextEditingController();
  TextEditingController status = TextEditingController();
  String status_keluar = "Keluar";
  List<Category> items = [];
  String selected;
  DateTime dateTime = DateTime.now();
  void addItem(Cash cash) async {
    var db = await DBHelper.createItem(cash);
  }

  void loadCategories() async {
    final categorys = await DBHelper.getAllCategory();

    categorys.forEach((category) {
      items.add(category);
    });
    setState(() {
      items = items;
      selected = items[0].category;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCategories();
    print(items.length);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return AlertDialog(
        title: const Text('Uang Keluar'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              autofocus: true,
              controller: credit,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Jumlah Uang"),
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              controller: catatan,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Catatan"),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey)),
              child: DropdownButton(
                  value: selected,
                  isExpanded: true,
                  underline: SizedBox(),
                  items: items
                      .map((e) => DropdownMenuItem(
                          value: e.category,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(e.category),
                          )))
                      .toList(),
                  onChanged: (item) {
                    setState(() {
                      selected = item;
                    });
                  }),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2012, 3, 5),
                          maxTime: DateTime(2030, 6, 7), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        print('confirm $date');
                        setState(() {
                          dateTime = date;
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.id);
                    },
                    child: Icon(
                      MdiIcons.calendar,
                    )),
                Text(
                  Shared.customeDateTime(dateTime),
                  style: TextStyle(color: Colors.grey),
                )
              ],
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          FlatButton(
            onPressed: () {
              int d = 0;
              var data = addItem(Cash(
                  debit: d,
                  credit: int.parse(credit.text),
                  catatan: catatan.text,
                  status: selected,
                  category: status_keluar,
                  date: dateTime.toString()));
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Tambah'),
          ),
        ],
      );
    });
  }
}

class Inbalance extends StatefulWidget {
  @override
  State<Inbalance> createState() => _InbalanceState();
}

class _InbalanceState extends State<Inbalance> {
  TextEditingController debit = TextEditingController();
  TextEditingController catatan = TextEditingController();
  TextEditingController status = TextEditingController();
  String status_keluar = "Masuk";
  DateTime dateTime = DateTime.now();
  void addItem(Cash cash) async {
    var db = await DBHelper.createItem(cash);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return AlertDialog(
        title: const Text('Uang Keluar'),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.number,
              autofocus: true,
              controller: debit,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Jumlah Uang"),
            ),
            SizedBox(
              height: 8,
            ),
            TextField(
              controller: catatan,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "Catatan"),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2012, 3, 5),
                          maxTime: DateTime(2030, 6, 7), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        print('confirm $date');
                        setState(() {
                          dateTime = date;
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.id);
                    },
                    child: Icon(
                      MdiIcons.calendar,
                    )),
                Text(
                  Shared.customeDateTime(dateTime),
                  style: TextStyle(color: Colors.grey),
                )
              ],
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text(
              'Batal',
              style: TextStyle(color: Colors.grey),
            ),
          ),
          FlatButton(
            onPressed: () {
              int d = 0;
              var data = addItem(Cash(
                  debit: int.parse(debit.text),
                  credit: d,
                  catatan: catatan.text,
                  category: status_keluar,
                  status: "Masuk",
                  date: dateTime.toString()));
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Tambah'),
          ),
        ],
      );
    });
  }
}
