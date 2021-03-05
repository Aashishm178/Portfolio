import 'dart:math';
import 'package:flutter/material.dart';
import 'package:portfolio/AppTheme.dart' as theme;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

Random random = Random(DateTime.now().millisecondsSinceEpoch);

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  ScrollController scrollController = ScrollController();
  List<Particle> particles = [];
  final _skillBlockKey = GlobalKey();
  final _experienceKey = GlobalKey();
  Offset _experienceOffset;
  Offset _skillBlockOffset;
  List<String> skillList = [
    'Dart',
    'Java',
    'Css',
    'Javascript',
    'Html',
    'Flutter',
    'Firebase Analytics',
    'Firebase Authentication',
    'Cloud Firestore',
    'Firebase Cloud Messaging',
    'Bloc',
    'Provider',
    'Social Logins',
    'Payment Gateway',
    'Firebase Cloud Functions',
    'Dart Test Codes',
  ];
  List<SkillModel> skillListModel = [];

  @override
  void initState() {
    super.initState();
    List.generate(
      skillList.length,
      (index) => skillListModel.add(
        SkillModel(
          skill: skillList[index],
          color: theme.secondaryColor,
          position:
              Offset(random.nextDouble() * 2000, random.nextDouble() * 2000),
          speed: random.nextDouble() * 2.0,
          theta: random.nextDouble() * 2.0 * pi,
        ),
      ),
    );
    List.generate(
      100,
      (index) => particles.add(
        Particle(
          color: theme.secondaryColor,
          position:
              Offset(random.nextDouble() * 2000, random.nextDouble() * 2000),
          speed: random.nextDouble() * 2,
          theta: random.nextDouble() * 2.0 * pi,
          radius: random.nextDouble() * 2,
        ),
      ),
    );
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    animationController.repeat();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getAllBlockOffsets();
    });
  }

  void getAllBlockOffsets() {
    RenderBox renderObject = _skillBlockKey.currentContext.findRenderObject();
    _skillBlockOffset = renderObject.localToGlobal(Offset.zero);
    RenderBox renderObjectTwo =
        _experienceKey.currentContext.findRenderObject();
    _experienceOffset = renderObjectTwo.localToGlobal(Offset.zero);
  }

  @override
  void dispose() {
    animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: LayoutBuilder(builder: (context, constrains) {
        double textSize = 35.0;
        return Scrollbar(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) => CustomPaint(
                        painter: CanvasPainter(
                          list: particles,
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: constrains.maxWidth,
                          height: constrains.maxHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RichText(
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                text: TextSpan(
                                  style: TextStyle(
                                    color: theme.secondaryColor,
                                    fontSize: textSize,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: ' Aashish Rathore',
                                      style: TextStyle(
                                        color: theme.accentColor,
                                        fontSize: textSize,
                                      ),
                                    ),
                                  ],
                                  text: 'Hello, I am',
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'I develop hybrid mobile application',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: theme.secondaryColor,
                                  fontSize: textSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Learn more about what I do',
                            style: TextStyle(
                              color: theme.secondaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              scrollController.animateTo(_skillBlockOffset.dy,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                            },
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 25.0,
                              color: theme.secondaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  key: _skillBlockKey,
                  alignment: Alignment.center,
                  width: constrains.maxWidth,
                  height: constrains.maxHeight,
                  color: theme.primaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.all(20.0),
                        child: Text(
                          'Skills',
                          style: TextStyle(
                            fontSize: textSize,
                            color: theme.accentColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: AnimatedBuilder(
                            animation: animationController,
                            builder: (context, child) {
                              skillListModel.forEach((element) {
                                var velocity = polarToCartesian(
                                    element.speed, element.theta);
                                var dx = element.position.dx + velocity.dx;
                                var dy = element.position.dy + velocity.dy;
                                if (element.position.dx < 0 ||
                                    element.position.dx > constrains.maxWidth) {
                                  dx =
                                      random.nextDouble() * constrains.maxWidth;
                                }

                                if (element.position.dy < 0 ||
                                    element.position.dy >
                                        constrains.maxHeight) {
                                  dy = random.nextDouble() *
                                      constrains.maxHeight;
                                }
                                element.position =
                                    Offset(dx * 1.001, dy * 1.01);
                              });
                              return Stack(
                                alignment: Alignment.center,
                                children: skillListModel
                                    .map(
                                      (e) => AnimatedPositioned(
                                          curve: Curves.bounceInOut,
                                          duration: Duration(milliseconds: 500),
                                          top: e.position.dy,
                                          left: e.position.dx,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              e.skill.toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: e.color,
                                                fontSize: textSize * 0.50,
                                              ),
                                            ),
                                          )),
                                    )
                                    .toList(),
                              );
                            }),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Lets see where i have worked',
                            style: TextStyle(
                              color: theme.secondaryColor,
                            ),
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              scrollController.animateTo(_experienceOffset.dy,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeIn);
                            },
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 25.0,
                              color: theme.secondaryColor,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  key: _experienceKey,
                  alignment: Alignment.center,
                  width: constrains.maxWidth,
                  height: constrains.maxHeight,
                  color: theme.secondaryColor,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

double t = 0;
double dt = 0.01;
double radiusFactor = 5;

double mapRange(
    double val, double max1, double min1, double max2, double min2) {
  double range1 = min1 - max1;
  double range2 = min2 - max2;
  return min2 + range2 * val / range1;
}

class Particle {
  Offset position;
  Color color;
  double speed;
  double radius;
  Offset origin;
  double theta;
  Particle(
      {this.position,
      this.speed,
      this.color,
      this.theta,
      this.radius,
      this.origin});

  @override
  String toString() {
    return '${this.position} ${this.speed} ${this.color} ${this.theta} ${this.radius} ${this.origin}';
  }
}

Offset polarToCartesian(double speed, double theta) {
  return Offset(speed * cos(theta), speed * sin(theta));
}

class CanvasPainter extends CustomPainter {
  List<Particle> list;
  CanvasPainter({this.list});
  @override
  void paint(Canvas canvas, Size size) {
    //Updating
    list.forEach((element) {
      var velocity = polarToCartesian(element.speed, element.theta);
      var dx = element.position.dx + velocity.dx;
      var dy = element.position.dy + velocity.dy;
      if (element.position.dx < 0 || element.position.dx > size.width) {
        dx = random.nextDouble() * size.width;
      }

      if (element.position.dy < 0 || element.position.dy > size.height) {
        dy = random.nextDouble() * size.height;
      }
      element.position = Offset(dx, dy);
    });

    //Building
    list.forEach((element) {
      Paint paint = Paint()..color = element.color;
      canvas.drawCircle(element.position, element.radius, paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SkillModel {
  String skill;
  Offset position;
  double speed;
  double theta;
  Color color;
  SkillModel({this.skill, this.position, this.speed, this.theta, this.color});
}
