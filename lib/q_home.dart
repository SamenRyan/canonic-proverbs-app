import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import for cached network images
import 'database/db.dart';
import 'pages/fav_page.dart';
import 'pages/v_page.dart';
import 'components/iconButton.dart';

class QHomeScreen extends StatefulWidget {
  const QHomeScreen({super.key});

  @override
  _QHomeScreenState createState() => _QHomeScreenState();
}

class _QHomeScreenState extends State<QHomeScreen> {
  final dbHelper = DatabaseHelper.instance;
  int currentTabSelected = 0;
  List<dynamic> quotes = [];
  late int randomIndex;

  // List of background image URLs
  final List<String> backgroundImages = [
    'https://res.cloudinary.com/dcn7oqkke/image/upload/v1739286022/83835e7626b3ec5cec1eeae6b7750f24-1_d9osah.jpg',
    'https://res.cloudinary.com/dcn7oqkke/image/upload/v1739285739/PXL_20230712_172427680.PORTRAIT_tpvecm.jpg',
    'https://res.cloudinary.com/dcn7oqkke/image/upload/v1739286020/cbddc5277ae9a8471d6eba5319ee4494_u5r476.jpg',
    'https://res.cloudinary.com/dcn7oqkke/image/upload/v1739285761/PXL_20230228_122627094.PORTRAIT_2_tmp3c0.jpg',
    'https://res.cloudinary.com/dcn7oqkke/image/upload/v1739293392/WhatsApp_Image_2025-02-11_at_17.44.32_fde6e8bd_twehvk.jpg',
    'https://res.cloudinary.com/dcn7oqkke/image/upload/v1739287249/WhatsApp_Image_2025-02-11_at_16.19.01_5f1e4358_xiblkp.jpg',
    'https://res.cloudinary.com/dcn7oqkke/image/upload/v1739293393/WhatsApp_Image_2025-02-11_at_17.44.31_cb50e168_lox7q6.jpg',
    'https://res.cloudinary.com/dcn7oqkke/image/upload/v1739285762/PXL_20230724_105727704.PORTRAIT_dlql3f.jpg'
  ];

  late String randomImageUrl; // Store the randomly selected image URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: FutureBuilder<String>(
        future: rootBundle.loadString('assests/json/ins.json'), // Fixed path
        builder: (context, snapshot) {
          if (!snapshot.hasData) return _buildLoader();

          quotes = json.decode(snapshot.data!);
          randomIndex = Random().nextInt(quotes.length);

          // Randomly select a background image each time the quote changes
          randomImageUrl =
              backgroundImages[Random().nextInt(backgroundImages.length)];

          return Stack(
            children: [
              _buildBody(randomIndex),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildFooterBar(),
              ),
            ],
          );
        },
      ),
    );
  }

  // Loader when data is not yet fetched
  Widget _buildLoader() {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      ),
    );
  }

  // Body layout with dynamic content
  Widget _buildBody(int index) {
    return Stack(
      children: [
        // Background Image
        CachedNetworkImage(
          imageUrl:
              randomImageUrl, // Using CachedNetworkImage to load background
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              const Center(child: Icon(Icons.error, color: Colors.red)),
        ),
        // Gradient Overlay
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const SizedBox.expand(),
        ),
        // Quote Content
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Quote Text
                  Text(
                    quotes[index]['quoteText'],
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  // Author Name
                  Text(
                    "- ${quotes[index]['quoteAuthor']}",
                    style: const TextStyle(
                      fontFamily: 'NunitoSans',
                      fontSize: 16,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildQuoteActions(),
            const SizedBox(height: 20),
            const Text(
              "Otantik Hub 🌍🌏",
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 24,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Quote action buttons (like save to favorites, copy, or change quote)
  Widget _buildQuoteActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ActionButton(
            icon: FontAwesomeIcons.heart,
            onTap: () async {
              Map<String, dynamic> row = {
                DatabaseHelper.columnquote: quotes[randomIndex]['quoteText'],
                DatabaseHelper.columnAuthor: quotes[randomIndex]['quoteAuthor'],
              };
              final id = await dbHelper.insert(row);
              print('Inserted row ID: $id');
            },
          ),
          ActionButton(
            icon: FontAwesomeIcons.copy,
            onTap: () async {
              Clipboard.setData(
                ClipboardData(
                  text:
                      '${quotes[randomIndex]['quoteText']}\n${quotes[randomIndex]['quoteAuthor']}',
                ),
              );
            },
          ),
          ActionButton(
            icon: Icons.format_quote,
            onTap: () {
              setState(() {
                randomIndex = Random().nextInt(quotes.length);
              });
            },
          ),
        ],
      ),
    );
  }

  // Footer bar with navigation buttons
  Widget _buildFooterBar() {
    return Card(
      color: const Color(0xff2D294A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFooterButton(0, Icons.home, () {}),
            _buildFooterButton(1, FontAwesomeIcons.bookmark, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const FavSqlPage()));
            }),
            _buildFooterButton(2, Icons.info, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DetailPage()));
            }),
          ],
        ),
      ),
    );
  }

  // Footer button logic
  Widget _buildFooterButton(int index, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: IconButton(
        icon: Icon(
          icon,
          color: currentTabSelected == index
              ? Colors.pink
              : const Color(0xff757495),
        ),
        onPressed: () {
          setState(() {
            currentTabSelected = index;
          });
          onTap();
        },
      ),
    );
  }
}
