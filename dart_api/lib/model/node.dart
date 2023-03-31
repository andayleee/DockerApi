
import 'package:apibackend/model/categories.dart';
import 'package:apibackend/model/user.dart';
import 'package:conduit/conduit.dart';

class Node extends ManagedObject<_Node> implements _Node{}
  
  class _Node{
  @primaryKey
  int? id;

  @Column(indexed: true)
  String? nodeTitle;
  
  @Column(indexed: true)
  String? nodeDescription;
  
  @Column(indexed: true)
  DateTime? createDate;
  
  @Column(indexed: true)
  DateTime? updateDate;

   @Column(indexed: true)
   bool? isDeleted;

  @Serialize(input: true, output: false)
  int? idCategory;


  @Relate(#node, isRequired: true, onDelete: DeleteRule.cascade)
  User? user;
  @Relate(#node, isRequired: true, onDelete: DeleteRule.cascade)
  Categories? category;

}