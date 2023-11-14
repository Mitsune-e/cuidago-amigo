
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidadoamigoapp/models/Prestador.dart';

import 'package:flutter/material.dart';


class Prestadores with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Prestador> listEvento = [];

  adiciona(Prestador prestador) {
    _firestore.collection("Prestadores").doc(prestador.id).set(prestador.toMap());
  }

  caregar() async {
    List<Prestador> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('Clientes').get();
    for (var element in snapshot.docs) {
      temp.add(Prestador.fromMap(element.data()));
    }
    return temp;
  }

  void remove(Prestador prestador) {
    _firestore.collection('Prestadores').doc(prestador.id).delete();
    notifyListeners();
  }
}
