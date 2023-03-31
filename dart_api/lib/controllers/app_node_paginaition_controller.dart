import 'dart:io';

import 'package:apibackend/model/node.dart';
import 'package:conduit/conduit.dart';

import '../model/model_response.dart';
import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class AppNodePaginationController extends ResourceController {
  AppNodePaginationController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.get("page")
  Future<Response> getPagination(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
    @Bind.path("page") int pageNumber,
  ) async {
    try {
      if (pageNumber < 0)
      {
        return Response.notFound(body: ModelResponse(data: [], message: "Страница не может быть меньше единицы"));
      }
      // Получаем id пользователя из header
      final id = AppUtils.getIdFromHeader(header);

      final qNodePages = Query<Node>(managedContext)
        ..where((x) => x.user!.id).equalTo(id)
        ..where((x) => x.isDeleted).equalTo(false)
        ..sortBy((x) => x.id, QuerySortOrder.ascending)
        ..fetchLimit = 3
        ..offset = (pageNumber-1)*20;

      final List<Node> list = await qNodePages.fetch();

      if (list.isEmpty)
      {
        return Response.notFound(body: ModelResponse(data: [], message: "Страница пуста"));
      }

      return Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }
  

}