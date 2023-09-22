import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mm_flutter_app/providers/models/scaffold_model.dart';
import 'package:provider/provider.dart';

import '../providers/models/notifications_model.dart';

mixin NavigationMixin<T extends StatefulWidget> on State<T>
    implements RouteAware {
  late final ScaffoldModel _scaffoldModel;
  late final NotificationsModel _notificationsModel;
  late GoRouter _router;
  late final RouteObserver<PageRoute> _routeObserver;
  PageRoute? _pageRoute;

  PageRoute get pageRoute => _pageRoute!;
  GoRouter get router => _router;

  @override
  void initState() {
    super.initState();
    _scaffoldModel = Provider.of<ScaffoldModel>(
      context,
      listen: false,
    );
    _notificationsModel = Provider.of<NotificationsModel>(
      context,
      listen: false,
    );
    _routeObserver = Provider.of<RouteObserver<PageRoute>>(
      context,
      listen: false,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _router = GoRouter.of(context);
    if (_pageRoute != null) {
      _routeObserver.unsubscribe(this);
    }
    _pageRoute = ModalRoute.of(context)! as PageRoute;
    _routeObserver.subscribe(this, _pageRoute!);
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {}

  @override
  void didPopNext() {}

  @override
  void didPush() {}

  @override
  void didPushNext() {}

  void buildPageRouteScaffold(
      void Function(
        ScaffoldModel scaffoldModel,
      ) build) {
    if (_pageRoute!.isCurrent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        //TODO: Use subscriptions to auto-refresh on relevant channel events
        _notificationsModel.refreshInboxNotifications();
        build(_scaffoldModel);
      });
    }
  }
}
