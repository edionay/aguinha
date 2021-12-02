import 'package:aguinha/constants.dart';
import 'package:aguinha/providers/payment_provider.dart';
import 'package:aguinha/shared/common.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({Key? key}) : super(key: key);
  static String id = 'premium_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Consumer<PaymentProvider>(builder: (context, provider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: 'aguinha',
                            style: TextStyle(fontSize: 50),
                            children: [
                              TextSpan(text: ' '),
                              TextSpan(
                                  text: 'premium',
                                  style: TextStyle(fontWeight: FontWeight.w100))
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: kDefaultPadding * 2, bottom: kDefaultPadding * 3),
                height: 3,
                width: 150,
                color: kPrimaryColor,
              ),
              PremiumRow(
                text: AppLocalizations.of(context)!.differentBeverages,
              ),
              PremiumRow(
                text: AppLocalizations.of(context)!.noAds,
              ),
              PremiumRow(
                text: AppLocalizations.of(context)!.supportAppDevelopment,
              ),
              Container(
                margin: EdgeInsets.only(
                    top: kDefaultPadding * 2, bottom: kDefaultPadding * 3),
                height: 3,
                width: 150,
                color: kPrimaryColor,
              ),
              if (!provider.isPremium)
                TextButton(
                  onPressed: () async {
                    try {
                      await context.read<PaymentProvider>().buySubscription();
                    } catch (error) {
                      print(error);
                      final snackBar = SnackBar(
                          content: Text('serviço de pagamentos indisponível'));

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: EdgeInsets.symmetric(
                          horizontal: kDefaultPadding * 4)),
                  child: Text(
                    'assinar por R\$ 5,99',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              else
                Flexible(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: AppLocalizations.of(context)!.youAre,
                        style: TextStyle(fontSize: 18),
                        children: [
                          TextSpan(
                              text: 'aguinha ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: 'premium',
                              style: TextStyle(fontWeight: FontWeight.w100))
                        ]),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class PremiumRow extends StatelessWidget {
  const PremiumRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 4, vertical: kDefaultPadding * 2),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/whale_icon.svg',
            alignment: Alignment.center,
            width: 40,
            // fit: BoxFit.fitHeight,
          ),
          SizedBox(
            width: kDefaultPadding * 2,
          ),
          Flexible(
            child: Text(
              text,
              style: TextStyle(color: kPrimaryColor, fontSize: 16),
            ),
          ),
        ],
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
