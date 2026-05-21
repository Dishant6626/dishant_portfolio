import 'dart:async';

import 'package:flutter/material.dart';

import 'base_bloc.dart';
import 'view_action.dart';

/// Matches the pattern in the vFul live template:
///   class _ScreenState extends BaseState<MyBloc, MyScreen>
///
/// Subclasses must override:
///   B createBloc()          — factory that returns the typed Bloc
///   void onViewEvent(...)   — handles NavigateScreen / DisplayMessage
abstract class BaseState<B extends BaseBloc, W extends StatefulWidget>
    extends State<W> {
  late final B bloc;
  StreamSubscription<ViewAction>? _viewActionSub;

  /// Subclass provides the concrete Bloc instance.
  B createBloc();

  @override
  void initState() {
    super.initState();
    bloc = createBloc();
    _viewActionSub = bloc.viewActionStream.listen(onViewEvent);
  }

  /// Handle view events dispatched by the Bloc.
  void onViewEvent(ViewAction event);

  @override
  void dispose() {
    _viewActionSub?.cancel();
    bloc.close();
    super.dispose();
  }
}
