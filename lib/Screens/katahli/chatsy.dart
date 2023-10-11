import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tanyapakar/Screens/katahli/ratings.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/components/icon_creation.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/main.dart';
import 'package:tanyapakar/model/chats/chats_model.dart';
import 'package:tanyapakar/model/klasifikasi/member_klasifikasi_model.dart';
import 'package:intl/intl.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';
import 'package:tanyapakar/utils/fungsi.dart';

class ChatyScreen extends StatefulWidget {
  final String idPakar;
  final String idPengguna;
  final String idKlasifikasi;
  const ChatyScreen(
      {Key? key,
      required this.idPakar,
      required this.idPengguna,
      required this.idKlasifikasi})
      : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<ChatyScreen> {
  String? token;
  String? imgMsg;
  List<MessageData> msglist = [];
  TextEditingController ctrlPesan = TextEditingController();
  late MemberKlasifikasi _memberKlasifikasi;
  late Pengguna _pengguna;
  final ApiUtils apiUtils = ApiUtils();

  Future<void> getChat({required String idPengguna}) async {
    FormData formData = FormData.fromMap({
      "idPengguna": idPengguna,
    });

    Response response = await apiUtils.getDataService().post(
          "pakar/getChat",
          data: formData,
        );

    if (response.statusCode == 200) {
      var getData = response.data as List;
      msglist = getData.map((e) => MessageData.fromJson(e)).toList();
      setState(() {});
    } else {
      debugPrint("failed to load Chat");
    }
  }

  Future<void> getToken() async {
    FormData formData = FormData.fromMap({
      "idPengguna": widget.idPakar,
    });

    Response response =
        await apiUtils.getDataService().post("pakar/getToken", data: formData);

    if (response.statusCode == 200) {
      if (response.data["error"] == 1) {
        token = response.data["token"];
      }
    }
  }

  Future<void> giveRating(BuildContext context) async {
    if (mulaiChat == 1) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RatingScreen(
              memberKlasifikasi: _memberKlasifikasi, pengguna: _pengguna),
        ),
      );
    } else {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RatingScreen(
              memberKlasifikasi: _memberKlasifikasi, pengguna: _pengguna),
        ),
      );
    }
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void initState() {
    socket.connect();
    getToken();

    var _idPengguna = idPenggunaLogged == null ? '0' : idPenggunaLogged;

    getChat(idPengguna: _idPengguna!);

    socket.on("chatpakar", (data) {
      String jam = DateFormat("HH:mm").format(DateTime.now());

      if (data["kepada"] == idPenggunaLogged) {
        msglist.add(
          MessageData(
              dari: widget.idPakar,
              kepada: idPenggunaLogged!,
              msg: data["imgmsg"],
              time: jam,
              jenis: data["jenis"]),
        );
        setState(() {});
      }
    });

    super.initState();
  }

  void sendMessage(String msg) async {
    String jam = DateFormat("HH:mm").format(DateTime.now());

    if (msg.isNotEmpty) {
      ctrlPesan.text = "";

      FormData formData = FormData.fromMap({
        "dari": idPenggunaLogged,
        "kepada": widget.idPakar,
        "msg": msg,
        "jenis": 1,
      });

      Response response = await apiUtils
          .getDataService()
          .post("pakar/saveChat", data: formData);

      if (response.statusCode == 200) {
        if (response.data["error"] == 1) {
          var pesan = {
            "dari": idPenggunaLogged,
            "kepada": widget.idPakar,
            "pesan": msg,
            "imgmsg": response.data["msg"],
            "jam": jam,
            "router": "chaterpakar",
            "title": "Tanya Pakar",
            "tokenTo": token,
            "tokenFrom": tokenLogged,
            "idKlasifikasi": widget.idKlasifikasi,
            "jenis": 1
          };

          msglist.add(MessageData(
              dari: idPenggunaLogged!,
              kepada: widget.idPakar,
              msg: response.data["msg"],
              time: jam,
              jenis: 1));
          setState(() {});
          socket.emit("chatpakar", pesan);
        }
      }
    }
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  void endChat() async {
    FormData formData = FormData.fromMap({
      "idPengguna": idPenggunaLogged,
    });

    Response response =
        await apiUtils.getDataService().post("pakar/endChat", data: formData);
    if (response.statusCode == 200) {
      if (response.data["error"] == 1) {
        Navigator.pop(context);
        giveRating(context);
      }
    }
  }

  Column header() {
    return Column(
      children: [
        const SizedBox(height: 3),
        Container(
          padding:
              const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
          child: const Text(
            "TANYA PAKAR tidak bertanggung jawab atas isi dan materi. Waspada dan hati-hati untuk setiap Transaksi",
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: kPrimaryLightColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: FutureBuilder(
                future: Future.wait([
                  apiUtils.getKlasifikasiById(
                      idKlasifikasi: widget.idKlasifikasi),
                  apiUtils.getPengguna(idPengguna: widget.idPengguna),
                ]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    _memberKlasifikasi =
                        (snapshot.data![0] as List<MemberKlasifikasi>)[0];
                    _pengguna = (snapshot.data![1] as List<Pengguna>)[0];
                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              NetworkImage(_memberKlasifikasi.imgAvatar),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_memberKlasifikasi.nickName,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Text(_memberKlasifikasi.namaKlasifikasi,
                                style: const TextStyle(
                                  fontSize: 12,
                                )),
                          ],
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            endChat();
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: const [
                              Text("End Chat",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                })),
      ],
    );
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
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                            kirimGambar(value);
                          });
                        });
                      },
                      icons: Icons.camera_alt,
                      color: Colors.pink,
                      text: "Camera"),
                  const SizedBox(
                    width: 20,
                  ),
                  IconCreation(
                      tap: () {
                        Navigator.pop(context);
                        FungsiPakar()
                            .getImage(ImageSource.gallery)
                            .then((value) {
                          setState(() {
                            kirimGambar(value);
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

  void kirimGambar(CroppedFile? img) async {
    String jam = DateFormat("HH:mm").format(DateTime.now());

    final bytes = File(img!.path).readAsBytesSync();
    String base64Image = base64Encode(bytes);

    FormData formData = FormData.fromMap({
      "dari": idPenggunaLogged,
      "kepada": widget.idPakar,
      "msg": base64Image,
      "jenis": 2,
    });

    Response response =
        await apiUtils.getDataService().post("pakar/saveChat", data: formData);

    if (response.statusCode == 200) {
      if (response.data["error"] == 1) {
        var pesan = {
          "dari": idPenggunaLogged,
          "kepada": widget.idPakar,
          "pesan": "Pesan Gambar",
          "imgmsg": response.data["msg"],
          "jam": jam,
          "router": "chaterpakar",
          "title": "Tanya Pakar",
          "tokenTo": token,
          "tokenFrom": tokenLogged,
          "idKlasifikasi": widget.idKlasifikasi,
          "jenis": 2
        };

        msglist.add(MessageData(
          dari: idPenggunaLogged!,
          kepada: widget.idPakar,
          msg: response.data["msg"],
          time: jam,
          jenis: 2,
        ));
        setState(() {});
        socket.emit("chatpakar", pesan);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: kPrimaryColor,
          leading: IconButton(
            onPressed: () {
              endChat();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          elevation: 0,
        ),
        body: Background(
          child: Stack(
            children: [
              Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: size.height * 0.07),
                    header(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: msglist.map((onmsg) {
                              return (onmsg.kepada == idPenggunaLogged)
                                  ? ChatBubble(
                                      clipper: ChatBubbleClipper1(
                                          type: BubbleType.receiverBubble),
                                      alignment: Alignment.topLeft,
                                      margin: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      backGroundColor: Colors.blueGrey[100],
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: size.width * 0.7),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(onmsg.time,
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10)),
                                            onmsg.jenis == 2
                                                ? Image.network(onmsg.msg)
                                                : Text(onmsg.msg,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 10))
                                          ],
                                        ),
                                      ),
                                    )
                                  : ChatBubble(
                                      clipper: ChatBubbleClipper1(
                                          type: BubbleType.sendBubble),
                                      alignment: Alignment.topRight,
                                      margin: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      backGroundColor: Colors.purple[100],
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: size.width * 0.7),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(onmsg.time,
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 8)),
                                            onmsg.jenis == 2
                                                ? Image.network(onmsg.msg)
                                                : Text(onmsg.msg,
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12))
                                          ],
                                        ),
                                      ),
                                    );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 20, right: 10, top: 5),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: TextField(
                              minLines: 1,
                              maxLines: 5,
                              controller: ctrlPesan,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration.collapsed(
                                hintText: "Type a message",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              alignment: Alignment.centerRight,
                              margin: const EdgeInsets.only(right: 7),
                              height: 43,
                              width: 42,
                              child: InkWell(
                                onTap: () {
                                  _showBottomSheet(context);
                                },
                                child: const Icon(
                                  Icons.attachment,
                                  size: 30,
                                ),
                              )),
                          SizedBox(
                            height: 43,
                            width: 42,
                            child: FloatingActionButton(
                              backgroundColor: const Color(0xFF271160),
                              onPressed: () async {
                                sendMessage(ctrlPesan.text);
                              },
                              mini: true,
                              child: Transform.rotate(
                                  angle: 5.79449,
                                  child: const Icon(Icons.send, size: 20)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
