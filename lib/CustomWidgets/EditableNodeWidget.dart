import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hrenb/Core/SizeConfig.dart';
import 'package:hrenb/Models/Node.dart';
import 'package:image_picker/image_picker.dart';

import '../Utils.dart';

class EditableNodeWidget extends StatefulWidget {
  double x;
  double y;
  double contentSize;
  int id;
  Function removeNode;
  Node node = Node(0, 0);

  @override
  State<EditableNodeWidget> createState() => _EditableNodeWidgetState();

  Node getNode() {
    return node;
  }

  EditableNodeWidget(this.x, this.y, this.contentSize, this.id, this.removeNode,
      {Key? key})
      : super(key: key);
}

class _EditableNodeWidgetState extends State<EditableNodeWidget> {
  @override
  void initState() {
    widget.node.x = widget.x;
    widget.node.y = widget.y;
  }

  void choosePicture() async {}

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: widget.node.x,
        top: widget.node.y,
        child: Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              getNodeEditDialog()).then((valueFromDialog) {
                        setState(() {});
                      });
                    },
                    child: Container(
                      width: widget.contentSize,
                      height: widget.contentSize,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
                      child: widget.node.content == null
                          ? Center(
                              child: Icon(Icons.edit,
                                  size: SizeConfig.smallButtonSize))
                          : Container(
                              width: widget.contentSize,
                              height: widget.contentSize,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          MemoryImage(widget.node.content!)))),
                    )),
                InkWell(
                  onTap: () {
                    widget.removeNode(widget.id);
                  },
                  child: Container(
                      width: SizeConfig.smallButtonSize,
                      height: SizeConfig.smallButtonSize,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                      child: const Center(
                        child: Icon(
                          Icons.close,
                          size: SizeConfig.smallButtonSize - 10,
                          color: Colors.white,
                        ),
                      )),
                ),
                Positioned(
                  right: 0,
                  child: GestureDetector(
                    onPanUpdate: (panDetails) {
                      setState(() {
                        widget.node.x += panDetails.delta.dx;
                        widget.node.y += panDetails.delta.dy;
                      });
                    },
                    child: Container(
                        width: SizeConfig.smallButtonSize,
                        height: SizeConfig.smallButtonSize,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.blue),
                        child: const Center(
                          child: Icon(
                            Icons.open_with,
                            size: SizeConfig.smallButtonSize - 20,
                            color: Colors.white,
                          ),
                        )),
                  ),
                )
              ],
            ),
            Text(widget.node.text ?? " ")
          ],
        ));
  }

  Widget getNodeEditDialog() {
    bool isVisible = false;
    String text = "";
    late dynamic content;
    late CONTENT_TYPE contentType;
    return StatefulBuilder(builder: (context, setState) {
      return Container(
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Center(
                      child: Text(
                        "Изменение данных",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 6)),
                    Center(child: const Text("1. Выберите контент",style: TextStyle(fontSize: 16),)),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              content = await (await ImagePicker()
                                  .pickImage(
                                  source: ImageSource.gallery,imageQuality: 60))!
                                  .readAsBytes();
                              contentType = CONTENT_TYPE.image;
                              setState(() {
                                isVisible = true;
                              });
                            },
                            child: Text("Выбрать фото")),
                        Padding(padding: EdgeInsets.only(left: 20)),
                        ElevatedButton(
                            onPressed: () async {
                              content = await (await ImagePicker()
                                  .pickVideo(
                                  source: ImageSource.gallery,))!
                                  .readAsBytes();
                              contentType = CONTENT_TYPE.video;
                              setState(() {
                                isVisible = true;
                              });
                            },
                            child: Text("Выбрать видео")),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Visibility(
                      visible: isVisible,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "2. Введите текст, который будет показан под контентом",style: TextStyle(fontSize: 16)),
                          TextField(
                            onChanged: (String newText) {
                              setState((){
                                text = newText;
                              });

                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),

                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                          onPressed: text == ""
                              ? null
                              : () {
                            widget.node.text = text;
                            widget.node.content = content;
                            widget.node.type = contentType;
                            Navigator.pop(context);
                          },
                          child: Text("Готово")),
                    )
                  ],
                ),
              ),
            ),
        ),
      );
    });
  }
}
