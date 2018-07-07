import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Data.dart';

class SiteForecastListView extends StatefulWidget {
  static final dayF = new DateFormat('EEE');

  final Site site;
  final Settings settings;

  SiteForecastListView(this.settings, this.site);

  @override
  _SiteForecastListViewState createState() => new _SiteForecastListViewState();

  static Row buildForecastRow(BuildContext context, Settings settings, Forecast forecast, bool onlyIfOn, bool showDay) {
    bool on = false;

    List<Widget> list = new List<Widget>();

    if(showDay)
      list.add(new Expanded(child: new Text(dayF.format(forecast.date), textAlign: TextAlign.center)));

    list.add(new Expanded(child: forecast.getImage(settings.iconSize)));

    for (int i=0; i<forecast.conditions.length; ++i){
      Condition c = forecast.conditions[i];

      if(!settings.hideExtremes || (i>1 && i<forecast.conditions.length-1)){
        Color colour = settings.showPGValues ? c.pgColour : c.colour;
        int speed = settings.showPGValues ? c.kmh : c.kts;

        if(colour != Colors.black26)
          on = true;

        Widget lt = Expanded(child:
        new Stack(alignment: AlignmentDirectional.center, children: <Widget>[
          new Transform.rotate(angle: c.dir == null?0.0:c.dir, child: new Icon(Icons.forward, color: (speed==0)?Theme.of(context).canvasColor:colour, size: settings.iconSize)),
          new Text((speed==0)?"":speed.toString())
        ],)
        );
        list.add(lt);
      }
    }

    // Sometimes the forecast is not downloaded from the BOM correctly, so there will be no conditions.
    if((forecast.conditions.length == 0) || (onlyIfOn && !on))
      return null;

    return new Row(children: list);
  }

  static Row buildTimeRow(BuildContext context, Settings settings, List<String> times, bool includeDay, DateTime date) {
    List<Widget> dateW = new List<Widget>();

    if(includeDay)
      dateW.add(new Expanded(child: new Text("", textAlign: TextAlign.center)));

    String day = (date == null) ? "" : dayF.format(date);

    dateW.add(new Expanded(child: new Text(day, textAlign: TextAlign.center)));

    for(int i=0; i<times.length; ++i) {
      String t = times[i];

      if(!settings.hideExtremes || (i>1 && i<times.length-1))
        dateW.add(new Expanded(child: new Text(t, textAlign: TextAlign.center)));
    }

    return new Row(children: dateW);
  }
}

class _SiteForecastListViewState extends State<SiteForecastListView> {

  @override
  Widget build(BuildContext context) {
    Settings settings = widget.settings;
    Site site = widget.site;

    List<Widget> list = new List<Widget>();

    for(Forecast f in site.forecasts){
      Row forecastRow = SiteForecastListView.buildForecastRow(context, settings, f, false, true);

      if(forecastRow != null){
        list.add(forecastRow);

        if(settings.showForecast && (f.imgTitle.length > 0))
          list.add(new Text(f.imgTitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.body2));
      }
    }

    return new ListView(children: list);
  }
}
