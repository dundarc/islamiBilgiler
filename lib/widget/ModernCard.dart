import 'package:flutter/material.dart';

class ModernCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget pageToNavigate;
  final String cardBackgroundImage;
  final double opacityOfCards;
  final Color? textColor;
  final double? textSize;

  final Color? iconColor;

  ModernCard({
    required this.title,
    required this.icon,
    this.iconColor,
    required this.pageToNavigate,
    required this.cardBackgroundImage,
    required this.opacityOfCards,
    this.textColor,
    this.textSize,

  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pageToNavigate),
        );
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            image: DecorationImage(
              image: AssetImage(cardBackgroundImage),
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(opacityOfCards),
                BlendMode.srcATop,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 48.0, color: (iconColor==null)? Colors.blue: iconColor),
              SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(
                    color: (textColor==null)? Colors.black: textColor,
                    fontSize: (textSize==null)? 16.0: textSize,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
