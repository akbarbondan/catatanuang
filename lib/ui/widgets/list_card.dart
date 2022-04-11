part of 'widgets.dart';

class Card_list extends StatelessWidget {
  final int balance;
  final String catan;
  final String category;
  final Function onTap;
  final Function onTapUpdate;
  Card_list(this.balance, this.catan, this.category,
      {this.onTap, this.onTapUpdate});

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
              width: MediaQuery.of(context).size.width - 188,
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
            GestureDetector(
              child: Icon(MdiIcons.pencil),
              onTap: onTapUpdate,
            ),
            SizedBox(
              width: 8,
            ),
            GestureDetector(child: Icon(MdiIcons.delete), onTap: onTap),
          ],
        ),
      ),
    );
  }
}
