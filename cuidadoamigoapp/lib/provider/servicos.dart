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
  Future<Servico?> data(String data) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('Prestadores').doc(data).get();

    if (snapshot.exists) {
      return Servico.fromMap(snapshot.data()!);
    } else {
      return null;
    }
  } catch (e) {
    print('Erro ao carregar cliente: $e');
    return null;
  }
}

Future<Servico?> horainicio(String horaInicio) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('Prestadores').doc(horaInicio).get();

    if (snapshot.exists) {
      return Servico.fromMap(snapshot.data()!);
    } else {
      return null;
    }
  } catch (e) {
    print('Erro ao carregar cliente: $e');
    return null;
  }
}

Future<Servico?> horaFim(String horaFim) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('Prestadores').doc(horaFim).get();

    if (snapshot.exists) {
      return Servico.fromMap(snapshot.data()!);
    } else {
      return null;
    }
  } catch (e) {
    print('Erro ao carregar cliente: $e');
    return null;
  }
}
}
