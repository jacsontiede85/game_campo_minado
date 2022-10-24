import 'package:flutter/material.dart';

class Quadrado{
  int index=0;
  int nivelDePerigo=0;
  double altura = 0;
  double largura = 0;
  Color cor = Colors.grey;
  bool isBomb = false;
  bool isSelected = false;
  bool isUserCheckedBomb = false;
  Icon icon = const Icon(Icons.lens, size: 0, color: Colors.black,);

  set setBomb(isbomb) => isBomb = isbomb;

  Quadrado({required index, required this.largura, required this.altura}){
    cor = index % 2==0 ? Colors.lightGreen : Colors.lightGreen.shade700;
    //cor = Colors.grey.shade300;
  }

  //entrar com o valor de perigo e definir cor do texto de perigo
  getCorNivelDePerigo(){
    switch(nivelDePerigo){
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red.shade500;
      case 4:
        return Colors.red.shade600;
      case 5:
        return Colors.red.shade700;
      case 6:
        return Colors.red.shade800;
      case 7:
        return Colors.red.shade900;
      case 8:
        return Colors.deepOrange;
    }
  }
}