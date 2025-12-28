import '../core/constants/global_constants.dart';
import '../services/api_service.dart';
import 'network/dio_client.dart';

class AppConfig {
  static void injectDependency() {
    getIt.registerSingleton<DioClient>(DioClient());
    getIt.registerSingleton<ApiService>(
      ApiService(client: getIt.get<DioClient>()),
    );
  }
}
