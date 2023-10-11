import 'package:flutter/material.dart';

class MyMessageHandler extends StatefulWidget {
  final Widget child;
  final String? router;

  const MyMessageHandler({Key? key, required this.child, this.router})
      : super(key: key);

  @override
  State createState() => MessageHandlerState();
}

class MessageHandlerState extends State<MyMessageHandler> {
  late Widget child;

  @override
  void initState() {
    super.initState();
    child = widget.child;
    debugPrint(widget.router);
    if (widget.router != null) {
      if (widget.router == "chater") {
        Navigator.of(context).pushNamed("chater");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
