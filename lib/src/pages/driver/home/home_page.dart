import 'package:fbus_app_driver/src/core/const/colors.dart';
import 'package:fbus_app_driver/src/pages/driver/dashboard/list/dashboard_page.dart';
import 'package:fbus_app_driver/src/pages/driver/history/history_trip_page.dart';
import 'package:fbus_app_driver/src/pages/driver/home/home_controller.dart';
import 'package:fbus_app_driver/src/pages/driver/notification/notifications_page.dart';
import 'package:fbus_app_driver/src/pages/driver/profile/info/profile_page.dart';
import 'package:fbus_app_driver/src/widgets/my_drawer_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomaeDriverPage extends StatefulWidget {
  @override
  _HomaeDriverPageState createState() => _HomaeDriverPageState();
}

class _HomaeDriverPageState extends State<HomaeDriverPage> {
  var currentPage = DrawerSections.dashboard;
  HomeDriverController con = Get.put(HomeDriverController());
  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.dashboard) {
      container = DashboardPage();
    } else if (currentPage == DrawerSections.profile) {
      container = ProfilePage();
    } else if (currentPage == DrawerSections.notifications) {
      container = const NotificationPage();
    } else if (currentPage == DrawerSections.history) {
      container = HistoryTripPage();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.orange
            .withAlpha(255)
            .withRed(225)
            .withGreen(109)
            .withBlue(54),
        toolbarHeight: 120,
        title: const Text(
          "F-BUS",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColor.textColor,
          ),
        ),
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                const MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget MyDrawerList() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Dashboard", Icons.dashboard_outlined,
              currentPage == DrawerSections.dashboard ? true : false),
          menuItem(2, "Profile", Icons.people_alt_outlined,
              currentPage == DrawerSections.profile ? true : false),
          menuItem(3, "Notifications", Icons.notifications_outlined,
              currentPage == DrawerSections.notifications ? true : false),
          menuItem(4, "History", Icons.history_outlined,
              currentPage == DrawerSections.history ? true : false),
          Divider(),
          menuItem(5, "Logout", Icons.logout,
              currentPage == DrawerSections.logout ? true : false),
          //     menuItem(4, "Notifications", Icons.notifications_outlined,
          //     currentPage == DrawerSections.notifications ? true : false),
          // Divider(),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.dashboard;
            } else if (id == 2) {
              currentPage = DrawerSections.profile;
            } else if (id == 3) {
              currentPage = DrawerSections.notifications;
            } else if (id == 4) {
              currentPage = DrawerSections.history;
            } else if (id == 5) {
              con.signOut();
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  dashboard,
  profile,
  notifications,
  history,
  logout,
}
