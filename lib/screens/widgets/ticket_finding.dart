import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TicketSelection extends StatelessWidget {
  TicketSelection({
    super.key,
  });

  final _airlineController = TextEditingController();
  final _flightNumberController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 5),
            shape: BoxShape.circle,
            color: Colors.white38,
          ),
          child: IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 5,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blueGrey.withOpacity(0.3),
                            ),
                          ),
                        ),
                        const Text(
                          'Swipe down to dismiss',
                          style: TextStyle(color: Colors.black38),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(
                                  0,
                                  3,
                                ), // changes position of shadow
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: _airlineController,
                                decoration: const InputDecoration(
                                  hintText: 'Airline',
                                  prefixIcon: Icon(Icons.apartment_outlined),
                                ),
                              ),
                              TextField(
                                controller: _flightNumberController,
                                decoration: const InputDecoration(
                                  hintText: 'Flight Number',
                                  prefixIcon:
                                      Icon(Icons.airplanemode_active_outlined),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _dateController,
                                      decoration: const InputDecoration(
                                          hintText: 'Date',
                                          prefixIcon: Icon(
                                            Icons.calendar_today_rounded,
                                          ),
                                          suffixIcon:
                                              Icon(Icons.unfold_more_rounded)),
                                      onTap: () async {
                                        FocusScope.of(context).requestFocus(
                                            FocusNode()); // to prevent opening the onscreen keyboard
                                        final DateTime? picked =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2023),
                                          lastDate: DateTime(2025),
                                        );
                                        if (picked != null &&
                                            picked != DateTime.now()) {
                                          _dateController.text =
                                              DateFormat('yyyy-MM-DD')
                                                  .format(picked);
                                        }
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: Colors.blueGrey,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, '/ticket',
                                              arguments: {
                                                'airline':
                                                    _airlineController.text,
                                                'flightNumber':
                                                    _flightNumberController
                                                        .text,
                                                'date': _dateController.text,
                                              });
                                        },
                                        child: const Text(
                                          "Search Flight",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            },
            icon: Icon(
              Icons.airplane_ticket_outlined,
              size: 40,
              color: Colors.blueGrey[900],
            ),
          ),
        ),
      ),
    );
  }
}
