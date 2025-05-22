import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:x_clone_app/components/bottom_naN_bar.dart';
import 'package:x_clone_app/provider/user_provider.dart';
import 'package:x_clone_app/utils/Snackbar/snackbar.dart';
import 'package:x_clone_app/utils/dialoag/confirmation_dialog.dart';

class blockeduserScreen extends StatefulWidget {
  const blockeduserScreen({super.key});

  @override
  State<blockeduserScreen> createState() => _blockeduserScreenState();
}

class _blockeduserScreenState extends State<blockeduserScreen> {
  late final provider = Provider.of<Userprovider>(context);
  late final databaseProvider = Provider.of<Userprovider>(
    context,
    listen: false,
  );

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    await databaseProvider.loadBlockUserID();
  }

  @override
  Widget build(BuildContext context) {
    final blockuser = provider.blockUser;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.offAll(() => BottomNavBar()),
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(
          'Block User',
          style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w700),
        ),
      ),
      body: blockuser.isEmpty
          ? Center(child: Text('No Block User...'))
          : ListView.builder(
              itemCount: blockuser.length,
              itemBuilder: (context, index) {
                var user = blockuser[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text('@ ${user.userName}'),
                  trailing: IconButton(
                    onPressed: () => AppDialog().showConfirmationDialod(
                      'Are You Sure',
                      'Are you sure to unbloack the user',
                      'Unblock ',
                      'cancel',
                      context,
                      () async{
                         databaseProvider.unblockUserfromFirebase(user.uid);
                         Navigator.pop(context);
                      },
                      () => Navigator.pop(context),
                    ),
                    icon: Icon(Icons.more_horiz),
                  ),
                );
              },
            ),
    );
  }
}
