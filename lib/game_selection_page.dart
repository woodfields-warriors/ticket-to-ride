import 'package:flutter/material.dart';
import 'global_context_widget.dart';

import 'package:ticket_to_ride/api/api.dart' as api;
import 'api/game.pb.dart';
import 'package:protobuf/protobuf.dart';

import 'fragments/game_list_fragment.dart';
import 'fragments/create_game_fragment.dart';

import 'package:fluttertoast/fluttertoast.dart';

class GameSelectionPage extends StatefulWidget {
  GameSelectionPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;


  @override
  GameSelectionPageState createState() => new GameSelectionPageState();
}

class GameSelectionPageState extends State<GameSelectionPage> {

  var createGameRequest = api.CreateGameRequest();
  var createPlayerRequest = api.CreatePlayerRequest();
  
  List<api.Game> games = List<api.Game>();

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        bgcolor: "#e74c3c",
        textcolor: '#ffffff',
        timeInSecForIos: 5,
        gravity: ToastGravity.TOP
    );
  }

  getGameList() async {
    var ctx = ClientContext();
    try {
      var request = api.ListGamesRequest();
      var response = await api.gameProxy.listGames(ctx, request);

      games = response.games;
    } catch(error) {
      print(error.code);
      print(error.message);
    }
  }

  createGame(form) async {
    if (form.validate()) {
        form.save();

        var ctx = ClientContext();

        print(createGameRequest.displayName);

        try {
          var response = await api.gameProxy.createGame(ctx,createGameRequest);

          GlobalContext.of(context).onCurrentGameIdChange(response.gameId);
          Navigator.of(context).pushNamed('/lobby_view');

        } catch(error) {
          switch(error.code) {
            case api.Code.INVALID_ARGUMENT:
              _showErrorToast('This game is full');
              break;
            case api.Code.NOT_FOUND:
              _showErrorToast('This game no longer exists');
              break;
            default:
              _showErrorToast('UNKNOWN ERROR');
          }
        }
    }
  }

  createPlayer(form) async {
    if (form.validate()) {
      form.save();

      var ctx = ClientContext();

      try {
        var response = await api.gameProxy.createPlayer(ctx, createPlayerRequest);

        GetPlayerRequest getPlayerRequest = GetPlayerRequest();
        getPlayerRequest.playerId = response.playerId;

        var playerResponse = await api.gameProxy.getPlayer(ctx, getPlayerRequest);

        GlobalContext.of(context).onCurrentGameIdChange(playerResponse.gameId);
        Navigator.of(context).pushNamed('/lobby_view');
      } catch(error) {
        print(error.code);
        print(error.message);
      }
    }
  }


  @override
  Widget build(BuildContext context) {

    getGameList();

    return Scaffold(
      appBar: new AppBar(
        title: new Text('Game Selection'),
      ),
      body: Row(
        children: [
          Flexible(
            child: CreateGameFragment(this),
          ),
          Flexible(
            child: GameListFragment(this),
          )
        ] 
      )
    );
  }
}
