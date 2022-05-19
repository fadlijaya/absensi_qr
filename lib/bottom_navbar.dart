import 'package:absensi/page/list_absensi_page.dart';
import 'package:flutter/material.dart';

import 'page/qr_create_page.dart';
import 'page/qr_scan_page.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({Key? key}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  @override
  Widget build(BuildContext context) {
    return const CategoryPage();
  }
}

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final GlobalKey _bottomNavigationKey = GlobalKey();

  final List<Widget> listPage = [
    const QRCreatePage(),
    const QRScanPage(),
    const ListAbsensiPage()
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listPage.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          key: _bottomNavigationKey,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.qr_code,
                size: 24,
              ),
              label: "Absensi QR",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.qr_code_scanner,
                size: 24,
              ),
              label: "QR Scan",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.document_scanner,
                size: 24,
              ),
              label: "Document",
            ),
          ],
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black38,
          selectedLabelStyle: const TextStyle(fontSize: 12),
          currentIndex: _selectedIndex,
          onTap: onItemTap),
    );
  }

  void onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
