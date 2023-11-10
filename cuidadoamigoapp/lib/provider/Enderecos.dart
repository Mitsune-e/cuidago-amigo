import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidadoamigoapp/models/Endereco.dart';
import 'package:flutter/material.dart';


class Enderecos with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Endereco> listEndereco = [];

  adiciona(Endereco endereco) {
    _firestore.collection("Enderecos").doc(endereco.id).set(endereco.toMap());
  }

  void edita(Endereco endereco) {
    // Certifique-se de que o endereço já existe na lista
    int index = listEndereco.indexWhere((e) => e.id == endereco.id);
    
    if (index != -1) {
      // Atualiza a lista local
      listEndereco[index] = endereco;

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

 void removeById(String enderecoId) {
    _firestore.collection('Enderecos').doc(enderecoId).delete();

    // Remove o endereço da lista local
    listEndereco.removeWhere((endereco) => endereco.id == enderecoId);

    notifyListeners();
  }
}