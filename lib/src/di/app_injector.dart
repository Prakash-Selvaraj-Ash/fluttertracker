import 'package:inject/inject.dart';
import 'app_injector.inject.dart' as g;
import '../../app.dart';
import 'app_module.dart';

@Injector(const [AppModule])
abstract class AppInjector {
  @provide
  App get app;

  static final create = g.AppInjector$Injector.create;
}
