import 'package:aguinha/shared/common.dart';
import 'package:aguinha/constants.dart';

class HistoryTile extends StatelessWidget {
  const HistoryTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: CircleAvatar(
        child: Icon(
          Icons.local_drink,
          color: Colors.white,
        ),
        backgroundColor: kPrimaryColor,
      ),
      title: Text(
        'ÁGUA',
        style: TextStyle(color: kPrimaryColor),
      ),
      subtitle: Text(DateTime.now().toString()),
    );
  }
}
