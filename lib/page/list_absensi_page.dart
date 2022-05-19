import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListAbsensiPage extends StatefulWidget {
  const ListAbsensiPage({Key? key}) : super(key: key);

  @override
  State<ListAbsensiPage> createState() => _ListAbsensiPageState();
}

class _ListAbsensiPageState extends State<ListAbsensiPage> {
  final Stream<QuerySnapshot> _streamAbsensi =
      FirebaseFirestore.instance.collection("absensi").snapshots();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("List Absensi"),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.all(16),
        child: StreamBuilder(
            stream: _streamAbsensi,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text("Errror!"),
                );
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("Belum Ada Data!"),
                );
              }

              var document = snapshot.data!.docs;

              return ListView.builder(
                  itemCount: document.length,
                  itemBuilder: (context, i) {
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        height: 100,
                        child: ListTile(
                          leading: const Icon(
                            Icons.account_circle_rounded,
                            size: 40,
                          ),
                          title: Text("${document[i]['nip']}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${document[i]['status']}"),
                              const SizedBox(height: 8,),
                              Text("${document[i]['waktu']}"),
                              const SizedBox(height: 8,),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
