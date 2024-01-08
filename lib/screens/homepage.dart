import 'package:aviation_tracking/api_data/aviation_data.dart';
import 'package:aviation_tracking/screens/widgets/ticket_finding.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool airplane = true;
  Set<Marker> markers = {};
  final flightService = FlightService();

  void getFlights() async {
    markers = await flightService.getFlights();
    setState(() {});
  }

  void getAirports() async {
    markers = await flightService.getAirports();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getFlights();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            markers: markers,
            initialCameraPosition: const CameraPosition(
              target: LatLng(37, 74),
              zoom: 0,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 115,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blueGrey,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.swap_vert_outlined,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                airplane = !airplane;
                              });
                              airplane ? getFlights() : getAirports();
                            },
                          ),
                          const Divider(color: Colors.white12, thickness: 2),
                          IconButton(
                              icon: const Icon(
                                Icons.refresh_rounded,
                                color: Colors.white,
                              ),
                              onPressed: airplane ? getFlights : getAirports,
                              tooltip: 'Update Flights'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.blueGrey,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 15),
                      child: Text(airplane ? "Airplanes" : "Airports",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              )
            ],
          ),
          TicketSelection(),
        ],
      ),
    );
  }
}
