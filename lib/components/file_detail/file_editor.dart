class FileEditor {
  late String name;
  String? language;
  String? code;
  String path;

  FileEditor({
    String? name,
    String? language,
    String? code,
    required this.path,
  }) {
    this.name = name ?? "file.${language ?? 'txt'}";
    this.language = language ?? "text";
    this.code = code ?? "";
  }
}
