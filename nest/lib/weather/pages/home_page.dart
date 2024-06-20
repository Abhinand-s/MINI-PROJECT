import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';
import 'package:signup_login/weather/consts.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  Weather? _weather;

  void _fetchWeather(String cityName) {
    _wf.currentWeatherByCityName(cityName).then((w) {
      setState(() {
        _weather = w;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: _buildUI()),
    );
  }

  Widget _buildUI() {
    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
        width: 200, // Adjust the width as needed
        child: TextField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Enter city name',
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Adjust the padding as needed
      ),
      onSubmitted: (value) {
        _fetchWeather(value);
      },
        ),
      ),
            if (_weather != null) ...[
              _locationHeader(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              _dateTimeInfo(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              _weatherIcon(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              _currentTemp(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              _extraInfo()
            ] else ...[
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _locationHeader() {
    return Text(
      _weather?.areaName ?? "",
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mma").format(now),
          style: const TextStyle(fontSize: 35),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              "${DateFormat("d.m.y").format(now)}",
              style: const TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        )
      ],
    );
  }

  Widget _weatherIcon() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"))),
        ),
        Text(
          _weather?.weatherDescription ?? "",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        )
      ],
    );
  }

  Widget _currentTemp() {
    return Text("${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
        style: const TextStyle(
            color: Colors.black, fontSize: 90, fontWeight: FontWeight.w500));
  }

  Widget _extraInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("MAX:${_weather?.tempMax?.celsius?.toStringAsFixed(0)}°C",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  )),
              Text("MIN:${_weather?.tempMin?.celsius?.toStringAsFixed(0)}°C",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ))
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("WIND:${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  )),
              Text("HUMIDITY:${_weather?.humidity?.toStringAsFixed(0)}%",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
