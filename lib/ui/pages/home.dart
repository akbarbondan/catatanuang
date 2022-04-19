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
        body: Container(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: const Center(
                            child: Text(
                              "My balance",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Center(
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
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text("Jumlah uang keluar",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                      NumberFormat.currency(
                                              locale: 'id-ID', symbol: 'Rp. ')
                                          .format(totalIn),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      )),
                                  Text(
                                    "Jumlah uang Masuk",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
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
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RaisedButton(
                                color: Colors.white,
                                onPressed: () {
                                  Get.to(FilterPage());
                                },
                                child: Container(
                                    height: 20,
                                    child: Text("Filter",
                                        style: TextStyle(color: Colors.blue))),
                              ),
                              RaisedButton(
                                color: Colors.white,
                                onPressed: () {
                                  Get.to(FormCategoriPag());
                                },
                                child: Container(
                                    height: 20,
                                    child: Text("Create category",
                                        style: TextStyle(color: Colors.blue))),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "List transaksi",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Container(
                            height: 600,
                            child: (datas.isEmpty)
                                ? Center(
                                    child: Container(
                                      height: 80,
                                      child: Column(
                                        children: [
                                          Icon(
                                            MdiIcons.fileSearchOutline,
                                            size: 50,
                                            color: Colors.grey,
                                          ),
                                          Text(
                                            "Belum ada data transaksi",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: datas.length,
                                    itemBuilder: (context, index) {
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
                                            dialogdelte(
                                                Cash(id: datas[index].id),
                                                index);
                                          },
                                          onTapUpdate: () {
                                            updateDialog(datas[index].id,
                                                datas[index].category);
                                            (datas[index].category == "Masuk")
                                                ? debit.text = datas[index]
                                                    .debit
                                                    .toString()
                                                : credit.text = datas[index]
                                                    .credit
                                                    .toString();
                                            catatan.text = datas[index].catatan;
                                            status.text = datas[index].category;
                                            datetime = datas[index].date;
                                          },
                                        ),
                                      );
                                    })),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        floatingActionButton: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 30),
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
              SizedBox(
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
                      child: Icon(
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
            children: <Widget>[Text("Apakah anda ingin menghapus?")],
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
