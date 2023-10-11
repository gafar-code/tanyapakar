import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tanyapakar/Screens/katahli/chatsy.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/components/diagonally_cut_colored_image.dart';
import 'package:tanyapakar/components/rounded_button.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/model/klasifikasi/klasifikasi_pakar_model.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';

class DetailKlasifikasiScreen extends StatefulWidget {
  final String idKlasifikasi;
  final Pengguna pengguna;
  const DetailKlasifikasiScreen(
      {Key? key, required this.pengguna, required this.idKlasifikasi})
      : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<DetailKlasifikasiScreen> {
  List<KlasifikasiPakar> listKlasifikasi = [];
  final ApiUtils apiUtils = ApiUtils();

  @override
  void initState() {
    super.initState();
    _loadKlasifikasi();
  }

  Future<void> _loadKlasifikasi() async {
    FormData formdata = FormData.fromMap({
      "idKlasifikasi": widget.idKlasifikasi,
    });

    try {
      Response response = await apiUtils
          .getDataService()
          .post("pakar/getKlasifikasiPakarById", data: formdata);
      if (response.statusCode == 200) {
        var getData = response.data as List;
        var listData =
            getData.map((e) => KlasifikasiPakar.fromJSON(e)).toList();
        listKlasifikasi.clear();
        listKlasifikasi.addAll(listData);
        setState(() {});
      } else {
        debugPrint("Failed to load Klasifikasi Pakar");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> btnChatClick(int position) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatyScreen(
          idKlasifikasi: listKlasifikasi[position].idKlasifikasi,
          idPengguna: widget.pengguna.idPengguna!,
          idPakar: listKlasifikasi[position].idPenggunaPakar,
        ),
      ),
    );
  }

  /*
  Future<void> btnChatClickOri() async {
    FormData formData = FormData.fromMap({
      "idPengguna": widget.pengguna.idPengguna,
      "idPakar": widget.memberKlasifikasi.idPenggunaPakar,
    });

    Response response = await ApiUtils()
        .getDataService()
        .post("pakar/cekBuktiBayar", data: formData);

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
        if (response.data["id_pakar"] != widget.memberKlasifikasi.idPakar) {
          ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              text: "Anda tidak bisa chat dengan Pakar tsb!",
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                  memberKlasifikasi: widget.memberKlasifikasi,
                  pengguna: widget.pengguna),
            ),
          );
        }
      }
    }
  }
  */

  Widget _buildDiagonalImageBackground(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DiagonallyCutColoredImage(
      image: Image.asset(
        "assets/images/profile_header_background.png",
        width: size.width,
        height: 180,
        fit: BoxFit.cover,
      ),
      color: const Color(0xBB8338f4),
    );
  }

  Widget _buildAvatar(int position) {
    return Hero(
      tag: "avartag",
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(listKlasifikasi[position].imgAvatar),
            radius: 30.0,
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              listKlasifikasi[position].nickName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, int position) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        listKlasifikasi[position].tersedia == "1"
            ? SizedBox(
                width: 100,
                height: 50,
                child: RoundedButton(
                  sizeWidth: 0.4,
                  icon: Icons.chat,
                  text: "CHAT",
                  press: () {
                    btnChatClick(position);
                  },
                  color: kRedi,
                  color2: kRedi,
                  textColor: colorWhite,
                ),
              )
            : SizedBox(
                width: 100,
                height: 50,
                child: RoundedButton(
                  sizeWidth: 0.4,
                  icon: Icons.chat,
                  text: "CHAT",
                  press: () {},
                  color: Colors.grey,
                  color2: Colors.grey,
                  textColor: Colors.grey,
                ),
              ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: colorWhite,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        elevation: 0,
      ),
      body: Background(
        child: Stack(
          children: [
            _buildDiagonalImageBackground(context),
            Align(
              alignment: FractionalOffset.bottomCenter,
              heightFactor: 1.4,
              child: ListView.builder(
                itemCount: listKlasifikasi.length,
                padding: const EdgeInsets.only(left: 0, top: 0),
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      SizedBox(height: size.height * 0.05),
                      _buildAvatar(index),
                      _buildActionButtons(context, index),
                      SizedBox(height: size.height * 0.03),
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            listKlasifikasi[index].coverKlasifikasi),
                        radius: 30.0,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          listKlasifikasi[index].namaKlasifikasi,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 4),
                        child: Text(
                          listKlasifikasi[index].deskripsiKlasifikasi,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            color: kPurple,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "Sertifikat",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        height: size.height * 0.20,
                        width: size.width * 0.50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: PhotoView(
                          imageProvider:
                              NetworkImage(listKlasifikasi[index].imgSerti1!),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        height: size.height * 0.20,
                        width: size.width * 0.50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: PhotoView(
                          imageProvider:
                              NetworkImage(listKlasifikasi[index].imgSerti2!),
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        height: size.height * 0.20,
                        width: size.width * 0.50,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: PhotoView(
                          imageProvider:
                              NetworkImage(listKlasifikasi[index].imgSerti3!),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
