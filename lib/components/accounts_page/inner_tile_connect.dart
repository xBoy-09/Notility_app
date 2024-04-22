import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notility/server/auth_service.dart';

final User user = FirebaseAuth.instance.currentUser!;
List<UserInfo> providerData = user.providerData;
List<String> providers =
    providerData.map((providerData) => providerData.providerId).toList();

Map<String, String> providersList = {
  'Google' : 'google.com',
  'Facebook' : 'facebook.com',
  'Phone' : 'phone',
};

Map<String, String> imageList = {
  'Google' : 'assets/images/google.png',
  'Facebook' : 'assets/images/facebook.png',
  'Phone' : 'assets/images/phone.png',
};

class InnerTileConnect extends StatefulWidget {
  const InnerTileConnect({super.key, required this.heading, required this.onTap});

  final String heading;
  final VoidCallback onTap;

  @override
  State<InnerTileConnect> createState() => _InnerTileConnectState();
}

class _InnerTileConnectState extends State<InnerTileConnect> {
  late bool isConnected;

  @override
  void initState() {
    super.initState();
    // Initialize isConnected based on whether the user is connected to the provider
    isConnected = FirebaseAuth.instance.currentUser!.providerData
        .any((info) => info.providerId == providersList[widget.heading]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 9,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.heading,
                  style: GoogleFonts.inter(
                    fontSize: 16.5,
                    color: Colors.grey[500],
                  ),
                ),
                Text(
                  isConnected
                      ? widget.heading == 'Phone'
                          ? 'You are connected to your phone number'
                          : 'You are connected to ${widget.heading}'
                      : widget.heading == 'Phone'
                          ? 'Connect to your Phone number'
                          : 'Connect to your ${widget.heading}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: isConnected
                        ? Colors.green[700]
                        : Colors.grey[600],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: isConnected
                  ? InkWell(
                      onTap: () {
                        AuthServoce().unlinkGoogle();
                        // Set state to refresh the UI after unlinking
                        setState(() {
                          isConnected = false;
                        });
                      },
                      child: Text(
                        'Unlink',
                        style: TextStyle(
                          color: Colors.red, // Change color as needed
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[600],
                      size: 20,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}