import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidadoamigoapp/models/Servico.dart';
import 'package:flutter/material.dart';

class Servicos with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Servico> listEvento = [];
  bool isLoading = false; // Adiciona a flag isLoading

  List<Servico> loadServicosByUsuario(String usuarioId) {
    return listEvento.where((servico) => servico.usuario == usuarioId).toList();
  }

  Future<void> loadServicosFromFirestore() async {
    try {
      isLoading = true; // Define isLoading como true ao começar a carregar
      notifyListeners();

      QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('Servicos').get();
      listEvento.clear();
      for (var element in snapshot.docs) {
        listEvento.add(Servico.fromMap(element.data()));
      }
    } catch (e) {
      print('Erro ao carregar serviços do Firestore: $e');
    } finally {
      isLoading = false; // Define isLoading como false após o carregamento (seja sucesso ou falha)
      notifyListeners();
    }
  }

  void adiciona(Servico servico) {
    _firestore.collection("Servicos").doc(servico.id).set(servico.toMap());
  }

  void remove(Servico servico) {
    _firestore.collection('Servicos').doc(servico.id).delete();
    notifyListeners();
  }
}
