
// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures, empty_catches, avoid_print

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_campo_minado/quadrado.class.dart';

class Game{

  Game({required double w, required h}){
  newGame(w, h);
}

  List<List<Quadrado>> matriz = [];
  int nivel = 8; //nivel eh igual a quantidade de quadrados por linha
  int qtBomba=0;


  int get qtBombaNoJogo{
    int qt = 0;
    for (var vetor in matriz)
      qt += vetor.where((element) => element.isBomb).toList().length;
   return qt;
  }

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

  onTap(int eixoX, int eixoY){
    if(matriz[eixoX][eixoY].nivelDePerigo==0)
      try{
        validateTopAndBottom(eixoX, eixoY);
      }catch(e){}
  }


  validateTopAndBottom(int eixoX, int eixoY){
    int x = eixoX, y= eixoY;
    //validateTopAndBottom realizar a analise com movimento vertical ( para cima e para baixo a partir do ponto selecionado )
    if(!matriz[x][y].isSelected){

      //TOP
      for(x=eixoX; x>=0; x--){
        if(matriz[x][y].nivelDePerigo==0 && !matriz[x][y].isSelected){
          validateLeftAndRight(x, y-1);
          validateDiagonal(x, y);
          matriz[x][y].isSelected = true;
          matriz[x][y].cor = Colors.grey.shade300;
        } else {
          if(!matriz[x][y].isBomb) {
            matriz[x][y].isSelected = true;
            matriz[x][y].cor = Colors.grey.shade300;
          }
          break;
        }
      }

      //BOTTOM
      x = eixoX; y= eixoY;
      for(x=eixoX; x<nivel; x++){
        if(matriz[x][y].nivelDePerigo==0 && !matriz[x][y].isSelected){
          validateLeftAndRight(x, y+1);
          validateDiagonal(x, y);
          matriz[x][y].isSelected = true;
          matriz[x][y].cor = Colors.grey.shade300;
        } else {
          if(!matriz[x][y].isBomb) {
            matriz[x][y].isSelected = true;
            matriz[x][y].cor = Colors.grey.shade300;
          }
          break;
        }
      }

    }
  }//fim validateTopAndBottom

  validateLeftAndRight(int eixoX, int eixoY){
    int x = eixoX, y= eixoY;

    //RIGHT
    for(y=eixoY; y<nivel; y++){
      if(matriz[x][y].nivelDePerigo==0 && !matriz[x][y].isSelected){
        matriz[x][y].isSelected = true;
        matriz[x][y].cor = Colors.grey.shade300;
        validateTopAndBottom(x-1, y);
        validateTopAndBottom(x+1, y);
        validateDiagonal(x, y);
      } else {
        if(!matriz[x][y].isBomb) {
          matriz[x][y].isSelected = true;
          matriz[x][y].cor = Colors.grey.shade300;
        }
        break;
      }
    }

    //LEFT
    x = eixoX; y= eixoY;
    for(y=eixoY; y>=0; y--){
      if(matriz[x][y].nivelDePerigo==0 && !matriz[x][y].isSelected){
        matriz[x][y].isSelected = true;
        matriz[x][y].cor = Colors.grey.shade300;
        validateTopAndBottom(x-1, y);
        validateTopAndBottom(x+1, y);
        validateDiagonal(x, y);
      } else {
        if(!matriz[x][y].isBomb) {
          matriz[x][y].isSelected = true;
          matriz[x][y].cor = Colors.grey.shade300;
        }
        break;
      }
    }


  }

  validateDiagonal(int eixoX, int eixoY){
    int x = eixoX, y= eixoY;

    //DIAGONAL SUP. DIREITA
    for(y=eixoY+1; y<nivel; y++){
      x-=1;
      if(matriz[x][y].nivelDePerigo==0 && !matriz[x][y].isSelected){
        validateTopAndBottom(x, y);
        matriz[x][y].isSelected = true;
        matriz[x][y].cor = Colors.grey.shade300;
      } else {
        if(!matriz[x][y].isBomb) {
          matriz[x][y].isSelected = true;
          matriz[x][y].cor = Colors.grey.shade300;
        }
        break;
      }
    }

    //DIAGONAL SUP. ESQUERDA
    x = eixoX; y= eixoY;
    for(y=eixoY-1; y>=0; y--){
      x-=1;
      if(matriz[x][y].nivelDePerigo==0 && !matriz[x][y].isSelected){
        validateTopAndBottom(x, y);
        matriz[x][y].isSelected = true;
        matriz[x][y].cor = Colors.grey.shade300;
      } else {
        if(!matriz[x][y].isBomb) {
          matriz[x][y].isSelected = true;
          matriz[x][y].cor = Colors.grey.shade300;
        }
        break;
      }
    }

    //DIAGONAL INFERIOR DIREITA
    x = eixoX; y= eixoY;
    for(y=eixoY+1; y<nivel; y++){
      x+=1;
      if(matriz[x][y].nivelDePerigo==0 && !matriz[x][y].isSelected){
        validateTopAndBottom(x, y);
        matriz[x][y].isSelected = true;
        matriz[x][y].cor = Colors.grey.shade300;
      } else {
        if(!matriz[x][y].isBomb) {
          matriz[x][y].isSelected = true;
          matriz[x][y].cor = Colors.grey.shade300;
        }
        break;
      }
    }

    //DIAGONAL INFERIOR ESQUERDA
    x = eixoX; y= eixoY;
    for(y=eixoY-1; y>=0; y--){
      x+=1;
      if(matriz[x][y].nivelDePerigo==0 && !matriz[x][y].isSelected){
        validateTopAndBottom(x, y);
        matriz[x][y].isSelected = true;
        matriz[x][y].cor = Colors.grey.shade300;
      } else {
        if(!matriz[x][y].isBomb) {
          matriz[x][y].isSelected = true;
          matriz[x][y].cor = Colors.grey.shade300;
        }
        break;
      }
    }

  }

}