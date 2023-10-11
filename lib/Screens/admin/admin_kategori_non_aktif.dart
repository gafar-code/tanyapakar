import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tanyapakar/Screens/admin/admin_kategori_add.dart';
import 'package:tanyapakar/Screens/admin/admin_kategori_edit.dart';
import 'package:tanyapakar/Screens/admin/admin_kategori_view.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/kategori/kategori_model.dart';

class AdminKategoriNonAktif extends StatefulWidget {
  const AdminKategoriNonAktif({Key? key}) : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<AdminKategoriNonAktif> {
  final ApiUtils apiUtils = ApiUtils();
  Future? nextFuture;
  bool sdhCari = false;
  List<Kategori> listKategori = [];
  TextEditingController ctrlCari = TextEditingController();

  int offset = 0;
  int perpage = 0;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _firstLoad();
    _controller = ScrollController()
      ..addListener(() {
        _loadMore();
      });
  }

  @override
  void dispose() {
    _controller.removeListener(() {
      _loadMore();
    });
    super.dispose();
  }

  void _hapus(String idKategori) async {
    FormData formdata = FormData.fromMap({"idKategori": idKategori});

    try {
      ArtDialogResponse _tanya = await ArtSweetAlert.show(
        barrierDismissible: false,
        context: context,
        artDialogArgs: ArtDialogArgs(
          type: ArtSweetAlertType.question,
          confirmButtonText: "Yakin!",
          denyButtonText: "Tidak",
          text: "Yakin Hapus Data Kategori?",
          title: "Hapus",
        ),
      );

      if (_tanya.isTapConfirmButton) {
        Response response = await apiUtils
            .getDataService()
            .post("pakar/hapusKategori", data: formdata);
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
            ArtDialogResponse _sukses = await ArtSweetAlert.show(
              barrierDismissible: false,
              context: context,
              artDialogArgs: ArtDialogArgs(
                type: ArtSweetAlertType.success,
                confirmButtonText: "Ok!",
                text: "Sukses Hapus Data Kategori",
              ),
            );

            if (_sukses.isTapConfirmButton) {
              _firstLoad();
            }
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _firstLoad() async {
    FormData formdata = FormData.fromMap({"offset": offset});

    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      Response response = await apiUtils
          .getDataService()
          .post("pakar/getKategoriNewNonAktif", data: formdata);
      if (response.statusCode == 200) {
        var getData = response.data["data"] as List;
        var listData = getData.map((e) => Kategori.fromJson(e)).toList();
        listKategori.clear();
        listKategori.addAll(listData);
        offset = 0;
        perpage = response.data["perpage"];
        setState(() {});
      } else {
        debugPrint("Failed to load Kategori");
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  Future<void> _cari(String? query) async {
    FormData formdata = FormData.fromMap({"key": query});

    setState(() {
      _isFirstLoadRunning = true;
    });

    try {
      Response response = await apiUtils
          .getDataService()
          .post("pakar/cariKategori", data: formdata);
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData = getData.map((e) => Kategori.fromJson(e)).toList();
        listKategori.clear();
        listKategori.addAll(listData);
        setState(() {});
      } else {
        debugPrint("Failed to load Kategori");
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      _isFirstLoadRunning = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true;
      });

      offset += perpage;
      try {
        FormData formdata = FormData.fromMap({"offset": offset});

        Response response = await apiUtils
            .getDataService()
            .post("pakar/getKategoriNew", data: formdata);

        if (response.statusCode == 200) {
          if (response.data["error"] == 2) {
            var getData = response.data["data"] as List;
            var listData = getData.map((e) => Kategori.fromJson(e)).toList();
            listKategori.addAll(listData);
            perpage = response.data["perpage"];
            setState(() {});
          } else {
            _hasNextPage = false;
          }
        } else {
          debugPrint("Failed to load Kategori");
        }
      } catch (e) {
        debugPrint(e.toString());
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  Future<void> _showPopupMenu(
      BuildContext context, TapDownDetails details, String idKategori) async {
    var selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      items: [
        _buildMenuItem("Edit", Icons.edit, 1),
        _buildMenuItem("View", Icons.view_agenda, 2),
        _buildMenuItem("Hapus", Icons.delete_forever, 3),
      ],
      elevation: 8,
    );

    if (selected == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminKategoriEdit(idKategori: idKategori),
        ),
      );
    } else if (selected == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminKategoriView(idKategori: idKategori),
        ),
      );
    } else if (selected == 3) {
      _hapus(idKategori);
    } else {
      return;
    }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminKategoriTambah(),
            ),
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          Container(
            margin:
                const EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(29),
            ),
            child: TextField(
              controller: ctrlCari,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Cari Kategori',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      if (ctrlCari.text.isEmpty) {
                        if (sdhCari) {
                          _firstLoad();
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
                        _cari(ctrlCari.text);
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
            child: _isFirstLoadRunning
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: listKategori.length,
                    controller: _controller,
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        margin:
                            const EdgeInsets.only(left: 1, right: 1, top: 10),
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                radius: 40.0,
                                backgroundImage: NetworkImage(
                                    listKategori[index].coverKategori),
                                backgroundColor: Colors.transparent,
                              ),
                              title: Text(listKategori[index].namaKategori,
                                  style: const TextStyle(fontSize: 20)),
                              subtitle: Text(
                                listKategori[index].deskripsiKategori,
                                style: subtitleTextStyle.copyWith(
                                    color: colorDarkBlue),
                              ),
                              trailing: Column(
                                children: [
                                  Text(
                                    listKategori[index].jmlPakar + ' Pakar',
                                    style: subtitleTextStyle.copyWith(
                                        color: colorDarkBlue),
                                  ),
                                  GestureDetector(
                                    child: const Icon(Icons.more_horiz),
                                    onTapDown: (details) => {
                                      _showPopupMenu(context, details,
                                          listKategori[index].idKategori),
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (_isLoadMoreRunning == true)
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 40),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
