import 'dart:io';
import 'package:apibackend/controllers/app_auth_controller.dart';
import 'package:apibackend/controllers/app_history_controller.dart';
import 'package:apibackend/controllers/app_node_controller.dart';
import 'package:apibackend/controllers/app_node_paginaition_controller.dart';
import 'package:apibackend/controllers/app_token_controller.dart';
import 'package:apibackend/controllers/app_user_controller.dart';
import 'controllers/app_category_controller.dart';
import 'controllers/app_node_logical_delete.dart';
import 'model/node.dart';
import 'model/user.dart';
import 'model/categories.dart';
import 'model/history.dart';
import 'package:conduit/conduit.dart';

class AppService extends ApplicationChannel{

  late final ManagedContext managedContext;

  @override
  Future prepare(){
    final persistentStore = _initDataBase();
    managedContext = ManagedContext(ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);
    return super.prepare();
  }
  @override 
  Controller get entryPoint =>Router()..route('token/[:refresh]').link(() => AppAuthContoler(managedContext),
    )
    ..route('user')
        .link(AppTokenController.new)!
        .link(() => AppUserConttolelr(managedContext))
    ..route('node/[:id]')
        .link(AppTokenController.new)!
        .link(() => AppNodeController(managedContext))
    ..route('node/delete/[:id]')
      .link(AppTokenController.new)!
      .link(() => AppNodeDeleteLogicalController(managedContext))
    ..route('node/pagination/[:page]')
      .link(AppTokenController.new)!
      .link(() => AppNodePaginationController(managedContext))
    ..route('node/history')
      .link(AppTokenController.new)!
      .link(() => AppHistoryController(managedContext))
    ..route('category')
      .link(AppTokenController.new)!
      .link(() => AppCategoryController(managedContext));
  PersistentStore _initDataBase(){
    final username = Platform.environment['DB_USERNAME'] ?? 'postgres';
    final password = Platform.environment['DB_PASSWORD'] ?? '717579';
    final host = Platform.environment['DB_HOST'] ?? '127.0.0.1';

    final port = int.parse(Platform.environment['DB_PORT'] ?? '5432');
    
    final databaseName = Platform.environment['DB_NAME'] ?? 'postgres';

    return PostgreSQLPersistentStore(username, password, host, port, databaseName);
    
  }
}