import 'package:flutter/material.dart';
import '../database/db.dart';
import '../models/quotes.dart';

class FavSqlPage extends StatefulWidget {
  const FavSqlPage({super.key});

  @override
  _FavSqlPageState createState() => _FavSqlPageState();
}

class _FavSqlPageState extends State<FavSqlPage> {
  final dbHelper = DatabaseHelper.instance;
  List<QuotesDb> items = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Load saved quotes from the database
  void _loadFavorites() {
    dbHelper.queryAllRows().then((rows) {
      setState(() {
        items = rows.map((row) => QuotesDb.fromMap(row)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: Theme.of(context).primaryColor,
      body: items.isEmpty ? _buildEmptyMessage() : _buildQuoteList(),
    );
  }

  // Build the app bar
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xff2D294A),
      leading: IconButton(
        icon: const Icon(Icons.navigate_before),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text("Favorite ❤"),
      centerTitle: true,
      elevation: 0,
    );
  }

  // Display a message if there are no saved quotes
  Widget _buildEmptyMessage() {
    return const Center(
      child: Text(
        '😝Whoops! Empty, but smile for others RYAN PRO🙂🙂',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white54,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Build the list of saved quotes
  Widget _buildQuoteList() {
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.all(15.0),
      itemBuilder: (BuildContext context, int index) {
        return _buildSavedQuoteItem(index);
      },
    );
  }

  // Build each saved quote item
  Widget _buildSavedQuoteItem(int index) {
    final quote = items[index];
    return Column(
      children: [
        const Divider(height: 5.0),
        ListTile(
          title: Text(
            quote.quote,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            quote.author,
            style: const TextStyle(
              fontSize: 13.0,
              fontStyle: FontStyle.italic,
              color: Colors.white70,
            ),
          ),
        ),
        _buildDeleteButton(index),
      ],
    );
  }

  // Build the delete button for each quote item
  Widget _buildDeleteButton(int index) {
    return Align(
      alignment: Alignment.bottomRight,
      child: IconButton(
        icon: const Icon(Icons.remove_circle_outline),
        color: const Color(0xFF00FFFF),
        tooltip: 'Remove',
        onPressed: () => _deleteNote(index),
      ),
    );
  }

  // Delete the selected quote
  void _deleteNote(int index) async {
    final quote = items[index];
    await dbHelper.delete(quote.id);
    setState(() {
      items.removeAt(index);
    });
  }
}
