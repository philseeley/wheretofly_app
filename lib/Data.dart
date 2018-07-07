import 'dart:math';
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:great_circle_distance/great_circle_distance.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Group {
  String name;
  List<String> sites = [];

  Map toJson(){
    return {
      'name': name,
      'sites': sites
    };
  }
}

class Settings {
  bool showPGValues = false;
  bool showForecast = false;
  num iconSize = 40.0;
  bool hideExtremes = false;
  List<Group> groups = [];

  File _store;

  Settings(){
    load();
  }

  Map toJson(){
    return {
      'showPGValues': showPGValues,
      'showForecast': showForecast,
      'iconSize': iconSize,
      'hideExtremes': hideExtremes,
      'groups': groups
    };
  }

  load() async {
    Directory directory = await path_provider.getApplicationDocumentsDirectory();
    _store = new File('${directory.path}/settings.json');

    try {
      String s = _store.readAsStringSync();
      dynamic data = json.decode(s);

      if(data['showPGValues'] != null) showPGValues = data['showPGValues'];
      if(data['showForecast'] != null) showForecast = data['showForecast'];
      if(data['iconSize'    ] != null) iconSize = data['iconSize'];
      if(data['hideExtremes'] != null) hideExtremes = data['hideExtremes'];

      if(data['groups'] != null) {
        for(var d in data['groups']){
          Group g = new Group();

          g.name = d['name'];

          for(String s in d['sites'])
            g.sites.add(s);

          groups.add(g);
        }
      }

    } on FileSystemException {}
  }

  save (){
    _store.writeAsStringSync(json.encode(this));
  }
}

class Condition {
  final String dirStr;
  final double dir;
  final int kts;
  final int kmh;
  final Color colour;
  final Color pgColour;

  Condition(this.dirStr, this.dir, this.kts, this.kmh, this.colour, this.pgColour);
}

class Forecast {
  final DateTime date;
  final String imageURL;
  CachedNetworkImage _image;
  double _imageSize;
  final String imgTitle;
  final List<Condition> conditions = [];

  Forecast(this.date, this.imageURL, this.imgTitle);

  CachedNetworkImage getImage(double imageSize) {
    if(_image == null || (_imageSize != imageSize)){
      _imageSize = imageSize;
      _image = CachedNetworkImage(imageUrl: "https://wheretofly.info/"+imageURL, width: _imageSize, height: _imageSize);
    }

    return _image;
  }
}

class Site {
  final String name;
  final String title;
  final double lat;
  final double lon;
  final double dist;
  final String url;
  final String weatherURL;
  final String obsURL;

  final List<Forecast> forecasts = [];

  Site(this.name, this.title, this.lat, this.lon, this.dist, this.url, this.weatherURL, this.obsURL);

  static sort(List<Site> sites, bool byLocation){
    if(byLocation)
      sites.sort((a, b){return (a.dist-b.dist).round();});
    else
      sites.sort((a, b){return a.title.compareTo(b.title);});
  }
}

final _dirs = {'W': 0.0*pi/180.0,
  'WNW': 22.5*pi/180.0,
  'NW': 45.0*pi/180.0,
  'NNW': 67.5*pi/180.0,
  'N': 90.0*pi/180.0,
  'NNE': 112.5*pi/180.0,
  'NE': 135.0*pi/180.0,
  'ENE': 157.5*pi/180.0,
  'E': 180.0*pi/180.0,
  'ESE': 202.5*pi/180.0,
  'SE': 225.0*pi/180.0,
  'SSE': 247.5*pi/180.0,
  'S': 270.0*pi/180.0,
  'SSW': 292.5*pi/180.0,
  'SW': 315.0*pi/180.0,
  'WSW': 337.5*pi/180.0};

List<Site> parseSites(dynamic data, double latitude, double longitude) {
  List<Site> sites = new List<Site>();

  for (var s in data['sites']) {
    num lat = s['lat'];
    num lon = s['lon'];
    var gcd = new GreatCircleDistance.fromDegrees(
        latitude1: latitude, longitude1: longitude, latitude2: lat.toDouble(), longitude2: lon.toDouble());
    double dist =gcd.haversineDistance();

    var site = new Site(
      s['name'],
      s['title'],
      lat.toDouble(),
      lon.toDouble(),
      dist,
      s['url'],
      s['weather_url'],
      s['obs_url'],
    );
    sites.add(site);

    for(var f in s['forecast']){
      var forecast = new Forecast(DateTime.parse(f['date']), f['img'], f['imgTitle']);

      site.forecasts.add(forecast);

      for(var c in f['conditions']){
        int kts = 0;
        try
        {
          kts = int.parse(c['kts']);
        } catch(e){}
        int kmh = 0;
        try
        {
          kmh = int.parse(c['kmh']);
        } catch(e){}

        Color colour = Colors.black26;
        switch(c['colour'])
        {
          case "Yellow":
            colour = Colors.yellow;
            break;
          case "LightGreen":
            colour = Colors.lightGreen;
            break;
          case "Orange":
            colour = Colors.orange;
            break;
        }

        Color pgColour = Colors.black26;
        switch(c['PGColour'])
        {
          case "Yellow":
            pgColour = Colors.yellow;
            break;
          case "LightGreen":
            pgColour = Colors.lightGreen;
            break;
          case "Orange":
            pgColour = Colors.orange;
            break;
        }

        var condition = new Condition(c['dir'], _dirs[c['dir']], kts, kmh, colour, pgColour);
        forecast.conditions.add(condition);
      }
    }
  }

  return sites;
}

List<String> parseTimes(dynamic data) {
  List<String> times = new List<String>();

  NumberFormat nf = new NumberFormat("00");

  for (String s in data['times']) {
    double t = double.parse(s.substring(0, s.length-3));

    if(s.substring(s.length-2) == "PM")
      t += 12.0;

    times.add(nf.format(t));
  }

  return times;
}