class FileEditor {
  late String name;
  String? language;
  String? code;
  FileEditor({String? name, String? language, String? code}) {
    this.name = name ?? "file.${language ?? 'txt'}";
    this.language = language ?? "text";
    this.code = code ?? "";
  }
}
