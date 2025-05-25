import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class followersRow extends StatelessWidget {
  final int postCount,followerCount,followingCount;
   Function()? onTap;
   followersRow({
    super.key, required this.postCount, required this.followerCount, required this.followingCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector
      (
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                 postCount.toString(),
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                ),
                  ),
                Text(
                  'Posts',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  followerCount.toString(),
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Followers',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                followingCount.toString(),
                  style: GoogleFonts.roboto(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Following',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
