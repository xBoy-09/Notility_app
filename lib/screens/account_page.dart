import 'package:flutter/material.dart';
import 'package:notility/components/accounts_page/inner_tile.dart';
import 'package:notility/components/accounts_page/option_section_account.dart';
import 'package:notility/components/accounts_page/option_section_connect.dart';
import 'package:notility/components/accounts_page/option_section_verify_email.dart';
import 'package:notility/components/accounts_page/picture_icon.dart';
import 'package:notility/components/accounts_page/user_info.dart';
import 'package:notility/components/accounts_tab/button.dart';
import 'package:notility/components/main_page/drop_down_main_button.dart';
import 'package:notility/components/main_page/main_menu_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notility/components/account_functions/update_email.dart';
import 'package:notility/components/account_functions/update_password.dart';
import 'package:notility/components/account_functions/update_user.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => AccountScreenState();

  // static AccountScreenState? of(BuildContext context) =>
  //     context.findAncestorStateOfType<AccountScreenState>();

  static void resetScreen(BuildContext context) {
    final AccountScreenState? state = context.findAncestorStateOfType<AccountScreenState>();
    if (state != null) {
      state.resetScreen();
    }
  }
}

class AccountScreenState extends State<AccountScreen> {
  final User user = FirebaseAuth.instance.currentUser!;

  void onProfilePictureEditTap() {}

  void resetScreen() {
    print('Calling reset screen');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const SizedBox(height: 36),
                ProfileIcon(onTap: onProfilePictureEditTap),
                const SizedBox(height: 24),
                UserInfoProfile(),
                const SizedBox(height: 24),
                OptoinSectionAccount(
                  heading: 'Account',
                ),
                const SizedBox(height: 24),
                OptoinSectionVerifyEmail(),
                const SizedBox(height: 24),
                const OptoinSectionConnect(),

                const SizedBox(height: 54,),
              ],
            ),
          ),
      ),
    );

  //   return Scaffold(
  //     backgroundColor: Theme.of(context).colorScheme.background,
  //     appBar: AppBar(
  //       scrolledUnderElevation: 0,
  //       toolbarHeight: 64,
  //       automaticallyImplyLeading: false,
  //       backgroundColor: Theme.of(context).colorScheme.background,
  //       title: MainMenuAppBar(),
  //       actions: const [DropDownMain()],
  //     ),
  //     body: SingleChildScrollView(
  //       // scrollable screen
  //       child: Container(
  //         margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
  //         child: Padding(
  //           padding: const EdgeInsets.all(6.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 // title text
  //                 'Your Account',
  //                 style: TextStyle(
  //                   fontFamily: 'Amiko',
  //                   fontWeight: FontWeight.bold,
  //                   fontSize: 20.2,
  //                   color: Colors.grey[600],
  //                 ),
  //               ),
  //               Divider(
  //                 // line
  //                 height: 1,
  //                 color: Colors.grey[600],
  //               ),
  //               const SizedBox(height: 30),
  //               Text(
  //                 'Change your Display Name',
  //                 style: TextStyle(
  //                   fontFamily: 'Amiko',
  //                   fontSize: 17.5,
  //                   color: Colors.grey[600],
  //                 ),
  //               ),
  //               const SizedBox(height: 14),
  //               PillButton(
  //                 // button for updating username
  //                 text: "Update Username",
  //                 onPressed: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(builder: (context) => UpdateUser()),
  //                   );
  //                 },
  //               ),
  //               const SizedBox(height: 44),
  //               Text(
  //                 'Change your Email',
  //                 style: TextStyle(
  //                   fontFamily: 'Amiko',
  //                   fontSize: 17.5,
  //                   color: Colors.grey[600],
  //                 ),
  //               ),
  //               const SizedBox(height: 14),
  //               PillButton(
  //                   text: "Update Email",
  //                   onPressed: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(builder: (context) => UpdateEmail()),
  //                     );
  //                   }), // update email
  //               const SizedBox(height: 44),
  //               Text(
  //                 'Change your Password',
  //                 style: TextStyle(
  //                   fontFamily: 'Amiko',
  //                   fontSize: 17.5,
  //                   color: Colors.grey[600],
  //                 ),
  //               ),
  //               const SizedBox(height: 14),
  //               PillButton(
  //                   text: "Update Password",
  //                   onPressed: () {
  //                     Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                           builder: (context) => const UpdatePassword()),
  //                     );
  //                   }), // update password
  //               const SizedBox(height: 44),
  //               Text(
  //                 'Change your Profile Photo',
  //                 style: TextStyle(
  //                   fontFamily: 'Amiko',
  //                   fontSize: 17.5,
  //                   color: Colors.grey[600],
  //                 ),
  //               ),
  //               const SizedBox(height: 14),
  //               PillButton(
  //                   text: "Update Photo", onPressed: () {}), // update photo
  //               const SizedBox(height: 44),
  //               Text(
  //                 'Change App Theme',
  //                 style: TextStyle(
  //                   fontFamily: 'Amiko',
  //                   fontSize: 17.5,
  //                   color: Colors.grey[600],
  //                 ),
  //               ),
  //               const SizedBox(height: 14),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  }
}
