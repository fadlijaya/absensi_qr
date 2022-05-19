import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({Key? key}) : super(key: key);

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  String? nip;
  String? dateTimeAbsen;
  String status = "Hadir";

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

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
        });
      }
    });
  }

  updateDataAbsen() async {
    DocumentReference docRefUsers =
        FirebaseFirestore.instance.collection('absensi').doc(FirebaseAuth.instance.currentUser!.uid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot task = await transaction.get(docRefUsers);
      if (task.exists) {
        // ignore: await_only_futures
        await transaction.update(
          docRefUsers,
          <String, dynamic>{
            'nip': nip.toString(),
            'uid': FirebaseAuth.instance.currentUser!.uid,
            'waktu': dateTimeAbsen.toString(),
            'status': status
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime dtNow = DateTime.now();
    dateTimeAbsen = DateFormat('dd/MM/yyyy hh:mm').format(dtNow);

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                  borderColor: Theme.of(context).primaryColor,
                  borderRadius: 10,
                  borderLength: 20,
                  borderWidth: 10,
                  cutOutSize: MediaQuery.of(context).size.width * 0.8),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Column(
                    children: [
                      Text('Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}'),
                      IconButton(onPressed: updateDataAbsen, icon: const Icon(Icons.done))
                    ],
                  )
                  : const Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }
}
