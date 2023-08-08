import 'package:fbus_app_driver/src/core/const/colors.dart';
import 'package:fbus_app_driver/src/widgets/my_drawer_header_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({super.key});

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  MyDrawerHeaderController con = Get.put(MyDrawerHeaderController());
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.busdetailColor,
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            child: CircleAvatar(
              backgroundImage: con.user.value.profileImg != null
                  ? NetworkImage(con.user.value.profileImg!)
                  : const AssetImage('assets/images/user.png') as ImageProvider,
              radius: 60,
              backgroundColor: Colors.white,
            ),
          ),
          Text(
            con.user.value.fullname ?? "",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            con.user.value.email ?? "",
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}
