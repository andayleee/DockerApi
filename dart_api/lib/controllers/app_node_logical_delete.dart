import 'dart:io';

import 'package:apibackend/model/node.dart';
import 'package:conduit/conduit.dart';

import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class AppNodeDeleteLogicalController extends ResourceController {
  AppNodeDeleteLogicalController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.put('id')
  Future<Response> deleteLogicalFinanceData(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.path("id") int id,
  ) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final node =
          await managedContext.fetchObjectWithID<Node>(id);
      if (node == null) {
        return AppResponse.ok(message: "Заметка не найдена");
      }
      if (node.user?.id != currentUserId) {
        return AppResponse.ok(message: "Нет доступа к заметке :(");
      }
      final qDeleteLogicalNode = Query<Node>(managedContext)
        ..where((x) => x.id).equalTo(id)
        ..values.isDeleted = true;
      await qDeleteLogicalNode.update();
      return AppResponse.ok(
          message:
              "Успешное логическое удаление заметки");
    } catch (error) {
      return AppResponse.serverError(error,
          message:
              "Ошибка логического удаления заметки");
    }
  }

  @Operation.put()
  Future<Response> returnLogicalFinanceData(
    @Bind.header(HttpHeaders.authorizationHeader) String header
  ) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final qDeleteLogicalFinanceData = Query<Node>(managedContext)
        ..where((x) => x.isDeleted).equalTo(true)
        ..where((x) => x.user!.id).equalTo(currentUserId)
        ..values.isDeleted = false;
      await qDeleteLogicalFinanceData.update();
      return AppResponse.ok(
          message:
              "Успешное логическое восстановление заметки");
    } catch (error) {
      return AppResponse.serverError(error,
          message:
              "Ошибка логического восстановления заметки");
    }
  }
}


