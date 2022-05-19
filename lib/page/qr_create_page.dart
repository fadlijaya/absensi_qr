import 'package:absensi/page/login_page.dart';
import 'package:absensi/page/qr_scan_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../service/auth_service.dart';

class QRCreatePage extends StatefulWidget {
  const QRCreatePage({
    Key? key,
  }) : super(key: key);

  @override
  State<QRCreatePage> createState() => _QRCreatePageState();
}

class _QRCreatePageState extends State<QRCreatePage> {
  String? nip;
  String? fullName;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future getUser() async {
    await FirebaseFirestore.instance
        .collection('absensi')
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        setState(() {
          nip = result.docs[0].data()['nip'];
          fullName = result.docs[0].data()['nama lengkap'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Absensi QR"),
        actions: [
          IconButton(
              padding: const EdgeInsets.only(right: 16),
              onPressed: logOut,
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$fullName",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 40,),
            Text("$nip"),
            QrImage(
              data: nip.toString(),
              version: QrVersions.auto,
              size: 240,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logOut() async {
    await context.read<AuthService>().signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
  }
}
