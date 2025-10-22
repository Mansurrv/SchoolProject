class Book {
  final int id;
  final String title;
  final String author;
  final String pdfUrl;

  Book({required this.id, required this.title, required this.author, required this.pdfUrl});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      pdfUrl: json['pdf_url'],
    );
  }
}
