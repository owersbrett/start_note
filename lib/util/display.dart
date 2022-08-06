class Display {
  static String substring(String str, int start, [int end = 0]) {
    try {
      if (end > 0) {
        return str.substring(start, end);
      } else {
        return str;
      }
    } catch (e) {
      return str;
    }
  }
}
