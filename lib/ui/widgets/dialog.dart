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
  List<String> items;
  String selected;

  void addItem(Cash cash) async {
    var db = await DBHelper.createItem(cash);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = ["Makan", "Traveling", "Bulanan"];
    selected = items[0];
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
                  border: Border.all(color: Colors.black)),
              child: DropdownButton(
                  value: selected,
                  isExpanded: true,
                  underline: SizedBox(),
                  items: items
                      .map(
                        (e) => DropdownMenuItem(
                            value: e,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                e,
                              ),
                            )),
                      )
                      .toList(),
                  onChanged: (item) {
                    setState(() {
                      selected = item;
                    });
                  }),
            ),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              int d = 0;
              var data = addItem(Cash(
                  debit: d,
                  credit: int.parse(credit.text),
                  catatan: catatan.text,
                  category: status_keluar,
                  status: selected));
              setState(() {});
              Navigator.of(context).pop(data);
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Tambah'),
          ),
        ],
      );
    });
  }
}
