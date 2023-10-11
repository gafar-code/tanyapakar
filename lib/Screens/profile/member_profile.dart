import 'package:flutter/material.dart';
import 'package:tanyapakar/Screens/profile/member_akun.dart';
import 'package:tanyapakar/Screens/profile/member_home.dart';
import 'package:tanyapakar/Screens/profile/member_saldo.dart';
import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';

class MemberProfileScreen extends StatefulWidget {
  final Pengguna pengguna;
  const MemberProfileScreen({Key? key, required this.pengguna})
      : super(key: key);

  @override
  _WidgetScreen createState() => _WidgetScreen();
}

class _WidgetScreen extends State<MemberProfileScreen> {
  late List<Widget> widgetOptions;

  int _selectedNavbar = 0;

  @override
  void initState() {
    super.initState();
    widgetOptions = [
      MemberHomeFragment(pengguna: widget.pengguna),
      MemberSaldoFragment(pengguna: widget.pengguna),
      MemberAkunFragment(pengguna: widget.pengguna),
    ];
  }

  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: kPrimaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        elevation: 0,
      ),
      body: Background(
        child: widgetOptions.elementAt(_selectedNavbar),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kPrimaryLightColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on_outlined),
            label: "Bayar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.policy_outlined),
            label: "Akun",
          ),
        ],
        currentIndex: _selectedNavbar,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: _changeSelectedNavBar,
      ),
    );
  }
}
