import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project/src/api/player_api.dart';
import 'package:project/src/ui/handler/player.dart';
//import '../../ui_exporter.dart';
import 'common_util.dart';

final String title = 'Manage Team Roster';
final String teamName = 'Level';

class ManageTeamWidget extends StatefulWidget {
  @override
  _ManageTeamWidgetState createState() => _ManageTeamWidgetState();
}

class _ManageTeamWidgetState extends State<ManageTeamWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: PreferredSize(
          child: Container(
            color: LevelTheme.levelDarkPurple,
            height: 2.0,
          ),
          preferredSize: Size.fromHeight(2.0),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: LevelTheme.levelDarkPurple,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 0,
              child: Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: _pageTitle(),
              ),
            ),
            Container(height: 10, color: Colors.transparent),
            Expanded(
              flex: 0,
              child: Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: _teamName(),
              ),
            ),
            Container(height: 20, color: Colors.transparent),
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: _teamList(),
              ),
            ),
            Container(height: 20, color: Colors.transparent),
          ],
        ),
      ),
    );
  }

//Displays 'Manage Team Roster' title
  Container _pageTitle() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: LevelTheme.levelDarkPurple,
          fontSize: 24,
          height: 2,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

//Contains the team name
  Container _teamName() {
    return Container(
      height: 50.0,
      width: 300.0,
      child: Container(
        decoration: BoxDecoration(
          color: LevelTheme.levelDarkPurple,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: new Center(
          child: Text(
            teamName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
    );
  }

//Box that contains the player list team
  Container _teamList() {
    return Container(
      width: 300.0,
      height: 467.0,
      decoration: BoxDecoration(
        border: Border.all(color: LevelColor),
      ),
      //FutureBuilder for the List<Player>
      child: FutureBuilder<List<Player>>(
          future: fetchPlayers(http.Client()),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? PlayersList(players: snapshot.data)
                : Center(child: CircularProgressIndicator());
          }),
    );
  }
}

//This creates the container that has the list of players
class PlayersList extends StatelessWidget {
  final List<Player> players;
  PlayersList({Key key, this.players}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: players.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            ListTile(
              title: Text(
                  players[index].firstName + ' ' + players[index].lastName),
            ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(color: LevelTheme.levelDarkPurple);
      },
    );
  }
}
