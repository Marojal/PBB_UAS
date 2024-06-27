import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sh/const.dart';
import 'package:weather/weather.dart';
import 'package:sh/header.dart';

class SuhuPage extends StatefulWidget {
  const SuhuPage({super.key});

  @override
  State<SuhuPage> createState() => _SuhuPageState();
}

class _SuhuPageState extends State<SuhuPage> {
  final WeatherFactory _wf = WeatherFactory(OPENWEATHER_API_KEY);
  late Future<Weather?> _weatherFuture;
  String _selectedCity = "Samarinda";

  @override
  void initState() {
    super.initState();
    _weatherFuture = _fetchWeather(_selectedCity);
  }

  Future<Weather?> _fetchWeather(String city) async {
    return await _wf.currentWeatherByCityName(city);
  }

  void _onCityChanged(String newCity) {
    setState(() {
      _selectedCity = newCity;
      _weatherFuture = _fetchWeather(newCity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff060720),
      appBar: CustomHeader(
        title: "Suhu",
        onMenuPressed: () {},
        onCityChanged: _onCityChanged,
      ),
      body: FutureBuilder<Weather?>(
        future: _weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching weather data'),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('No weather data available'),
            );
          } else {
            Weather? weather = snapshot.data;
            return SingleChildScrollView(
              child: _buildUI(weather),
            );
          }
        },
      ),
    );
  }

  Widget _buildUI(Weather? weather) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _locationHeader(weather),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          _dateTimeInfo(weather!),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          _weatherIcon(weather),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          _currentTemp(weather),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          _extraInfo(weather),
        ],
      ),
    );
  }

  Widget _locationHeader(Weather? weather) {
    return Text(
      weather?.areaName ?? "",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }

  Widget _dateTimeInfo(Weather weather) {
    DateTime now = weather.date!;
    return Column(
      children: [
        Text(
          DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 35,
            color: Colors.white,
          ),
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
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Text(
              "  ${DateFormat("d.M.y").format(now)}",
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _weatherIcon(Weather? weather) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "http://openweathermap.org/img/wn/${weather?.weatherIcon}@4x.png"),
            ),
          ),
        ),
        Text(
          weather?.weatherDescription ?? "",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _currentTemp(Weather? weather) {
    return Text(
      "${weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
      style: const TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.w300,
        color: Colors.white,
      ),
    );
  }

  Widget _extraInfo(Weather? weather) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              "${weather?.windSpeed?.toStringAsFixed(2)} m/s",
              style: const TextStyle(color: Colors.white),
            ),
            const Text(
              "Angin",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "${weather?.humidity} %",
              style: const TextStyle(color: Colors.white),
            ),
            const Text(
              "Kelembapan",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "${weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
              style: const TextStyle(color: Colors.white),
            ),
            const Text(
              "Max",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              "${weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
              style: const TextStyle(color: Colors.white),
            ),
            const Text(
              "Min",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ],
    );
  }
}
