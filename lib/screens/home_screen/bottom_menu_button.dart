import 'package:aguinha/common.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/screens/friends_screen.dart';

class BottomMenuButton extends StatelessWidget {
  const BottomMenuButton(
      {required this.label, required this.onPress, required this.icon});

  final String label;
  final IconData icon;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: Container(
        width: 70,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(kDefaultPadding * 1.5),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: kDefaultPadding / 2,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: kPrimaryColor),
            )
          ],
        ),
      ),
    );
  }
}
