import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/components/rounded_button.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/klasifikasi/klasifikasi_model.dart';

class AdminKlasifikasiEdit extends StatefulWidget {
  final String idKlasifikasi;
  const AdminKlasifikasiEdit({Key? key, required this.idKlasifikasi})
      : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<AdminKlasifikasiEdit> {
  final ApiUtils apiUtils = ApiUtils();
  CroppedFile? _imgKlasifikasi, _serti1, _serti2, _serti3;

  TextEditingController ctrlKategori = TextEditingController();
  TextEditingController ctrlKlasifikasi = TextEditingController();
  TextEditingController ctrlDeskripsi = TextEditingController();
  TextEditingController ctrlJasak = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> appImage(String source) async {
    final String ket;

    if (source == "C") {
      ket = "Yakin Approv Gambar Cover?";
    } else {
      ket = "Yakin Approv Gambar Sertifikat?";
    }

    FormData formData = FormData.fromMap(
        {"idKlasifikasi": widget.idKlasifikasi, "source": source});

    ArtDialogResponse artDialogResponse = await ArtSweetAlert.show(
        barrierDismissible: false,
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.question,
          confirmButtonText: "Yakin",
          denyButtonText: "Batal",
          text: ket,
          title: "Approval",
        ));

    if (artDialogResponse.isTapConfirmButton) {
      try {
        Response response = await apiUtils
            .getDataService()
            .post("pakar/appKlasifikasi", data: formData);

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
      "IdKlasifikasi": widget.idKlasifikasi,
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
                'Approval Klasifikasi',
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder(
                    future: apiUtils.getKlasifikasiAdminById(
                        idKlasifikasi: widget.idKlasifikasi),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var _klasifikasi =
                            (snapshot.data as List<Klasifikasi>)[0];
                        ctrlKlasifikasi.text = _klasifikasi.namaKlasifikasi;
                        ctrlJasak.text = _klasifikasi.jasa;
                        ctrlDeskripsi.text = _klasifikasi.deskripsiKlasifikasi;
                        return Column(
                          children: [
                            SizedBox(height: size.height * .03),
                            Container(
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                controller: ctrlKlasifikasi,
                                decoration: InputDecoration(
                                  labelText: "Klasifikasi",
                                  hintText: "Spesifikasi Keahlianmu",
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
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                    borderSide:
                                        const BorderSide(color: kPrimaryColor),
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
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                controller: ctrlDeskripsi,
                                decoration: InputDecoration(
                                  labelText: "Deskripsi",
                                  hintText: "Ceritakan detail tentang pakarmu",
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(28, 20, 12, 12),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                    borderSide:
                                        const BorderSide(color: kPrimaryColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(32),
                                    borderSide: const BorderSide(
                                        color: kPrimaryLightColor),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.05),
                            Container(
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: const Text("Cover Klasifikasi"),
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage:
                                    NetworkImage(_klasifikasi.coverKlasifikasi),
                                backgroundColor: Colors.transparent,
                                child: GestureDetector(
                                  onTap: () {
                                    appImage("C");
                                  },
                                  child: const Align(
                                    alignment: Alignment.bottomRight,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.green,
                                      radius: 20,
                                      child: Icon(
                                        Icons.check_sharp,
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
                                      backgroundImage:
                                          NetworkImage(_klasifikasi.imgSerti1!),
                                      backgroundColor: Colors.transparent,
                                      child: GestureDetector(
                                        onTap: () {
                                          appImage("1");
                                        },
                                        child: const Align(
                                          alignment: Alignment.bottomRight,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.cyan,
                                            radius: 20,
                                            child: Icon(
                                              Icons.check_sharp,
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
                                      backgroundImage:
                                          NetworkImage(_klasifikasi.imgSerti2!),
                                      backgroundColor: Colors.transparent,
                                      child: GestureDetector(
                                        onTap: () {
                                          appImage("2");
                                        },
                                        child: const Align(
                                          alignment: Alignment.bottomRight,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.indigo,
                                            radius: 20,
                                            child: Icon(
                                              Icons.check_sharp,
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
                                      backgroundImage:
                                          NetworkImage(_klasifikasi.imgSerti3!),
                                      backgroundColor: Colors.transparent,
                                      child: GestureDetector(
                                        onTap: () {
                                          appImage("3");
                                        },
                                        child: const Align(
                                          alignment: Alignment.bottomRight,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.deepPurple,
                                            radius: 20,
                                            child: Icon(
                                              Icons.check_sharp,
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
                                text: "Tutup",
                                press: () {
                                  Navigator.pop(context);
                                },
                                color: kPrimaryColor,
                                color2: kOrange,
                                textColor: colorWhite,
                              ),
                            ),
                          ],
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
