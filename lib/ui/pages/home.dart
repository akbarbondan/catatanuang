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
  String datetime;
  void refreshData() async {
    final data = await DBHelper.getItems();
    setState(() {
      datas = data;
      if (datas.isEmpty) {
        datas.clear();
        total = 0;
        totalIn = 0;
        totalOut = 0;
      }
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
      category,
    );
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
        body: Stack(
          children: [
            Container(
              color: Colors.blue,
            ),
            SafeArea(
                child: Container(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hai Kamu",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "Uang Kamu Tersisa",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            NumberFormat.currency(
                                    locale: 'id-ID', symbol: 'Rp. ')
                                .format(total),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(
                          'assets/photo.png',
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                        height: 90,
                        width: 160,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pemasukan',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey),
                                ),
                                Icon(
                                  Icons.arrow_circle_up_rounded,
                                  color: Colors.green[300],
                                )
                              ],
                            ),
                            Text(
                              NumberFormat.currency(
                                      locale: 'id-ID', symbol: 'Rp. ')
                                  .format(totalIn),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.green[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
                        height: 90,
                        width: 160,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Pengeluaran',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.grey),
                                ),
                                Icon(
                                  Icons.arrow_circle_down_sharp,
                                  color: Colors.red[300],
                                )
                              ],
                            ),
                            Text(
                                NumberFormat.currency(
                                        locale: 'id-ID', symbol: 'Rp. ')
                                    .format(totalOut),
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red[300],
                                    overflow: TextOverflow.clip)),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  // Button filter
                  Container(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(FilterPage());
                          },
                          child: Row(
                            children: [
                              Icon(Icons.filter_alt_sharp, color: Colors.white),
                              SizedBox(
                                width: 6,
                              ),
                              Text("Filter",
                                  style: TextStyle(color: Colors.white))
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(FormCategoriPag());
                          },
                          child: Row(
                            children: [
                              Icon(Icons.category, color: Colors.white),
                              SizedBox(
                                width: 6,
                              ),
                              Text("Create Category",
                                  style: TextStyle(color: Colors.white))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(top: 280),
              padding: EdgeInsets.fromLTRB(24, 30, 24, 0),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(48),
                      topRight: Radius.circular(48))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "List Transaksi",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  (datas.isEmpty)
                      ? Expanded(
                          child: Center(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    MdiIcons.fileSearchOutline,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Belum ada data transaksi",
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              padding: EdgeInsets.only(top: 4),
                              itemCount: datas.length,
                              itemBuilder: (context, index) {
                                final item = datas[index].catatan;
                                return Dismissible(
                                  key: UniqueKey(),
                                  onDismissed: (direction) {
                                    setState(() {
                                      delete(datas[index].id, index);
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                '$item berhasil dihapus')));
                                  },
                                  background: Container(
                                    padding: EdgeInsets.only(right: 8),
                                    color: Colors.red,
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          'Menghapus Transaksi $item',
                                          style: TextStyle(color: Colors.white),
                                          textAlign: TextAlign.start,
                                        )),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      updateDialog(datas[index].id,
                                          datas[index].category);
                                      (datas[index].category == "Masuk")
                                          ? debit.text =
                                              datas[index].debit.toString()
                                          : credit.text =
                                              datas[index].credit.toString();
                                      catatan.text = datas[index].catatan;
                                      status.text = datas[index].category;
                                      datetime = datas[index].date;
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Card_list(
                                        Cash(
                                            debit: datas[index].debit,
                                            credit: datas[index].credit,
                                            catatan: datas[index].catatan,
                                            status: datas[index].status,
                                            category: datas[index].category,
                                            date: datas[index].date),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                ],
              ),
            )),
          ],
        ),
        floatingActionButton: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Inbalance();
                      });
                },
                child: Container(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: Colors.white),
                        Text(
                          "CASH IN",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width / 2 - 24,
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4,
                            color: Color.fromARGB(255, 139, 139, 139),
                            offset: Offset(0, 1))
                      ]),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: (total <= 0)
                    ? () {
                        Get.snackbar("Belum ada uang", "Uang anda masih Rp 0");
                      }
                    : () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return OutBalance();
                            });
                      },
                child: Container(
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(MdiIcons.minus, color: Colors.white),
                        Text(
                          "CASH OUT",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  width: MediaQuery.of(context).size.width / 2 - 24,
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 4,
                            color: Color.fromARGB(255, 139, 139, 139),
                            offset: Offset(0, 1))
                      ]),
                ),
              ),
            ],
          ),
        ));
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
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Jumlah Uang"),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                controller: catatan,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), hintText: "Catatan"),
              ),
              const SizedBox(
                height: 8,
              ),
              TextField(
                enabled: false,
                controller: status,
                style: const TextStyle(color: Colors.grey),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Category"),
              ),
              const SizedBox(
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
                            datetime = date.toString();
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.id);
                      },
                      child: const Icon(
                        MdiIcons.calendar,
                      )),
                  Text(
                    Shared.customeDateTime(DateTime.parse(datetime)),
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
              child: const Text('Batal'),
            ),
            FlatButton(
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
            children: [Text("Apakah anda ingin menghapus?")],
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () {
                delete(cash.id, position);
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => HomePage()));
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
