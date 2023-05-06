import 'package:hive/hive.dart';
part 'details.g.dart';

@HiveType(typeId: 0)
class Detail extends HiveObject{
  @HiveField(0,defaultValue:0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String request;

  Detail({required this.id, required this.name, required this.request});
}