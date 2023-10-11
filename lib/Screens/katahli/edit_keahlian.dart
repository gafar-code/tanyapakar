import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/components/icon_creation.dart';
import 'package:tanyapakar/components/rounded_button.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/klasifikasi/klasifikasi_model.dart';
import 'package:tanyapakar/utils/fungsi.dart';

class EditKeahlianScreen extends StatefulWidget {
  final String idPengguna;
  final Klasifikasi klasifikasi;
  const EditKeahlianScreen(
      {Key? key, required this.idPengguna, required this.klasifikasi})
      : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<EditKeahlianScreen> {
  final ApiUtils apiUtils = ApiUtils();
  CroppedFile? _imgKlasifikasi, _serti1, _serti2, _serti3;

  TextEditingController ctrlKategori = TextEditingController();
  TextEditingController ctrlKlasifikasi = TextEditingController();
  TextEditingController ctrlDeskripsi = TextEditingController();
  TextEditingController ctrlJasak = TextEditingController();

  @override
  void initState() {
    super.initState();
    ctrlKategori.text = widget.klasifikasi.namaKategori;
    ctrlKlasifikasi.text = widget.klasifikasi.namaKlasifikasi;
    ctrlDeskripsi.text = widget.klasifikasi.deskripsiKlasifikasi;
    ctrlJasak.text = widget.klasifikasi.jasa;
  }

  Future<void> simpanData() async {
    MultipartFile? cover, serti1, serti2, serti3;

    if (_imgKlasifikasi?.path != null) {
      cover = await MultipartFile.fromFile(_imgKlasifikasi!.path,
          filename: _imgKlasifikasi!.path.split('/').last);
    }

    if (_serti1?.path != null) {
      serti1 = await MultipartFile.fromFile(_serti1!.path,
          filename: _serti1!.path.split('/').last);
    }

    if (_serti2?.path != null) {
      serti2 = await MultipartFile.fromFile(_serti2!.path,
          filename: _serti2!.path.split('/').last);
    }

    if (_serti3?.path != null) {
      serti3 = await MultipartFile.fromFile(_serti3!.path,
          filename: _serti3!.path.split('/').last);
    }

    ArtDialogResponse artDialogResponse = await ArtSweetAlert.show(
        barrierDismissible: false,
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.question,
          confirmButtonText: "Benar",
          denyButtonText: "Belum",
          text: "Apakah data sudah Benar?",
          title: "Simpan Data",
        ));

    FormData formData = FormData.fromMap({
      "idPengguna": widget.idPengguna,
      "IdKlasifikasi": widget.klasifikasi.idKlasifikasi,
      "jasa": ctrlJasak.text,
      "deskripsi": ctrlDeskripsi.text,
      "imgKlasifikasi": cover,
      "serti1": serti1,
      "serti2": serti2,
      "serti3": serti3,
      "state": "2",
    });

    if (artDialogResponse.isTapConfirmButton) {
      try {
        Response response = await apiUtils
            .getDataService()
            .post("pakar/simpanPakar", data: formData);

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
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> _showBottomSheet(BuildContext context, int asal) async {
    Size _size = MediaQuery.of(context).size;
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
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
                        if (asal == 1) {
                          Navigator.pop(context);
                          FungsiPakar()
                              .getImage(ImageSource.camera)
                              .then((value) {
                            setState(() {
                              _imgKlasifikasi = value;
                            });
                          });
                        } else {
                          Navigator.pop(context);
                          FungsiPakar()
                              .getSerti(ImageSource.camera)
                              .then((value) {
                            setState(() {
                              if (asal == 2) {
                                _serti1 = value;
                              } else if (asal == 3) {
                                _serti2 = value;
                              } else if (asal == 4) {
                                _serti3 = value;
                              }
                            });
                          });
                        }
                      },
                      icons: Icons.camera_alt,
                      color: Colors.pink,
                      text: "Camera"),
                  const SizedBox(
                    width: 40,
                  ),
                  IconCreation(
                      tap: () {
                        if (asal == 1) {
                          Navigator.pop(context);
                          FungsiPakar()
                              .getImage(ImageSource.gallery)
                              .then((value) {
                            setState(() {
                              _imgKlasifikasi = value;
                            });
                          });
                        } else {
                          Navigator.pop(context);
                          FungsiPakar()
                              .getSerti(ImageSource.gallery)
                              .then((value) {
                            setState(() {
                              if (asal == 2) {
                                _serti1 = value;
                              } else if (asal == 3) {
                                _serti2 = value;
                              } else if (asal == 4) {
                                _serti3 = value;
                              }
                            });
                          });
                        }
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
                'Edit Keahlian',
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: size.height * .03),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: ctrlKategori,
                        decoration: InputDecoration(
                          labelText: "Kategori",
                          contentPadding:
                              const EdgeInsets.fromLTRB(28, 20, 12, 12),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: const BorderSide(color: kPrimaryColor),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide:
                                const BorderSide(color: kPrimaryLightColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: ctrlKlasifikasi,
                        decoration: InputDecoration(
                          labelText: "Klasifikasi",
                          hintText: "Spesifikasi Keahlianmu",
                          contentPadding:
                              const EdgeInsets.fromLTRB(28, 20, 12, 12),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: const BorderSide(color: kPrimaryColor),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide:
                                const BorderSide(color: kPrimaryLightColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        textAlign: TextAlign.end,
                        controller: ctrlJasak,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          ThousandsFormatter(),
                        ],
                        decoration: InputDecoration(
                          labelText: "Jasa Konsultasi 30 Menit (Rp)",
                          contentPadding:
                              const EdgeInsets.fromLTRB(28, 20, 12, 12),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: const BorderSide(color: kPrimaryColor),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide:
                                const BorderSide(color: kPrimaryLightColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: ctrlDeskripsi,
                        decoration: InputDecoration(
                          labelText: "Deskripsi",
                          hintText: "Ceritakan detail tentang pakarmu",
                          contentPadding:
                              const EdgeInsets.fromLTRB(28, 20, 12, 12),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: const BorderSide(color: kPrimaryColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide:
                                const BorderSide(color: kPrimaryLightColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.05),
                    Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Text("Cover Klasifikasi"),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: _imgKlasifikasi?.path == null
                            ? NetworkImage(widget.klasifikasi.coverKlasifikasi)
                            : FileImage(File(_imgKlasifikasi!.path))
                                as ImageProvider,
                        backgroundColor: Colors.transparent,
                        child: GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, 1);
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
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundImage: _serti1?.path == null
                                  ? NetworkImage(widget.klasifikasi.imgSerti1!)
                                  : FileImage(File(_serti1!.path))
                                      as ImageProvider,
                              backgroundColor: Colors.transparent,
                              child: GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, 2);
                                },
                                child: const Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.cyan,
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
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundImage: _serti2?.path == null
                                  ? NetworkImage(widget.klasifikasi.imgSerti2!)
                                  : FileImage(File(_serti2!.path))
                                      as ImageProvider,
                              backgroundColor: Colors.transparent,
                              child: GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, 3);
                                },
                                child: const Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.indigo,
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
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: CircleAvatar(
                              radius: 50.0,
                              backgroundImage: _serti3?.path == null
                                  ? NetworkImage(widget.klasifikasi.imgSerti3!)
                                  : FileImage(File(_serti3!.path))
                                      as ImageProvider,
                              backgroundColor: Colors.transparent,
                              child: GestureDetector(
                                onTap: () {
                                  _showBottomSheet(context, 4);
                                },
                                child: const Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.deepPurple,
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
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
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
