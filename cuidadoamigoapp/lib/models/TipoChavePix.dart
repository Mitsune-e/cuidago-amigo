enum TipoChavePix { CPF, CNPJ, Telefone, Email, ChaveAleatoria, Outro }

class ValidadorChavePix {
  static TipoChavePix validarChave(String chave) {
    chave = chave.replaceAll(RegExp(r'\D'), ''); // Remove caracteres não numéricos

    // Verifica o formato da chave PIX
    if (RegExp(r"^\d{11}$").hasMatch(chave)) {
      return TipoChavePix.CPF;
    } else if (RegExp(r"^\d{14}$").hasMatch(chave)) {
      return TipoChavePix.CNPJ;
    } else if (RegExp(r"^\d{11,}$").hasMatch(chave)) {
      return TipoChavePix.Telefone;
    } else if (RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$").hasMatch(chave)) {
      return TipoChavePix.Email;
    } else if (RegExp(r"^[a-zA-Z0-9]{1,50}$").hasMatch(chave)) {
      return TipoChavePix.ChaveAleatoria;
    } else {
      return TipoChavePix.Outro;
    }
  }

  static bool validarFormatoChave(String chave, TipoChavePix tipoChave) {
    switch (tipoChave) {
      case TipoChavePix.CPF:
        return RegExp(r"^\d{11}$").hasMatch(chave);
      case TipoChavePix.CNPJ:
        return RegExp(r"^\d{14}$").hasMatch(chave);
      case TipoChavePix.Telefone:
        return RegExp(r"^\d{11,}$").hasMatch(chave);
      case TipoChavePix.Email:
        return RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$").hasMatch(chave);
      case TipoChavePix.ChaveAleatoria:
        return RegExp(r"^[a-zA-Z0-9]{1,50}$").hasMatch(chave);
      case TipoChavePix.Outro:
        return false;
    }
  }
}
