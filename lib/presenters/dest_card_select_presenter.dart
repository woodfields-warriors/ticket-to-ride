import 'package:ticket_to_ride/api/api.dart' as api;
import 'package:ticket_to_ride/global_context.dart';
import 'package:protobuf/protobuf.dart';
import 'package:ticket_to_ride/fragments/dest_card_select_fragment.dart';
import 'package:ticket_to_ride/fragments/fragment_library.dart';

class DestCardSelectApi {
  getDestinationCards(ctx, request) async {
    return api.cardProxy.peekDestinationCards(ctx, request);
  }
  claimDestinationCards(ctx, request) async {
    return api.cardProxy.claimDestinationCards(ctx, request);
  }
}

class DestCardSelectPresenter implements DestCardSelectObserver  {

  DestCardSelectApi _api;
  DestCardSelectFragment _fragment;

  DestCardSelectPresenter() {
    this._api = new DestCardSelectApi();
  }

  DestCardSelectPresenter.withApi(this._api);

  @override
  getDestinationCards() async {
    var ctx = ClientContext();

    try {
      var request = new api.PeekDestinationCardsRequest();
      request.gameId = GlobalContext().currentGameId;
      var response = await _api.getDestinationCards(ctx, request);

      print(response);

      return [
        DestinationCard("losAngeles-newYorkCity", "losAngeles-newYorkCity", 21),
        DestinationCard("duluth-houston", "duluth-houston", 8),
        DestinationCard("toronto-miami", "toronto-miami", 10)
      ];
    } catch(error) {
      print(error);
      print(error.code);
      print(error.message);
      return [];
    }

  }

  @override
  selectDestinationCards(List<String> cardIds) async {
    var ctx = ClientContext();

    try {
      var request = new api.ClaimDestinationCardsRequest();
      request.playerId = GlobalContext().currentPlayerId;
      request.destinationCardIds.addAll(cardIds);
      await _api.claimDestinationCards(ctx, request);

      print(cardIds);
      FragmentLibrary.navigatePop();
    } catch(error) {
      print(error);
      print(error.code);
      print(error.message);
    }
  }

  build() {
    _fragment = new DestCardSelectFragment(title: 'Login');
    _fragment.addObserver(this);
    return _fragment;
  }
}