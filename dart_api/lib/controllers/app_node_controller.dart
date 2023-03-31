import 'dart:io';

import 'package:apibackend/model/node.dart';
import 'package:conduit/conduit.dart';

import '../model/model_response.dart';
import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class AppNodeController extends ResourceController {
  AppNodeController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.get()
  Future<Response> getNodes(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
  //  @Bind.query("page") int page,
  ) async {
    try {
      // Получаем id пользователя из header
      final id = AppUtils.getIdFromHeader(header);

      final qCreateNode = Query<Node>(managedContext)
        ..where((x) => x.user!.id).equalTo(id)
        ..where((x) => x.isDeleted).equalTo(false);
    //    ..fetchLimit = 3
    //    ..offset = (page-1) * 20;

      final List<Node> list = await qCreateNode.fetch();

      if (list.isEmpty)
        return Response.notFound(
            body: ModelResponse(data: [], message: "Нет ни одной заметки"));

      return Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

  @Operation.post()
  Future<Response> createNode(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.body() Node node) async {
    try {
      // Получаем id пользователя из header
      final id = AppUtils.getIdFromHeader(header);

      // Создаем запрос для создания финансового отчета передаем id пользователя контент берем из body
      final qCreateNode = Query<Node>(managedContext)
        ..values.nodeTitle = node.nodeTitle
        ..values.nodeDescription = node.nodeDescription
        ..values.createDate = DateTime.now()
        ..values.updateDate = DateTime.now()
        ..values.isDeleted = false
        //передаем в внешний ключ id пользователя
        ..values.user!.id = id
        ..values.category!.id = node.idCategory;

      await qCreateNode.insert();

      return AppResponse.ok(message: 'Успешное создание заметки отчета');
    } catch (error) {
      return AppResponse.serverError(error, message: 'Ошибка создания заметки');
    }
  }

  @Operation.put('id')
  Future<Response> updateNode(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path("id") int id,
      @Bind.body() Node bodyNode) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final nodeData = await managedContext.fetchObjectWithID<Node>(id);
      if (nodeData == null) {
        return AppResponse.ok(message: "Заметка не найдена");
      }
      if (nodeData.user?.id != currentUserId) {
        return AppResponse.ok(message: "Нет доступа к заметке");
      }

      final qUpdateNodeData = Query<Node>(managedContext)
        ..where((x) => x.id).equalTo(id)
        ..values.nodeTitle = bodyNode.nodeTitle
        ..values.nodeDescription = bodyNode.nodeDescription
        ..values.createDate = bodyNode.createDate
        ..values.updateDate = DateTime.now()
        ..values.isDeleted = false
        //передаем в внешний ключ id пользователя
        ..values.user!.id = currentUserId
        ..values.category!.id = bodyNode.idCategory;

      await qUpdateNodeData.update();

      return AppResponse.ok(message: 'Заметка успешно обновлена');
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

  @Operation.delete("id")
  Future<Response> deleteNode(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.path("id") int id,
  ) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final nodeData = await managedContext.fetchObjectWithID<Node>(id);
      if (nodeData == null) {
        return AppResponse.ok(message: "Заметка не найденa");
      }
      if (nodeData.user?.id != currentUserId) {
        return AppResponse.ok(message: "Нет доступа к заметке :(");
      }
      final qDeleteNodeData = Query<Node>(managedContext)
        ..where((x) => x.id).equalTo(id);
      await qDeleteNodeData.delete();
      return AppResponse.ok(message: "Успешное удаление заметки");
    } catch (error) {
      return AppResponse.serverError(error, message: "Ошибка удаления заметки");
    }
  }

  @Operation.get("id")
  Future<Response> getNodeDataFromID(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.path("id") int id,
  ) async {
    try {
      final currentUserId = AppUtils.getIdFromHeader(header);
      final nodeData = await managedContext.fetchObjectWithID<Node>(id);
      if (nodeData == null) {
        return AppResponse.ok(message: "Заметка не найдена");
      }
      if (nodeData.user?.id != currentUserId) {
        return AppResponse.ok(message: "Нет доступа к заметке");
      }
      nodeData.backing.removeProperty("user");
      return Response.ok(nodeData);
    } catch (error) {
      return AppResponse.serverError(error,
          message: "Ошибка получения заметки");
    }
  }
}
