import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanyapakar/Screens/login/login.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/icon_creation.dart';
import 'package:tanyapakar/components/rounded_button.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:tanyapakar/utils/fungsi.dart';

class MemberHomeFragment extends StatefulWidget {
  final Pengguna pengguna;
  const MemberHomeFragment({Key? key, required this.pengguna})
      : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<MemberHomeFragment> {
  final ApiUtils apiUtils = ApiUtils();

  CroppedFile? _imgKlasifikasi;

  TextEditingController nama = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController? tempatLahir = TextEditingController();
  TextEditingController? lahirTanggal = TextEditingController();
  TextEditingController? hp = TextEditingController();
  Future? nextFuture;

  @override
  void initState() {
    super.initState();
    nextFuture = apiUtils.getPengguna(idPengguna: widget.pengguna.idPengguna!);
  }

  Future<void> keluar(BuildContext context) async {
    SharedPreferences sesLogin;
    sesLogin = await SharedPreferences.getInstance();
    await sesLogin.clear();
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.routeName, (route) => false);
  }

  void upadateData() async {
    FormData formData;
    MultipartFile? cover;

    if (_imgKlasifikasi?.path != null) {
      cover = await MultipartFile.fromFile(_imgKlasifikasi!.path,
          filename: _imgKlasifikasi!.path.split('/').last);
    }

    formData = FormData.fromMap({
      "idPengguna": widget.pengguna.idPengguna,
      "imgAvatar": cover,
      "nama": nama.text,
      "email": email.text,
      "tempatLahir": tempatLahir?.text,
      "lahirTanggal": lahirTanggal?.text,
      "hp": hp?.text,
      "state": 2,
    });

    try {
      ArtDialogResponse artDialogResponse = await ArtSweetAlert.show(
          barrierDismissible: false,
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.question,
            confirmButtonText: "Sudah!",
            denyButtonText: "Belum",
            text: "Apakah data sudah Benar?",
            title: "Simpan Data",
          ));

      if (artDialogResponse.isTapConfirmButton) {
        Response response = await apiUtils
            .getDataService()
            .post("pakar/daftarMember", data: formData);
        if (response.statusCode == 200) {
          if (response.data["error"] == 2) {
            ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.danger,
                text: response.data["msgErr"],
              ),
            );
          } else {
            if (_imgKlasifikasi?.path != null) {
              ArtDialogResponse rsp = await ArtSweetAlert.show(
                context: context,
                barrierDismissible: false,
                artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success,
                  text: response.data["msgErr"],
                  confirmButtonText: 'Ok!',
                ),
              );

              if (rsp.isTapConfirmButton) {
                keluar(context);
              }
            } else {
              ArtSweetAlert.show(
                context: context,
                artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success,
                  text: response.data["msgErr"],
                ),
              );
            }
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> tglGanti({required String slug}) async {
    Future.delayed(const Duration(seconds: 1), () => lahirTanggal?.text = slug);
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    Size _size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Pilih Sumber",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(height: _size.height * 0.05),
              Row(
                children: [
                  IconCreation(
                      tap: () {
                        Navigator.pop(context);
                        FungsiPakar()
                            .getImage(ImageSource.camera)
                            .then((value) {
                          setState(() {
                            _imgKlasifikasi = value;
                          });
                        });
                      },
                      icons: Icons.camera_alt,
                      color: Colors.pink,
                      text: "Camera"),
                  const SizedBox(
                    width: 40,
                  ),
                  IconCreation(
                      tap: () {
                        Navigator.pop(context);
                        FungsiPakar()
                            .getImage(ImageSource.gallery)
                            .then((value) {
                          setState(() {
                            _imgKlasifikasi = value;
                          });
                        });
                      },
                      icons: Icons.image,
                      color: Colors.purple,
                      text: "Gallery"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: size.height * 0.2),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: const Text(
            "DATA DIRI",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2661FA),
                fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: nextFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var _pengguna = (snapshot.data as List<Pengguna>)[0];

                nama.text = _pengguna.namaPengguna!;
                email.text = _pengguna.email!;
                tempatLahir?.text =
                    _pengguna.tempatLahir == null ? "" : _pengguna.tempatLahir!;
                hp?.text = _pengguna.hp == null ? "" : _pengguna.hp!;
                lahirTanggal?.text = _pengguna.lahirTanggal == null
                    ? ""
                    : _pengguna.lahirTanggal!;

                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: size.height * 0.03),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: const Text(
                          "Gambar Avatar",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: CircleAvatar(
                            radius: 40.0,
                            backgroundImage: _imgKlasifikasi?.path == null
                                ? NetworkImage(_pengguna.avatarPengguna!)
                                : FileImage(File(_imgKlasifikasi!.path))
                                    as ImageProvider,
                            backgroundColor: Colors.transparent,
                            child: GestureDetector(
                              onTap: () {
                                _showBottomSheet(context);
                              },
                              child: const Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  backgroundColor: Colors.green,
                                  radius: 20,
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextField(
                          controller: nama,
                          decoration: const InputDecoration(labelText: "Nama"),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextField(
                          controller: email,
                          decoration: const InputDecoration(labelText: "Email"),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Row(
                        children: [
                          Container(
                            width: size.width * 0.4,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 40),
                            child: TextField(
                              controller: tempatLahir,
                              decoration: const InputDecoration(
                                labelText: "Tempat Lahir",
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: size.width * 0.25,
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: TextField(
                                controller: lahirTanggal,
                                onTap: () async {
                                  var datePicked =
                                      await DatePicker.showSimpleDatePicker(
                                    context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1954),
                                    lastDate: DateTime.now(),
                                    dateFormat: "dd-MMMM-yyyy",
                                    locale: DateTimePickerLocale.id,
                                    looping: false,
                                  );

                                  if (datePicked != null) {
                                    String dateSlug =
                                        "${datePicked.day.toString().padLeft(2, '0')}-${datePicked.month.toString().padLeft(2, '0')}-${datePicked.year.toString()}";

                                    tglGanti(slug: dateSlug);
                                  }
                                },
                                decoration: const InputDecoration(
                                  labelText: "Tanggal Lahir",
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        child: TextField(
                          controller: hp,
                          decoration: const InputDecoration(labelText: "HP"),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: RoundedButton(
                          sizeWidth: 0.3,
                          borderRadius: BorderRadius.circular(29),
                          icon: Icons.save,
                          text: "Update",
                          press: () {
                            upadateData();
                          },
                          color: kPrimaryColor,
                          color2: kOrange,
                          textColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        )
      ],
    );
  }
}
