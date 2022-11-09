import 'dart:async';
import 'package:animated_check/animated_check.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:ukfitnesshub/config/constants.dart';
import 'package:ukfitnesshub/models/exercise_model.dart';
import 'package:ukfitnesshub/views/custom/custom_app_bar.dart';
import 'package:ukfitnesshub/views/custom/custom_button.dart';

class PlayProgramPage extends StatelessWidget {
  final List<ExerciseModel> exercises;
  final String? programName;
  const PlayProgramPage({
    super.key,
    required this.exercises,
    this.programName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: customAppBar(
        context,
        title: programName ?? exercises.first.name,
        showDefaultActionButtons: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage(bg), fit: BoxFit.fill),
        ),
        child: PlayProgramPageBody(
          exercises: exercises,
          isProgramme: programName != null,
        ),
      ),
    );
  }
}

class PlayProgramPageBody extends StatefulWidget {
  final List<ExerciseModel> exercises;
  final bool isProgramme;
  const PlayProgramPageBody({
    super.key,
    required this.exercises,
    required this.isProgramme,
  });

  @override
  State<PlayProgramPageBody> createState() => _PlayProgramPageBodyState();
}

class _PlayProgramPageBodyState extends State<PlayProgramPageBody> {
  final PageController _pageController = PageController();

  void _onPageFinished() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final exercise in widget.exercises) ...[
          ReadyToGoPage(
            seconds: (widget.exercises.indexOf(exercise) == 0) ? 10 : 5,
            exercise: exercise,
            onPlayFinished: _onPageFinished,
          ),
          ExercisePlayPage(exercise: exercise, onPlayFinished: _onPageFinished),
          if (widget.exercises.indexOf(exercise) != widget.exercises.length - 1)
            RestingPage(seconds: 20, onRestingFinished: _onPageFinished),
        ],
        FinishedPage(isProgramme: widget.isProgramme),
      ],
    );
  }
}

class ReadyToGoPage extends StatefulWidget {
  final int seconds;
  final ExerciseModel exercise;

  final VoidCallback onPlayFinished;
  const ReadyToGoPage({
    super.key,
    required this.seconds,
    required this.exercise,
    required this.onPlayFinished,
  });

  @override
  State<ReadyToGoPage> createState() => _ReadyTogoPageState();
}

class _ReadyTogoPageState extends State<ReadyToGoPage> {
  late int _initialSeconds;
  late int _totalSeconds;
  late Timer _timer;
  @override
  void initState() {
    _initialSeconds = widget.seconds;
    _totalSeconds = _initialSeconds;

    _initTimer();

    super.initState();
  }

  void _initTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_initialSeconds <= 0) {
        timer.cancel();
        widget.onPlayFinished();
      } else {
        setState(() {
          _initialSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _totalSeconds = 0;
    _initialSeconds = 0;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            CachedNetworkImage(
              imageUrl: widget.exercise.image ?? "",
              placeholder: (context, url) => const Center(
                child: CupertinoActivityIndicator(),
              ),
              width: MediaQuery.of(context).size.height * 0.25,
            ),
            const SizedBox(height: kDefaultPadding * 2),
            Text("Ready to go!".toUpperCase(),
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.bold, color: secondaryColor)),
            Text(widget.exercise.name,
                style: Theme.of(context).textTheme.headline6!.copyWith(
                    fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: kDefaultPadding),
            CircularPercentIndicator(
              radius: MediaQuery.of(context).size.height * 0.1,
              lineWidth: 5.0,
              percent: _initialSeconds / _totalSeconds,
              center: Text(
                _initialSeconds.toString(),
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              progressColor: Colors.green,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding * 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "+5 Secs",
                      onPressed: () {
                        setState(() {
                          _initialSeconds += 5;
                          _totalSeconds += 5;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: kDefaultPadding / 2),
                  MaterialButton(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    shape: const CircleBorder(),
                    color: primaryColor,
                    onPressed: () {
                      if (_timer.isActive) {
                        setState(() {
                          _timer.cancel();
                        });
                      } else {
                        setState(() {});
                        _initTimer();
                      }
                    },
                    child: _timer.isActive
                        ? const Icon(Icons.pause, color: Colors.white)
                        : const Icon(Icons.play_arrow, color: Colors.white),
                  ),
                  const SizedBox(width: kDefaultPadding / 2),
                  Expanded(
                    child: CustomButton(
                      text: "Skip",
                      onPressed: () {
                        _timer.cancel();
                        widget.onPlayFinished();
                        _totalSeconds = 0;
                        _initialSeconds = 0;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RestingPage extends StatefulWidget {
  final int seconds;
  final VoidCallback onRestingFinished;
  const RestingPage({
    super.key,
    required this.seconds,
    required this.onRestingFinished,
  });

  @override
  State<RestingPage> createState() => _RestingPageState();
}

class _RestingPageState extends State<RestingPage> {
  late int _initialSeconds;
  late int _totalSeconds;
  late Timer _timer;
  @override
  void initState() {
    _initialSeconds = widget.seconds;
    _totalSeconds = widget.seconds;
    _initTimer();

    super.initState();
  }

  void _initTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_initialSeconds <= 0) {
        timer.cancel();
        widget.onRestingFinished();
      } else {
        setState(() {
          _initialSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _totalSeconds = 0;
    _initialSeconds = 0;

    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const SizedBox(height: kDefaultPadding),
            Text("Have Rest!".toUpperCase(),
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    fontWeight: FontWeight.bold, color: secondaryColor)),
            const SizedBox(height: kDefaultPadding * 2),
            CircularPercentIndicator(
              radius: MediaQuery.of(context).size.height * 0.1,
              lineWidth: 5.0,
              percent: _initialSeconds / _totalSeconds,
              center: Text(
                _initialSeconds.toString(),
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              progressColor: Colors.green,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding * 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "+5 Secs",
                      onPressed: () {
                        setState(() {
                          _initialSeconds += 5;
                          _totalSeconds += 5;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: kDefaultPadding / 2),
                  MaterialButton(
                    padding: const EdgeInsets.all(kDefaultPadding),
                    shape: const CircleBorder(),
                    color: primaryColor,
                    onPressed: () {
                      if (_timer.isActive) {
                        setState(() {
                          _timer.cancel();
                        });
                      } else {
                        setState(() {});
                        _initTimer();
                      }
                    },
                    child: _timer.isActive
                        ? const Icon(Icons.pause, color: Colors.white)
                        : const Icon(Icons.play_arrow, color: Colors.white),
                  ),
                  const SizedBox(width: kDefaultPadding / 2),
                  Expanded(
                    child: CustomButton(
                      text: "Skip",
                      onPressed: () {
                        _timer.cancel();
                        widget.onRestingFinished();
                        _totalSeconds = 0;
                        _initialSeconds = 0;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExercisePlayPage extends StatefulWidget {
  final ExerciseModel exercise;
  final VoidCallback onPlayFinished;
  const ExercisePlayPage({
    super.key,
    required this.exercise,
    required this.onPlayFinished,
  });

  @override
  State<ExercisePlayPage> createState() => _ExercisePlayPageState();
}

class _ExercisePlayPageState extends State<ExercisePlayPage> {
  final ScrollController _scrollController = ScrollController();

  late int _initialSeconds;
  late int _totalSeconds;
  late Timer _timer;
  @override
  void initState() {
    _initialSeconds = int.parse(widget.exercise.defaultTime);
    _totalSeconds = _initialSeconds;

    _initTimer();

    super.initState();
  }

  void _initTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_initialSeconds <= 0) {
        timer.cancel();
        widget.onPlayFinished();
      } else {
        setState(() {
          _initialSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _totalSeconds = 0;
    _initialSeconds = 0;

    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double percentage = 1 - (_initialSeconds / _totalSeconds);

    String durationString = DateFormat('mm:ss')
        .format(DateTime(0).add(Duration(seconds: _initialSeconds)));

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: kDefaultPadding * 2),
          Expanded(
            child: CachedNetworkImage(
              imageUrl: widget.exercise.image ?? "",
              placeholder: (context, url) => const Center(
                child: CupertinoActivityIndicator(),
              ),
            ),
          ),
          const SizedBox(height: kDefaultPadding * 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Text(widget.exercise.name.toUpperCase(),
                style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.bold, color: primaryColor)),
          ),
          const SizedBox(height: kDefaultPadding / 2),
          if (widget.exercise.description != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              height: MediaQuery.of(context).size.height * 0.1,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Text(widget.exercise.description ?? ""),
              ),
            ),
          if (widget.exercise.description != null)
            const SizedBox(height: kDefaultPadding),
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.17,
                color: Colors.grey.withOpacity(0.1),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.17,
                width: MediaQuery.of(context).size.width * percentage,
                color: primaryColor.withOpacity(0.15),
              ),
              Positioned.fill(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: kDefaultPadding),
                        child: Text(durationString,
                            style:
                                Theme.of(context).textTheme.headline5!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    )),
                      ),
                      IconButton(
                        iconSize: MediaQuery.of(context).size.height * 0.07,
                        onPressed: () {
                          if (_timer.isActive) {
                            setState(() {
                              _timer.cancel();
                            });
                          } else {
                            setState(() {});
                            _initTimer();
                          }
                        },
                        icon: _timer.isActive
                            ? const Icon(Icons.pause, color: primaryColor)
                            : const Icon(Icons.play_arrow, color: primaryColor),
                      ),
                      IconButton(
                        iconSize: MediaQuery.of(context).size.height * 0.07,
                        onPressed: () {
                          _timer.cancel();
                          widget.onPlayFinished();
                          _totalSeconds = 0;
                          _initialSeconds = 0;
                        },
                        icon: const Icon(CupertinoIcons.chevron_forward,
                            color: primaryColor),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class FinishedPage extends StatefulWidget {
  final bool isProgramme;
  const FinishedPage({
    super.key,
    required this.isProgramme,
  });

  @override
  State<FinishedPage> createState() => _FinishedPageState();
}

class _FinishedPageState extends State<FinishedPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutCirc));

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(kDefaultPadding * 2),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(kDefaultPadding),
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.4),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: AnimatedCheck(
                  progress: _animation,
                  size: MediaQuery.of(context).size.width * 0.3,
                  color: Colors.white,
                )),
            const SizedBox(height: kDefaultPadding * 2),
            Text("Congratulations!",
                style: Theme.of(context).textTheme.headline5!.copyWith(
                    fontWeight: FontWeight.bold, color: primaryColor)),
            const SizedBox(height: kDefaultPadding / 2),
            Text(
              "You have completed the ${widget.isProgramme ? 'programme' : 'exercise'}",
            ),
            const SizedBox(height: kDefaultPadding * 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: CustomButton(
                text: "Go Back",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
