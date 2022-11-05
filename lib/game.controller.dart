
// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, empty_catches, avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_campo_minado/quadrado.class.dart';

class Game{

  Game({required double w, required h}){
    newGame(w, h);
  }

  List<List<Quadrado>> matriz = [];
  int nivel = 12; //nivel eh igual a quantidade de quadrados por linha
  int qtBomba=0;


  //retorna quantidade de bombas que estão no jogo
  int get qtBombaNoJogo{
    int qt = 0;
    for (var vetor in matriz)
      qt += vetor.where((element) => element.isBomb).toList().length;
   return qt;
  }

  //criar novo jogo
  newGame(w, h){
    matriz = [];
    if(nivel<2) nivel = 2;//<2 causara bug por loop
    int totalQuadradosNoJogo = (nivel*nivel);

    double larg = w / nivel;
    double alt = h / nivel;

    int x=0;
    List<Quadrado> vetor=[];
    while(x<nivel) {
      for (int i = 0; i < nivel; i++)
        vetor.add(
            Quadrado(
                index: x%2==0 ? i : i-1,
                altura: alt * 0.9245,
                largura: larg * 0.9712
            )
        );

      matriz.add([...vetor]);
      vetor.clear();
      x++;
    }

    //definir bombas no jogo de modo randomico
    var rng = Random();
    double peso = 0.1;
    int qtbomb = (totalQuadradosNoJogo*peso).floor()==0 ? 2 : (totalQuadradosNoJogo*peso).floor();
    while( qtbomb > qtBombaNoJogo ) {
      int posicaoX = rng.nextInt(nivel);
      int posicaoY = rng.nextInt(nivel);
      matriz[posicaoX][posicaoY].isBomb = true;
      matriz[posicaoX][posicaoY].icon = Icon(Icons.lens, size: larg*0.6, color: Colors.black,);
    }

    //criar nivel de perigo
    calcularNivelDePerigo();
  }


  //calcular nivel de pegigo do jogo com base na quantida de bombos
  calcularNivelDePerigo(){
    for(int eixox=0; eixox<nivel; eixox++){
      for( int eixoy=0; eixoy<nivel; eixoy++ ) {
        if(matriz[eixox][eixoy].isBomb) {
          matriz[eixox][eixoy].nivelDePerigo++; //ponto selecionado
          try{matriz[eixox][eixoy-1].nivelDePerigo++;}catch(e){} //esquerda
          try{matriz[eixox][eixoy+1].nivelDePerigo++;}catch(e){} //direita
          try{matriz[eixox+1][eixoy-1].nivelDePerigo++;}catch(e){} //diagonal inf. esquerda
          try{matriz[eixox+1][eixoy].nivelDePerigo++;}catch(e){} //abaixo
          try{matriz[eixox+1][eixoy+1].nivelDePerigo++;}catch(e){} //diagonal inf. direita
          try{matriz[eixox-1][eixoy-1].nivelDePerigo++;}catch(e){} //diagonal sup. esquerda
          try{matriz[eixox-1][eixoy].nivelDePerigo++;}catch(e){} //abaixo
          try{matriz[eixox-1][eixoy+1].nivelDePerigo++;}catch(e){} //abaixo
        }
      }
    }
  }





  //############### VALIDATE: ESPAÇOS BRANCOS (NIVEL DE PERIGO ZERO) ################
  //INICIO VALIDATE
  onTap(int vertical, int horizontal){
    if(matriz[vertical][horizontal].nivelDePerigo==0)
      try{
        validateTop(vertical, horizontal);
        validateBottom(vertical, horizontal);
        validateEsq(vertical, horizontal);
        validateDir(vertical, horizontal);
      }catch(e){}
  }

  //EIXO VERTICAL: onTAP -> TOPO
  Future<void> validateTop(int vertical, int horizontal, {bool? dipararDiagonal}) async{
    for (vertical = vertical; vertical >=0; vertical--) {
      if(vertical==0) {
        validateEsq(vertical, horizontal, dispararBottomEndTop: false);
        validateDir(vertical, horizontal, dispararBottomEndTop: false);
      }
      if(dipararDiagonal??true) {
        validateDiagSupDir(vertical, horizontal);
        validateDiagSupEsq(vertical, horizontal);
      }
      if( await onVerify(vertical, horizontal) ) break;
    }
  }

  //EIXO VERTICAL: onTAP -> BOTTOM
  Future<void> validateBottom(int vertical, int horizontal, {bool? dipararDiagonal}) async{
    for (vertical = vertical+1; vertical <nivel; vertical++) {
      if(vertical==nivel-1) {
        validateEsq(vertical, horizontal, dispararBottomEndTop: true);
        validateDir(vertical, horizontal, dispararBottomEndTop: true);
      }
      if(dipararDiagonal??true) {
        validateDiagInfDir(vertical, horizontal);
        validateDiagInfEsq(vertical, horizontal);
      }
      if( await onVerify(vertical, horizontal) ) break;
    }
  }


  //VALIDATE: onTAP -> ESQUERDA
  Future<void> validateEsq(int vertical, int horizontal, {bool? dispararBottomEndTop}) async{
    for (horizontal = horizontal-1; horizontal >= 0; horizontal--) {
      if(dispararBottomEndTop??true){//quanto estiver na borda da matriz
        validateDiagSupEsq(vertical, horizontal);
        validateDiagInfEsq(vertical, horizontal);
        await Future.delayed(Duration(microseconds: 500));
        validateTop(vertical, horizontal, dipararDiagonal: true);
        validateBottom(vertical, horizontal, dipararDiagonal: true);
      }
      if( await onVerify(vertical, horizontal) ) break;
    }
  }

  //VALIDATE: onTAP -> DIREITA
  Future<void> validateDir(int vertical, int horizontal, {bool? dispararBottomEndTop}) async{
    for (horizontal = horizontal+1; horizontal < nivel; horizontal++) {
      if(dispararBottomEndTop??true){//quanto estiver na borda da matriz
        validateDiagSupDir(vertical, horizontal);
        validateDiagInfDir(vertical, horizontal);
        await Future.delayed(Duration(microseconds: 500));
        validateTop(vertical, horizontal, dipararDiagonal: true);
        validateBottom(vertical, horizontal, dipararDiagonal: true);
      }
      if( await onVerify(vertical, horizontal) ) break;
    }
  }


  //VALIDATE: DIAGONAL
  Future<void> validateDiagSupDir(int vertical, int horizontal) async{
    vertical-=1;
    for (vertical = vertical; vertical >=0; vertical--) {
      horizontal++;
      if( await onVerify(vertical, horizontal) ) break;
    }
  }

  Future<void> validateDiagSupEsq(int vertical, int horizontal) async{
    vertical-=1;
    for (vertical = vertical; vertical >=0; vertical--) {
      horizontal--;
      if( await onVerify(vertical, horizontal) ) break;
    }
  }

  Future<void> validateDiagInfDir(int vertical, int horizontal) async{
    vertical+=1;
    for (vertical = vertical; vertical <nivel; vertical++) {
      horizontal++;
      if( await onVerify(vertical, horizontal) ) break;
    }
  }

  Future<void> validateDiagInfEsq(int vertical, int horizontal) async{
    vertical+=1;
    for (vertical = vertical; vertical <nivel; vertical++) {
      horizontal--;
      if( await onVerify(vertical, horizontal) ) break;
    }
  }


  //VALIDATE: VERIFICAÇÃO
  //função para não permitir que o index da matriz seja estourado
  onProtegeBorda(int vertical, int horizontal){
    if(vertical<0) vertical=0;
    else if(vertical>nivel) vertical=nivel;
    if(horizontal<0) horizontal=0;
    else if(horizontal>nivel) horizontal=nivel;
    return [vertical, horizontal];
  }

  Future<bool> onVerify(int vertical, int horizontal) async{
    //CRIAR UM PAUSA RANDOMICA
    var rng = Random();
    int tempo = rng.nextInt(1500);

    // var p = onProtegeBorda(vertical, horizontal); //função para não permitir que o index da matriz seja estourado
    // vertical = p[0]; horizontal = p[1];

    try{
      print('position $vertical, $horizontal -> Perigo: ${matriz[vertical][horizontal].nivelDePerigo}  verify: ${matriz[vertical][horizontal].isSelected}');
      await Future.delayed(Duration(milliseconds: tempo));

      if(matriz[vertical][horizontal].nivelDePerigo == 0) {
        matriz[vertical][horizontal].isSelected = true;
        matriz[vertical][horizontal].cor = Colors.grey.shade300;
        //matriz[vertical][horizontal].cor = Colors.red.shade400.withOpacity(0.5);
        return false;
      }else{
        if(!matriz[vertical][horizontal].isBomb) {
          matriz[vertical][horizontal].isSelected = true;
          matriz[vertical][horizontal].cor = Colors.grey.shade300;
          // matriz[vertical][horizontal].cor = Colors.blue.withOpacity(0.3);
        }
        return true;
      }
    }catch(e){
      return false;
    }
  }
  //############### VALIDATE: ESPAÇOS BRANCOS (NIVEL DE PERIGO ZERO) ################ fim
}