
// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, empty_catches, avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_campo_minado/quadrado.class.dart';
import 'package:mobx/mobx.dart';
part 'game.controller.g.dart';

class Game = GameBase with _$Game;
abstract class GameBase with Store{

  GameBase({required double w, required h, required this.nivel}){
    newGame(w, h);
  }

  List<List<Quadrado>> matriz = [];

  @observable
  int nivel = 10; //nivel eh igual a quantidade de quadrados por linha
  double peso = 0.10; //(10% de bombas)

  @observable
  bool isDerrota=false, isVitoria=false;


  //retorna quantidade de bombas que estão no jogo
  @computed
  int get qtBombaNoJogo{
    int qt = 0;
    for (var vetor in matriz) qt += vetor.where((element) => element.isBomb).toList().length;
   return qt;
  }

  @computed
  int get qtBombaDesarmada{
    int qt = 0;
    for (var vetor in matriz) qt += vetor.where((element) => element.isUserCheckedBomb).toList().length;
    return qt;
  }

  @computed
  int get qtIsChecked{
    int qt = 0;
    for (var vetor in matriz) qt += vetor.where((element) => element.isSelected).toList().length;
    return qt;
  }


  get validarVitoria{
    int check = 0, qtBombaDesativadaValida=0;
    for (var vetor in matriz) check += vetor.where((element) => element.isSelected).toList().length;
    for (var vetor in matriz) qtBombaDesativadaValida += vetor.where((element) => element.isUserCheckedBomb && element.isBomb).toList().length;
    if(qtBombaDesativadaValida == qtBombaNoJogo  &&  check == (nivel*nivel) && qtBombaNoJogo == qtBombaDesarmada)
      isVitoria = true;
  }

  //criar novo jogo
  newGame(w, h){
    isDerrota=false; isVitoria=false;
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

    for(int eixox=0; eixox<nivel; eixox++){
      for( int eixoy=0; eixoy<nivel; eixoy++ ) {
        if(matriz[eixox][eixoy].isBomb) {
          matriz[eixox][eixoy].nivelDePerigo=50; //abaixo
        }
      }
    }
  }


  explodirTodasAsBombas() async{
    for(var vetor in matriz)
      for(var value in vetor){
        if(value.isBomb){
          value.isSelected=true;
          value.cor = Colors.redAccent.shade200.withOpacity(0.5);
          await Future.delayed(Duration(milliseconds: 100));
        }
      }
    isDerrota = true;
  }




  //############### VALIDATE: ESPAÇOS BRANCOS (NIVEL DE PERIGO ZERO) ################
  //INICIO VALIDATE
  onTap(int vertical, int horizontal){
    matriz[vertical][horizontal].isSelected = true;
    matriz[vertical][horizontal].isUserCheckedBomb = false;
    if(!matriz[vertical][horizontal].isBomb) matriz[vertical][horizontal].cor = Colors.grey.shade300;

    if(matriz[vertical][horizontal].isBomb) {
      matriz[vertical][horizontal].isSelected=true;
      matriz[vertical][horizontal].cor = Colors.redAccent.shade200.withOpacity(0.5);
      explodirTodasAsBombas();
    }else
      if(matriz[vertical][horizontal].nivelDePerigo==0)
        try{
          move(vertical, horizontal);
        }catch(e){}

    validarVitoria;
  }


  Future<void> move(int vertical, int horizontal) async{
    try{
      await Future.delayed(Duration(milliseconds: 10));

      //TOP
      if(vertical-1 >=0)
        if(!matriz[vertical-1][horizontal].isSelected){
          if(matriz[vertical-1][horizontal].nivelDePerigo == 0){
            matriz[vertical-1][horizontal].isSelected = true;
            matriz[vertical-1][horizontal].cor = Colors.grey.shade300;
            move(vertical-1, horizontal);
          }else{
            if(!matriz[vertical-1][horizontal].isBomb) {
              matriz[vertical-1][horizontal].isSelected = true;
              matriz[vertical-1][horizontal].cor = Colors.grey.shade300;
            }
          }
        }

      //BOTTOM
      if(vertical+1 < nivel)
        if(!matriz[vertical+1][horizontal].isSelected){
          if(matriz[vertical+1][horizontal].nivelDePerigo == 0){
            matriz[vertical+1][horizontal].isSelected = true;
            matriz[vertical+1][horizontal].cor = Colors.grey.shade300;
            move(vertical+1, horizontal);
          }else{
            if(!matriz[vertical+1][horizontal].isBomb) {
              matriz[vertical+1][horizontal].isSelected = true;
              matriz[vertical+1][horizontal].cor = Colors.grey.shade300;
            }
          }
        }

      //LEFT
      if(horizontal-1 >=0)
        if(!matriz[vertical][horizontal-1].isSelected){
          if(matriz[vertical][horizontal-1].nivelDePerigo == 0){
            matriz[vertical][horizontal-1].isSelected = true;
            matriz[vertical][horizontal-1].cor = Colors.grey.shade300;
            move(vertical, horizontal-1);
          }else{
            if(!matriz[vertical][horizontal-1].isBomb) {
              matriz[vertical][horizontal-1].isSelected = true;
              matriz[vertical][horizontal-1].cor = Colors.grey.shade300;
            }
          }
        }

      //RIGTH
      if(horizontal+1 < nivel)
        if(!matriz[vertical][horizontal+1].isSelected){
          if(matriz[vertical][horizontal+1].nivelDePerigo == 0){
            matriz[vertical][horizontal+1].isSelected = true;
            matriz[vertical][horizontal+1].cor = Colors.grey.shade300;
            move(vertical, horizontal+1);
          }else{
            if(!matriz[vertical][horizontal+1].isBomb) {
              matriz[vertical][horizontal+1].isSelected = true;
              matriz[vertical][horizontal+1].cor = Colors.grey.shade300;
            }
          }
        }

      if(matriz[vertical][horizontal].nivelDePerigo == 0){
        setDiagonalSelected(vertical, horizontal);
      }
    }catch(e){
    }
  }



  Future<void> setDiagonalSelected(int vertical, int horizontal) async{
    if(vertical-1 >=0 && horizontal-1>=0)
      if(matriz[vertical][horizontal].nivelDePerigo==0 && matriz[vertical][horizontal-1].nivelDePerigo>0 && matriz[vertical-1][horizontal].nivelDePerigo>0){
        if(matriz[vertical-1][horizontal-1].nivelDePerigo==0)
          move(vertical-1, horizontal-1);
        else{
          matriz[vertical-1][horizontal-1].isSelected = true;
          matriz[vertical-1][horizontal-1].cor = Colors.grey.shade300;
        }
      }

    if(vertical+1 <nivel && horizontal+1 <nivel)
      if(matriz[vertical][horizontal].nivelDePerigo==0 && matriz[vertical+1][horizontal].nivelDePerigo>0 && matriz[vertical][horizontal+1].nivelDePerigo>0){
        if(matriz[vertical+1][horizontal+1].nivelDePerigo==0)
          move(vertical+1, horizontal+1);
        else{
          matriz[vertical+1][horizontal+1].isSelected = true;
          matriz[vertical+1][horizontal+1].cor = Colors.grey.shade300;
        }
      }

    if(vertical-1 >=0 && horizontal+1<nivel)
      if(matriz[vertical][horizontal].nivelDePerigo==0 && matriz[vertical-1][horizontal].nivelDePerigo>0 && matriz[vertical][horizontal+1].nivelDePerigo>0){
        if(matriz[vertical-1][horizontal+1].nivelDePerigo==0)
          move(vertical-1, horizontal+1);
        else{
          matriz[vertical-1][horizontal+1].isSelected = true;
          matriz[vertical-1][horizontal+1].cor = Colors.grey.shade300;
        }
      }

    if(vertical+1 <nivel && horizontal-1 >=0)
      if(matriz[vertical][horizontal].nivelDePerigo==0 && matriz[vertical+1][horizontal].nivelDePerigo>0 && matriz[vertical][horizontal-1].nivelDePerigo>0){
        if(matriz[vertical+1][horizontal-1].nivelDePerigo==0)
          move(vertical+1, horizontal-1);
        else{
          matriz[vertical+1][horizontal-1].isSelected = true;
          matriz[vertical+1][horizontal-1].cor = Colors.grey.shade300;
        }
      }

    if(vertical-1 >=0 && horizontal-1>=0)
      if(matriz[vertical][horizontal].nivelDePerigo==0 && matriz[vertical-1][horizontal].nivelDePerigo>0 && matriz[vertical][horizontal-1].nivelDePerigo>0){
        matriz[vertical-1][horizontal-1].isSelected = true;
        matriz[vertical-1][horizontal-1].cor = Colors.grey.shade300;
      }


    if(vertical+1==nivel && horizontal+1<nivel && matriz[vertical][horizontal].nivelDePerigo==0){
      if(horizontal+1<nivel){
        matriz[vertical][horizontal+1].isSelected = true;
        matriz[vertical][horizontal+1].cor = Colors.grey.shade300;
      }
      if(horizontal-1>=0){
        matriz[vertical][horizontal-1].isSelected = true;
        matriz[vertical][horizontal-1].cor = Colors.grey.shade300;
      }
    }
  }
  //############### VALIDATE: ESPAÇOS BRANCOS (NIVEL DE PERIGO ZERO) ################ fim
}