class Shared {
  static String customeDateTime(DateTime date) {
    if (date == null) {
      date = DateTime.now();
    }
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
}
