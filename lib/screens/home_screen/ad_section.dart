import 'package:aguinha/ad_state.dart';
import 'package:aguinha/common.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class AdSection extends StatefulWidget {
  const AdSection({Key? key}) : super(key: key);

  @override
  _AdSectionState createState() => _AdSectionState();
}

class _AdSectionState extends State<AdSection> {
  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
            size: AdSize.banner,
            adUnitId: adState.bannerAdUnitId,
            listener: adState.adListenet,
            request: AdRequest())
          ..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (banner == null)
          SizedBox(
            height: 50,
          )
        else
          Container(
            height: 50,
            child: AdWidget(
              ad: banner!,
            ),
          ),
      ],
    );
  }
}
