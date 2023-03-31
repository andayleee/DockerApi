import 'dart:io';

import 'package:apibackend/model/categories.dart';
import 'package:conduit/conduit.dart';

import '../model/model_response.dart';
import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class AppCategoryController extends ResourceController {
  AppCategoryController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.get()
  Future<Response> getCategorys(
    @Bind.header(HttpHeaders.authorizationHeader) String header,
  //  @Bind.query("page") int page,
  ) async {
    try {
      // Получаем id пользователя из header
      final id = AppUtils.getIdFromHeader(header);

      final qGetCategory = Query<Categories>(managedContext);

      final List<Categories> list = await qGetCategory.fetch();

      if (list.isEmpty)
        return Response.notFound(
            body: ModelResponse(data: [], message: "Нет ни одной категории"));

      return Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }
}
