import 'package:flutter/material.dart';

enum TabItem { personalProjects, publicBoard, account }

class TabItemData {
  const TabItemData({
    @required this.title,
    @required this.icon,
  });

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> tabDataMap = {
    TabItem.personalProjects: TabItemData(
      title: 'Manage',
      icon: Icons.call_to_action,
    ),
    TabItem.publicBoard: TabItemData(
      title: 'Public',
      icon: Icons.view_headline,
    ),
    TabItem.account: TabItemData(
      title: 'Account',
      icon: Icons.account_box,
    ),
  };
}
