import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanyapakar/Screens/login/login.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/components/rounded_button.dart';
import 'package:tanyapakar/components/text_field_pakar.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';

class GantiPassword extends StatefulWidget {
  final Pengguna pengguna;
  const GantiPassword({Key? key, required this.pengguna}) : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<GantiPassword> {
  final ApiUtils apiUtils = ApiUtils();

  TextEditingController ctrlPwdLama = TextEditingController();
  TextEditingController ctrlPwdBaru = TextEditingController();
  TextEditingController ctrlKonfirmasiPwdBaru = TextEditingController();

  Future<void> keluar() async {
    SharedPreferences sesLogin;
    sesLogin = await SharedPreferences.getInstance();
    await sesLogin.clear();
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  Future<void> simpanData() async {
    ArtDialogResponse artDialogResponse = await ArtSweetAlert.show(
        barrierDismissible: false,
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.question,
          confirmButtonText: "Sudah!",
          denyButtonText: "Belum",
          text: "Apakah data sudah Benar?",
          title: "Ganti Password",
        ));

    if (artDialogResponse.isTapConfirmButton) {
      try {
        FormData formData = FormData.fromMap({
          "idPengguna": widget.pengguna.idPengguna,
          "pwdLama": ctrlPwdLama.text,
          "pwdBaru": ctrlPwdBaru.text,
          "pwdBaruKonfirmasi": ctrlKonfirmasiPwdBaru.text,
        });

        Response response = await apiUtils
            .getDataService()
            .post("pakar/updatePwd", data: formData);

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
            ArtDialogResponse rsp = await ArtSweetAlert.show(
              context: context,
              barrierDismissible: false,
              artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success,
                text: response.data["msgErr"],
              ),
            );

            if (rsp.isTapConfirmButton) {
              keluar();
            }
          }
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
        child: Column(
          children: [
            SizedBox(height: size.height * 0.22),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Ganti Password',
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: size.height * .03),
                    TextFieldPakar(
                      controller: ctrlPwdLama,
                      label: "Password Lama",
                      isPwd: true,
                    ),
                    SizedBox(height: size.height * 0.03),
                    TextFieldPakar(
                      controller: ctrlPwdBaru,
                      label: "Password Baru",
                      isPwd: true,
                    ),
                    SizedBox(height: size.height * 0.03),
                    TextFieldPakar(
                      controller: ctrlKonfirmasiPwdBaru,
                      label: "Konfirmasi Password Baru",
                      isPwd: true,
                    ),
                    SizedBox(height: size.height * 0.05),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: RoundedButton(
                          sizeWidth: 0.4,
                          borderRadius: BorderRadius.circular(29),
                          icon: Icons.save,
                          text: "Simpan",
                          press: () {
                            simpanData();
                          },
                          color: kPrimaryColor,
                          color2: kOrange,
                          textColor: colorWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
