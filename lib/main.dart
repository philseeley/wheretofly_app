import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:io';
import 'Site.dart';
import 'SiteForecastListView.dart';
import 'dart:math';

void main() => runApp(new WhereToFlyApp());

class WhereToFlyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Where To Fly',
      home: new Main(),
    );
  }
}

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);

  @override
  _MainState createState() => new _MainState();
}

class _MainState extends State<Main> {
  final List<Site> _sites = new List<Site>();
  static final dirs = {'W': 0.0*pi/180.0,
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


  _MainState() {
    getForcast();
  }

  getForcast() async {
    try {
      dynamic data;

      var uri = new Uri.https(
          'wheretofly.info', '/run/current.json');

      http.Response response = await http.get(uri);
      data = json.decode(response.body);

//      String s = '{"times":["2.00 AM","5.00 AM","8.00 AM","11.00 AM","2.00 PM","5.00 PM","8.00 PM","11.00 PM"],"sites":[{"name":"spion_kop","title":"Spion Kop (Fairhaven, Aireys, Moggs)","url":"http://www.vhpa.org.au/Sites/Spion%20Kop%20(Fairhaven,%20Aireys,%20Moggs).html","weather_url":"http://wind.willyweather.com.au/vic/barwon/moggs-creek.html","lat":-38.46,"lon":144.06,"minDir":"SSE","maxDir":"SSW","minSpeed":5,"maxSpeed":15,"forecast":[{"date":"2017-02-25","img":"run/images/partly-cloudy.png","imgTitle":"Partly cloudy.","conditions":[{"dir":"","kts":""},{"dir":"","kts":""},{"dir":"","kts":""},{"dir":"S","kts":"14","colour":"LightGreen"},{"dir":"S","kts":"14","colour":"LightGreen"},{"dir":"SSE","kts":"16","colour":"Orange"},{"dir":"ESE","kts":"15"},{"dir":"ESE","kts":"19"}]},{"date":"2017-02-26","img":"run/images/partly-cloudy.png","imgTitle":"Partly cloudy.","conditions":[{"dir":"ESE","kts":"19"},{"dir":"E","kts":"19"},{"dir":"E","kts":"19"},{"dir":"E","kts":"11"},{"dir":"ESE","kts":"7"},{"dir":"ESE","kts":"9"},{"dir":"ESE","kts":"8"},{"dir":"E","kts":"8"}]},{"date":"2017-02-27","img":"run/images/sunny.png","imgTitle":"Sunny.","conditions":[{"dir":"E","kts":"10"},{"dir":"E","kts":"7"},{"dir":"N","kts":"3"},{"dir":"ENE","kts":"4"},{"dir":"E","kts":"7"},{"dir":"SSE","kts":"9","colour":"LightGreen"},{"dir":"SW","kts":"3"},{"dir":"S","kts":"6","colour":"LightGreen"}]},{"date":"2017-02-28","img":"run/images/sunny.png","imgTitle":"Sunny.","conditions":[{"dir":"N","kts":"3"},{"dir":"N","kts":"4"},{"dir":"NNW","kts":"2"},{"dir":"ENE","kts":"5"},{"dir":"E","kts":"7"},{"dir":"SSE","kts":"9","colour":"LightGreen"},{"dir":"SW","kts":"3"},{"dir":"SSE","kts":"3","colour":"Yellow"}]},{"date":"2017-03-01","img":"run/images/partly-cloudy.png","imgTitle":"Mostly sunny.","conditions":[{"dir":"N","kts":"5"},{"dir":"NNW","kts":"4"},{"dir":"NNE","kts":"3"},{"dir":"ENE","kts":"4"},{"dir":"E","kts":"7"},{"dir":"SSE","kts":"3","colour":"Yellow"},{"dir":"ENE","kts":"1"},{"dir":"NNE","kts":"2"}]},{"date":"2017-03-02","img":"run/images/sunny.png","imgTitle":"Possible shower later.","conditions":[{"dir":"N","kts":"3"},{"dir":"N","kts":"4"},{"dir":"NNE","kts":"5"},{"dir":"ENE","kts":"5"},{"dir":"E","kts":"4"},{"dir":"ESE","kts":"3"},{"dir":"NE","kts":"3"},{"dir":"NNW","kts":"4"}]},{"date":"2017-03-03","img":"run/images/partly-cloudy.png","imgTitle":"Partly cloudy.","conditions":[{"dir":"WNW","kts":"4"},{"dir":"W","kts":"3"},{"dir":"SSW","kts":"3","colour":"Yellow"},{"dir":"SSE","kts":"3","colour":"Yellow"},{"dir":"S","kts":"4","colour":"Yellow"},{"dir":"SSW","kts":"5","colour":"LightGreen"},{"dir":"SSW","kts":"5","colour":"LightGreen"},{"dir":"SSW","kts":"6","colour":"LightGreen"}]}]},{"name":"ben_more","title":"Ben More","url":"http://www.vhpa.org.au/Sites/Ben%20More.html","weather_url":"http://wind.willyweather.com.au/vic/central-highlands/amphitheatre.html","lat":-37.22,"lon":143.43,"minDir":"SSW","maxDir":"WSW","minSpeed":5,"maxSpeed":10,"forecast":[{"date":"2017-02-25","img":"run/images/sunny.png","imgTitle":"Partly cloudy. Slight (20%) chance of drizzle near the Otways this evening. Winds south to southeasterly 20 to 30 km/h. Daytime maximum temperatures between 19 and 23.","conditions":[{"dir":"","kts":""},{"dir":"","kts":""},{"dir":"","kts":""},{"dir":"SSE","kts":"17"},{"dir":"SSE","kts":"15"},{"dir":"S","kts":"15"},{"dir":"SSE","kts":"12"},{"dir":"SSE","kts":"13"}]},{"date":"2017-02-26","img":"run/images/fog.png","imgTitle":"Partly cloudy. Slight (20%) chance of drizzle near the Otways in the early morning. Near zero chance of rain elsewhere. Winds south to southeasterly 15 to 25 km/h tending east to southeasterly 15 to 20 km/h early in the morning then tending south to southeasterly in the middle of the day. Overnight temperatures falling to between 8 and 11 with daytime temperatures reaching 25 to 30.","conditions":[{"dir":"SSE","kts":"11"},{"dir":"SSE","kts":"7"},{"dir":"ESE","kts":"5"},{"dir":"NNE","kts":"11"},{"dir":"NNE","kts":"7"},{"dir":"ENE","kts":"6"},{"dir":"E","kts":"6"},{"dir":"ESE","kts":"6"}]},{"date":"2017-02-27","img":"run/images/partly-cloudy.png","imgTitle":"Sunny. Light winds becoming north to northeasterly 15 to 20 km/h during the morning then turning east to southeasterly later in the day. Overnight temperatures falling to around 15 with daytime temperatures reaching around 30.","conditions":[{"dir":"E","kts":"5"},{"dir":"ENE","kts":"7"},{"dir":"ENE","kts":"8"},{"dir":"NE","kts":"8"},{"dir":"NE","kts":"5"},{"dir":"E","kts":"5"},{"dir":"E","kts":"5"},{"dir":"E","kts":"6"}]},{"date":"2017-02-28","img":"run/images/partly-cloudy.png","imgTitle":"Sunny. Winds east to northeasterly 15 to 20 km/h tending north to northeasterly during the morning then turning east to southeasterly during the day. Overnight temperatures falling to around 16 with daytime temperatures reaching the low to mid 30s.","conditions":[{"dir":"ENE","kts":"7"},{"dir":"ENE","kts":"6"},{"dir":"ENE","kts":"7"},{"dir":"NE","kts":"8"},{"dir":"NNE","kts":"6"},{"dir":"ENE","kts":"5"},{"dir":"E","kts":"6"},{"dir":"ESE","kts":"6"}]},{"date":"2017-03-01","img":"run/images/cloudy.png","imgTitle":"","conditions":[{"dir":"ESE","kts":"3"},{"dir":"NE","kts":"3"},{"dir":"NE","kts":"1"},{"dir":"NNE","kts":"4"},{"dir":"E","kts":"3"},{"dir":"SSE","kts":"4"},{"dir":"ESE","kts":"6"},{"dir":"ESE","kts":"3"}]},{"date":"2017-03-02","img":"run/images/showers.png","imgTitle":"","conditions":[{"dir":"E","kts":"3"},{"dir":"E","kts":"3"},{"dir":"ENE","kts":"3"},{"dir":"NE","kts":"3"},{"dir":"ESE","kts":"3"},{"dir":"S","kts":"3"},{"dir":"ESE","kts":"3"},{"dir":"ESE","kts":"4"}]},{"date":"2017-03-03","img":"run/images/cloudy.png","imgTitle":"","conditions":[{"dir":"ESE","kts":"3"},{"dir":"E","kts":"2"},{"dir":"NE","kts":"3"},{"dir":"NNE","kts":"4"},{"dir":"NW","kts":"5"},{"dir":"WSW","kts":"5","colour":"LightGreen"},{"dir":"SSW","kts":"6","colour":"LightGreen"},{"dir":"SSE","kts":"5"}]}]},{"name":"ben_nevis","title":"Ben Nevis","url":"http://www.vhpa.org.au/Sites/Ben%20Nevis.html","weather_url":"http://wind.willyweather.com.au/vic/central-highlands/warrak.html","lat":-37.23,"lon":143.19,"minDir":"W","maxDir":"NW","minSpeed":5,"maxSpeed":10,"forecast":[{"date":"2017-02-25","img":"run/images/sunny.png","imgTitle":"Partly cloudy. Slight (20%) chance of drizzle near the Otways this evening. Winds south to southeasterly 20 to 30 km/h. Daytime maximum temperatures between 19 and 23.","conditions":[{"dir":"","kts":""},{"dir":"","kts":""},{"dir":"","kts":""},{"dir":"SSE","kts":"17"},{"dir":"SSE","kts":"15"},{"dir":"SSE","kts":"15"},{"dir":"SSE","kts":"13"},{"dir":"SSE","kts":"15"}]},{"date":"2017-02-26","img":"run/images/partly-cloudy.png","imgTitle":"Partly cloudy. Slight (20%) chance of drizzle near the Otways in the early morning. Near zero chance of rain elsewhere. Winds south to southeasterly 15 to 25 km/h tending east to southeasterly 15 to 20 km/h early in the morning then tending south to southeasterly in the middle of the day. Overnight temperatures falling to between 8 and 11 with daytime temperatures reaching 25 to 30.","conditions":[{"dir":"SSE","kts":"12"},{"dir":"ESE","kts":"10"},{"dir":"ESE","kts":"7"},{"dir":"NNE","kts":"10"},{"dir":"NNE","kts":"6"},{"dir":"NE","kts":"5"},{"dir":"E","kts":"5"},{"dir":"E","kts":"8"}]},{"date":"2017-02-27","img":"run/images/partly-cloudy.png","imgTitle":"Sunny. Light winds becoming north to northeasterly 15 to 20 km/h during the morning then turning east to southeasterly later in the day. Overnight temperatures falling to around 15 with daytime temperatures reaching around 30.","conditions":[{"dir":"ENE","kts":"8"},{"dir":"ENE","kts":"9"},{"dir":"ENE","kts":"12"},{"dir":"NE","kts":"8"},{"dir":"NNE","kts":"5"},{"dir":"ENE","kts":"5"},{"dir":"E","kts":"6"},{"dir":"ENE","kts":"8"}]},{"date":"2017-02-28","img":"run/images/partly-cloudy.png","imgTitle":"Sunny. Winds east to northeasterly 15 to 20 km/h tending north to northeasterly during the morning then turning east to southeasterly during the day. Overnight temperatures falling to around 16 with daytime temperatures reaching the low to mid 30s.","conditions":[{"dir":"ENE","kts":"9"},{"dir":"NE","kts":"7"},{"dir":"NE","kts":"11"},{"dir":"NE","kts":"9"},{"dir":"N","kts":"5"},{"dir":"N","kts":"5"},{"dir":"ESE","kts":"6"},{"dir":"E","kts":"7"}]},{"date":"2017-03-01","img":"run/images/cloudy.png","imgTitle":"","conditions":[{"dir":"ENE","kts":"4"},{"dir":"ENE","kts":"4"},{"dir":"NE","kts":"3"},{"dir":"N","kts":"4"},{"dir":"SSW","kts":"1"},{"dir":"ESE","kts":"5"},{"dir":"E","kts":"3"},{"dir":"E","kts":"4"}]},{"date":"2017-03-02","img":"run/images/partly-cloudy.png","imgTitle":"","conditions":[{"dir":"ENE","kts":"4"},{"dir":"ENE","kts":"3"},{"dir":"NE","kts":"3"},{"dir":"N","kts":"3"},{"dir":"WNW","kts":"3","colour":"Yellow"},{"dir":"SW","kts":"3"},{"dir":"SSE","kts":"4"},{"dir":"E","kts":"4"}]},{"date":"2017-03-03","img":"run/images/cloudy.png","imgTitle":"","conditions":[{"dir":"ENE","kts":"4"},{"dir":"ENE","kts":"3"},{"dir":"NNE","kts":"4"},{"dir":"NNW","kts":"5"},{"dir":"NW","kts":"5","colour":"LightGreen"},{"dir":"W","kts":"4","colour":"Yellow"},{"dir":"SW","kts":"5"},{"dir":"SSE","kts":"5"}]}]}]}';
//      data = json.decode(s);

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      if (data != null)
        setState(() {
          try {
            for (var s in data['sites']) {
              num lat = s['lat'];
              num lon = s['lon'];
              var site = new Site(
                s['name'],
                s['title'],
                lat.toDouble(),
                lon.toDouble(),
                s['url'],
                s['weather_url'],
                s['obs_url'],
              );
              _sites.add(site);

              for(var f in s['forecast']){
                var forecast = new Forecast(DateTime.parse(f['date']), f['img'], f['imgTitle']);
                site.forecasts.add(forecast);

                for(var c in f['conditions']){
                  int kts = 0;
                  try
                  {
                    kts = int.parse(c['kts']);
                  } catch(e){};
                  int kms = 0;
                  try
                  {
                    kms = int.parse(c['kms']);
                  } catch(e){};

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

                  var condition = new Condition(c['dir'], dirs[c['dir']], kts, kms, colour, pgColour);
                  forecast.conditions.add(condition);
                }
              }
            }
          } catch (e, s) {
            print(e);
            print(s);
          }
        });
    } catch (e, s) {
      //TODO something useful to debug
      print(e);
      print(s);
    }
  }

  _sort (){
    setState(() {
      _sites.sort((a, b) => a.title.compareTo(b.title));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> list = new List<Widget>();

    for(Site s in _sites){
      list.add(new ListTile(
          title: new Text(s.title, style: Theme.of(context).textTheme.subhead.apply(fontWeightDelta: 4)),
          subtitle: SiteForecastListView.buildForecastRow(context, s.forecasts[0], false),
          onTap: () {
            Navigator.push(context, new MaterialPageRoute(builder: (context) {
              return new SiteForcecast(site: s);
            }));}
      ));
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sites"),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.sort), onPressed: _sort),
        ],
        ),
      body: new ListView(children: list)
    );
  }
}

class SiteForcecast extends StatefulWidget {
  final Site site;

  SiteForcecast({Key key, this.site}) : super(key: key);

  @override
  _SiteForecasteState createState() => new _SiteForecasteState();
}

class _SiteForecasteState extends State<SiteForcecast> {
  static final dayF = new DateFormat('EEE');

  Site site;

  @override
  Widget build(BuildContext context) {
    site = widget.site;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(site.title),
      ),
      body: new SiteForecastListView(site)
    );
  }
}
