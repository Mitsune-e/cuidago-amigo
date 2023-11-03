import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidadoamigoapp/models/Endereco.dart';
import 'package:flutter/material.dart';


class Enderecos with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Endereco> listEvento = [];

  adiciona(Endereco endereco) {
    _firestore.collection("Enderecos").doc(endereco.id).set(endereco.toMap());
  }

  caregar() async {
    List<Endereco> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('Enderecos').get();
    for (var element in snapshot.docs) {
      temp.add(Endereco.fromMap(element.data()));
    }
    return temp;
  }

  void remove(Endereco endereco) {
    _firestore.collection('Enderecos').doc(endereco.id).delete();
    notifyListeners();
  }
}