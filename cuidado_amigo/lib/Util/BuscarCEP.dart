import 'package:search_cep/search_cep.dart';

buscarCEP(String cep) async {
  final viaCepSearchCep = ViaCepSearchCep();
  final resultJson = await viaCepSearchCep.searchInfoByCep(cep: cep);

  ViaCepInfo result = ViaCepInfo();

  resultJson.fold(((err) => throw Exception(err)), (info) => result = info);

  return result;
}
