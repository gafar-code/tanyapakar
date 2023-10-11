import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/chats/norma_model.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';

class AdminPenggunaNonAktif extends StatefulWidget {
  const AdminPenggunaNonAktif({Key? key}) : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<AdminPenggunaNonAktif> {
  Future? nextFuture;
  bool sdhCari = false;
  String? selectedNorma;
  String? selectedIdMember;
  List<NormaData> normaList = [];
  late NormaData normaPilih;
  TextEditingController ctrlCari = TextEditingController();

  @override
  void initState() {
    super.initState();
    nextFuture = ApiUtils().getAllPenggunaNonAktif();
    getNorma();
  }

  Future<void> getNorma() async {
    Response response = await ApiUtils().getDataService().get("pakar/getNorma");

    if (response.statusCode == 200) {
      var getData = response.data as List;
      normaList = getData.map((e) => NormaData.fromJson(e)).toList();
      normaPilih = normaList[0];
      selectedNorma = normaPilih.idNorma;
      setState(() {});
    } else {
      debugPrint("failed to load Norma");
    }
  }

  Future<void> aktfikanPengguna({required String idPengguna}) async {
    FormData formData = FormData.fromMap({
      "idPengguna": idPengguna,
    });

    Response response = await ApiUtils()
        .getDataService()
        .post("pakar/aktifkanPengguna", data: formData);

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
          setState(() {
            nextFuture = ApiUtils().getAllPenggunaNonAktif();
          });
        }
      }
    }
  }

  Future<void> _showPopupMenu(
      BuildContext context, TapDownDetails details, Pengguna pengguna) async {
    var selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      items: [
        _buildMenuItem("Aktifkan", Icons.check_sharp, 2),
        _buildMenuItem("Tolak", Icons.cancel_outlined, 3),
      ],
      elevation: 8.0,
    );

    if (selected == 2) {
      aktfikanPengguna(idPengguna: pengguna.idPengguna!);
    } else if (selected == 3) {
      inputFormDialog(context,
          formBuilder: buildFormDialog,
          title: "Tolak Akun",
          okButton: "Tolak",
          cancelButton: "Batal");
      selectedIdMember = pengguna.idPengguna;
    } else {
      return;
    }
  }

  Future<void> rejected() async {
    FormData formData = FormData.fromMap(
        {"idPengguna": selectedIdMember, "alasan": selectedNorma});

    ArtDialogResponse tanya = await ArtSweetAlert.show(
      context: context,
      barrierDismissible: false,
      artDialogArgs: ArtDialogArgs(
        type: ArtSweetAlertType.success,
        text: "Yakin Tolak Akun?",
        confirmButtonText: "Yakin!",
        cancelButtonText: "Batal",
      ),
    );

    if (tanya.isTapConfirmButton) {
      Response response = await ApiUtils()
          .getDataService()
          .post("pakar/TolakMember", data: formData);
      if (response.statusCode == 200) {
        if (response.data["error"] == 2) {
          ArtSweetAlert.show(
            context: context,
            barrierDismissible: false,
            artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.success,
              text: response.data["msgErr"],
              confirmButtonText: "OK",
            ),
          );
        } else {
          Navigator.pop(context, false);
        }
      }
    }
  }

  Future<bool> inputFormDialog(BuildContext context,
      {String? title,
      required Form Function(BuildContext, GlobalKey) formBuilder,
      String? okButton,
      String? cancelButton}) async {
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: (title != null) ? Text(title) : null,
        content: formBuilder(context, formKey),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelButton?.toUpperCase() ??
                MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () {
              rejected();
            },
            child: Text(okButton?.toUpperCase() ??
                MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Form buildFormDialog(BuildContext context, GlobalKey formKey) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<NormaData>(
              hint: const Text("Pilih Alasan"),
              value: normaPilih,
              onChanged: (newVal) {
                normaPilih = newVal!;
                selectedNorma = normaPilih.idNorma;
              },
              items: normaList.map((NormaData item) {
                return DropdownMenuItem<NormaData>(
                  child: Text(item.isiNorma),
                  value: item,
                );
              }).toList())
        ],
      ),
    );
  }

  PopupMenuItem _buildMenuItem(String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          Text(title),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(29),
            ),
            child: TextField(
              controller: ctrlCari,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari Pengguna',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      if (ctrlCari.text.isEmpty) {
                        if (sdhCari) {
                          nextFuture = ApiUtils().getAllPengguna();
                          sdhCari = false;
                        } else {
                          ArtSweetAlert.show(
                            context: context,
                            artDialogArgs: ArtDialogArgs(
                              type: ArtSweetAlertType.danger,
                              text: "Kata Kunci Kosong",
                            ),
                          );
                        }
                      } else {
                        nextFuture =
                            ApiUtils().getAllPenggunaCari(query: ctrlCari.text);
                        sdhCari = true;
                      }
                    });
                  },
                  icon: const Icon(Icons.search_rounded),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: nextFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    itemBuilder: (context, index) {
                      var pengguna = (snapshot.data as List<Pengguna>)[index];
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(right: 10),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 40.0,
                                        backgroundImage: NetworkImage(
                                            pengguna.avatarPengguna!),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(pengguna.nickName!,
                                              style: const TextStyle(
                                                  fontSize: 20)),
                                          Text(
                                            pengguna.hp!,
                                            style: subtitleTextStyle.copyWith(
                                                color: colorDarkBlue),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            child: GestureDetector(
                                              child:
                                                  const Icon(Icons.more_vert),
                                              onTapDown: (details) {
                                                _showPopupMenu(
                                                    context, details, pengguna);
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: size.height * 0.03),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                    itemCount: (snapshot.data as List<Pengguna>).length,
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
