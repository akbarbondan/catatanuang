part of 'pages.dart';

class FilterPage extends StatefulWidget {
  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<Category> categories = [];
  List<Cash> items = [];
  String selectd;

  void refreshdata() async {
    final categorys = await DBHelper.getAllCategory();

    categorys.forEach((element) {
      categories.add(element);
    });

    setState(() {
      categories = categories;
      selectd = categories[0].category;
    });
  }

  void filterdata(String query) async {
    final item = await DBHelper.getItems();
    final datas = item.where((data) {
      final category = data.status.toLowerCase();
      final input = query.toLowerCase();
      return category.contains(input);
    }).toList();
    setState(() {
      items = datas;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    refreshdata();
    filterdata(selectd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.only(top: 40),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Icon(Icons.arrow_back),
                  onTap: () {
                    Get.back();
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButton(
                      isExpanded: true,
                      value: selectd,
                      underline: SizedBox(),
                      items: categories
                          .map((e) => DropdownMenuItem(
                                value: e.category,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(e.category),
                                ),
                              ))
                          .toList(),
                      onChanged: (item) {
                        setState(() {
                          selectd = item;
                          filterdata(selectd);
                        });
                        print(selectd);
                      }),
                ),
                SizedBox(
                  height: 14,
                ),
                Text("List Transaksi"),
                SizedBox(
                  height: 14,
                ),
                Container(
                  height: 600,
                  child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Card_list(
                            Cash(
                                debit: items[index].debit,
                                credit: items[index].credit,
                                catatan: items[index].catatan,
                                status: items[index].status,
                                category: items[index].category,
                                date: items[index].date),
                          ),
                        );
                      }),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
