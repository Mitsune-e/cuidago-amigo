class Mascaras {
  static int lengthTelefone = 11;
  static int lenghtCpf = 11;

  static String aplicarMascara(String type, String text) {
    switch (type) {
      case "telefone":
        return _mascaraTelefone(text);
      case "cpf":
        return _mascaraCpf(text);
    }
    return text;
  }

  static String _mascaraCpf(String inputText) {
    var text = inputText;

    text = text.replaceAll(RegExp(r'\-+|\.+'), "");

    if (text.length > lenghtCpf) {
      text = text.substring(0, lenghtCpf);
    }

    text = text.replaceAll(RegExp(r'[^0-9]'), '');

    var maskedText = text.length == lenghtCpf
        ? '${text.substring(0, 3)}.${text.substring(3, 6)}.${text.substring(6, 9)}-${text.substring(9)}'
        : text;

    return maskedText;
  }

  static String _mascaraTelefone(String inputText) {
    var text = inputText;

    text = text.replaceAll(RegExp(r'\(+|\)+| +|\-+'), '');

    if (text.length > lengthTelefone) {
      text = text.substring(0, lengthTelefone);
    }

    text = text.replaceAll(RegExp(r'[^0-9]+'), '');

    var maskedText = text.length == lengthTelefone
        ? '(${text.substring(0, 2)}) ${text.substring(2, 7)}-${text.substring(7)}'
        : text;

    return maskedText;
  }
}
