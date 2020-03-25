import 'package:campsite/model/SpotSeparate.dart';
import 'package:campsite/model/checkin.dart';
import 'package:campsite/model/event.dart';
import 'package:campsite/model/favourite.dart';
import 'package:campsite/model/friends.dart';
import 'package:campsite/model/profile.dart';
import 'package:campsite/model/spot.dart';
import 'package:campsite/model/review.dart';

class CreateList<T> {
  dynamic json;
  CreateList(this.json);

  List getList() {
    List<T> models = List();
    if (this.json is List) {
      this.json.forEach((obj) {
        models.add(getObject(obj));
      });
    } else {
      models.add(getObject(this.json));
    }

    return models;
  }

  dynamic getObject(json) {
    if (T == ProfileModel().runtimeType) {
      return ProfileModel.fromJson(json);
    }
    if (T == SpotModel().runtimeType) {
      return SpotModel.fromJson(json);
    }
    if (T == SpotSeparateModel().runtimeType) {
      return SpotSeparateModel.fromJson(json);
    }

    if (T == ReviewModel().runtimeType) {
      return ReviewModel.fromJson(json);
    }

    if (T == EventModel().runtimeType) {
      return EventModel.fromJson(json);
    }
    if (T == FriendsModel().runtimeType) {
      return FriendsModel.fromJson(json);
    }
    if (T == CheckinModel().runtimeType) {
      return CheckinModel.fromJson(json);
    }
    if (T == FavouriteModel().runtimeType) {
      return FavouriteModel.fromJson(json);
    }
  }
}
