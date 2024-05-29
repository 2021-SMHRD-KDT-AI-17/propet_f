import 'package:flutter/material.dart';

class ShopDetails extends StatelessWidget {
  final int heroTag;

  const ShopDetails({Key? key, required this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "제품 상세 정보",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Hero(
                tag: heroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    _images[heroTag],
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    "제품 이름 $heroTag",
                    style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "₩48,130 / 4kg",
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        "4.1 (523개 리뷰)",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow(
              context,
              Icons.pets_outlined,
              "성분 분석",
              "주요 성분: 닭고기, 쌀, 옥수수",
              [
                _buildTag(context, "비타민 A", Colors.pink[200]!),
                _buildTag(context, "비타민 D", Colors.blue[200]!),
                _buildTag(context, "비타민 E", Colors.purple[200]!),
                _buildTag(context, "칼슘", Colors.green[200]!),
                _buildTag(context, "인", Colors.yellow[200]!),
                _buildTag(context, "철", Colors.orange[200]!),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailRow(
              context,
              Icons.recommend_outlined,
              "추천 사용법",
              "하루 두 번, 아침과 저녁에 급여하세요. 신선한 물을 항상 함께 제공해 주세요.",
              [
                _buildTag(context, "아침", Colors.pink[200]!),
                _buildTag(context, "저녁", Colors.blue[200]!),
              ],
            ),
            const SizedBox(height: 20),
            _buildReviewSection(context),
            const SizedBox(height: 20),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String title, String content, List<Widget> tags) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor, size: 30),
              const SizedBox(width: 10),
              Container(
                height: 24,
                width: 1,
                color: Colors.grey,
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.grey),
          const SizedBox(height: 10),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: tags,
          ),
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text, Color color) {
    return Chip(
      label: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          shadows: [
            Shadow(
              blurRadius: 3.0,
              color: Colors.black,
              offset: Offset(1.0, 1.0),
            ),
          ],
        ),
      ),
      backgroundColor: color,
      shape: StadiumBorder(
        side: BorderSide(color: color),
      ),
    );
  }

  Widget _buildReviewSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.rate_review_outlined, color: Colors.deepPurpleAccent, size: 30),
              const SizedBox(width: 10),
              Container(
                height: 24,
                width: 1,
                color: Colors.grey,
              ),
              const SizedBox(width: 10),
              Text(
                "상품 리뷰",
                style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.grey),
          const SizedBox(height: 10),
          _buildReviewCard(context, "반려견이 정말 좋아해요!", "사용자가", 5),
          const SizedBox(height: 10),
          _buildReviewCard(context, "냄새도 좋고, 잘 먹어요.", "사용자가", 4),
          const SizedBox(height: 10),
          _buildReviewCard(context, "포장이 깔끔하고 좋아요.", "사용자가", 4.5),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, String review, String user, double rating) {
    return Card(
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.withOpacity(0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < rating
                      ? Icons.star
                      : index < rating + 0.5
                      ? Icons.star_half
                      : Icons.star_border,
                  color: Colors.yellow,
                  size: 16,
                  shadows: [
                    Shadow(
                      blurRadius: 1.0,
                      color: Colors.black,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                  semanticLabel: 'Rating Star',
                  // Add a border to the star icon
                );
              }),
            ),
            const SizedBox(height: 5),
            Text(
              review,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                "- $user",
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ],
        ),
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
