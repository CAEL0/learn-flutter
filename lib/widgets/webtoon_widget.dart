import "package:flutter/material.dart";
import "package:toonflix/screens/detail_screen.dart";

class Webtoon extends StatelessWidget {
  final String title;
  final String thumb;
  final String id;

  const Webtoon({
    required this.title,
    required this.thumb,
    required this.id,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<dynamic>(
            builder: (_) => DetailScreen(title: title, thumb: thumb, id: id),
          ),
        );
      },
      child: Column(
        children: <Widget>[
          Hero(
            tag: id,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(10, 10),
                    blurRadius: 15,
                  ),
                ],
              ),
              width: 250,
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                thumb,
                headers: const <String, String>{
                  "User-Agent":
                      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 22),
          ),
        ],
      ),
    );
  }
}
