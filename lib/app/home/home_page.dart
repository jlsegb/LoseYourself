import 'package:flutter/material.dart';
import 'package:just_serve/app/home/account/account_page.dart';
import 'package:just_serve/app/home/cupertino_home_scaffold.dart';
import 'package:just_serve/app/home/projects/personal_projects_page.dart';
import 'package:just_serve/app/home/projects/public_board_page.dart';
import 'package:just_serve/app/home/tab_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.personalProjects;

  Map<TabItem, WidgetBuilder> get _widgetBuilderMap {
    return {
      TabItem.personalProjects: (_) => PersonalProjectsPage(),
      TabItem.publicBoard: (_) => PublicBoardPage(),
      TabItem.account: (_) => AccountPage(),
    };
  }

  void _select(TabItem tabItem) {
    setState(() {
      _currentTab = tabItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoHomeScaffold(
      currentTab: _currentTab,
      onSelectTab: _select,
      widgetBuilderMap: _widgetBuilderMap,
    );
  }
}
