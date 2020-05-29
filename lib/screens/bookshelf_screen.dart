import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Book with ChangeNotifier {
  Book(this.id, this.title);

  final String id;
  final String title;
  bool isFavorite = false;

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book List'),
      ),
      body: Center(
        child: SizedBox(
          height: 200,
          child: ChangeNotifierProvider(
            create: (ctx) => Books(),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Bookshelf(),
                ),
                Consumer<Books>(
                  builder: (ctx, booksData, _) => Center(
                    child:
                        Text('totalFavoriteCount: ${booksData.favoriteCount}'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Bookshelf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final booksData = Provider.of<Books>(context, listen: false);
    return ListView.builder(
      itemCount: booksData.books.length,
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: booksData.books[index],
        child: BookItem(),
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Book>(
      builder: (ctx, book, child) => ListTile(
        leading: child,
        title: Text(book.id),
        subtitle: Text(book.title),
        trailing: IconButton(
          icon: Icon(book.isFavorite ? Icons.star : Icons.star_border),
          onPressed: () => Provider.of<Books>(context, listen: false)
              .toggleFavorite(book.id),
        ),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.book,
        ),
        onPressed: () {},
      ),
    );
  }
}
