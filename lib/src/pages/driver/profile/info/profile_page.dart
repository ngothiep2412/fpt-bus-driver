import 'package:fbus_app_driver/src/core/const/colors.dart';
import 'package:fbus_app_driver/src/core/helpers/image_helper.dart';
import 'package:fbus_app_driver/src/pages/driver/profile/info/profile_controller.dart';
import 'package:fbus_app_driver/src/utils/helper.dart';
import 'package:fbus_app_driver/src/widgets/item_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  ProfileController con = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    print('User name: ${con.user.value.profileImg}');
    return Scaffold(
        body: Obx(
      () => Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: Helper.getScreenWidth(context),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      children: [
                        _imageProfile(context),
                        const SizedBox(
                          height: 10,
                        ),
                        _boxForm(context),
                        const SizedBox(
                          height: 40,
                        ),
                        ItemButtonWidget(
                          data: 'Update profile',
                          color: Colors.white,
                          onTap: () {
                            con.goToProfileUpdate();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          _textWelcome(),
          _textEmail(con.user.value.email ?? ''),
          _textName(con.user.value.fullname ?? ''),
          _textPhone(con.user.value.phoneNumber ?? 'None'),
        ],
      )),
    );
  }

  Widget _imageProfile(BuildContext context) {
    return ClipOval(
      child: Stack(
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
        ],
      ),
    );
  }

  Widget _textWelcome() {
    return const Text(
      "Personal Detail",
      style: TextStyle(
        color: AppColor.secondary,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  Widget _textEmail(String email) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      // borderRadius: BorderRadius.circular(5),
      // ),
      child: ListTile(
        leading:
            ImageHelper.loadFromAsset(Helper.getAssetIconName('ico_mail.png')),
        title: Text(
          'Email',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF323B4B),
            fontWeight: FontWeight.w400,
            height: 16 / 14,
          ).copyWith(
            fontSize: 14,
            height: 12 / 10,
          ),
        ),
        subtitle: Text(
          email,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF323B4B),
            fontWeight: FontWeight.w400,
            height: 16 / 14,
          ),
        ),
      ),
    );
  }

  Widget _textName(String name) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      // borderRadius: BorderRadius.circular(5),
      // ),
      child: ListTile(
        leading:
            ImageHelper.loadFromAsset(Helper.getAssetIconName('ico_user.png')),
        title: Text(
          'Full Name',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF323B4B),
            fontWeight: FontWeight.w400,
            height: 16 / 14,
          ).copyWith(
            fontSize: 14,
            height: 12 / 10,
          ),
        ),
        subtitle: Text(
          name,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF323B4B),
            fontWeight: FontWeight.w400,
            height: 16 / 14,
          ),
        ),
      ),
    );
  }

  Widget _textPhone(String phone) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      // borderRadius: BorderRadius.circular(5),
      // ),
      child: ListTile(
        leading:
            ImageHelper.loadFromAsset(Helper.getAssetIconName('ico_phone.png')),
        title: Text(
          'Phone',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF323B4B),
            fontWeight: FontWeight.w400,
            height: 16 / 14,
          ).copyWith(
            fontSize: 14,
            height: 12 / 10,
          ),
        ),
        subtitle: Text(
          phone,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF323B4B),
            fontWeight: FontWeight.w400,
            height: 16 / 14,
          ),
        ),
      ),
    );
  }
}
