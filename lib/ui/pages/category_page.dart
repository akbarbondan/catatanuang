part of 'pages.dart';

class FormCategoriPag extends StatefulWidget {
  @override
  State<FormCategoriPag> createState() => _FormCategoriPagState();
}

class _FormCategoriPagState extends State<FormCategoriPag> {
  TextEditingController category = TextEditingController();

  List<Category> datas = [];

  void insertCategory(Category category) async {
    var db = await DBHelper.craateCategoty(category);
    refreshData();
  }

  void refreshData() async {
    final data = await DBHelper.getAllCategory();
    setState(() {
      datas = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(30),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        child: Icon(Icons.arrow_back),
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                      controller: category,
                      decoration: InputDecoration(
                          label: Text("Category"),
                          hintText: "Masukan Category",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)))),
                  RaisedButton(
                    onPressed: () {
                      if (category.text == "") {
                        Get.snackbar("", "Inputan tidak boleh kosong");
                      } else {
                        Get.snackbar("", "Berhasil menyimpan category");
                        insertCategory(Category(category: category.text));
                        setState(() {
                          category.text = "";
                        });
                      }
                    },
                    color: Colors.white,
                    child: Text(
                      "Simpan",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("List Category"),
                  Container(
                      height: 500,
                      width: double.infinity,
                      child: (datas.isNotEmpty)
                          ? ListView.builder(
                              itemCount: datas.length,
                              itemBuilder: (_, index) => Card(
                                    child: ListTile(
                                      title: Text(datas[index].category),
                                      trailing: GestureDetector(
                                        child: Icon(MdiIcons.delete),
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) => AlertDialog(
                                                    content: Text(
                                                        "Anda ingin menghapus " +
                                                            datas[index]
                                                                .category +
                                                            "?"),
                                                    actions: [
                                                      FlatButton(
                                                          onPressed: () {
                                                            DBHelper
                                                                .deleteCategory(
                                                                    datas[index]
                                                                        .id);
                                                            setState(() {
                                                              datas.removeAt(
                                                                  index);
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            "ya",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                          )),
                                                      FlatButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            "Tidak",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ))
                                                    ],
                                                  ));
                                        },
                                      ),
                                    ),
                                  ))
                          : Center(
                              child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Icon(MdiIcons.fileSearchOutline,
                                          size: 50, color: Colors.grey),
                                      Text(
                                        "Belum ada data category",
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      )
                                    ],
                                  ))))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
