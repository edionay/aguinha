import 'package:aguinha/constants.dart';
import 'package:aguinha/shared/common.dart';

class AppBarBuilder extends StatelessWidget {
  const AppBarBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        Builder(
          builder: (context) => TextButton(
            child: Row(
              children: [
                Text(
                  'MENU',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: kDefaultPadding / 2,
                ),
                Icon(
                  Icons.menu_rounded,
                  color: Colors.white,
                ),
              ],
            ),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
      ],
    );
  }
}
