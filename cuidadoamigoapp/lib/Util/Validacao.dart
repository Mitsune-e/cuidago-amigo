class Validacao {
  static bool validar(String type, String text) {
    switch (type) {
      case "email":
        return _validarEmail(text);
      case "cpf":
        return _validarCpf(text);
      case "telefone":
        return false;
    }
    return false;
  }

  static bool validarSenha(String senha, String confirmarSenha) {
    if (senha != confirmarSenha) {
      return false;
    }
    return true;
  }

  static bool _validarCpf(String inputText) {
    return false;
  }

  static bool _validarEmail(String inputText) {
    var emailRegexPattern = RegExp(
        r'^((?:[A-Za-z0-9!#$%&*+\-\/=?^_`{|}~]|(?<=^|\.)"|"(?=$|\.|@)|(?<=".*)[ .](?=.*")|(?<!\.)\.){1,64})(@)((?:[A-Za-z0-9.\-])*(?:[A-Za-z0-9])\.(?:[A-Za-z0-9]){2,})$');
    if (!emailRegexPattern.hasMatch(inputText)) {
      return false;
    }

    return true;
  }
}
