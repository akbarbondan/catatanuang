part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController balance = TextEditingController();
  TextEditingController catatan = TextEditingController();
  String category_masuk = "Masuk";
  String categoty_keluar = "Keluar";

  void addItem(Cash cash) async {
    var db = await DBHelper.createItem(cash);
    calculate();
    calculateinBalance();
    calculateoutBalance();
    refreshData();
  }

  void delete() {}

  int total = 0;
  int totalIn = 0;
  int totalOut = 0;
  List<Cash> datas = [];
  void refreshData() async {
    final data = await DBHelper.getItems();
    setState(() {
      datas = data;
    });
  }

  void calculate() async {
    int total_sum = (await DBHelper.calculate())[0]['total'];
    print(total_sum);

    (total_sum == null) ? total_sum = 0 : total = total_sum;

    refreshData();
  }

  void calculateinBalance() async {
    int total_inBalance = (await DBHelper.calculateIn())[0]['inbalance'];
    print(total_inBalance);
    totalIn = total_inBalance;
    refreshData();
  }

  void calculateoutBalance() async {
    int total_outBlance = (await DBHelper.calculateOut())[0]['outbalance'];
    totalOut = total_outBlance;
    refreshData();
  }

  @override
  void initState() {
    super.initState();
    calculate();
    calculateinBalance();
    calculateoutBalance();
  }

  @override
  void dispose() {
    super.dispose();
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
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, left: 30),
                          child: Text(
                            NumberFormat.currency(
                                    locale: 'id-ID', symbol: 'Rp. ')
                                .format(total),
                            style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ),
                        const Padding(
                          padding: const EdgeInsets.only(left: 30, top: 10),
                          child: Text(
                            "Uang yang ada di dompet",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    NumberFormat.currency(
                                            locale: 'id-ID', symbol: "Rp. ")
                                        .format(totalOut),
                                    style: TextStyle(
                                        color: Colors.pink,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text("Jumlah uang keluar",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.pink))
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                      NumberFormat.currency(
                                              locale: 'id-ID', symbol: 'Rp. ')
                                          .format(totalIn),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green)),
                                  Text(
                                    "Jumlah uang Masuk",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("List transaksi"),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                      height: 600,
                      child: ListView.builder(
                          itemCount: datas.length,
                          itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: card(
                                    datas[index].balance,
                                    datas[index].catatan,
                                    datas[index].category),
                              ))),
                ],
              )
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              onPressed: () async {
                await addBalance();
              },
              child: Icon(Icons.add),
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              onPressed: () async {
                await outBalance();
              },
              child: Icon(MdiIcons.minus),
            )
          ],
        ));
  }

  Future addBalance() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Uang masuk'),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                autofocus: true,
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
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                var data = addItem(Cash(
                    balance: int.parse(balance.text),
                    catatan: catatan.text,
                    category: category_masuk));

                catatan.text = "";
                balance.text = "";
                setState(() {});
                Navigator.of(context).pop(data);
              },
              textColor: Theme.of(context).primaryColor,
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  Future outBalance() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Uang Keluar'),
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                autofocus: true,
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
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                var data = addItem(Cash(
                    balance: -int.parse(balance.text),
                    catatan: catatan.text,
                    category: categoty_keluar));
                catatan.text = "";
                balance.text = "";
                setState(() {});
                Navigator.of(context).pop(data);
              },
              textColor: Theme.of(context).primaryColor,
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }
}

class card extends StatelessWidget {
  final int balance;
  final String catan;
  final String category;
  card(this.balance, this.catan, this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
      child: Container(
        padding: EdgeInsets.only(right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                (category == "Masuk") ? Icons.add : MdiIcons.minus,
                color: Colors.white,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    NumberFormat.currency(locale: 'id-ID', symbol: 'Rp. ')
                        .format(balance),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: (category == "Masuk") ? Colors.green : Colors.pink,
                    ),
                  ),
                  Text(
                    catan,
                    style: TextStyle(
                        color:
                            (category == "Masuk") ? Colors.green : Colors.pink),
                  )
                ],
              ),
            ),
            Text(
              category,
              style: TextStyle(
                color: (category == "Masuk") ? Colors.green : Colors.pink,
              ),
            )
          ],
        ),
      ),
    );
  }
}
