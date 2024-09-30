import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import '../auth_session/auth_mgr.dart';

class DIContainer {
  static Future<void> setup() async {
    await GetStorage.init();
    GetIt.I.registerSingleton<AuthMgr>(AuthMgr());
  }
}