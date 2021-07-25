import 'package:aims_mobile/services/push_notification_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => PushNotificationService());
}