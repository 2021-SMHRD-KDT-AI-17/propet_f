import 'package:flutter/material.dart';
import 'shop_details.dart';

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
    _currentCategoryImages = _images; // 초기 이미지
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
      // 선택한 카테고리에 따라 이미지 업데이트
      switch (index) {
        case 0:
          _currentCategoryImages = _images; // 모든 이미지
          break;
        case 1:
          _currentCategoryImages = _images.sublist(0, 2); // 첫 두 개의 이미지
          break;
        case 2:
          _currentCategoryImages = _images.sublist(2, 4); // 중간 두 개의 이미지
          break;
        case 3:
          _currentCategoryImages = _images.sublist(4, 6); // 마지막 두 개의 이미지
          break;
        default:
          _currentCategoryImages = _images; // 기본적으로 모든 이미지
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
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: '전체'),
              Tab(text: '사료'),
              Tab(text: '장난감'),
              Tab(text: '액세서리'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCategoryPage(),
            _buildCategoryPage(),
            _buildCategoryPage(),
            _buildCategoryPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: _currentCategoryImages.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (BuildContext context, int index) {
          final int imageIndex = _images.indexOf(_currentCategoryImages[index]);
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ShopDetails(heroTag: imageIndex)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Hero(
                    tag: imageIndex,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        _currentCategoryImages[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '제품 이름 $imageIndex',
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₩29,900',
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.grey),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 16),
                        SizedBox(width: 4),
                        Text(
                          '4.0',
                          style: Theme.of(context).textTheme.bodyText2?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
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
