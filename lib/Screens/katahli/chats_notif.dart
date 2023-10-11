import 'package:flutter/material.dart';
import 'package:tanyapakar/api/apiutils.dart';
import 'package:tanyapakar/components/background.dart';
import 'package:tanyapakar/constanta/warna.dart';
import 'package:tanyapakar/main.dart';
import 'package:tanyapakar/model/chats/chats_model.dart';
import 'package:intl/intl.dart';
import 'package:tanyapakar/model/pengguna/pengguna_model.dart';

class ChatScreenNotif extends StatefulWidget {
  final String idPenggunaMember;

  const ChatScreenNotif({Key? key, required this.idPenggunaMember})
      : super(key: key);

  @override
  _WidgetState createState() => _WidgetState();
}

class _WidgetState extends State<ChatScreenNotif> {
  late Pengguna pengguna;
  final ApiUtils apiUtils = ApiUtils();

  int mulaiChat = 0;
  List<MessageData> msglist = [];
  TextEditingController ctrlPesan = TextEditingController();

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void initState() {
    socket.connect();

    socket.on("chatpakar", (data) {
      String jam = DateFormat("HH:mm").format(DateTime.now());

      setStateIfMounted(() {
        if (data["to"] == idPenggunaLogged) {
          msglist.add(
            MessageData(
                dari: idPenggunaLogged!,
                kepada: idPenggunaLogged!,
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
        "pesan": msg,
        "to": idPenggunaLogged,
        "from": idPenggunaLogged,
        "time": jam
      };
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
          child: FutureBuilder(
            future: apiUtils.getPengguna(idPengguna: widget.idPenggunaMember),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                pengguna = (snapshot.data as List<Pengguna>)[0];
                String tipe = pengguna.jenisPengguna!;
                //2 = Member
                //1 = Pakar
                if (tipe == "2") {
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(pengguna.avatarPengguna!),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pengguna.nickName!, style: titleTextStyle),
                        ],
                      ),
                    ],
                  );
                } else if (tipe == "1") {
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(pengguna.avatarPengguna!),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pengguna.nickName!, style: titleTextStyle),
                          const SizedBox(height: 2),
                          Text('Pakar', style: subtitleTextStyle),
                        ],
                      ),
                    ],
                  );
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
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
            Navigator.pop(context);
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
                                  isMe: pengguna.idPengguna == onmsg.kepada,
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
