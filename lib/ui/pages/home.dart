part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: EdgeInsets.all(20),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 30),
                          child: Text(
                            "Rp.20000000",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, top: 10),
                          child: Text("Uang yang ada di dompet"),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("List transaksi"),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 600,
                    child: ListView(children: [card()]),
                  )
                ],
              )
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context, builder: (context) => BuildPopupDialog());
              },
              child: Icon(Icons.add),
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context, builder: (context) => OutBalance());
              },
              child: Icon(MdiIcons.minus),
            )
          ],
        ));
  }
}

class card extends StatelessWidget {
  const card({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "300000",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text("Beli makan")
              ],
            ),
          ),
          SizedBox(
            width: 150,
          ),
          Icon(MdiIcons.food)
        ],
      ),
    );
  }
}

class BuildPopupDialog extends StatelessWidget {
  Cash? cash;
  TextEditingController balance = TextEditingController();
  TextEditingController catatan = TextEditingController();
  Future addData() async {
    var db = DbHelper();
    DateTime date = DateTime.now();
    String dateTime = "${date}";
    var cash =
        Cash(id: 1, balance: balance.text, catatan: catatan.text, date: date);

    await db.saveData(cash);
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: const Text('Uang masuk'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: balance,
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
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            addData();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Tambah'),
        ),
      ],
    );
  }
}

class OutBalance extends StatelessWidget {
  Cash? cash;
  TextEditingController balance = TextEditingController();
  TextEditingController catatan = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: const Text('Uang keluar'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: balance,
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
          )
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Kurangi'),
        ),
      ],
    );
  }
}
