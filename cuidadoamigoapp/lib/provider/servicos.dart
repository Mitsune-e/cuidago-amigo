
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidadoamigoapp/models/Prestador.dart';
import 'package:cuidadoamigoapp/models/servico.dart';

import 'package:flutter/material.dart';


class Servicos with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Servico> listEvento = [];

  adiciona(Servico servico) {
    _firestore.collection("Servicos").doc(servico.id).set(servico.toMap());
  }

  caregar() async {
    List<Servico> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('Servicos').get();
    for (var element in snapshot.docs) {
      temp.add(Servico.fromMap(element.data()));
    }
    return temp;
  }

  void remove(Servico servico) {
    _firestore.collection('Servicos').doc(servico.id).delete();
    notifyListeners();
  }
}
