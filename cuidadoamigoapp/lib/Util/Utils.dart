class Utils {
  static bool validarCPF(String cpf) {
    final cpfNumerico = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    if (cpfNumerico.length != 11) {
      return false;
    }

    List<int> cpfList = cpfNumerico.split('').map((e) => int.parse(e)).toList();

    // Verifica o primeiro dígito verificador
    int firstVerifierDigit = _calculateVerifierDigit(cpfList.sublist(0, 9));
    if (firstVerifierDigit != cpfList[9]) {
      return false;
    }

    // Verifica o segundo dígito verificador
    int secondVerifierDigit = _calculateVerifierDigit(cpfList.sublist(0, 10));
    return secondVerifierDigit == cpfList[10];
  }

  static int _calculateVerifierDigit(List<int> partialCpf) {
    int sum = 0;
    int multiplier = partialCpf.length + 1;

    for (int digit in partialCpf) {
      sum += digit * multiplier;
      multiplier--;
    }

    int remainder = sum % 11;

    return remainder < 2 ? 0 : 11 - remainder;
  }
  
}
