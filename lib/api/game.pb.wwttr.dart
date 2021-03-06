///
//  Generated code. Do not modify.
//  source: game.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME

import 'dart:async';
import 'package:protobuf/protobuf.dart';
import 'dart:collection';

import 'game.pb.dart';
import 'game.pbjson.dart';
import 'api_error.dart';
import 'api.pb.dart';

import 'package:http/http.dart' as http;
import 'dart:typed_data';

import './api.pb.dart';
import './auth.pb.dart';
import './card.pb.dart';
import './chat.pb.dart';
import './descriptor.pb.dart';
import './health.pb.dart';
import './plugin.pb.dart';
import './route.pb.dart';

class GameServiceProxy {
  String _url;
  GameServiceProxy(this._url);

    Future<CreateResponse> createGame(ClientContext ctx, CreateGameRequest request) async {

    var req = Request();
    Response response;
    try {
      req.method = 'CreateGame';
      req.service = 'game.GameService';
      req.payload = request.writeToBuffer();
      var httpResponse = await http.post(_url, body: req.writeToBuffer());
      response = Response.fromBuffer(httpResponse.bodyBytes);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }

    if (response.code != Code.OK) {
      throw ApiError(response.code, response.message);
    }

    try {
      return CreateResponse.fromBuffer(response.payload);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }
  }

  Future<Empty> leaveGame(ClientContext ctx, LeaveGameRequest request) async {

    var req = Request();
    Response response;
    try {
      req.method = 'LeaveGame';
      req.service = 'game.GameService';
      req.payload = request.writeToBuffer();
      var httpResponse = await http.post(_url, body: req.writeToBuffer());
      response = Response.fromBuffer(httpResponse.bodyBytes);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }

    if (response.code != Code.OK) {
      throw ApiError(response.code, response.message);
    }

    try {
      return Empty.fromBuffer(response.payload);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }
  }

  Future<Empty> deleteGame(ClientContext ctx, DeleteGameRequest request) async {

    var req = Request();
    Response response;
    try {
      req.method = 'DeleteGame';
      req.service = 'game.GameService';
      req.payload = request.writeToBuffer();
      var httpResponse = await http.post(_url, body: req.writeToBuffer());
      response = Response.fromBuffer(httpResponse.bodyBytes);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }

    if (response.code != Code.OK) {
      throw ApiError(response.code, response.message);
    }

    try {
      return Empty.fromBuffer(response.payload);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }
  }

  Future<Game> getGame(ClientContext ctx, GetGameRequest request) async {

    var req = Request();
    Response response;
    try {
      req.method = 'GetGame';
      req.service = 'game.GameService';
      req.payload = request.writeToBuffer();
      var httpResponse = await http.post(_url, body: req.writeToBuffer());
      response = Response.fromBuffer(httpResponse.bodyBytes);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }

    if (response.code != Code.OK) {
      throw ApiError(response.code, response.message);
    }

    try {
      return Game.fromBuffer(response.payload);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }
  }

  Future<Game> startGame(ClientContext ctx, StartGameRequest request) async {

    var req = Request();
    Response response;
    try {
      req.method = 'StartGame';
      req.service = 'game.GameService';
      req.payload = request.writeToBuffer();
      var httpResponse = await http.post(_url, body: req.writeToBuffer());
      response = Response.fromBuffer(httpResponse.bodyBytes);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }

    if (response.code != Code.OK) {
      throw ApiError(response.code, response.message);
    }

    try {
      return Game.fromBuffer(response.payload);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }
  }

  Future<ListGamesResponse> listGames(ClientContext ctx, ListGamesRequest request) async {

    var req = Request();
    Response response;
    try {
      req.method = 'ListGames';
      req.service = 'game.GameService';
      req.payload = request.writeToBuffer();
      var httpResponse = await http.post(_url, body: req.writeToBuffer());
      response = Response.fromBuffer(httpResponse.bodyBytes);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }

    if (response.code != Code.OK) {
      throw ApiError(response.code, response.message);
    }

    try {
      return ListGamesResponse.fromBuffer(response.payload);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }
  }

  Stream<Game> streamGames(ClientContext ctx, StreamGamesRequest request) async* {
    print("STREAMING REQ");
    while (true) {
      try {
        var req = Request();
        req.method = 'StreamGames';
        req.service = 'game.GameService';
        req.payload = request.writeToBuffer();

        var client = http.Client();
        var httpRequest = http.Request('POST', Uri.parse(_url));
        httpRequest.bodyBytes = req.writeToBuffer();
        var httpResponse = await client.send(httpRequest);
        int length = 0;
        var dataBuffer = List<int>();
        var lengthBuffer = ByteData(4);
        var lengthOffset = 0;
        var recieved = HashSet<String>();

        await for (var byte in httpResponse.stream.expand((el) => el)) {
          if (length == 0) {
            lengthBuffer.setInt8(lengthOffset, byte);
            lengthOffset++;
            if (lengthOffset == 4) {
              lengthOffset = 0;
              length = ByteData.view(lengthBuffer.buffer).getUint32(0, Endian.little);
            }
            continue;
          }

          dataBuffer.add(byte);

          length--;
          if (length == 0) {
            var resp = Response.fromBuffer(dataBuffer);
            print("GOT PAYLOAD");
            print(resp.id);
            print(resp.code);
            if (resp.code == Code.PING) {
              continue;
            }
            if (!recieved.add(resp.id)) {
              continue;
            }
            if (resp.code != Code.OK) {
              throw ApiError(resp.code, resp.message);
            }
            yield Game.fromBuffer(resp.payload);
            dataBuffer.clear();
          }
        }
      }
      catch (err) {
        print("ERROR FROM STREAM: RETRYING in 5 seconds");
        print(err);
        await Future.delayed(Duration(seconds: 5));
      }
    }
  }

  Future<CreatePlayerResponse> createPlayer(ClientContext ctx, CreatePlayerRequest request) async {

    var req = Request();
    Response response;
    try {
      req.method = 'CreatePlayer';
      req.service = 'game.GameService';
      req.payload = request.writeToBuffer();
      var httpResponse = await http.post(_url, body: req.writeToBuffer());
      response = Response.fromBuffer(httpResponse.bodyBytes);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }

    if (response.code != Code.OK) {
      throw ApiError(response.code, response.message);
    }

    try {
      return CreatePlayerResponse.fromBuffer(response.payload);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }
  }

  Future<Player> getPlayer(ClientContext ctx, GetPlayerRequest request) async {

    var req = Request();
    Response response;
    try {
      req.method = 'GetPlayer';
      req.service = 'game.GameService';
      req.payload = request.writeToBuffer();
      var httpResponse = await http.post(_url, body: req.writeToBuffer());
      response = Response.fromBuffer(httpResponse.bodyBytes);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }

    if (response.code != Code.OK) {
      throw ApiError(response.code, response.message);
    }

    try {
      return Player.fromBuffer(response.payload);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }
  }

  Stream<PlayerStats> streamPlayerStats(ClientContext ctx, StreamPlayerStatsRequest request) async* {
    print("STREAMING REQ");
    while (true) {
      try {
        var req = Request();
        req.method = 'StreamPlayerStats';
        req.service = 'game.GameService';
        req.payload = request.writeToBuffer();

        var client = http.Client();
        var httpRequest = http.Request('POST', Uri.parse(_url));
        httpRequest.bodyBytes = req.writeToBuffer();
        var httpResponse = await client.send(httpRequest);
        int length = 0;
        var dataBuffer = List<int>();
        var lengthBuffer = ByteData(4);
        var lengthOffset = 0;
        var recieved = HashSet<String>();

        await for (var byte in httpResponse.stream.expand((el) => el)) {
          if (length == 0) {
            lengthBuffer.setInt8(lengthOffset, byte);
            lengthOffset++;
            if (lengthOffset == 4) {
              lengthOffset = 0;
              length = ByteData.view(lengthBuffer.buffer).getUint32(0, Endian.little);
            }
            continue;
          }

          dataBuffer.add(byte);

          length--;
          if (length == 0) {
            var resp = Response.fromBuffer(dataBuffer);
            print("GOT PAYLOAD");
            print(resp.id);
            print(resp.code);
            if (resp.code == Code.PING) {
              continue;
            }
            if (!recieved.add(resp.id)) {
              continue;
            }
            if (resp.code != Code.OK) {
              throw ApiError(resp.code, resp.message);
            }
            yield PlayerStats.fromBuffer(resp.payload);
            dataBuffer.clear();
          }
        }
      }
      catch (err) {
        print("ERROR FROM STREAM: RETRYING in 5 seconds");
        print(err);
        await Future.delayed(Duration(seconds: 5));
      }
    }
  }

  Future<Empty> togglePlayerStats(ClientContext ctx, Empty request) async {

    var req = Request();
    Response response;
    try {
      req.method = 'TogglePlayerStats';
      req.service = 'game.GameService';
      req.payload = request.writeToBuffer();
      var httpResponse = await http.post(_url, body: req.writeToBuffer());
      response = Response.fromBuffer(httpResponse.bodyBytes);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }

    if (response.code != Code.OK) {
      throw ApiError(response.code, response.message);
    }

    try {
      return Empty.fromBuffer(response.payload);
    }
    catch (err) {
      throw ApiError(Code.UNAVAILABLE, err.toString());
    }
  }

  Stream<GameAction> streamHistory(ClientContext ctx, StreamHistoryRequest request) async* {
    print("STREAMING REQ");
    while (true) {
      try {
        var req = Request();
        req.method = 'StreamHistory';
        req.service = 'game.GameService';
        req.payload = request.writeToBuffer();

        var client = http.Client();
        var httpRequest = http.Request('POST', Uri.parse(_url));
        httpRequest.bodyBytes = req.writeToBuffer();
        var httpResponse = await client.send(httpRequest);
        int length = 0;
        var dataBuffer = List<int>();
        var lengthBuffer = ByteData(4);
        var lengthOffset = 0;
        var recieved = HashSet<String>();

        await for (var byte in httpResponse.stream.expand((el) => el)) {
          if (length == 0) {
            lengthBuffer.setInt8(lengthOffset, byte);
            lengthOffset++;
            if (lengthOffset == 4) {
              lengthOffset = 0;
              length = ByteData.view(lengthBuffer.buffer).getUint32(0, Endian.little);
            }
            continue;
          }

          dataBuffer.add(byte);

          length--;
          if (length == 0) {
            var resp = Response.fromBuffer(dataBuffer);
            print("GOT PAYLOAD");
            print(resp.id);
            print(resp.code);
            if (resp.code == Code.PING) {
              continue;
            }
            if (!recieved.add(resp.id)) {
              continue;
            }
            if (resp.code != Code.OK) {
              throw ApiError(resp.code, resp.message);
            }
            yield GameAction.fromBuffer(resp.payload);
            dataBuffer.clear();
          }
        }
      }
      catch (err) {
        print("ERROR FROM STREAM: RETRYING in 5 seconds");
        print(err);
        await Future.delayed(Duration(seconds: 5));
      }
    }
  }


}

