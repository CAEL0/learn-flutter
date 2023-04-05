import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:toonflix/models/webtoon_detail_model.dart";
import "package:toonflix/models/webtoon_episode_model.dart";
import "package:toonflix/services/api_service.dart";
import "package:toonflix/widgets/episode_widget.dart";

class DetailScreen extends StatefulWidget {
  final String title;
  final String thumb;
  final String id;

  const DetailScreen({
    required this.title,
    required this.thumb,
    required this.id,
    super.key,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final Future<WebtoonDetailModel> _webtoon;
  late final Future<List<WebtoonEpisodeModel>> _episodes;
  late final SharedPreferences _prefs;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _webtoon = ApiService.getToonById(widget.id);
    _episodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final List<String>? likedToons = _prefs.getStringList("likedToons");
    if (likedToons == null) {
      await _prefs.setStringList("likedToons", <String>[]);
      return;
    }
    if (likedToons.contains(widget.id)) {
      setState(() {
        _isLiked = true;
      });
    }
  }

  Future<void> onHeartTap() async {
    final List<String>? likedToons = _prefs.getStringList("likedToons");
    if (likedToons == null) {
      await _prefs.setStringList("likedToons", <String>[]);
      return;
    }
    setState(() {
      _isLiked = !_isLiked;
    });
    if (_isLiked) {
      likedToons.add(widget.id);
    } else {
      likedToons.remove(widget.id);
    }
    await _prefs.setStringList("likedToons", likedToons);
  }

  @override
  Widget build(BuildContext context) {
    initPrefs();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 24),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_outline,
            ),
          ),
        ],
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: <Widget>[
              Center(
                child: Hero(
                  tag: widget.id,
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
                      widget.thumb,
                      headers: const <String, String>{
                        "User-Agent":
                            "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              FutureBuilder<WebtoonDetailModel>(
                future: _webtoon,
                builder: (_, AsyncSnapshot<WebtoonDetailModel> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        snapshot.data!.about,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "${snapshot.data!.genre} / ${snapshot.data!.age}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 25),
              FutureBuilder<List<WebtoonEpisodeModel>>(
                future: _episodes,
                builder:
                    (_, AsyncSnapshot<List<WebtoonEpisodeModel>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    children: snapshot.data!
                        .sublist(0, 10)
                        .map(
                          (WebtoonEpisodeModel episode) => Episode(
                            webtoonId: widget.id,
                            episode: episode,
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
