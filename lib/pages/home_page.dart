import 'package:flutter/material.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var numOfPlayers = 2;
  var numOfPlayersCanPlay = 0;
  List<RangeValues> playersValues = [];
  var allowedRange = const RangeValues(10, 23);
  late List selectedRanges;
  String averageTime = '';

  List filledRange({
    required int min,
    required int max,
  }) {
    final range = []
      ..add(min)
      ..add(max);
    final diff = max - min;
    //*range is with one item (max == min)
    if (diff == 0) return range;
    //*range is with 2 items
    for (var i = 0; i != diff - 1; i++) {
      range.insert(i + 1, range[i] + 1);
    }
    return range;
  }

  bool isInRange({
    required int mainMin,
    required int mainMax,
    required int myMin,
    required int myMax,
  }) {
    final mainRange = filledRange(min: mainMin, max: mainMax);
    final myRange = filledRange(min: myMin, max: myMax);

    bool isIn = false;
    //*if in range return true
    for (var item in myRange) {
      isIn = mainRange.contains(item);
      if (isIn) return true;
    }
    return isIn;
  }

  void calculateAverageTime({required List ranges}) {
    numOfPlayersCanPlay = 0;

    //*all mins and max in mins
    final mins = [];
    for (var i = 0; i != ranges.length; i++) {
      mins.add(ranges[i].start.toInt());
    }
    final maxInMins = mins.reduce((curr, next) => curr > next ? curr : next);

    //*all maxes and min in maxes
    final maxes = [];
    for (var i = 0; i != ranges.length; i++) {
      maxes.add(ranges[i].end.toInt());
    }
    final minInMaxes = maxes.reduce((curr, next) => curr < next ? curr : next);

    print('average time: $maxInMins - $minInMaxes');

    setState(() {
      averageTime = '$maxInMins - $minInMaxes';
    });

    for (var i = 0; i != ranges.length; i++) {
      isInRange(
        mainMin: maxInMins,
        mainMax: minInMaxes,
        myMin: int.parse(ranges[i].start.toString().substring(0, 2)),
        myMax: int.parse(ranges[i].end.toString().substring(0, 2)),
      )
          ? numOfPlayersCanPlay++
          : numOfPlayersCanPlay = numOfPlayersCanPlay;
    }
  }

  @override
  void initState() {
    super.initState();

    selectedRanges =
        List.generate(numOfPlayers, (index) => RangeValues(20, 22));

    //print(isInRange(mainMin: 24, mainMax: 24, myMin: 19, myMax: 19));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                itemCount: selectedRanges.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Text(
                          'Player $index: ${selectedRanges[index].start.toString().substring(0, 2)} - ${selectedRanges[index].end.toString().substring(0, 2)}'),
                      RangeSlider(
                        values: selectedRanges[index],
                        min: allowedRange.start,
                        max: allowedRange.end,
                        divisions: (allowedRange.end.toInt() -
                            allowedRange.start.toInt()),
                        onChanged: (newRange) {
                          setState(() {
                            averageTime = '';
                            numOfPlayersCanPlay = 0;
                            selectedRanges[index] = newRange;
                            //playersValues.insert(index, newRange);
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedRanges.add(RangeValues(20, 22));
                  });
                },
                icon: const Icon(Icons.add),
              ),
              const SizedBox(height: 16),
              Text('Selected Ranges:\n$selectedRanges'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  calculateAverageTime(ranges: selectedRanges);
                },
                child: Text('Count'),
              ),
              Text('Average Time: '),
              Text(averageTime),
              Text('How many players can play: '),
              Text('$numOfPlayersCanPlay'),
            ],
          ),
        ),
      ),
    );
  }
}
