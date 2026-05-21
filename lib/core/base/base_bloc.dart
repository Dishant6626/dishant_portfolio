import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'view_action.dart';

/// Base for every Bloc in the project.
/// Provides [dispatchViewEvent] so blocs can push navigation/message
/// actions to the screen without knowing about BuildContext.
abstract class BaseBloc<E, S> extends Bloc<E, S> {
  BaseBloc(super.initialState);

  final _viewActionController = StreamController<ViewAction>.broadcast();

  Stream<ViewAction> get viewActionStream => _viewActionController.stream;

  /// Called from bloc handlers to notify the screen
  void dispatchViewEvent(ViewAction event) {
    if (!_viewActionController.isClosed) {
      _viewActionController.add(event);
    }
  }

  @override
  Future<void> close() async {
    await _viewActionController.close();
    return super.close();
  }
}
