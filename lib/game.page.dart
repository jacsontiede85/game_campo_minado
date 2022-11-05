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
  late Game game;
  String _nivel = 'Médio';
  int _valNivel=5;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async{
    await Future.delayed(Duration(seconds: 1));
    game = Game(
        w: 500,
        h: 500,
        nivel: _valNivel
    );
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.flag, color: Colors.redAccent, size: 30,),
                  Observer(builder: (_)=> Text('Bomba: ${game.qtBombaDesarmada} de ${game.qtBombaNoJogo}'),),
                ],
              ),
              Observer(builder: (_)=> Padding(padding: EdgeInsets.only(left: 30,), child: Text('Status: ${game.qtIsChecked} de ${game.nivel*game.nivel}', style: TextStyle(fontSize: 11),),)),
            ],
          ),
          elevation: 0,
          actions: [
            SizedBox(
              width: 80,
              child: DropdownButton<String>(
                  value: _nivel,
                  icon: Icon(Icons.arrow_drop_down_sharp, color: Colors.white,),
                  isExpanded: true,
                  iconSize: 25,
                  elevation: 16,
                  focusColor: Colors.transparent,
                  dropdownColor: Theme.of(context).colorScheme.secondary,
                  style: TextStyle(color: Colors.white),
                  underline: Container(height: 0, color: Theme.of(context).colorScheme.secondary,),
                  onChanged: (String? value) async {
                    switch(value){
                      case 'Fácil': _valNivel = 5; break;
                      case 'Médio': _valNivel = 10; break;
                      case 'Difícil': _valNivel = 20; break;
                    }
                    _nivel = value??'Médio';
                    setState(() {
                      loading=true;
                      init();
                    });
                  },
                  items: ['Fácil', 'Médio', 'Difícil'].map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                            padding: EdgeInsets.only(left: 0, top: 3, bottom: 3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Flexible(child: Text(
                                  value,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.left,
                                ),),
                              ],
                            )
                        )
                    );
                  }).toList()
              )
            ),

            Padding(
              padding: EdgeInsets.only(left: 50, right: 10),
              child: IconButton(
                  onPressed: (){
                    setState(() {
                      loading=true;
                      init();
                    });
                  },
                  icon: Icon(Icons.refresh)
              ),
            ),
          ],
        ),
        body: loading
        ? Container(color: Colors.white, child: Center(child: CircularProgressIndicator(),),)
        : Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 0.7),
              child: Column(
                children: game.matriz.map((vetor) =>
                    Row(
                      children: vetor.map((value) =>
                          GestureDetector(
                            onSecondaryTap: value.isSelected ? null : (){
                              value.isUserCheckedBomb = !value.isUserCheckedBomb;
                              if(value.isUserCheckedBomb){
                                value.isSelected=true;
                                value.icon = Icon(Icons.flag, size: value.largura*0.6, color: Colors.redAccent,);
                                game.validarVitoria;
                              }else{
                                value.isSelected=false;
                                if(value.isBomb)
                                  value.icon = Icon(Icons.lens, size: value.largura*0.6, color: Colors.black,);
                              }
                            },
                            onTap: (value.isSelected || value.isUserCheckedBomb) ? null : (){
                              game.onTap(game.matriz.indexOf(vetor), vetor.indexOf(value));
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
              ),
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Observer(builder: (_)=>
                  Visibility(
                    visible: game.isDerrota,
                    child: Container(
                      color: Colors.red.withOpacity(0.8),
                      child: Center(
                        child: Text('Você perdeu!', style: TextStyle(fontSize: 30, color: Colors.white),),
                      ),
                    ),
                  )
              ),
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Observer(builder: (_)=>
                  Visibility(
                    visible: game.isVitoria,
                    child: Container(
                      color: Colors.green.withOpacity(0.8),
                      child: Center(
                        child: Text('Parabéns! Você venceu.', style: TextStyle(fontSize: 30, color: Colors.white),),
                      ),
                    ),
                  )
              ),
            ),

          ],
        )
    );
  }
}