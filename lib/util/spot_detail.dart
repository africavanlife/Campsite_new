import 'package:campsite/util/icon_buttons.dart';
import 'package:campsite/util/resources.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:campsite/model/spot.dart';

class SpotDetails extends StatefulWidget {
  SpotDetails(
      {this.show = true,
      @required this.spotModel,
      this.onSpotChange,
      this.filter = false});
  bool show;
  SpotModel spotModel;
  Function(SpotModel) onSpotChange;
  bool filter;
  @override
  _SpotDetailsState createState() => _SpotDetailsState(show);
}

class _SpotDetailsState extends State<SpotDetails> {
  _SpotDetailsState(this.show);

  @override
  void initState() {
    print(
        "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA : ${widget.spotModel.necessities.autoParts}");
    super.initState();
  }

  bool show;

  List<bool> _toggleSelections = [true, false, false];
  @override
  Widget build(BuildContext context) {
    double sysHeight = MediaQuery.of(context).size.height;
    double sysWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.filter && !widget.show
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('WHO CAN SEE THIS SPOT'),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ToggleButtons(
                      borderColor: Resources.mainColor,
                      color: Resources.mainColor,
                      selectedColor: Colors.white,
                      fillColor: Resources.mainColor,
                      children: [
                        Container(
                          child: Center(child: Text("EVERYONE")),
                          width: sysWidth / 3.3,
                        ),
                        Container(
                          child: Center(child: Text("VERIFIED")),
                          width: sysWidth / 3.3,
                        ),
                        Container(
                          child: Center(child: Text("FRIENDS")),
                          width: sysWidth / 3.3,
                        ),
                      ],
                      onPressed: (int index) {
                        print(index);
                        setState(() {
                          _toggleSelections = [false, false, false];
                          _toggleSelections[index] = true;
                        });
                      },
                      isSelected: _toggleSelections,
                    ),
                  ),
                ],
              )
            : Container(),
        SizedBox(
          height: 20,
        ),
        Text("ACCESSIBILITY"),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Row(
            children: <Widget>[
              Container(
                width: sysWidth * 0.5 - 10,
                child: Row(
                  children: <Widget>[
                    AIconButtons(
                      show,
                      actImageUrl: "assets/PavedRoad_act.png",
                      inactImageUrl: "assets/PavedRoad_inact.png",
                      onTap: (status) {
                        print(status);
                        setState(() {
                          widget.spotModel.accessibility.pavedRoute = status;
                          widget.onSpotChange(widget.spotModel);
                        });
                      },
                      initAct: widget.spotModel.accessibility.pavedRoute,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Paved Road",
                      style: TextStyle(color: Resources.mainBlackColor),
                    ),
                  ],
                ),
              ),
              Container(
                width: sysWidth * 0.5 - 10,
                child: Row(
                  children: <Widget>[
                    AIconButtons(
                      show,
                      actImageUrl: "assets/offroad_act.png",
                      inactImageUrl: "assets/offroad_inct.png",
                      onTap: (status) {
                        print(status);
                        setState(() {
                          widget.spotModel.accessibility.offRoad = status;
                          widget.onSpotChange(widget.spotModel);
                        });
                      },
                      initAct: widget.spotModel.accessibility.offRoad,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Offroad",
                      style: TextStyle(color: Resources.mainBlackColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Row(
            children: <Widget>[
              Container(
                width: sysWidth * 0.5 - 10,
                child: Row(
                  children: <Widget>[
                    AIconButtons(
                      show,
                      actImageUrl: "assets/unpaveRoad_act.png",
                      inactImageUrl: "assets/unpaveroad_inact.png",
                      onTap: (status) {
                        print(status);
                        setState(() {
                          widget.spotModel.accessibility.unPavedRoad = status;
                          widget.onSpotChange(widget.spotModel);
                        });
                      },
                      initAct: widget.spotModel.accessibility.unPavedRoad,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Unpaved Road",
                      style: TextStyle(color: Resources.mainBlackColor),
                    ),
                  ],
                ),
              ),
              Container(
                width: sysWidth * 0.5 - 10,
                child: Row(
                  children: <Widget>[
                    AIconButtons(
                      show,
                      initAct: widget.spotModel.accessibility.forestRoad,
                      actImageUrl: "assets/forestroad_act.png",
                      inactImageUrl: "assets/forestroad_inact.png",
                      onTap: (status) {
                        print(status);
                        setState(() {
                          widget.spotModel.accessibility.forestRoad = status;
                          widget.onSpotChange(widget.spotModel);
                        });
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Forest Road",
                      style: TextStyle(color: Resources.mainBlackColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "ACTIVITIES",
          style: TextStyle(color: Resources.mainBlackColor),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show,
                  initAct: widget.spotModel.activities.climbing,
                  onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.activities.climbing = status;
                });
              },
                  actImageUrl: "assets/icons/climbing_active.png",
                  inactImageUrl: "assets/icons/climbing_incat.png"),
            ),
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show,
                  initAct: widget.spotModel.activities.surf, onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.activities.surf = status;
                });
              },
                  actImageUrl: "assets/icons/surf_actv.png",
                  inactImageUrl: "assets/icons/surf_inact.png"),
            ),
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show,
                  initAct: widget.spotModel.activities.climb, onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.activities.climb = status;
                });
              },
                  actImageUrl: "assets/icons/climb_active.png",
                  inactImageUrl: "assets/icons/climb_inactive.png"),
            ),
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show,
                  initAct: widget.spotModel.activities.fire, onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.activities.fire = status;
                });
              },
                  actImageUrl: "assets/icons/fire_actv.png",
                  inactImageUrl: "assets/icons/fire_inactv.png"),
            ),
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show, onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.activities.boat = status;
                });
              },
                  initAct: widget.spotModel.activities.boat,
                  actImageUrl: "assets/icons/boat_actv.png",
                  inactImageUrl: "assets/icons/boat_inactv.png"),
            ),
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show, onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.activities.iron = status;
                });
              },
                  initAct: widget.spotModel.activities.iron,
                  actImageUrl: "assets/icons/iron_actv.png",
                  inactImageUrl: "assets/icons/iron_inactv.png"),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show,
                  initAct: widget.spotModel.activities.wind, onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.activities.wind = status;
                });
              },
                  actImageUrl: "assets/icons/wind_activ.png",
                  inactImageUrl: "assets/icons/wind_inactiv.png"),
            ),
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show,
                  initAct: widget.spotModel.activities.bike, onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.activities.bike = status;
                });
              },
                  actImageUrl: "assets/icons/bike_actv.png",
                  inactImageUrl: "assets/icons/bike_inactv.png"),
            ),
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show, onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.activities.safari = status;
                });
              },
                  initAct: widget.spotModel.activities.safari,
                  actImageUrl: "assets/icons/safari_actv.png",
                  inactImageUrl: "assets/icons/safari_inactv.png"),
            ),
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show, onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.activities.diving = status;
                });
              },
                  initAct: widget.spotModel.activities.diving,
                  actImageUrl: "assets/icons/diving_act.png",
                  inactImageUrl: "assets/icons/diving_inact.png"),
            ),
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show,
                  initAct: widget.spotModel.activities.jump, onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.activities.jump = status;
                });
              },
                  actImageUrl: "assets/icons/jump_actv.png",
                  inactImageUrl: "assets/icons/jump_inactv.png"),
            ),
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show, onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.activities.snow = status;
                });
              },
                  initAct: widget.spotModel.activities.snow,
                  actImageUrl: "assets/icons/snow_actv.png",
                  inactImageUrl: "assets/icons/snow_inactv.png"),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "ENVIRONMENT",
          style: TextStyle(color: Resources.mainBlackColor),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show, onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.environment.mountain = status;
                });
              },
                  initAct: widget.spotModel.environment.mountain,
                  actImageUrl: "assets/icons/mountain_act.png",
                  inactImageUrl: "assets/icons/mantain_inact.png"),
            ),
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show, onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.environment.desert = status;
                });
              },
                  initAct: widget.spotModel.environment.desert,
                  actImageUrl: "assets/icons/desert_actv.png",
                  inactImageUrl: "assets/icons/desert_inact.png"),
            ),
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show,
                  initAct: widget.spotModel.environment.waterfall,
                  onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.environment.waterfall = status;
                });
              },
                  actImageUrl: "assets/icons/waterfall_act.png",
                  inactImageUrl: "assets/icons/waterfall_inact.png"),
            ),
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show,
                  initAct: widget.spotModel.environment.cliff, onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.environment.cliff = status;
                });
              },
                  actImageUrl: "assets/icons/cliff_act.png",
                  inactImageUrl: "assets/icons/cliff_inactv.png"),
            ),
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show, onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.environment.lac = status;
                });
              },
                  initAct: widget.spotModel.environment.lac,
                  actImageUrl: "assets/icons/lac_actv.png",
                  inactImageUrl: "assets/icons/lac_inactv.png"),
            ),
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show,
                  initAct: widget.spotModel.environment.sea, onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.environment.sea = status;
                });
              },
                  actImageUrl: "assets/icons/sea_actv.png",
                  inactImageUrl: "assets/icons/sea_inactv.png"),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: (sysWidth - 20) / 8,
              child: AIconButtons(show,
                  initAct: widget.spotModel.environment.river, onTap: (status) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.environment.river = status;
                });
              },
                  actImageUrl: "assets/icons/reiver_actv.png",
                  inactImageUrl: "assets/icons/reiver_inactv.png"),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "NECESSITIES",
          style: TextStyle(color: Resources.mainBlackColor),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CheckBoxTile(
              show,
              title: "Water",
              value: widget.spotModel.necessities.water,
              width: sysWidth / 2,
              onChange: (value) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.necessities.water = value;
                });
              },
            ),
            CheckBoxTile(
              show,
              title: "Electricity",
              value: widget.spotModel.necessities.electricity,
              width: sysWidth / 2,
              onChange: (value) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.necessities.electricity = value;
                });
              },
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CheckBoxTile(
              show,
              title: "Drinking Water",
              value: widget.spotModel.necessities.drinkingWater,
              width: sysWidth / 2,
              onChange: (value) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.necessities.drinkingWater = value;
                });
              },
            ),
            CheckBoxTile(
              show,
              title: "Wi-fi",
              value: widget.spotModel.necessities.wifi,
              width: sysWidth / 2,
              onChange: (value) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.necessities.wifi = value;
                });
              },
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CheckBoxTile(
              show,
              title: "Shower",
              value: widget.spotModel.necessities.shower,
              width: sysWidth / 2,
              onChange: (value) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.necessities.shower = value;
                });
              },
            ),
            CheckBoxTile(
              show,
              title: "Cellular Network",
              value: widget.spotModel.necessities.cellularNetwork,
              width: sysWidth / 2,
              onChange: (value) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.necessities.cellularNetwork = value;
                });
              },
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CheckBoxTile(
              show,
              title: "Trash bin",
              value: widget.spotModel.necessities.trashbin,
              width: sysWidth / 2,
              onChange: (value) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.necessities.trashbin = value;
                });
              },
            ),
            CheckBoxTile(
              show,
              title: "Toilet",
              value: widget.spotModel.necessities.toilet,
              width: sysWidth / 2,
              onChange: (value) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.necessities.toilet = value;
                });
              },
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CheckBoxTile(
              show,
              title: "Repair Mechanic",
              value: widget.spotModel.necessities.repairMechanics,
              width: sysWidth / 2,
              onChange: (value) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.necessities.repairMechanics = value;
                });
              },
            ),
            CheckBoxTile(
              show,
              title: "Auto parts",
              value: widget.spotModel.necessities.autoParts,
              width: sysWidth / 2,
              onChange: (value) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.necessities.autoParts = value;
                });
              },
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CheckBoxTile(
              show,
              title: "Gas",
              value: widget.spotModel.necessities.gas,
              width: sysWidth / 2,
              onChange: (value) {
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.necessities.gas = value;
                });
              },
            ),
            CheckBoxTile(
              show,
              title: "Laundary",
              value: widget.spotModel.necessities.laundary,
              width: sysWidth / 2,
              onChange: (value) {
                print(value);
                setState(() {
                  widget.onSpotChange(widget.spotModel);
                  widget.spotModel.necessities.laundary = value;
                });
              },
            )
          ],
        ),
      ],
    );
  }
}

class CheckBoxTile extends StatefulWidget {
  CheckBoxTile(this.show, {this.onChange, this.title, this.value, this.width});
  final bool value;
  final String title;
  final Function(bool) onChange;
  final double width;
  final bool show;
  @override
  _CheckBoxTileState createState() => _CheckBoxTileState(show,
      title: title, value: value, onChange: onChange, width: width);
}

class _CheckBoxTileState extends State<CheckBoxTile> {
  _CheckBoxTileState(this.show,
      {this.onChange, this.title, this.value, this.width});
  bool value;
  final String title;
  final Function(bool) onChange;
  final double width;
  final bool show;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        width: width - 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(color: Resources.mainBlackColor),
            ),
            show
                ? Icon(
                    value
                        ? FontAwesomeIcons.solidCheckSquare
                        : FontAwesomeIcons.square,
                    color: Resources.mainColor,
                  )
                : Checkbox(
                    activeColor: Resources.mainColor,
                    value: value,
                    onChanged: (value) {
                      setState(() {
                        this.value = value;
                      });
                      onChange(value);
                    },
                  )
          ],
        ),
      ),
    );
  }
}
