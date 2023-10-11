import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanyapakar/Screens/login/login.dart';
import 'package:tanyapakar/Screens/profile/ganti_pwd.dart';
import 'package:tanyapakar/Screens/profile/kode_reff.dart';
import 'package:tanyapakar/Screens/profile/tutup_akun.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/rounded_button.dart';

import 'package:tanyapakar/model/pengguna/pengguna_model.dart';

class PakarAkunFragment extends StatefulWidget {
  final Pengguna pengguna;
  const PakarAkunFragment({Key? key, required this.pengguna}) : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<PakarAkunFragment> {
  final ApiUtils apiUtils = ApiUtils();
  late SharedPreferences sesLogin;
  Future? nextFuture;

  @override
  void initState() {
    super.initState();
    nextFuture = apiUtils.getPengguna(idPengguna: widget.pengguna.idPengguna!);
  }

  Future<void> keluar() async {
    FormData formData =
        FormData.fromMap({"idPengguna": widget.pengguna.idPengguna!});

    Response response =
        await apiUtils.getDataService().post("pakar/logout", data: formData);
    if (response.statusCode == 200) {
      if (response.data["error"] == 2) {
        ArtSweetAlert.show(
          context: context,
          barrierDismissible: false,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.danger,
            text: response.data["msgErr"],
          ),
        );
      } else {
        sesLogin = await SharedPreferences.getInstance();
        await sesLogin.clear();
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.routeName, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      children: [
        SizedBox(height: size.height * 0.15),
        Container(
          alignment: Alignment.center,
          child: const Text(
            "Profile Picture",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        FutureBuilder(
          future: nextFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var _pengguna = (snapshot.data as List<Pengguna>)[0];
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: CircleAvatar(
                  radius: 50.0,
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
        Row(
          children: [
            Expanded(
              child: Column(children: [
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
                      radius: 20,
                      child: Icon(Icons.password_outlined),
                    ),
                    title: const Text("Ganti Password"),
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
                      radius: 20,
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      child: Icon(Icons.supervisor_account_outlined),
                    ),
                    title: const Text("Kode Reffreal"),
                    trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const KodeReff(),
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
                      radius: 20,
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      child: Icon(Icons.no_accounts_outlined),
                    ),
                    title: const Text("Tutup Akun"),
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
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  child: RoundedButton(
                    sizeWidth: 0.4,
                    borderRadius: BorderRadius.circular(29),
                    icon: Icons.power_settings_new,
                    text: "Keluar",
                    press: () {
                      keluar();
                    },
                    color: Colors.red,
                    color2: Colors.red,
                    textColor: Colors.white,
                  ),
                ),
              ]),
            ),
          ],
        ),
      ],
    );
  }
}
