class OrderModel {
  int id;
  DateTime created;
  DateTime finished;
  List<String> addresses;
  String status;
  int cash;
  // TODO: this must driver model
  int driverId;
  // TODO: this must car model
  int carId;

  OrderModel({
    required this.id,
    required this.created,
    required this.finished,
    required this.addresses,
    required this.status,
    required this.cash,
    required this.driverId,
    required this.carId,
  });
}
