class Weather {
  String city;
  String date;
  String condition;
  String icon;
  double temp;
  double min;
  double max;
  double feelTemp;
  int humidity;
  double wind;
  double visibility;
  double uv;

  // Sugar
  Weather(this.city, this.date, this.condition, this.icon, this.temp, this.min, this.max,this.feelTemp,this.humidity,this.wind,this.visibility, this.uv);

  Weather.from(Map<String, dynamic> e) {
    this.city = e['location']['name'];
    this.date = e['location']['localtime'];
    this.condition = e['current']['condition']['text'];
    this.icon = e['current']['condition']['icon'];
    this.temp = e['current']['temp_c'];
    this.min = e['forecast']['forecastday'].first['day']['mintemp_c'];
    this.max = e['forecast']['forecastday'].first['day']['maxtemp_c'];
    this.feelTemp = e['current']['feelslike_c'];
    this.humidity = e['current']['humidity'];
    this.wind = e['current']['wind_kph'];
    this.visibility = e['current']['vis_km'];
    this.uv = e['current']['uv'];
  }

  @override
  String toString() {
    return 'Weather{city: $city, condition: $condition}';
  }


}