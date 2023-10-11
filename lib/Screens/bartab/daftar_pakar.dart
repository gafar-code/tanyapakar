import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/icon_creation.dart';
import 'package:tanyapakar/components/rounded_button.dart';
import 'package:tanyapakar/components/text_field_pakar.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/utils/fungsi.dart';

class DaftarPakarScreen extends StatefulWidget {
  const DaftarPakarScreen({Key? key}) : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<DaftarPakarScreen> {
  final ApiUtils apiUtils = ApiUtils();

  CroppedFile? _imgKlasifikasi;
  bool? setuju = false;

  TextEditingController nickName = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController tempatLahir = TextEditingController();
  TextEditingController lahirTanggal = TextEditingController();
  TextEditingController hp = TextEditingController();
  TextEditingController nikSim = TextEditingController();
  TextEditingController bank = TextEditingController();
  TextEditingController noRek = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController repwd = TextEditingController();
  TextEditingController kodeRef = TextEditingController();

  void simpanData() async {
    FormData formData;

    if (_imgKlasifikasi?.path == null) {
      formData = FormData.fromMap({
        "nickName": nickName.text,
        "nama": nama.text,
        "email": email.text,
        "tempatLahir": tempatLahir.text,
        "lahirTanggal": lahirTanggal.text,
        "hp": hp.text,
        "nikSim": nikSim.text,
        "bank": bank.text,
        "noRek": noRek.text,
        "jenisPengguna": 1,
        "pwd": pwd.text,
        "repwd": repwd.text,
        "state": 1,
        "setuju": setuju,
        "kodeRef": kodeRef.text,
      });
    } else {
      formData = FormData.fromMap({
        "imgAvatar": await MultipartFile.fromFile(_imgKlasifikasi!.path,
            filename: _imgKlasifikasi!.path.split("/").last),
        "nickName": nickName.text,
        "nama": nama.text,
        "email": email.text,
        "tempatLahir": tempatLahir.text,
        "lahirTanggal": lahirTanggal.text,
        "hp": hp.text,
        "nikSim": nikSim.text,
        "bank": bank.text,
        "noRek": noRek.text,
        "jenisPengguna": 1,
        "pwd": pwd.text,
        "repwd": repwd.text,
        "state": 1,
        "setuju": setuju,
        "kodeRef": kodeRef.text,
      });
    }

    ArtDialogResponse artDialogResponse = await ArtSweetAlert.show(
      barrierDismissible: false,
      context: context,
      artDialogArgs: ArtDialogArgs(
        type: ArtSweetAlertType.question,
        confirmButtonText: "Sudah!",
        denyButtonText: "Belum",
        text: "Apakah data sudah Benar?",
        title: "Simpan Data",
      ),
    );

    if (artDialogResponse.isTapConfirmButton) {
      try {
        Response response = await apiUtils
            .getDataService()
            .post("pakar/daftarPakar", data: formData);

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
            Navigator.pop(context);
            ArtSweetAlert.show(
              context: context,
              artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success,
                text: response.data["msgErr"],
              ),
            );
          }
        } else {
          debugPrint("Gagal Simpan Data");
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
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
                  style: TextStyle(fontSize: 20),
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
                  const SizedBox(width: 40),
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

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage: _imgKlasifikasi?.path == null
                          ? const AssetImage("assets/images/place_holder.png")
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
                  SizedBox(height: size.height * 0.03),
                  TextFieldPakar(controller: nickName, label: "Nick Name"),
                  SizedBox(height: size.height * 0.03),
                  const Text(
                    "DATA DIRI",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2661FA),
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.03),
                  TextFieldPakar(controller: nama, label: "Nama"),
                  SizedBox(height: size.height * 0.03),
                  TextFieldPakar(controller: email, label: "Email/WA"),
                  SizedBox(height: size.height * 0.03),
                  Row(
                    children: [
                      Container(
                        width: size.width * 0.4,
                        margin: const EdgeInsets.only(left: 20),
                        child: TextField(
                          controller: tempatLahir,
                          decoration: InputDecoration(
                            labelText: "Tempat Lahir",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding:
                                const EdgeInsets.fromLTRB(28, 20, 12, 12),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide:
                                  const BorderSide(color: kPrimaryColor),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide:
                                  const BorderSide(color: kPrimaryLightColor),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: size.width * 0.6,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
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

                              setState(() {
                                if (datePicked != null) {
                                  String dateSlug =
                                      "${datePicked.day.toString().padLeft(2, '0')}-${datePicked.month.toString().padLeft(2, '0')}-${datePicked.year.toString()}";

                                  lahirTanggal.text = dateSlug;
                                }
                              });
                            },
                            decoration: InputDecoration(
                              labelText: "Tgl. Lahir",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(28, 20, 12, 12),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide:
                                    const BorderSide(color: kPrimaryColor),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide:
                                    const BorderSide(color: kPrimaryLightColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
                  TextFieldPakar(controller: hp, label: "HP"),
                  SizedBox(height: size.height * 0.03),
                  TextFieldPakar(controller: nikSim, label: "NIK/SIM"),
                  SizedBox(height: size.height * 0.03),
                  Row(
                    children: [
                      Container(
                        width: size.width * 0.4,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: TextField(
                          controller: bank,
                          decoration: InputDecoration(
                            labelText: "Bank",
                            contentPadding:
                                const EdgeInsets.fromLTRB(28, 20, 12, 12),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide:
                                  const BorderSide(color: kPrimaryColor),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide:
                                  const BorderSide(color: kPrimaryLightColor),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: size.width * 0.6,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          child: TextField(
                            controller: noRek,
                            decoration: InputDecoration(
                              labelText: "No. Rek",
                              contentPadding:
                                  const EdgeInsets.fromLTRB(28, 20, 12, 12),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide:
                                    const BorderSide(color: kPrimaryColor),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide:
                                    const BorderSide(color: kPrimaryLightColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
                  TextFieldPakar(controller: kodeRef, label: "Kode Reffreal"),
                  SizedBox(height: size.height * 0.03),
                  TextFieldPakar(
                      controller: pwd, label: "Password", isPwd: true),
                  SizedBox(height: size.height * 0.03),
                  TextFieldPakar(
                      controller: repwd,
                      label: "Konfirmasi Password",
                      isPwd: true),
                  SizedBox(height: size.height * 0.03),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 20, right: 10),
                        child: Checkbox(
                          value: setuju,
                          onChanged: (bool? value) {
                            setState(() {
                              setuju = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                          child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: const Text(
                            "Setuju atas peraturan yang berlaku. Yang mungkin ada perubahan sewaktu-waktu"),
                      ))
                    ],
                  ),
                  SizedBox(height: size.height * 0.03),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: RoundedButton(
                      sizeWidth: 0.4,
                      borderRadius: BorderRadius.circular(29),
                      icon: Icons.save,
                      text: "Daftar",
                      press: () {
                        simpanData();
                      },
                      color: kPrimaryColor,
                      color2: kOrange,
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
