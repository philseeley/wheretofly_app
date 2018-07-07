import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Data.dart';
import 'SiteForecastListView.dart';
import 'SettingsPage.dart';

void main() => runApp(WhereToFlyApp());

class WhereToFlyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle ts = Theme.of(context).textTheme.subhead.apply(fontWeightDelta: 4);

    return MaterialApp(
      title: 'Where To Fly',
      home: Main(),
      theme: ThemeData(
        textTheme: TextTheme(body1: ts, subhead: ts)
      ),
    );
  }
}

class Main extends StatefulWidget {
  Main({Key key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> with WidgetsBindingObserver {
  static final dayF = DateFormat('EEE dd MMMM');

  final Settings settings = Settings();

  double latitude = 0.0;
  double longitude = 0.0;
  bool sortByLocation = true;
  bool onlyShowOn = true;
  Group showGroup = Group();

  List<Site> _sites;
  List<String> times;

  _MainState() {
    getForecast();
  }

  getForecast() async {
    try {
      var loc = <String, double>{};

      loc = await Location().getLocation;
      latitude = loc["latitude"];
      longitude = loc["longitude"];

    } catch (e, s) {
      //TODO something useful to debug
      print(e);
      print(s);
    }

    try {
      dynamic data;

      var uri = Uri.https(
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
            _sites = parseSites(data, latitude, longitude);
            times = parseTimes(data);
          } catch (e, s) {
            print(e);
            print(s);
          }

          _sort();
        });
    } catch (e, s) {
      //TODO something useful to debug
      print(e);
      print(s);
    }
  }

  _sort(){
    Site.sort(_sites, sortByLocation);

    sortByLocation = !sortByLocation;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state)
    {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.suspending:
        settings.save();
        break;
      case AppLifecycleState.resumed:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    if(_sites == null || _sites.length == 0)
      return Scaffold(
        appBar: AppBar(title: Text("Where To Fly")),
        body: Center(child: Text("Waiting for Location"))
      );

    List<Widget> pages = List<Widget>();

    for(int day = 0; day < _sites[0].forecasts.length; ++day)
    {
      List<Widget> list = List<Widget>();

      for (Site s in _sites)
      {
        if(showGroup.name == null || showGroup.sites.contains(s.name)) {
          Forecast forecast = s.forecasts[day];

          Row forecastRow = SiteForecastListView.buildForecastRow(
            context, settings, forecast, onlyShowOn, false);

          if (forecastRow != null) {
            list.add(Text(s.title, textAlign: TextAlign.center));
            list.add(InkWell(child: forecastRow, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SiteForecast(settings, _sites, s, times);
              }));
            }));

            if (settings.showForecast && (forecast.imgTitle.length > 0))
              list.add(Text(
                forecast.imgTitle, textAlign: TextAlign.center, style: Theme
                .of(context)
                .textTheme
                .body2));
          }
        }
      }

      // If we're hiding the extreme values we might not have any rows to show.
      if(list.length > 0) {
        Row timeRow = SiteForecastListView.buildTimeRow(
            context, settings, times, false, _sites[0].forecasts[day].date);

        pages.add(Column(children: <Widget>[
              timeRow,
              Expanded(child: ListView(children: list))
            ])
        );
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Where To Fly"),
          actions: <Widget>[
            IconButton(icon: Icon(
                sortByLocation ? Icons.location_off : Icons.location_on),
                onPressed: () {
                  setState(() {
                    _sort();
                  });
                }),
            IconButton(icon: Icon(Icons.power_settings_new,
                color: onlyShowOn ? Colors.red : Colors.white),
                onPressed: () {
                  setState(() {
                    onlyShowOn = !onlyShowOn;
                  });
                }),
            IconButton(icon: Icon(
              settings.showForecast ? Icons.cloud : Icons.cloud_off),
              onPressed: () {
                setState(() {
                  settings.showForecast = !settings.showForecast;
                });
              }),
            IconButton(icon: Icon(Icons.group),
              onPressed: () {
                setState(() {
                  settings.showForecast = !settings.showForecast;
                });
              }),
            IconButton(icon: Icon(Icons.settings), onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) {
                return SettingsPage(settings, _sites);
              }));
            }),
            PopupMenuButton<Group>(
              onSelected: (group){
                setState(() {
                  showGroup = group;
                });
              },
              itemBuilder: (context){
              List<PopupMenuItem<Group>> l = [];

              l.add(PopupMenuItem<Group>(value: null, child: Text("Groups:")));
              l.add(PopupMenuItem<Group>(value: Group(), child: Text("ALL")));

              for(Group g in settings.groups)
                l.add(PopupMenuItem<Group>(value: g, child: Text(g.name)));

              return l;
            })
          ],
        ),
        body: PageView(children: pages)
    );
  }
}

class SiteForecast extends StatefulWidget {
  final Site site;
  final List<String> times;
  final Settings settings;
  final List<Site> sites;

  SiteForecast(this.settings, this.sites, this.site, this.times);

  @override
  _SiteForecastState createState() => _SiteForecastState();
}

class _SiteForecastState extends State<SiteForecast> {
  static final dayF = DateFormat('EEE');

  @override
  Widget build(BuildContext context) {
    Settings settings = widget.settings;
    Site site = widget.site;
    List<String> times = widget.times;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.info), onPressed: (){
            setState(() {
              launch(site.url);
            });
          }),
          IconButton(icon: Icon(settings.showForecast?Icons.cloud:Icons.cloud_off), onPressed: (){
            setState(() {
              settings.showForecast = !settings.showForecast;
            });
          }),
          IconButton(icon: Icon(Icons.cloud_upload), onPressed: (){
            setState(() {
              launch(site.weatherURL);
            });
          }),
          (site.obsURL != null)?IconButton(icon: Icon(Icons.cloud, color: Colors.red), onPressed: (){
            setState(() {
              launch(site.obsURL);
            });
          }):Container(),
          IconButton(icon: Icon(Icons.settings), onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)
            {
              return SettingsPage(settings, widget.sites);
            }));
          }),
        ],
      ),
      body: Column(children: <Widget>[
        Text(site.title),
        SiteForecastListView.buildTimeRow(context, settings, times, true, null),
        Expanded(child: SiteForecastListView(settings, site))
        ])
    );
  }
}
