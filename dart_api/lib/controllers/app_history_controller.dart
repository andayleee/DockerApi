import 'dart:io';

import 'package:apibackend/model/history.dart';
import 'package:apibackend/model/node.dart';
import 'package:conduit/conduit.dart';

import '../model/model_response.dart';
import '../utils/app_response.dart';
import '../utils/app_utils.dart';

class AppHistoryController extends ResourceController {
  AppHistoryController(this.managedContext);

  final ManagedContext managedContext;

  @Operation.get()
  Future<Response> getFinanceHistory() 
  async {
    try {

      final qGetHistory = Query<History>(managedContext);

      final List<History> list = await qGetHistory.fetch();

      if (list.isEmpty)
      {
        return Response.notFound(body: ModelResponse(data: [], message: "История пуста"));
      }

      return Response.ok(list);
    } catch (e) {
      return AppResponse.serverError(e);
    }
  }

}