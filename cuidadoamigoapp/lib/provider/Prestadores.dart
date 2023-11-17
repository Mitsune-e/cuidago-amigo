
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

Future<Prestador?> loadClienteById(String prestadorId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('Prestadores').doc(prestadorId).get();

    if (snapshot.exists) {
      return Prestador.fromMap(snapshot.data()!);
    } else {
      return null;
    }
  } catch (e) {
    print('Erro ao carregar cliente: $e');
    return null;
  }
}
   Prestador? loadClienteByIdSync(String prestadorId) {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          _firestore.collection('Prestadores').doc(prestadorId).get() as DocumentSnapshot<Map<String, dynamic>>;

      if (snapshot.exists) {
        return Prestador.fromMap(snapshot.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao carregar cliente: $e');
      return null;
    }
  }

}
