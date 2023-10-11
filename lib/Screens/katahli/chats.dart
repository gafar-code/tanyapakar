import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tanyapakar/Screens/katahli/ratings.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/main.dart';
import 'package:tanyapakar/model/chats/chats_model.dart';
import 'package:tanyapakar/model/klasifikasi/member_klasifikasi_model.dart';
import 'package:intl/intl.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';

class ChatScreen extends StatefulWidget {
  final MemberKlasifikasi memberKlasifikasi;
  final Pengguna pengguna;
  const ChatScreen(
      {Key? key, required this.memberKlasifikasi, required this.pengguna})
      : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<ChatScreen> {
  int mulaiChat = 0;
  String? token;
  List<MessageData> msglist = [];
  TextEditingController ctrlPesan = TextEditingController();

  Future<void> getToken() async {
    FormData formData = FormData.fromMap({
      "idPengguna": widget.memberKlasifikasi.idPakar,
    });

    Response response = await ApiUtils()
        .getDataService()
        .post("pakar/getToken", data: formData);

    if (response.statusCode == 200) {
      if (response.data["error"] == 2) {
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
              memberKlasifikasi: widget.memberKlasifikasi,
              pengguna: widget.pengguna),
        ),
      );
    } else {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RatingScreen(
              memberKlasifikasi: widget.memberKlasifikasi,
              pengguna: widget.pengguna),
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

    socket.on("chatpakar", (data) {
      String jam = DateFormat("HH:mm").format(DateTime.now());
      setStateIfMounted(() {
        if (data["to"] == widget.pengguna.idPengguna) {
          msglist.add(
            MessageData(
                dari: widget.pengguna.idPengguna!,
                kepada: widget.memberKlasifikasi.idPakar,
                msg: data["pesan"],
                time: jam),
          );
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  void sendMessage(String msg) {
    String jam = DateFormat("HH:mm").format(DateTime.now());

    if (msg.isNotEmpty) {
      ctrlPesan.text = "";
      var pesan = {
        "from": widget.pengguna.idPengguna,
        "to": widget.memberKlasifikasi.idPakar,
        "pesan": msg,
        "jam": jam,
        "tokenTo": token,
        "tokenFrom": tokenLogged
      };
      msglist.add(MessageData(
          dari: widget.pengguna.idPengguna!,
          kepada: widget.memberKlasifikasi.idPakar,
          msg: msg,
          time: jam));
      socket.emit("chatpakar", pesan);
    }
  }

  Column header() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: const Text(
            "TANYA PAKAR tidak bertanggung jawab atas isi dan materi. Waspada dan hati-hati untuk setiap Transaksi",
            textAlign: TextAlign.justify,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: kPrimaryLightColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(40),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage:
                    NetworkImage(widget.memberKlasifikasi.imgAvatar),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.memberKlasifikasi.nickName,
                      style: titleTextStyle),
                  const SizedBox(height: 2),
                  Text(widget.memberKlasifikasi.namaKlasifikasi,
                      style: subtitleTextStyle),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row chatInput(BuildContext context) {
    return Row(children: [
      TextField(
        controller: ctrlPesan,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: kPrimaryColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: kPrimaryLightColor),
          ),
          hintText: 'Type Message ...',
          suffixIcon: GestureDetector(
            onTap: () {
              sendMessage(ctrlPesan.text);
            },
            child: const Icon(Icons.send),
          ),
        ),
      ),
    ]);
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
            giveRating(context);
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
                            return Column(
                              children: [
                                ChatBubble(
                                  message: onmsg.msg,
                                  date: onmsg.time,
                                  isMe: widget.pengguna.idPengguna ==
                                      onmsg.kepada,
                                ),
                              ],
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
                          child: const Icon(Icons.attachment),
                        ),
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
    );
  }
}

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final String date;

  const ChatBubble({
    Key? key,
    required this.message,
    this.isMe = true,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            constraints: BoxConstraints(maxWidth: size.width * 1.5),
            decoration: BoxDecoration(
              color: isMe ? const Color(0xFFE3D8FF) : const Color(0xFFCACACA),
              borderRadius: isMe
                  ? const BorderRadius.only(
                      topRight: Radius.circular(11),
                      topLeft: Radius.circular(11),
                      bottomRight: Radius.circular(0),
                      bottomLeft: Radius.circular(11),
                    )
                  : const BorderRadius.only(
                      topRight: Radius.circular(11),
                      topLeft: Radius.circular(11),
                      bottomRight: Radius.circular(11),
                      bottomLeft: Radius.circular(0),
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  message,
                  textAlign: TextAlign.start,
                  softWrap: true,
                  style:
                      const TextStyle(color: Color(0xFF2E1963), fontSize: 14),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(
                      date,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                          color: Color(0xFF594097), fontSize: 9),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
