part of 'widgets.dart';

class Card_list extends StatelessWidget {
  final Cash cash;
  final Function onTap;
  final Function onTapUpdate;
  Card_list(this.cash, {this.onTap, this.onTapUpdate});

  String customeDateTime() {
    DateTime date = DateTime.parse(cash.date);
    String day = date.day.toString();
    String thn = date.year.toString();
    switch (date.month) {
      case 01:
        return day + " Jan " + thn;
        break;
      case 02:
        return day + " Feb " + thn;
        break;
      case 03:
        return day + " Mar " + thn;
        break;
      case 04:
        return day + " Apr " + thn;
        break;
      case 05:
        return day + " Mei " + thn;
        break;
      case 06:
        return day + " Jun " + thn;
        break;
      case 07:
        return day + " Jul " + thn;
        break;
      case 08:
        return day + " Agt " + thn;
        break;
      case 09:
        return day + " Sep " + thn;
        break;
      case 10:
        return day + " Okt " + thn;
        break;
      case 11:
        return day + " Nov " + thn;
        break;
      default:
        return day + " Des " + thn;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 204, 202, 202)),
        borderRadius: BorderRadius.circular(10),
      ),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                (cash.status == "Makan")
                    ? MdiIcons.food
                    : (cash.status == "Traveling")
                        ? MdiIcons.bus
                        : MdiIcons.gold,
                color: (cash.status == "Makan")
                    ? Colors.orange
                    : (cash.status == "Traveling")
                        ? Colors.blue
                        : Colors.amber,
              ),
            ),
            SizedBox(width: 4),
            Container(
              width: MediaQuery.of(context).size.width - 188,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    NumberFormat.currency(locale: 'id-ID', symbol: 'Rp. ')
                        .format((cash.category != "Keluar")
                            ? cash.debit
                            : cash.credit),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: (cash.category == "Masuk")
                          ? Colors.green
                          : Colors.pink,
                    ),
                  ),
                  Text(
                    cash.catatan,
                    style: TextStyle(
                        fontSize: 13,
                        color: (cash.category == "Masuk")
                            ? Colors.green
                            : Colors.pink),
                  ),
                  Text(
                    customeDateTime(),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  )
                ],
              ),
            ),
            GestureDetector(
              child: Icon(MdiIcons.pencil, color: Colors.grey),
              onTap: onTapUpdate,
            ),
            SizedBox(
              width: 8,
            ),
            GestureDetector(
                child: Icon(MdiIcons.delete, color: Colors.pink), onTap: onTap),
          ],
        ),
      ),
    );
  }
}
