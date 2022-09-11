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
        border: Border(
          bottom: BorderSide(color: Color.fromARGB(255, 204, 202, 202)),
        ),
      ),
      child: Container(
        // padding: EdgeInsets.only(right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue),
                  child: Icon(
                    (cash.status == "Makan")
                        ? MdiIcons.food
                        : (cash.status == "Traveling")
                            ? MdiIcons.bus
                            : (cash.status == "Masuk")
                                ? MdiIcons.gold
                                : MdiIcons.minus,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cash.catatan,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700)),
                    Text(
                      customeDateTime(),
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ),
              ],
            )

            // (onTapUpdate != null)
            //     ? GestureDetector(
            //         child: Icon(MdiIcons.pencil, color: Colors.grey),
            //         onTap: onTapUpdate,
            //       )
            //     : SizedBox(),
            // SizedBox(
            //   width: 8,
            // ),
            // (onTap != null)
            //     ? GestureDetector(
            //         child: Icon(MdiIcons.delete, color: Colors.grey),
            //         onTap: onTap)
            //     : SizedBox(),

            ,
            Text(
              NumberFormat.currency(
                      locale: 'id-ID',
                      symbol: (cash.category != "Keluar") ? 'Rp. ' : '- Rp. ')
                  .format(
                      (cash.category != "Keluar") ? cash.debit : cash.credit),
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: (cash.category != "Keluar")
                      ? Colors.green[300]
                      : Colors.red[300]),
            ),
          ],
        ),
      ),
    );
  }
}
