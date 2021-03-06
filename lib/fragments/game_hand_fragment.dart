import 'package:flutter/material.dart';

class TrainCards {
  int color;
  int count;

  TrainCards(this.color, this.count);
}

class DestinationCard {
  String city1name;
  String city2name;
  int points;

  DestinationCard(this.city1name, this.city2name, this.points);
}

abstract class GameHandObserver {
  getTrainCards() {}
  getDestinationCards() {}
}

class GameHandFragment extends StatefulWidget {
  GameHandFragment({Key key, this.title}) : super(key: key);

  final observers = List<GameHandObserver>();
  final String title;

  void addObserver(GameHandObserver o) {
    observers.add(o);
  }

  void removeObserver(GameHandObserver o) {
    observers.remove(o);
  }

  @override
  _GameHandFragmentState createState() => new _GameHandFragmentState();
}

class _GameHandFragmentState extends State<GameHandFragment> {

  List<dynamic> _destinationCards = [];
  List<dynamic> _trainCards = [];

  @override
  initState() {
    super.initState();

    _getDestinationCards();
    _getTrainCards();
  }

  _getDestinationCards() async {
    for (var o in widget.observers) {
      await for(var response in o.getDestinationCards()) {
        setState(() {
          _destinationCards = response;
        });
      }
    }
  }

  _getTrainCards() async {
    for (var o in widget.observers) {
      await for(var response in o.getTrainCards()) {
        setState(() {
          _trainCards = response;
        });
      }
    }
  }

  _buildDestinationHand() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _destinationCards.map((destination) {
        return Container(
          margin: const EdgeInsets.only(right: 10.0),
          decoration: new BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Text("${destination.city1name} - ${destination.city2name} -- ${destination.points.toString()}")
          )
        );
      }).toList()
    );
  }

  _buildTrainHand() {
    return Row(
      children: _trainCards.map((trainCard) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          height: MediaQuery.of(context).size.width * .05 * 1.5,
          width: MediaQuery.of(context).size.width * .05,
          decoration: new BoxDecoration(
            color: Color(trainCard.color),
          ),
          child: Text(
            trainCard.count.toString(),
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white
            ),
          )
        );
      }).toList()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildDestinationHand(),
        _buildTrainHand()
      ]
    );
  }
}
