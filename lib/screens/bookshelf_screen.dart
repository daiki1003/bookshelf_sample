import 'package:flutter/material.dart';

class Book {
  Book(this.id, this.title);

  final String id;
  final String title;
  bool isFavorite = false;

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}

class BookshelfScreen extends StatefulWidget {
  @override
  _BookshelfScreenState createState() => _BookshelfScreenState();
}

class _BookshelfScreenState extends State {
  List<Book> books = [
    Book('1', 'Harry Potter'),
    Book('2', 'FACTFULNESS'),
  ];

  void toggleFavorite(String id) {
    setState(() {
      books.firstWhere((book) => book.id == id).toggleFavorite();
    });
  }

  int get favoriteCount {
    return books.where((book) => book.isFavorite).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book List'),
      ),
      body: Center(
        child: SizedBox(
          height: 200,
          child: Column(
            children: [
              Expanded(
                child: Bookshelf(books, toggleFavorite),
              ),
              Center(
                child: Text('totalFavoriteCount: $favoriteCount'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Bookshelf extends StatelessWidget {
  const Bookshelf(this.books, this.toggleFavorite);

  final List<Book> books;
  final Function(String) toggleFavorite;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (ctx, index) => BookItem(
        books[index],
        toggleFavorite,
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  const BookItem(this.book, this.toggleFavorite);

  final Book book;
  final Function(String) toggleFavorite;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(book.id),
      title: Text(book.title),
      trailing: IconButton(
        icon: Icon(book.isFavorite ? Icons.star : Icons.star_border),
        onPressed: () => toggleFavorite(book.id),
      ),
    );
  }
}
