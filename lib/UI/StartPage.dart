import 'package:flutter/material.dart';

import '../Core/SizeConfig.dart';
import '../Utils.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/createNew');
                  },
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(20))),
                  child: const Text("Создать",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ))),
              const Padding(padding: EdgeInsets.only(top: 20)),
              ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            getIdInputDialog());
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.all(20))),
                  child: const Text("Найти по номеру",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ))),
            ],
          ),
        ),
      ),
    ));
  }

  Widget getIdInputDialog() {
    String graphID = "";
    late dynamic content;

    return StatefulBuilder(builder: (context, setState) {
      return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        //this right here
        child: SizedBox(
            height: 200.0,
            width: 400.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 10)),
                    const Center(
                      child: Text(
                        "Введите ID",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    TextField(
                      onChanged: (String newText) {
                        graphID = newText;
                      },
                      style: TextStyle(fontSize: 24),
                    ),
                    Spacer(flex: 1),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/graph',
                                arguments: graphID);
                          },
                          child: Text(
                            "Готово",
                            style: TextStyle(fontSize: 20),
                          )),
                    )
                  ],
                ),
              ),
            )),
      );
    });
  }
}
