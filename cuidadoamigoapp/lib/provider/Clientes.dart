/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidadoamigoapp/models/cliente.dart';
import 'package:flutter/material.dart';


/class Clientes with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Cliente> listEvento = [];

  adiciona(Cliente cliente) {
    _firestore.collection("Clientes").doc(cliente.id).set(cliente.toMap());
  }

  caregar() async {
    List<Cliente> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('Clientes').get();
    for (var element in snapshot.docs) {
      temp.add(Cliente.fromMap(element.data()));
    }
    return temp;
  }

  void remove(Cliente cliente) {
    _firestore.collection('Clientes').doc(cliente.id).delete();
    notifyListeners();
  }
}
*/