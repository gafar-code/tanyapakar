import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanyapakar/Screens/login/login.dart';
import 'package:tanyapakar/Screens/profile/ganti_pwd.dart';
import 'package:tanyapakar/Screens/profile/tutup_akun.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/rounded_button.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';

class MemberAkunFragment extends StatefulWidget {
  final Pengguna pengguna;
  const MemberAkunFragment({Key? key, required this.pengguna})
      : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<MemberAkunFragment> {
  final ApiUtils apiUtils = ApiUtils();
  late SharedPreferences sesLogin;

  @override
  void initState() {
    super.initState();
  }

  Future<void> keluar() async {
    sesLogin = await SharedPreferences.getInstance();
    await sesLogin.clear();

    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: size.height * 0.2),
        Container(
          alignment: Alignment.center,
          child: const Text(
            "Profile Picture",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        FutureBuilder(
          future: apiUtils.getPengguna(idPengguna: widget.pengguna.idPengguna!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var _pengguna = (snapshot.data as List<Pengguna>)[0];
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: CircleAvatar(
                  radius: 40.0,
                  backgroundImage: NetworkImage(_pengguna.avatarPengguna!),
                  backgroundColor: Colors.transparent,
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        SizedBox(height: size.height * 0.05),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    radius: 15,
                    child: Icon(Icons.password_outlined),
                  ),
                  title: const Text(
                    "Ganti Password",
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GantiPassword(pengguna: widget.pengguna),
                        ),
                      );
                    },
                    icon: const Icon(Icons.navigate_next),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    child: Icon(Icons.no_accounts_outlined),
                  ),
                  title: const Text(
                    "Tutup Akun",
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TutupAkun(pengguna: widget.pengguna),
                        ),
                      );
                    },
                    icon: const Icon(Icons.navigate_next),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.1),
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: RoundedButton(
                  sizeWidth: 0.27,
                  borderRadius: BorderRadius.circular(29),
                  icon: Icons.power_settings_new_rounded,
                  text: "Keluar",
                  press: () {
                    keluar();
                  },
                  color: Colors.red,
                  color2: Colors.red,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
