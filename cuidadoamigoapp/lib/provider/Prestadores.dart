
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cuidadoamigoapp/models/Prestador.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        await _firestore.collection('Prestador').get();
    for (var element in snapshot.docs) {
      temp.add(Prestador.fromMap(element.data()));
    }
    return temp;
  }

  void remove(Prestador prestador) {
    _firestore.collection('Prestadores').doc(prestador.id).delete();
    notifyListeners();
  }

Future<Prestador?> loadPrestadorById(String prestadorId) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('Prestadores').doc(prestadorId).get();

    if (snapshot.exists) {
      return Prestador.fromMap(snapshot.data()!);
    } else {
      return null;
    }
  } catch (e) {
    print('Erro ao carregar prestador: $e');
    return null;
  }
 
}

   Prestador? loadPrestadorByIdSync(String prestadorId) {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          _firestore.collection('Prestadores').doc(prestadorId).get() as DocumentSnapshot<Map<String, dynamic>>;

      if (snapshot.exists) {
        return Prestador.fromMap(snapshot.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao carregar prestador: $e');
      return null;
    }
  }

Future<String?> getChavePixDoPrestadorLogado(String prestadorId) async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      User? user = _auth.currentUser;

      if (user != null) {
        DocumentSnapshot prestadorSnapshot = await FirebaseFirestore.instance
            .collection('Prestadores')
            .doc(user.uid)
            .get();

        if (prestadorSnapshot.exists) {
          // Obtenha a chave PIX do documento do prestador
          return prestadorSnapshot['chavePix'];
        }
      }
    } catch (e) {
      print('Erro ao obter chave PIX do prestador logado: $e');
    }

    return null; 
  }

Prestador? _prestadorLogado;

  Prestador? get prestadorLogado => _prestadorLogado;

  void setPrestadorLogado(Prestador prestador) {
    _prestadorLogado = prestador;
  }

  // Método para atualizar o saldo do prestador
  void atualizarSaldo(double valor, double d) {
    if (_prestadorLogado != null) {
      _prestadorLogado!.saldo = (_prestadorLogado!.saldo ?? 0) + valor;

      // Notificar ou emitir um evento para informar aos interessados sobre a mudança
      notifyListeners();
    }
  }

}

