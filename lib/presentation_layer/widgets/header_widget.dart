import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final String date;

  const HeaderWidget({
    Key? key,
    required this.title,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
        margin: const EdgeInsets.all(10.0), // Add margin around the container
        decoration: BoxDecoration(
          color: theme.primaryColorDark, // Set the background color
          borderRadius: BorderRadius.circular(10.0), // Rounded corners
        ),
        child: Stack(
          children: [
            Positioned(
              right:-20,
              top:0,
              bottom:-20,
              child:Align(
                alignment: Alignment.centerRight,
                child:Image.asset('assets/images/3dpack/Dumbell_03.png',
                  width: 200,
                  fit:BoxFit.cover,
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0), // Only apply padding to the text
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary), // Use titleLarge with custom color
                  ),
                  SizedBox(height: 8), // Space between the texts
                  Text(
                    date,
                    style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onPrimary), // Use titleSmall with custom color
                  ),
                ],
              ),
            )
          ],
        ));
  }
}