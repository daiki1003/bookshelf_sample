import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Book {
  Book(this.id, this.title);

  final String id;
  final String title;
  bool isFavorite = false;

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}

class Books with ChangeNotifier {
  List<Book> books = [
    Book('1', 'Harry Potter'),
    Book('2', 'FACTFULNESS'),
  ];

  Book findById(String id) {
    return books.firstWhere((book) => book.id == id);
  }

  void toggleFavorite(String id) {
    final book = findById(id);
    if (book == null) {
      return;
    }

    book.toggleFavorite();
    notifyListeners();
  }

  int get favoriteCount {
    return books.where((book) => book.isFavorite).length;
  }
}

class BookshelfScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final booksData = Provider.of<Books>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book List'),
      ),
      body: Center(
        child: SizedBox(
          height: 200,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Bookshelf(booksData.books),
              ),
              Center(
                child: Text('totalFavoriteCount: ${booksData.favoriteCount}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Bookshelf extends StatelessWidget {
  const Bookshelf(this.books);

  final List<Book> books;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (ctx, index) => BookItem(
        books[index].id,
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  const BookItem(this.bookId);

  final String bookId;

  @override
  Widget build(BuildContext context) {
    final booksData = Provider.of<Books>(context);
    final book = booksData.findById(bookId);
    return ListTile(
      leading: Text(book.id),
      title: Text(book.title),
      trailing: IconButton(
        icon: Icon(book.isFavorite ? Icons.star : Icons.star_border),
        onPressed: () => booksData.toggleFavorite(book.id),
      ),
    );
  }
}
