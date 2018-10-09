import 'package:flutter/material.dart';
import 'package:ticket_to_ride/global_context_widget.dart';
import 'package:ticket_to_ride/game_selection_presenter.dart';
import 'package:ticket_to_ride/api/game.pb.dart';


class GameListFragment extends StatefulWidget {

  GameListFragment(GameSelectionPresenterState presenterState, {Key key, this.title}) : presenterState = presenterState, super(key: key);

  final String title;
  final GameSelectionPresenterState presenterState;

  @override
  _GameListFragmentState createState() => new _GameListFragmentState();

}

class _GameListFragmentState extends State<GameListFragment> {

  final _formKey = GlobalKey<FormState>();

  final TextStyle _lightStyle = TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {

    Widget _buildRow(Game game) {
    
      final joinButton = Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: RaisedButton(
          onPressed: () {
            this.widget.presenterState.createPlayerRequest.userId = GlobalContext.of(context).userId;
            this.widget.presenterState.createPlayerRequest.gameId = game.gameId;
            this.widget.presenterState.createPlayer(_formKey.currentState);
          },
          child: Text(
            'Join',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),            
      );

      return ListTile(
        //leading: const Icon(),
        title: Text(
          game.displayName,
        ),
        subtitle:  Column(
          children: [
            Text('Host: ' + game.hostPlayerId.toString()),
            Text('Waiting for ' + ((game.maxPlayers - game.playerIds.length).toString() + ' players')),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        trailing: joinButton,
      );

    }

  
    
    var gameList = (!this.widget.presenterState.gamesLoaded) ? Text('Loading games...') :
      ((this.widget.presenterState.games.length == 0) ? 
        Text('No active games to show.') : 
          Flexible(
            child: ListView.builder(
              itemCount: this.widget.presenterState.games.length,
              itemBuilder: (BuildContext context, int i) {
                return _buildRow(this.widget.presenterState.games[i]);
              }
            ),
          )
      );

    return Padding(
      padding: EdgeInsets.fromLTRB(15.0, 30.0, 30.0, 30.0),
      child: Column (
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Join a Game', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
          SizedBox(height:8.0),
          gameList
        ]
      )
    );
  }
}