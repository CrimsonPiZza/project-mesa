// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_mesa/src/data/game_data.dart';
import 'package:project_mesa/src/model/item.dart';
import 'package:project_mesa/src/model/statistic.dart';
import 'package:project_mesa/src/service/warframe_market.dart';
import 'package:project_mesa/src/theme/theme.dart';

class ItemDetail extends StatefulWidget {
  const ItemDetail({Key? key, required this.name}) : super(key: key);

  final String name;
  static const routeName = '/item';

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  Item? item;
  late Statistic stat;
  late StatisticsClosed48Hour priceDetail;
  var isLoaded = false;

  @override
  void initState() {
    try {
      item = GameData.items.firstWhere((element) =>
          element.itemName.toLowerCase() == widget.name.toLowerCase());
    } catch (_) {}

    super.initState();
    getStatistic();
  }

  void getStatistic() async {
    if (item == null) return;
    Statistic? stat_ = await WarframeMarket().getStatistic(item!.urlName);

    if (stat_ != null) {
      setState(() {
        stat = stat_;
        getPriceDetail();
        isLoaded = true;
      });
    }
  }

  void getPriceDetail() {
    priceDetail = stat.payload.statisticsClosed.the90Days.lastWhere(
      (element) {
        if (element.modRank != null) {
          return element.modRank == 0;
        } else {
          return true;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: item == null
          ? Center(
              child: Text('${widget.name} is not found!'),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                // IMAGE BOX
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Themes.card,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    height: 256,
                    child: Center(
                      // child: Image.network(
                      //     'https://warframe.market/static/assets/${thumbToFullResImg(item.thumb)}'),
                      child: CachedNetworkImage(
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(
                          color: Themes.primaryColor,
                        ),
                        imageUrl:
                            'https://warframe.market/static/assets/${thumbToFullResImg(item!.thumb)}',
                      ),
                    ),
                  ),
                ),
                // ITEM NAME BOX
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Themes.card,
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        item!.itemName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
                // PRICE DETAILS
                isLoaded
                    ? PriceDetail()
                    : const SizedBox(
                        height: 80,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Themes.primaryColor,
                          ),
                        ),
                      ),
              ],
            ),
    );
  }

  Padding PriceDetail() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: const BoxDecoration(
          color: Themes.card,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Center(
          // child: Image.network(
          //     'https://warframe.market/static/assets/${thumbToFullResImg(item.thumb)}'),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    'Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Themes.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // Min-Max Platinum & Closed-Opened Trade
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Min-Max:'),
                        Text(
                          ' ${priceDetail.minPrice} - ${priceDetail.maxPrice}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Themes.primaryColorHighlighted),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Closed-Opened:'),
                        Text(
                          ' ${priceDetail.closedPrice} - ${priceDetail.openPrice}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Themes.primaryColorHighlighted),
                        )
                      ],
                    )
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                // Min-Max Platinum & Closed-Opened Trade
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Median:'),
                        Text(
                          ' ${priceDetail.median}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Themes.primaryColorHighlighted),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Volume:'),
                        Text(
                          ' ${priceDetail.volume}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Themes.primaryColorHighlighted),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String thumbToFullResImg(String thumb) {
    if (thumb.startsWith('sub_icons/')) return thumb;

    return '${thumb.substring(0, thumb.length - ".128x128.png".length).replaceFirst('/thumbs', '')}.png';
  }
}
