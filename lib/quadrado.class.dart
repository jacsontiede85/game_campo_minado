import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
part 'quadrado.class.g.dart';

class Quadrado = QuadradoBase with _$Quadrado;
abstract class QuadradoBase with Store{
  @observable
  int index=0;
  @observable
  int nivelDePerigo=0;
  @observable
  double altura = 0;
  @observable
  double largura = 0;
  @observable
  Color cor = Colors.grey;
  @observable
  bool isBomb = false;
  @observable
  bool isSelected = false;
  @observable
  bool isUserCheckedBomb = false;
  @observable
  Icon icon = const Icon(Icons.lens, size: 0, color: Colors.black,);

  set setBomb(isbomb) => isBomb = isbomb;

  QuadradoBase({required index, required this.largura, required this.altura}){
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