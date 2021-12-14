part of 'auth_screen_widget_model.dart';

/// Interface of [AuthScreenWidgetModel]
abstract class IAuthWidgetModel extends IWidgetModel {
  ListenableState<EntityState<User?>> get tagListState;

  Future<void> addUserIfRegistered(User user);
}
