import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanyapakar/Screens/admin/admin_bb_app.dart';
import 'package:tanyapakar/Screens/admin/admin_kategori.dart';
import 'package:tanyapakar/Screens/admin/admin_kategori_non_aktif.dart';
import 'package:tanyapakar/Screens/admin/admin_klasifikasi_aktif.dart';
import 'package:tanyapakar/Screens/admin/admin_klasifikasi_non_aktif.dart';
import 'package:tanyapakar/Screens/admin/admin_pengguna.dart';
import 'package:tanyapakar/Screens/admin/admin_pengguna_non_aktif.dart';
import 'package:tanyapakar/Screens/login/login.dart';

class HomeAdminScreen extends StatefulWidget {
  const HomeAdminScreen({Key? key}) : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<HomeAdminScreen> {
  int _selectedIndex = 0;

  Future<void> keluar() async {
    SharedPreferences sesLogin = await SharedPreferences.getInstance();
    await sesLogin.clear();
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.routeName, (route) => false);
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return const Center(child: Text("Selamat Datang di Tanya Pakar"));
      case 1:
        return const AdminKategoriScreen();
      case 2:
        return const AdminPengguna();
      case 3:
        return const AdminBBApp();
      case 4:
        return const AdminPenggunaNonAktif();
      case 5:
        return const AdminKlasifikasiAktif();
      case 6:
        return const AdminKlasifikasiNonAktif();
      case 7:
        return const AdminKategoriNonAktif();
      default:
        return const Text("Error Navigation");
    }
  }

  _onSelectItem(int index) {
    setState(() {
      Navigator.of(context).pop();
      _selectedIndex = index;
    });
  }

  Widget _drawerHeader() {
    return const UserAccountsDrawerHeader(
      currentAccountPicture: ClipOval(
        child: Image(
            image: AssetImage('assets/images/place_holder.png'),
            fit: BoxFit.cover),
      ),
      accountName: Text('Admin'),
      accountEmail: Text('admin@gmail.com'),
    );
  }

  Widget _drawerItem(
      {IconData? icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tanya Pakar"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _drawerHeader(),
            _drawerItem(
              icon: Icons.home_outlined,
              text: 'Beranda',
              onTap: () => _onSelectItem(0),
            ),
            _drawerItem(
              icon: Icons.folder_open,
              text: 'Kategori Aktif',
              onTap: () => _onSelectItem(1),
            ),
            _drawerItem(
              icon: Icons.folder_off_outlined,
              text: 'Kategori Non Aktif',
              onTap: () => _onSelectItem(7),
            ),
            _drawerItem(
              icon: Icons.catching_pokemon_outlined,
              text: 'Klasifikasi Non Aktif',
              onTap: () => _onSelectItem(6),
            ),
            _drawerItem(
              icon: Icons.group_off_outlined,
              text: 'Pengguna Non Aktif',
              onTap: () => _onSelectItem(4),
            ),
            _drawerItem(
              icon: Icons.group_outlined,
              text: 'Pengguna Aktif',
              onTap: () => _onSelectItem(2),
            ),
            _drawerItem(
              icon: Icons.access_time,
              text: 'Persetujuan Bukti Bayar',
              onTap: () => _onSelectItem(3),
            ),
            const Divider(height: 25, thickness: 1),
            const Padding(
              padding: EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
              child: Text("Settings",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  )),
            ),
            _drawerItem(
              icon: Icons.bookmark_outline,
              text: 'Account',
              onTap: () => debugPrint('Tap Family menu'),
            ),
            _drawerItem(
              icon: Icons.power_settings_new,
              text: 'Log Out',
              onTap: () => keluar(),
            ),
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedIndex),
    );
  }
}
