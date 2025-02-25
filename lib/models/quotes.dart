class QuotesDb{
  int id;
  String quote;
  String  author;
  QuotesDb({required this.id, required this.quote, required this.author});
  factory QuotesDb.fromMap(Map<String, dynamic> json) => QuotesDb(
    id: json["_id"],
    quote: json["quote"],
    author: json["author"],
  );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "quote": quote,
        "author": author,
  };
}