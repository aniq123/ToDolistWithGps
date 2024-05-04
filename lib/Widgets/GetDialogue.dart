import 'package:flutter/material.dart';

getWidgetDialogue(context, List<Widget> children) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      actions: children,
    ),
  );
}

class GetWidgetDialogue extends StatefulWidget {
  final List<Widget>? popupWidget;

  const GetWidgetDialogue({Key? key, required this.popupWidget})
      : super(key: key);

  @override
  _GetWidgetDialogueState createState() => _GetWidgetDialogueState();
}

class _GetWidgetDialogueState extends State<GetWidgetDialogue> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.cancel_outlined,
                color: Colors.red,
              ),
            ),
          ],
        ),
        ...(widget.popupWidget ?? []),
      ],
    );
  }
}
