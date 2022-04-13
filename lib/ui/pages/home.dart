part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController debit = TextEditingController();
  TextEditingController credit = TextEditingController();
  TextEditingController catatan = TextEditingController();
  TextEditingController status = TextEditingController();
  String status_masuk = "Masuk";
  String status_keluar = "Keluar";
  int total = 0;
  int totalIn = 0;
  int totalOut = 0;
  List<Cash> datas = [];
  List<String> items;
  String selected;
  void refreshData() async {
    final data = await DBHelper.getItems();
    setState(() {
      datas = data;
    });
  }

  void addItem(Cash cash) async {
    var db = await DBHelper.createItem(cash);
    refreshData();
    calculate();
    calculateinBalance();
    calculateoutBalance();
    setState(() {});
  }

  void delete(int id, int index) async {
    final db = DBHelper.deletData(id);

    refreshData();
    calculate();
    calculateinBalance();
    calculateoutBalance();
    setState(() {
      datas.removeAt(index);
    });
  }

  Future<void> update(int id, String category) async {
    final db = DBHelper.db();
    await DBHelper.upadateData(
        id,
        (category == "Masuk") ? int.parse(debit.text) : 0,
        (category == "Keluar") ? int.parse(credit.text) : 0,
        catatan.text,
        category);
    calculate();
    calculateinBalance();
    calculateoutBalance();
    refreshData();
    setState(() {});
  }

  void calculate() async {
    int total_sum = (await DBHelper.calculate())[0]['total'];
    (total_sum == null) ? total_sum = 0 : total = total_sum;
    refreshData();
  }

  void calculateinBalance() async {
    int total_inBalance = (await DBHelper.calculateIn())[0]['inbalance'];
    (total_inBalance != null) ? totalIn = total_inBalance : total_inBalance = 0;

    refreshData();
  }

  void calculateoutBalance() async {
    int total_outBlance = (await DBHelper.calculateOut())[0]['outbalance'];
    (total_outBlance != null)
        ? totalOut = total_outBlance
        : total_outBlance = 0;
    totalOut = total_outBlance;
    refreshData();
  }

  @override
  void initState() {
    super.initState();
    calculateinBalance();
    calculateoutBalance();
    calculate();
    refreshData();
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
                        border: Border.all(
                            color: Color.fromARGB(255, 199, 198, 198)),
                        color: Color.fromARGB(255, 226, 238, 248),
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
                                color: Color.fromARGB(255, 184, 184, 184)),
                          ),
                        ),
                        const Padding(
                          padding: const EdgeInsets.only(left: 30, top: 10),
                          child: Text(
                            "Uang yang ada di dompet",
                            style: TextStyle(
                                color: Color.fromARGB(255, 88, 88, 88)),
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
                                        color:
                                            Color.fromARGB(255, 245, 63, 124),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text("Jumlah uang keluar",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                              255, 245, 63, 124)))
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                      NumberFormat.currency(
                                              locale: 'id-ID', symbol: 'Rp. ')
                                          .format(totalIn),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.green)),
                                  Text(
                                    "Jumlah uang Masuk",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
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
                  Container(
                      height: 600,
                      child: ListView.builder(
                          itemCount: datas.length,
                          itemBuilder: (context, index) {
                            print(datas[index].status);
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Card_list(
                                Cash(
                                    debit: datas[index].debit,
                                    credit: datas[index].credit,
                                    catatan: datas[index].catatan,
                                    status: datas[index].status,
                                    category: datas[index].category,
                                    date: datas[index].date),
                                onTap: () {
                                  print("Delet");
                                  dialogdelte(Cash(id: datas[index].id), index);
                                },
                                onTapUpdate: () {
                                  print("update");
                                  updateDialog(
                                      datas[index].id, datas[index].category);

                                  (datas[index].category == "Masuk")
                                      ? debit.text =
                                          datas[index].debit.toString()
                                      : credit.text =
                                          datas[index].credit.toString();
                                  catatan.text = datas[index].catatan;
                                  status.text = datas[index].category;

                                  setState(() {});
                                },
                              ),
                            );
                          })),
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
                showDialog(
                    context: context,
                    builder: (context) {
                      return OutBalance();
                    });
              },
              child: Icon(MdiIcons.minus),
            )
          ],
        ));
  }

  Future addBalance() async {
    setState(() {
      debit.text = '';
      catatan.text = '';
      status.text = '';
    });

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
            ],
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                int c = 0;
                var data = addItem(Cash(
                    credit: c,
                    debit: int.parse(debit.text),
                    catatan: catatan.text,
                    category: status_masuk,
                    status: "TopUp"));

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
    setState(() {
      debit.text = '';
      catatan.text = '';
      status.text = '';
    });
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {},
    );
  }

  Future updateDialog(int id, String categoryy) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                keyboardType: TextInputType.number,
                autofocus: true,
                controller: (categoryy == "Masuk") ? debit : credit,
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
              TextField(
                enabled: false,
                controller: status,
                style: TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: "Category"),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                update(id, categoryy);
                Navigator.pop(context);
              },
              textColor: Theme.of(context).primaryColor,
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future dialogdelte(Cash cash, int position) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delet Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[Text("Apakah anda ingin menghapus?")],
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                delete(cash.id, position);
                Navigator.pop(context);

                refreshData();
              },
              textColor: Theme.of(context).primaryColor,
              child: const Text('Ya'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              textColor: Colors.grey,
              child: const Text('Tidak'),
            ),
          ],
        );
      },
    );
  }
}
