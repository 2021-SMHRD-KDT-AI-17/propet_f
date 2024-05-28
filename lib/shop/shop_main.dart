import 'package:flutter/material.dart';

class MainShopPage extends StatefulWidget {
  const MainShopPage({Key? key}) : super(key: key);

  @override
  _MainShopPageState createState() => _MainShopPageState();
}

class _MainShopPageState extends State<MainShopPage> {
  late List<String> _currentCategoryImages;
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentCategoryImages = _images; // Initial images
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      // Update images based on selected category
      switch (index) {
        case 0:
          _currentCategoryImages = _images; // All images
          break;
        case 1:
          _currentCategoryImages = _images.sublist(0, 2); // First two images
          break;
        case 2:
          _currentCategoryImages = _images.sublist(2, 4); // Middle two images
          break;
        case 3:
          _currentCategoryImages = _images.sublist(4, 6); // Last two images
          break;
        default:
          _currentCategoryImages = _images; // Default to all images
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: TabBar(
            onTap: _onCategorySelected,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Category 1'),
              Tab(text: 'Category 2'),
              Tab(text: 'Category 3'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCategoryPage(0),
            _buildCategoryPage(1),
            _buildCategoryPage(2),
            _buildCategoryPage(3),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPage(int index) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        child: ListView.builder(
          itemCount: _currentCategoryImages.length,
          itemBuilder: (BuildContext context, int index) {
            final int imageIndex =
            _images.indexOf(_currentCategoryImages[index]);
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SecondPage(heroTag: imageIndex)));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Hero(
                      tag: imageIndex,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          _currentCategoryImages[index],
                          width: 200,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Title: $imageIndex',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final int heroTag;

  const SecondPage({Key? key, required this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hero ListView Page 2")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Hero(
                tag: heroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(_images[heroTag]),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              "Content goes here",
              style: Theme.of(context).textTheme.headline5,
            ),
          )
        ],
      ),
    );
  }
}

final List<String> _images = [
  'https://images.pexels.com/photos/167699/pexels-photo-167699.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
  'https://images.pexels.com/photos/2662116/pexels-photo-2662116.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  'https://images.pexels.com/photos/273935/pexels-photo-273935.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  'https://images.pexels.com/photos/1591373/pexels-photo-1591373.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  'https://images.pexels.com/photos/462024/pexels-photo-462024.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  'https://images.pexels.com/photos/325185/pexels-photo-325185.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'
];
