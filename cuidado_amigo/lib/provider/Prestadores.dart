import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidado_amigo/models/Prestador.dart';
import 'package:flutter/material.dart';

class Prestadores with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Prestador> listEvento = [];

  void adiciona(Prestador prestador) {
    _firestore
        .collection("Prestadores")
        .doc(prestador.id)
        .set(prestador.toMap());
  }

  Future<List<Prestador>> caregar() async {
    List<Prestador> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('Clientes').get();
    for (var element in snapshot.docs) {
      temp.add(Prestador.fromMap(element.data()));
    }
    return temp;
  }

  Future<Prestador> carregarById(String id) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('Prestadores').get();

    final dadosPrestador = snapshot.docs.firstWhere((item) => item.id == id);

    final prestadorSelecionado = Prestador.fromMap(dadosPrestador.data());
    return prestadorSelecionado;
  }

  void remove(Prestador prestador) {
    _firestore.collection('Prestadores').doc(prestador.id).delete();
    notifyListeners();
  }

  void removeById(String prestadorId) {
    // Remove do Firestore
    _firestore.collection('Prestadores').doc(prestadorId).delete();

    // Remove da lista local
    listEvento.removeWhere((prestador) => prestador.id == prestadorId);

    // Notifica os ouvintes que a lista foi alterada
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
      DocumentSnapshot<Map<String, dynamic>> snapshot = _firestore
          .collection('Prestadores')
          .doc(prestadorId)
          .get() as DocumentSnapshot<Map<String, dynamic>>;

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
