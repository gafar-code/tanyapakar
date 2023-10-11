import 'dart:io';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanyapakar/Screens/login/login.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/icon_creation.dart';
import 'package:tanyapakar/components/rounded_button.dart';
import 'package:tanyapakar/components/text_field_pakar.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/bb/bank.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';
import 'package:tanyapakar/utils/fungsi.dart';

class HomeAhliFragment extends StatefulWidget {
  final Pengguna listPengguna;
  const HomeAhliFragment({Key? key, required this.listPengguna})
      : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<HomeAhliFragment> {
  final ApiUtils apiUtils = ApiUtils();

  CroppedFile? _imgKlasifikasi;
  String? idBankSelected;

  TextEditingController nickName = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController? tempatLahir = TextEditingController();
  TextEditingController lahirTanggal = TextEditingController();
  TextEditingController hp = TextEditingController();
  TextEditingController nikSim = TextEditingController();
  TextEditingController bank = TextEditingController();
  TextEditingController noRek = TextEditingController();
  Future? nextFuture;

  @override
  void initState() {
    super.initState();
  }

  Future<void> keluar(BuildContext context) async {
    SharedPreferences sesLogin;
    sesLogin = await SharedPreferences.getInstance();
    await sesLogin.clear();
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.routeName, (route) => false);
  }

  Future<void> simpanData(BuildContext context) async {
    FormData formData;
    MultipartFile? cover;

    if (_imgKlasifikasi?.path != null) {
      cover = await MultipartFile.fromFile(_imgKlasifikasi!.path,
          filename: _imgKlasifikasi!.path.split('/').last);
    }

    formData = FormData.fromMap({
      "idPengguna": widget.listPengguna.idPengguna,
      "imgAvatar": cover,
      "nickName": nickName.text,
      "nama": nama.text,
      "email": email.text,
      "tempatLahir": tempatLahir?.text,
      "lahirTanggal": lahirTanggal.text,
      "hp": hp.text,
      "nikSim": nikSim.text,
      "bank": idBankSelected,
      "noRek": noRek.text,
      "state": 2,
    });

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
            if (_imgKlasifikasi?.path != null) {
              ArtDialogResponse rsp = await ArtSweetAlert.show(
                context: context,
                barrierDismissible: false,
                artDialogArgs: ArtDialogArgs(
                  type: ArtSweetAlertType.success,
                  text: response.data["msgErr"] + ' Silahkan Login Ulang',
                  confirmButtonText: "Ok!",
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
        } else {
          debugPrint("Gagal Simpan Data");
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> tglGanti({required String slug}) async {
    Future.delayed(const Duration(seconds: 1), () => lahirTanggal.text = slug);
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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: size.height * 0.2),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Text(
            "DATA DIRI",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2661FA),
                fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: FutureBuilder(
            future: apiUtils.getPengguna(
                idPengguna: widget.listPengguna.idPengguna!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var pengguna = (snapshot.data as List<Pengguna>)[0];
                nickName.text = pengguna.nickName!;
                nama.text = pengguna.namaPengguna!;
                email.text = pengguna.email!;
                tempatLahir?.text =
                    pengguna.tempatLahir == null ? "" : pengguna.tempatLahir!;
                lahirTanggal.text =
                    pengguna.lahirTanggal == null ? "" : pengguna.lahirTanggal!;
                hp.text = pengguna.hp == null ? "" : pengguna.hp!;
                nikSim.text = pengguna.nikSim == null ? "" : pengguna.nikSim!;
                bank.text = pengguna.namaBank == null ? "" : pengguna.namaBank!;
                noRek.text = pengguna.noRek == null ? "" : pengguna.noRek!;
                idBankSelected = pengguna.idBank;

                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 0),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          child: CircleAvatar(
                            radius: 50.0,
                            backgroundImage: _imgKlasifikasi?.path == null
                                ? NetworkImage(pengguna.avatarPengguna!)
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
                      TextFieldPakar(controller: nickName, label: "Nick Name"),
                      SizedBox(height: size.height * 0.03),
                      TextFieldPakar(controller: nama, label: "Nama"),
                      SizedBox(height: size.height * 0.03),
                      TextFieldPakar(controller: email, label: "E-Mail"),
                      SizedBox(height: size.height * 0.03),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              width: size.width * 0.5,
                              alignment: Alignment.center,
                              child: TextField(
                                controller: tempatLahir,
                                decoration: InputDecoration(
                                  labelText: "Tempat Lahir",
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
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                width: size.width * 0.5,
                                alignment: Alignment.centerLeft,
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
                                  decoration: InputDecoration(
                                    labelText: "Tgl. Lahir",
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        28, 20, 12, 12),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
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
                            alignment: Alignment.center,
                            width: size.width * 0.4,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            child: TypeAheadField<Banks?>(
                              debounceDuration:
                                  const Duration(milliseconds: 500),
                              keepSuggestionsOnLoading: false,
                              hideSuggestionsOnKeyboardHide: true,
                              textFieldConfiguration: TextFieldConfiguration(
                                  decoration: InputDecoration(
                                    labelText: 'Bank',
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        28, 20, 12, 12),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      borderSide: const BorderSide(
                                          color: kPrimaryColor),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      borderSide: const BorderSide(
                                          color: kPrimaryLightColor),
                                    ),
                                  ),
                                  controller: bank),
                              suggestionsCallback: (pattern) async {
                                return await apiUtils
                                    .getSuggestionBank(pattern);
                              },
                              itemBuilder: (context, Banks? suggestion) {
                                final kategori = suggestion!;

                                return ListTile(
                                  title: Text(kategori.namaBank),
                                );
                              },
                              noItemsFoundBuilder: (context) => const SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text(
                                    'Data tidak ketemu.',
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              onSuggestionSelected: (Banks? suggestion) {
                                final kategori = suggestion!;

                                bank.text = kategori.namaBank;
                                idBankSelected = kategori.idBank;
                              },
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Container(
                                width: size.width * 0.6,
                                alignment: Alignment.center,
                                child: TextField(
                                  controller: noRek,
                                  decoration: InputDecoration(
                                    labelText: "No. Rek",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        28, 20, 12, 12),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      borderSide: const BorderSide(
                                          color: kPrimaryColor),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      borderSide: const BorderSide(
                                          color: kPrimaryLightColor),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: RoundedButton(
                            sizeWidth: 0.4,
                            borderRadius: BorderRadius.circular(29),
                            icon: Icons.save,
                            text: "Update",
                            press: () {
                              simpanData(context);
                            },
                            color: kPrimaryColor,
                            color2: kOrange,
                            textColor: Colors.white,
                          ),
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
