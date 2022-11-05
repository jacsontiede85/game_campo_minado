// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quadrado.class.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Quadrado on QuadradoBase, Store {
  late final _$indexAtom = Atom(name: 'QuadradoBase.index', context: context);

  @override
  int get index {
    _$indexAtom.reportRead();
    return super.index;
  }

  @override
  set index(int value) {
    _$indexAtom.reportWrite(value, super.index, () {
      super.index = value;
    });
  }

  late final _$nivelDePerigoAtom =
      Atom(name: 'QuadradoBase.nivelDePerigo', context: context);

  @override
  int get nivelDePerigo {
    _$nivelDePerigoAtom.reportRead();
    return super.nivelDePerigo;
  }

  @override
  set nivelDePerigo(int value) {
    _$nivelDePerigoAtom.reportWrite(value, super.nivelDePerigo, () {
      super.nivelDePerigo = value;
    });
  }

  late final _$alturaAtom = Atom(name: 'QuadradoBase.altura', context: context);

  @override
  double get altura {
    _$alturaAtom.reportRead();
    return super.altura;
  }

  @override
  set altura(double value) {
    _$alturaAtom.reportWrite(value, super.altura, () {
      super.altura = value;
    });
  }

  late final _$larguraAtom =
      Atom(name: 'QuadradoBase.largura', context: context);

  @override
  double get largura {
    _$larguraAtom.reportRead();
    return super.largura;
  }

  @override
  set largura(double value) {
    _$larguraAtom.reportWrite(value, super.largura, () {
      super.largura = value;
    });
  }

  late final _$corAtom = Atom(name: 'QuadradoBase.cor', context: context);

  @override
  Color get cor {
    _$corAtom.reportRead();
    return super.cor;
  }

  @override
  set cor(Color value) {
    _$corAtom.reportWrite(value, super.cor, () {
      super.cor = value;
    });
  }

  late final _$isBombAtom = Atom(name: 'QuadradoBase.isBomb', context: context);

  @override
  bool get isBomb {
    _$isBombAtom.reportRead();
    return super.isBomb;
  }

  @override
  set isBomb(bool value) {
    _$isBombAtom.reportWrite(value, super.isBomb, () {
      super.isBomb = value;
    });
  }

  late final _$isSelectedAtom =
      Atom(name: 'QuadradoBase.isSelected', context: context);

  @override
  bool get isSelected {
    _$isSelectedAtom.reportRead();
    return super.isSelected;
  }

  @override
  set isSelected(bool value) {
    _$isSelectedAtom.reportWrite(value, super.isSelected, () {
      super.isSelected = value;
    });
  }

  late final _$isUserCheckedBombAtom =
      Atom(name: 'QuadradoBase.isUserCheckedBomb', context: context);

  @override
  bool get isUserCheckedBomb {
    _$isUserCheckedBombAtom.reportRead();
    return super.isUserCheckedBomb;
  }

  @override
  set isUserCheckedBomb(bool value) {
    _$isUserCheckedBombAtom.reportWrite(value, super.isUserCheckedBomb, () {
      super.isUserCheckedBomb = value;
    });
  }

  late final _$iconAtom = Atom(name: 'QuadradoBase.icon', context: context);

  @override
  Icon get icon {
    _$iconAtom.reportRead();
    return super.icon;
  }

  @override
  set icon(Icon value) {
    _$iconAtom.reportWrite(value, super.icon, () {
      super.icon = value;
    });
  }

  @override
  String toString() {
    return '''
index: ${index},
nivelDePerigo: ${nivelDePerigo},
altura: ${altura},
largura: ${largura},
cor: ${cor},
isBomb: ${isBomb},
isSelected: ${isSelected},
isUserCheckedBomb: ${isUserCheckedBomb},
icon: ${icon}
    ''';
  }
}
