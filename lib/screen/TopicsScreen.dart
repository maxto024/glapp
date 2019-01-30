import 'package:glapp/model/repo.dart';
import 'package:glapp/styles/mainStyle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:url_launcher/url_launcher.dart';

class RepoScreen extends StatefulWidget {
  @override
  RepoScreenState createState() => new RepoScreenState();
}

class RepoScreenState extends State<RepoScreen> {
  _renderBody() {
    return FutureBuilder<List<Repo>>(
        future: fetchRepo(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("${snapshot.error}");
          return snapshot.hasData
              ? ReposList(repos: snapshot.data)
              : Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(' GreanLine'),
        ),
        body: _renderBody());
  }
}

// With Card view
class ReposList extends StatelessWidget {
  final List<Repo> repos;
  final String defaultUrl =
      "https://b.thumbs.redditmedia.com/S6FTc5IJqEbgR3rTXD5boslU49bEYpLWOlh8-CMyjTY.png";

  const ReposList({Key key, this.repos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: repos.length,
        itemBuilder: (context, index) {
          var image =
              repos[index].avator.length > 0 ? repos[index].avator : defaultUrl;
          var title = repos[index].name;
          var desc = repos[index].description;
          final cardIcon = Container(
            padding: const EdgeInsets.all(16.0),
            margin: EdgeInsets.symmetric(vertical: 16.0),
            alignment: FractionalOffset.centerLeft,
            child: Image.network(image, height: 64.0, width: 64.0),
          );
          var cardText = Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  child: new AutoSizeText(
                    title,
                    style: headerTextStyle,
                    maxLines: 2,
                  ),
                  padding: EdgeInsets.only(bottom: 15.0),
                ),
                Text(desc.length > 32 ? "${desc.substring(0, 32)}..." : desc)
              ],
            ),
          );
          return InkWell(
            onTap: () {
              _launchURL(context, repos[index].url);
            },
            child: Card(
              margin: EdgeInsets.all(5.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: Row(
                children: <Widget>[cardIcon, cardText],
              ),
            ),
          );
        });
  }
}

void _launchURL(BuildContext context, String url) async {
  try {
    await launch(
      url,
    );
  } catch (e) {
    debugPrint(e.toString());
  }
}
