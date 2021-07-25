import 'package:aims_mobile/screens/forms/supervisor/cluster_operations.dart';
import 'package:aims_mobile/screens/forms/supervisor/review_data.dart';
import 'package:flutter/material.dart';

import 'assign_households.dart';

class Menus extends StatelessWidget {
  final Map clusters;

  Menus(this.clusters);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff392850),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                text: "Assign Households",
              ),
              Tab(text: "Review Data"),
              Tab(text: "Cluster Operations"),
            ],
          ),
          title: Text(clusters['clustername']),
        ),
        body: TabBarView(
          children: [
            AssignHouseholds(),
            ReviewData(),
            ClusterOperations(),
          ],
        ),
      ),
    );
  }
}
