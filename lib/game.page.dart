// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'game.controller.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  bool loading = true;
  Game? game;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async{
    await Future.delayed(Duration(seconds: 1));
    game = Game(
        w: 500,
        h: 500
    );
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: loading
        ? Container(color: Colors.redAccent, child: Center(child: CircularProgressIndicator(color: Colors.white,),),)
        : Column(
          children: game!.matriz.map((vetor) =>
              Row(
                children: vetor.map((value) =>
                    GestureDetector(
                      onSecondaryTap: value.isSelected ? null : (){
                        value.isUserCheckedBomb = !value.isUserCheckedBomb;
                        if(value.isUserCheckedBomb)
                          value.icon = Icon(Icons.flag, size: value.largura*0.6, color: Colors.redAccent,);
                        else
                        if(value.isBomb)
                          value.icon = Icon(Icons.lens, size: value.largura*0.6, color: Colors.black,);
                      },
                      onTap: (value.isSelected || value.isUserCheckedBomb) ? null : (){
                        game!.onTap(game!.matriz.indexOf(vetor), vetor.indexOf(value));
                        value.isSelected = true;
                        value.isUserCheckedBomb = false;
                        value.cor = Colors.grey.shade300;
                      },
                      child: Observer(
                        builder: (_)=>
                          Container(
                            width: value.largura,
                            height: value.altura,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 0.2),
                              color: value.cor,
                            ),
                            child: Center(
                              child: (value.isSelected && (value.isBomb || value.isUserCheckedBomb)) ||  value.isUserCheckedBomb
                                  ? value.icon
                                  : Text(
                                //'${value.nivelDePerigo}',
                                value.isSelected ? '${value.nivelDePerigo>0 ? value.nivelDePerigo : ''}' : '',
                                style: TextStyle(color: value.getCorNivelDePerigo(), fontSize: value.largura*0.4, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                      ),
                    ),
                ).toList(),
              ),
          ).toList(),
        )
    );
  }
}