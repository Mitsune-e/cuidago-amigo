
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidadoamigoapp/Util/Utils.dart';
import 'package:cuidadoamigoapp/models/cliente.dart';
import 'package:flutter/material.dart';


class Clientes with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Cliente> listEvento = [];

  adiciona(Cliente cliente) {
  if (Utils.validarCPF(cliente.cpf)) {
    _firestore.collection("Clientes").doc(cliente.id).set(cliente.toMap());
    print('Está chamando essa função');
    print(cliente.toMap());
  } else {
    print('CPF inválido');
  }
}

  editar(Cliente cliente) {
    // Certifique-se de que o endereço já existe na lista
    int index = listEvento.indexWhere((e) => e.id == cliente.id);
    
    if (index != -1) {
      // Atualiza a lista local
      listEvento[index] = cliente;

      // Atualiza os dados no Firestore
      _firestore.collection("Clientes").doc(cliente.id).set(cliente.toMap());
      
      notifyListeners();
    }
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

 
  Cliente? loadClienteByIdSync(String clienteId) {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          _firestore.collection('Clientes').doc(clienteId).get() as DocumentSnapshot<Map<String, dynamic>>;

      if (snapshot.exists) {
        return Cliente.fromMap(snapshot.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao carregar cliente: $e');
      return null;
    }
  }

  Future<Cliente?> loadClienteById(String clientId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('Clientes').doc(clientId).get();

      if (snapshot.exists) {
        return Cliente.fromMap(snapshot.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao carregar cliente: $e');
      return null;
    }
  }


}
