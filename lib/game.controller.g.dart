// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$Game on GameBase, Store {
  Computed<int>? _$qtBombaNoJogoComputed;

  @override
  int get qtBombaNoJogo =>
      (_$qtBombaNoJogoComputed ??= Computed<int>(() => super.qtBombaNoJogo,
              name: 'GameBase.qtBombaNoJogo'))
          .value;
  Computed<int>? _$qtBombaDesarmadaComputed;

  @override
  int get qtBombaDesarmada => (_$qtBombaDesarmadaComputed ??= Computed<int>(
          () => super.qtBombaDesarmada,
          name: 'GameBase.qtBombaDesarmada'))
      .value;
  Computed<int>? _$qtIsCheckedComputed;

  @override
  int get qtIsChecked => (_$qtIsCheckedComputed ??=
          Computed<int>(() => super.qtIsChecked, name: 'GameBase.qtIsChecked'))
      .value;

  late final _$nivelAtom = Atom(name: 'GameBase.nivel', context: context);

  @override
  int get nivel {
    _$nivelAtom.reportRead();
    return super.nivel;
  }

  @override
  set nivel(int value) {
    _$nivelAtom.reportWrite(value, super.nivel, () {
      super.nivel = value;
    });
  }

  late final _$isDerrotaAtom =
      Atom(name: 'GameBase.isDerrota', context: context);

  @override
  bool get isDerrota {
    _$isDerrotaAtom.reportRead();
    return super.isDerrota;
  }

  @override
  set isDerrota(bool value) {
    _$isDerrotaAtom.reportWrite(value, super.isDerrota, () {
      super.isDerrota = value;
    });
  }

  late final _$isVitoriaAtom =
      Atom(name: 'GameBase.isVitoria', context: context);

  @override
  bool get isVitoria {
    _$isVitoriaAtom.reportRead();
    return super.isVitoria;
  }

  @override
  set isVitoria(bool value) {
    _$isVitoriaAtom.reportWrite(value, super.isVitoria, () {
      super.isVitoria = value;
    });
  }

  @override
  String toString() {
    return '''
nivel: ${nivel},
isDerrota: ${isDerrota},
isVitoria: ${isVitoria},
qtBombaNoJogo: ${qtBombaNoJogo},
qtBombaDesarmada: ${qtBombaDesarmada},
qtIsChecked: ${qtIsChecked}
    ''';
  }
}
