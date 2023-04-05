import "package:flutter/material.dart";
import "package:toonflix/models/webtoon_episode_model.dart";
import "package:url_launcher/url_launcher_string.dart";

class Episode extends StatelessWidget {
  final String webtoonId;
  final WebtoonEpisodeModel episode;

  const Episode({
    required this.webtoonId,
    required this.episode,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await launchUrlString(
          "https://comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${episode.id}",
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                episode.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
