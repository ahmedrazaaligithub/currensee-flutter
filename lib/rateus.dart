import 'package:flutter/material.dart';

void main() {
  runApp(rateus());
}

class rateus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Rate Us App'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              _showRatingPopup(context); // Direct popup
            },
            child: Text('Rate Us'),
          ),
        ),
      ),
    );
  }

  // Function to show the popup
  void _showRatingPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedStars = 0;

        return StatefulBuilder(
          builder: (context, setState) {
            // Function to get Emoji based on selected stars
            String getEmoji() {
              switch (selectedStars) {
                case 1:
                  return '😢'; // Sad
                case 2:
                  return '😟'; // Poor
                case 3:
                  return '😐'; // Neutral
                case 4:
                  return '😊'; // Happy
                case 5:
                  return '🤩'; // Excited
                default:
                  return '⭐'; // Default
              }
            }

            // Function to get message based on selected stars
            String getMessage() {
              switch (selectedStars) {
                case 1:
                  return 'Oh no!';
                case 2:
                  return 'Poor!';
                case 3:
                  return 'Okay!';
                case 4:
                  return 'Good!';
                case 5:
                  return 'Amazing!';
                default:
                  return 'Rate us!';
              }
            }

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },
                    child: Text(
                      getEmoji(),
                      key: ValueKey<int>(selectedStars),
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    getMessage(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            selectedStars = index + 1;
                          });
                        },
                        icon: Icon(
                          Icons.star,
                          color: selectedStars > index
                              ? Colors.amber
                              : Colors.grey,
                          size: 30,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close popup
                        },
                        child: Text('Not now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add backend submission here
                          print("User rated: $selectedStars stars");
                          Navigator.pop(context);
                        },
                        child: Text('Rate'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
