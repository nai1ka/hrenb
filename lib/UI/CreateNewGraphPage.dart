import 'dart:math';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:hrenb/Core/SizeConfig.dart';
import 'package:hrenb/CustomWidgets/EditableNodeWidget.dart';
import 'package:hrenb/Models/Graph.dart';
import 'package:hrenb/Models/Pattern.dart';
import 'package:hrenb/Utils.dart';
import 'package:matrix4_transform/matrix4_transform.dart';

double minZoom = 1 / SizeConfig.areaSizeMultiplier;

class CreateNewGraphPage extends StatefulWidget {
  const CreateNewGraphPage({Key? key}) : super(key: key);

  @override
  State<CreateNewGraphPage> createState() => _CreateNewGraphPageState();
}

class _CreateNewGraphPageState extends State<CreateNewGraphPage> {
  Map<int, EditableNodeWidget> nodesWidgetMap = {};
  int nodeKeyValue = 0;
  final TransformationController transformationController =
      TransformationController();
  String? graphId = null;
  final fabStateKey = GlobalKey<ExpandableFabState>();

  @override
  void initState() {
    transformationController.value = Matrix4Transform().scale(minZoom).matrix4;
  }

  void addNewNode() {}

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        body: InteractiveViewer(
          transformationController: transformationController,
      boundaryMargin: EdgeInsets.all(512),
          minScale: minZoom,
          // scaleEnabled: false,
          constrained: false,
          child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              addSingeNodeToGraph(details.localPosition);
            },
            child: Container(
              width: SizeConfig.areaWidth,
              height: SizeConfig.areaHeight,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 10),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Stack(
                  alignment: Alignment.center,
                  children: nodesWidgetMap.values.toList()),
            ),
          ),
        ),
        floatingActionButton: ExpandableFab(
          key: fabStateKey,
          overlayStyle: ExpandableFabOverlayStyle(color: Colors.black26),
          type: ExpandableFabType.left,
          distance: 60,
          children: [
            FloatingActionButton.small(
              child: const Icon(Icons.pattern),
              onPressed: () {
                fabStateKey.currentState!.toggle();
                showDialog(
                    context: context,
                    builder: (BuildContext context) => getPatternsDialog());
              },
            ),
            FloatingActionButton.small(
              backgroundColor: Colors.red,
              child: const Icon(
                Icons.delete,
              ),
              onPressed: () {
                fabStateKey.currentState!.toggle();
                cleanGraph();
              },
            ),
            FloatingActionButton.small(
              backgroundColor: Colors.green,
              child: const Icon(
                Icons.check,
              ),
              onPressed: () async {
//TODO запретить загрузку еще раз без изменений, добавить возможность обновления
                fabStateKey.currentState!.toggle();
                if (checkIfGraphReadyToSave()) {
                  proceedGraphSave();
                } else {
                  showBeautifulToast(
                      "Необходимо выбрать изображения для всех элементов");
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  bool checkIfGraphReadyToSave() {
    if(nodesWidgetMap.isEmpty) return false;
    for (var i in nodesWidgetMap.values) {
      if (i.getNode().content == null) {
        return false;
      }
    }
    return true;
  }

  void showBeautifulToast(String text) {
    showToast(text,
        context: context,
        animation: StyledToastAnimation.scale,
        animDuration: const Duration(milliseconds: 200),
        reverseAnimation: StyledToastAnimation.scale);
  }

  void copyText() {
    Clipboard.setData(ClipboardData(text: graphId));
    showBeautifulToast("ID скопирован в буфер обмена");
  }

  void proceedGraphSave() async {
    var result = await Utils.saveGraph(
        Graph("Name", nodesWidgetMap.values.map((i) => i.getNode()).toList()), existingGraphID: graphId);
    if (result.first) {
      graphId = result.second;
      CoolAlert.show(
          context: context,
          width: 300,
          copyText: copyText,
          type: CoolAlertType.confirmWithCopy,
          title: "Успешно загружено ",
          text: "ID: ${result.second}",
          textStyle: TextStyle(fontSize: 26),
          confirmBtnText: "Ок",
          onConfirmBtnTap: () {
            Navigator.pop(context);
          });
    } else {
      CoolAlert.show(
          context: context,
          width: 300,
          type: CoolAlertType.error,
          text: "Ошибка при загрузке, попробуйте еще раз",
          confirmBtnText: "Ок",
          onConfirmBtnTap: () => Navigator.pop(context));
    }
  }

  Widget getPatternsDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: SizedBox(
          height: 400.0,
          width: 400.0,
          child: Column(
            children: [
              const Text(
                "Выбор шаблона",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: getListOfPatterns(),
                ),
              )
            ],
          )),
    );
  }

  List<Widget> getListOfPatterns() {
    List<Pattern> patternsList = [
      Pattern(Patterns.CIRCLE, "Окружность", Icons.circle_outlined),
      Pattern(Patterns.HEART, "Сердце", Icons.heart_broken)
    ];
    List<Widget> resultList = [];
    for (var pattern in patternsList) {
      resultList.add(
        InkWell(
          onTap: () {
            addPatternToGraph(pattern);
            Navigator.of(context).pop();
          },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
            child: SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text(pattern.name), Icon(pattern.icon)],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return resultList;
  }

  void removeNode(int id) {
    setState(() {
      nodesWidgetMap.remove(id);
    });
  }

  void cleanGraph() {
    CoolAlert.show(
      context: context,
      type: CoolAlertType.confirm,
      width: 300,
      text: "Вы уверены, что хотите очистить экран?",
      onConfirmBtnTap: () {
        setState(() {
          nodesWidgetMap = {};
          nodeKeyValue = 0;
        });
        Navigator.pop(context);
      },
      onCancelBtnTap: () => Navigator.pop(context),
      confirmBtnText: "Да",
      cancelBtnText: "Нет",
    );
  }

  void addSingeNodeToGraph(Offset position) {
    nodesWidgetMap[nodeKeyValue] = EditableNodeWidget(
        position.dx - SizeConfig.nodeRadius / 2,
        position.dy - SizeConfig.nodeRadius / 2,
        SizeConfig.nodeRadius,
        nodeKeyValue,
        removeNode);
    nodeKeyValue++;
    setState(() {});
  }

  void updateGraph() {
    setState(() {});
  }

  void addPatternToGraph(Pattern pattern) {
    switch (pattern.id) {
      case Patterns.CIRCLE:
        int tmpNodesNumber = 6;
        var angle = 0.0;
        for (int i = 0; i < tmpNodesNumber; i++) {
          var tmpX = (SizeConfig.radiusAroundCentre) * cos(angle);
          var tmpY = (SizeConfig.radiusAroundCentre) * sin(angle);
          var x = SizeConfig.areaWidth / 2 + tmpX - SizeConfig.nodeRadius / 2;
          var y = SizeConfig.areaHeight / 2 + tmpY - SizeConfig.nodeRadius / 2;
          nodesWidgetMap[nodeKeyValue] = EditableNodeWidget(
              x, y, SizeConfig.nodeRadius, nodeKeyValue, removeNode);
          nodeKeyValue++;
          angle += pi / (tmpNodesNumber / 2);
        }
        setState(() {});
        break;
      case Patterns.HEART:
        break;
    }
  }
}
