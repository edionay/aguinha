import 'package:aguinha/common.dart';
import 'package:aguinha/constants.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({Key? key}) : super(key: key);
  static String id = 'premium_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: kPrimaryColor,
              height: 250,
              child: Center(
                child: Text(
                  'aguinha premium',
                  style: TextStyle(fontSize: 35, color: Colors.white),
                ),
              ),
            ),
            Text(
              'benefícios:',
              style: TextStyle(color: kPrimaryColor, fontSize: 20),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
              child: Column(
                children: [
                  Text(
                      'avise que está tomando outras bebidas como suco, café, chá etc...'),
                  Text('sem propagandas'),
                  Text('incentive o desenvolvimento do aplicativo'),
                ],
              ),
            ),
            TextButton(
                onPressed: () {}, child: Text('assinar por R\$ 5,99/ano')),
            Column(
              children: [
                Text(
                  'experimente grátis por 7 dias',
                  style: TextStyle(color: kSecondaryColor),
                ),
                Text('pague R\$ 5,99 somente uma vez por ano'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PurchaseCondition extends StatelessWidget {
  const PurchaseCondition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
