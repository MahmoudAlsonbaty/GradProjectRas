//REQUEST is a single medicine, while ORDER is a bunch of REQUESTS,
class REQUEST {
  final String medicineName;
  final int orderQuantity;
  final int shelfNo;

  const REQUEST(
      {required this.medicineName,
      required this.orderQuantity,
      required this.shelfNo});
}

class ORDER {
  final List<REQUEST> requestsList;

  const ORDER({required this.requestsList});
}
