import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:mm_flutter_app/constants/app_constants.dart';
import 'package:mm_flutter_app/widgets/atoms/notification_bubble.dart';

/*
 * Contains bottom navigation bar and app bar
 */
class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key, required this.child});
  final Widget child;

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  int _currentTabIndex = 0;
  String? _appBarTitle;

  List<_Tab> _generateTabs(BuildContext context, AppLocalizations l10n) {
    // TODO(m-rosario): Calculate notifications from backend call
    const int chatsNotifications = 1;
    const int invitesNotifications = 0;
    const int archivedChatsNotifications = 1;
    const int totalNotifications =
        chatsNotifications + invitesNotifications + archivedChatsNotifications;
    return [
      const _Tab(route: Routes.home),
      const _Tab(route: Routes.explore),
      const _Tab(route: Routes.progress),
      _Tab(
        route: Routes.inboxChats,
        appBar: AppBar(
          leading: Builder(builder: (context) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
                if (totalNotifications > 0)
                  const Padding(
                    padding: EdgeInsetsDirectional.only(
                      top: Insets.widgetSmallInset,
                      start: Insets.widgetSmallInset,
                    ),
                    child: NotificationBubble(
                      notifications: totalNotifications,
                    ),
                  ),
              ],
            );
          }),
          title: Text(
            _appBarTitle ?? l10n.inboxTitleChats,
            style: TextStyles.appBarTitle(context),
          ),
          centerTitle: true,
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              SizedBox(
                height: Dimensions.drawerHeaderHeight,
                child: DrawerHeader(
                  child: Text(l10n.inboxTitle),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.chat_bubble_outline),
                title: Text(l10n.inboxTitleChats),
                trailing: chatsNotifications > 0
                    ? Text(
                        chatsNotifications > Limits.maxNotificationsDisplayed
                            ? Identifiers.notificationOverflow
                            : chatsNotifications.toString(),
                      )
                    : null,
                onTap: () {
                  // Close Drawer
                  Navigator.of(context).pop();
                  GoRouter.of(context).push(Routes.inboxChats);
                  setState(() {
                    _appBarTitle = l10n.inboxTitleChats;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_add_outlined),
                title: Text(l10n.inboxTitleInvites),
                trailing: invitesNotifications > 0
                    ? Text(
                        invitesNotifications > Limits.maxNotificationsDisplayed
                            ? Identifiers.notificationOverflow
                            : invitesNotifications.toString(),
                      )
                    : null,
                onTap: () {
                  // Close Drawer
                  Navigator.of(context).pop();
                  GoRouter.of(context).push(Routes.inboxInvites);
                  setState(() {
                    _appBarTitle = l10n.inboxTitleInvites;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: Text(l10n.inboxTitleArchivedChats),
                trailing: archivedChatsNotifications > 0
                    ? Text(
                        archivedChatsNotifications >
                                Limits.maxNotificationsDisplayed
                            ? Identifiers.notificationOverflow
                            : archivedChatsNotifications.toString(),
                      )
                    : null,
                onTap: () {
                  // Close Drawer
                  Navigator.of(context).pop();
                  GoRouter.of(context).push(Routes.inboxArchived);
                  setState(() {
                    _appBarTitle = l10n.inboxTitleArchivedChats;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      const _Tab(route: Routes.profile),
    ];
  }

  int _calculateSelectedIndex(BuildContext context) {
    final GoRouter route = GoRouter.of(context);
    final String location = route.location;
    if (location.startsWith(Routes.explore)) {
      return 1;
    }
    if (location.startsWith(Routes.progress)) {
      return 2;
    }
    if (location.startsWith(Routes.inbox)) {
      return 3;
    }
    if (location.startsWith(Routes.profile)) {
      return 4;
    }
    if (location.startsWith(Routes.home)) {
      return 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final List<_Tab> tabs = _generateTabs(context, l10n);
    return Scaffold(
      body: widget.child,
      appBar: tabs[_currentTabIndex].appBar,
      drawer: tabs[_currentTabIndex].drawer,
      bottomNavigationBar: NavigationBar(
        destinations: <Widget>[
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            label: AppLocalizations.of(context)!.navHomeText,
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_outlined),
            label: AppLocalizations.of(context)!.navExploreText,
          ),
          NavigationDestination(
            icon: const Icon(Icons.incomplete_circle),
            label: AppLocalizations.of(context)!.navProgressText,
          ),
          NavigationDestination(
            icon: const Icon(Icons.mail_outline),
            label: AppLocalizations.of(context)!.navInboxText,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outlined),
            label: AppLocalizations.of(context)!.navProfileText,
          ),
        ],
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) {
          context.push(tabs[index].route);
          setState(() {
            _currentTabIndex = index;
          });
        },
      ),
    );
  }
}

class _Tab {
  final String route;
  final Drawer? drawer;
  final AppBar? appBar;

  const _Tab({
    required this.route,
    this.drawer,
    this.appBar,
  });
}
