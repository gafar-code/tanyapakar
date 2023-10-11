import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/components/icon_creation.dart';
import 'package:tanyapakar/components/rounded_button.dart';
import 'package:tanyapakar/components/text_field_pakar.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/kategori/kategori_model.dart';
import 'package:tanyapakar/utils/fungsi.dart';

class AdminKategoriEdit extends StatefulWidget {
  final String idKategori;

  const AdminKategoriEdit({Key? key, required this.idKategori})
      : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<AdminKategoriEdit> {
  final ApiUtils apiUtils = ApiUtils();
  String? fileName;
  MultipartFile? gambar;

  CroppedFile? _imgKlasifikasi;
  List<Kategori> listKategori = [];
  TextEditingController ctrlKategori = TextEditingController();
  TextEditingController ctrlDeskripsi = TextEditingController();

  @override
  void initState() {
    super.initState();
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
          title: "Simpan Data",
        ));

    if (artDialogResponse.isTapConfirmButton) {
      try {
        if (_imgKlasifikasi?.path != null) {
          fileName = _imgKlasifikasi?.path.split("/").last;
          gambar = await MultipartFile.fromFile(_imgKlasifikasi!.path,
              filename: fileName);
        }

        FormData formData = FormData.fromMap({
          "idKategori": widget.idKategori,
          "kategori": ctrlKategori.text,
          "deskripsi": ctrlDeskripsi.text,
          "imgCover": gambar,
          "state": 2
        });

        Response response = await apiUtils
            .getDataService()
            .post("pakar/simpanKategori", data: formData);

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
                'Edit Kategori',
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Expanded(
              child: FutureBuilder(
                  future:
                      apiUtils.getKategoriById(idKategori: widget.idKategori),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var _kategori = (snapshot.data as List<Kategori>)[0];
                      ctrlKategori.text = _kategori.namaKategori;
                      ctrlDeskripsi.text = _kategori.deskripsiKategori;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: size.height * .03),
                            TextFieldPakar(
                                controller: ctrlKategori, label: "Kategori"),
                            SizedBox(height: size.height * 0.03),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: TextField(
                                minLines: 1,
                                maxLines: 5,
                                controller: ctrlDeskripsi,
                                decoration: InputDecoration(
                                  labelText: "Deskripsi",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(28, 20, 12, 12),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                    borderSide: const BorderSide(
                                        color: kPrimaryLightColor),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                    borderSide: const BorderSide(
                                        color: kPrimaryLightColor),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.03),
                            Container(
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: const Text("Gambar Cover"),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage: _imgKlasifikasi?.path == null
                                    ? NetworkImage(_kategori.coverKategori)
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
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Container(
                                      width: size.width * 0.5,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: RoundedButton(
                                        sizeWidth: 0.4,
                                        borderRadius: BorderRadius.circular(29),
                                        icon: Icons.close,
                                        text: "Batal",
                                        press: () {
                                          Navigator.pop(context);
                                        },
                                        color: kRedi,
                                        color2: kRedi,
                                        textColor: colorWhite,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Container(
                                      width: size.width * 0.5,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.symmetric(
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
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
