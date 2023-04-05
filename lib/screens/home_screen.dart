import "package:flutter/material.dart";
import "package:toonflix/models/webtoon_model.dart";
import "package:toonflix/services/api_service.dart";
import "package:toonflix/widgets/webtoon_widget.dart";

class HomeScreen extends StatelessWidget {
  final Future<List<WebtoonModel>> _webtoons = ApiService.getTodaysToons();

  HomeScreen({super.key});

  ListView _makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (_, int index) {
        final WebtoonModel webtoon = snapshot.data![index];
        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      separatorBuilder: (_, __) => const SizedBox(width: 40),
      itemCount: snapshot.data!.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "오늘의 웹툰",
          style: TextStyle(fontSize: 24),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
      ),
      body: FutureBuilder<List<WebtoonModel>>(
        future: _webtoons,
        builder: (_, AsyncSnapshot<List<WebtoonModel>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: <Widget>[
              const SizedBox(height: 50),
              Expanded(child: _makeList(snapshot)),
            ],
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
