import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidadoamigoapp/models/Endereco.dart';
import 'package:flutter/material.dart';


class Enderecos with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Endereco> listEvento = [];

  adiciona(Endereco endereco) {
    _firestore.collection("Enderecos").doc(endereco.id).set(endereco.toMap());
  }

  void edita(Endereco endereco) {
    // Certifique-se de que o endereço já existe na lista
    int index = listEvento.indexWhere((e) => e.id == endereco.id);
    
    if (index != -1) {
      // Atualiza a lista local
      listEvento[index] = endereco;

      // Atualiza os dados no Firestore
      _firestore.collection("Enderecos").doc(endereco.id).set(endereco.toMap());
      
      notifyListeners();
    }
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