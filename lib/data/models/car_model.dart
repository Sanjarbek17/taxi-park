class CarModel {
  final int id;
  final String brand;
  final String color;
  final String plate;
  final bool? isWorking;
  final int year;

  CarModel({
    required this.id,
    required this.brand,
    required this.color,
    required this.plate,
    required this.isWorking,
    required this.year,
  });

  factory CarModel.fromJson(Map<String, dynamic> data) {
    final json = data['attributes'];
    return CarModel(
      id: data['id'],
      brand: json['brand'].toString().isEmpty ? 'NOCAR' : json['brand'].toString().toUpperCase(),
      color: json['color'],
      plate: json['plate'],
      isWorking: json['isWorking'],
      year: json['year'],
    );
  }
}
