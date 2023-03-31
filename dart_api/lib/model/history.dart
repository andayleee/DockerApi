
import 'package:conduit/conduit.dart';

class History extends ManagedObject<_History> implements _History{}
  
  class _History{
  @primaryKey
  int? idhistory;

  @Column(indexed: true)
  String? statusrecord;
  
  @Column(indexed: true)
  String? nodeinfo;
  
  @Column(indexed: true)
  String? userinfo;
  
  @Column(indexed: true)
  DateTime? datacreate;


}