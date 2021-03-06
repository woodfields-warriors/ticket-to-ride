import 'package:flutter/material.dart';
import 'package:ticket_to_ride/global_context.dart';

import 'package:ticket_to_ride/api/api.dart' as api;
import 'package:ticket_to_ride/api/game.pb.dart';
import 'package:protobuf/protobuf.dart';

import 'package:ticket_to_ride/fragments/fragment_library.dart';
import 'package:ticket_to_ride/fragments/game_list_fragment.dart';
import 'package:ticket_to_ride/fragments/create_game_fragment.dart';
import 'package:ticket_to_ride/fragments/game_selection_view.dart';


class GameSelectionPresenter implements GameSelectionPresenterApi {

  final String title;

  CreateGameFragment createGameFragment;
  GameListFragment gameListFragment;

  // default constructor
  GameSelectionPresenter({this.title}) {
    createGameFragment = CreateGameFragment(this);
    gameListFragment = GameListFragment(this, key: gameListKey);
  }

  // another constructor with fragments passed in
  GameSelectionPresenter.fromFragments(CreateGameFragment createGameFragment, GameListFragment gameListFragment,
  {this.title}) {
    this.createGameFragment = createGameFragment;
    this.gameListFragment = gameListFragment;
  }


  getGameList() async {
    var ctx = ClientContext();
    try {
      var request = api.ListGamesRequest();
      var response = await api.gameProxy.listGames(ctx, request);

      var games = [];

      response.games.forEach((game) {
        if(game.status == api.Game_Status.PRE) {
          games.add(game);
        }
      });

      return games;

    } catch(error) {
      print(error);
      print(error.code);
      print(error.message);
    }
  }

  @override
  createGame(request) async {

    var ctx = ClientContext();

    try {
      var response = await api.gameProxy.createGame(ctx,request);

      GetPlayerRequest getPlayerRequest = GetPlayerRequest();
      getPlayerRequest.playerId = response.playerId;
      var playerResponse = await api.gameProxy.getPlayer(ctx, getPlayerRequest);

      GlobalContext().currentGameId = response.gameId;
      GlobalContext().currentPlayerId = playerResponse.id;

      // gameListKey.currentState.cancelPoll();
      FragmentLibrary.navigatePush('/lobby_view');

    } catch(error) {
      print(error);
      print(error.code);
      print(error.message);
    }
  }

  @override
  createPlayer(request) async {
      var ctx = ClientContext();

      try {
        var response = await api.gameProxy.createPlayer(ctx, request);

        try {
          GetPlayerRequest getPlayerRequest = GetPlayerRequest();
          getPlayerRequest.playerId = response.playerId;
          print(getPlayerRequest.playerId);
          var playerResponse = await api.gameProxy.getPlayer(ctx, getPlayerRequest);

          GlobalContext().currentGameId = playerResponse.gameId;
          GlobalContext().currentPlayerId = playerResponse.id;

          FragmentLibrary.navigatePush('/lobby_view');

        } catch(error) {
          print(error);
          print(error.code);
          print(error.message);
        }

      } catch(error) {
          switch(error.code) {
            case api.Code.INVALID_ARGUMENT:
              FragmentLibrary.showErrorToast('This game is full');
              break;
            case api.Code.NOT_FOUND:
              FragmentLibrary.showErrorToast('This game no longer exists');
              break;
            default:
              FragmentLibrary.showErrorToast('UNKNOWN ERROR');
          }
      }
  }

  Widget build() {

    getGameList();

    return GameSelectionView.build(createGameFragment, gameListFragment);

  }

}
