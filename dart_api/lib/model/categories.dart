import 'package:apibackend/model/node.dart';
import 'package:conduit/conduit.dart';

class Categories extends ManagedObject<_Categories> implements _Categories{}
  
  class _Categories{
  @primaryKey
  int? id;

  @Column(unique: true, indexed: true)
  String? categoryName;
  
   ManagedSet<Node>? node;
}