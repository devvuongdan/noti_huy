
import 'drink_record.dart';

class DailyDrinkRecord {
  int? id;
  int target;
  List<DrinkRecord> records;
  DateTime date;

  DailyDrinkRecord(
      {this.id,
      required this.target,
      required this.records,
      required this.date});

  int get totalCapacity => records.fold(
      0, (previousCapacity, record) => previousCapacity + record.capacity);
}
