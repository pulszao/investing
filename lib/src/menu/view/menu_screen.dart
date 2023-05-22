import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:investing/services/get_quote/get_quote.dart';
import 'package:investing/src/menu/controller/menu_controller.dart';
import 'package:investing/src/portfolio/controller/portfolio_controller.dart';
import 'package:investing/src/portfolio/view/portfolio_screen.dart';
import 'package:investing/src/portfolio/view/portfolio_sector_screen.dart';
import 'package:investing/src/profile/controller/profile_controller.dart';
import 'package:investing/src/profile/view/profile_screen.dart';
import 'package:investing/src/rentability/controller/rentability_controller.dart';
import 'package:investing/src/rentability/view/rentability_screen.dart';
import 'package:investing/src/shared/model/chart_data_model.dart';
import 'package:investing/src/shared/model/number_formatter_model.dart';
import 'package:investing/src/shared/view/cards/menu_card.dart';
import 'package:investing/src/transactions/view/transactions_screen.dart';
import 'package:investing/src/watchlist/view/watchlist_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constants.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  void fetchSep500Quote() async {
    Map? sep500 = await getSingleQuote(code: 'SPY'); // ETF that represents S&P500

    if (sep500 != null && mounted) {
      Provider.of<MenuProvider>(context, listen: false).setSep500(sep500['changePercent'] * 100);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setDataTimer();
      fetchSep500Quote();
      buildPortfolioGraph();
      buildSectorGraph();
      setUserDisplayName();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool rebuild = Provider.of<MenuProvider>(context).getRebuild();
    double total = Provider.of<PortfolioProvider>(context).getCurrentAsset();
    double sep500 = Provider.of<MenuProvider>(context).getSep500();
    double portfolioDailyChange = Provider.of<PortfolioProvider>(context).getPortfolioDailyChange();
    List<ChartData> portfolioChartData = Provider.of<MenuProvider>(context).getPortfolioData();
    List<ChartData> sectorChartData = Provider.of<MenuProvider>(context).getPortfolioSectorData();
    String? username = Provider.of<ProfileProvider>(context).getDisplayName();
    String? initials = Provider.of<ProfileProvider>(context).getInitials();

    if (rebuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        buildPortfolioGraph();
        buildSectorGraph();
        Provider.of<MenuProvider>(context, listen: false).setRebuild(false);
      });
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: kColorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        username ?? 'user',
                        style: kBaseTextStyle(fontSize: 24),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => const ProfileScreen()),
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: kColorScheme.primary.withOpacity(0.4),
                              radius: 26,
                              child: Text(
                                initials ?? '',
                                style: kBaseTextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Text('Profile'),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.arrow_forward,
                                  size: 12,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: MenuCardWidget(
                      screenWidth: MediaQuery.of(context).size.width,
                      itemModel: CardItemModel(
                        description: 'Rentability',
                        iconData: MdiIcons.finance,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => const RentabilityScreen()),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: MenuCardWidget(
                      screenWidth: MediaQuery.of(context).size.width,
                      itemModel: CardItemModel(
                        description: 'Transactions',
                        iconData: MdiIcons.swapHorizontal,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => const TransactionsScreen()),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: MenuCardWidget(
                      screenWidth: MediaQuery.of(context).size.width,
                      itemModel: CardItemModel(
                        description: 'Watchlist',
                        iconData: Icons.reorder,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => const WatchlistScreen()),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Card(
                color: kColorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Performance',
                        style: kBaseTextStyle(
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'S&P500:',
                                style: kBaseTextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: rentabilityColor(sep500),
                                highlightColor: Colors.grey.shade300,
                                period: const Duration(seconds: 3),
                                child: Text(
                                  ' ${NumberFormatter(number: sep500, coinName: '').formatNumber()}%',
                                  textAlign: TextAlign.center,
                                  style: kBaseTextStyle(
                                    fontSize: 18,
                                    color: rentabilityColor(sep500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Portfolio:',
                                style: kBaseTextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor: rentabilityColor(portfolioDailyChange),
                                highlightColor: Colors.grey.shade300,
                                period: const Duration(seconds: 3),
                                child: Text(
                                  ' ${NumberFormatter(number: portfolioDailyChange, coinName: '').formatNumber()}%',
                                  style: kBaseTextStyle(
                                    fontSize: 18,
                                    color: rentabilityColor(portfolioDailyChange),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: kColorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 20, 12, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Portfolio',
                                  style: kBaseTextStyle(
                                    fontSize: 26,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Asset Value: ${NumberFormatter(number: total).formatNumber()}',
                                  style: kBaseTextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          portfolioChartData.isNotEmpty
                              ? SfCircularChart(
                                  tooltipBehavior: TooltipBehavior(
                                      enable: true,
                                      builder: (data, point, series, pointIndex, seriesIndex) {
                                        return Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            '${data.description}: ${NumberFormatter(number: data.totalValue).formatNumber()}',
                                            style: kBaseTextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      }),
                                  series: <CircularSeries>[
                                    DoughnutSeries<ChartData, String>(
                                      dataSource: portfolioChartData,
                                      dataLabelSettings: const DataLabelSettings(
                                        isVisible: true,
                                        labelPosition: ChartDataLabelPosition.outside,
                                        connectorLineSettings: ConnectorLineSettings(type: ConnectorType.curve, length: '25%'),
                                      ),
                                      selectionBehavior: SelectionBehavior(
                                        enable: true,
                                      ),
                                      dataLabelMapper: (ChartData data, _) => data.description,
                                      pointColorMapper: (ChartData data, _) => data.color,
                                      xValueMapper: (ChartData data, _) => data.description,
                                      yValueMapper: (ChartData data, _) => data.totalValue,
                                      radius: '70%',
                                      innerRadius: '40%',
                                      explode: true,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton(
                              heroTag: 'portfolio',
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (BuildContext context) => const PortfolioScreen()),
                              ),
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              mini: true,
                              elevation: 2,
                              backgroundColor: kColorScheme.primary.withOpacity(0.4),
                              child: Icon(
                                Icons.arrow_forward,
                                size: 23.0,
                                color: kColorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: kColorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                            child: Text(
                              'Allocation by Sector',
                              style: kBaseTextStyle(
                                fontSize: 26,
                              ),
                            ),
                          ),
                          sectorChartData.isNotEmpty
                              ? SfCircularChart(
                                  tooltipBehavior: TooltipBehavior(
                                    enable: true,
                                    builder: (data, point, series, pointIndex, seriesIndex) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          '${data.description}: ${NumberFormatter(number: data.totalValue).formatNumber()}',
                                          style: kBaseTextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  series: <CircularSeries>[
                                    DoughnutSeries<ChartData, String>(
                                      dataSource: sectorChartData,
                                      dataLabelSettings: const DataLabelSettings(
                                        isVisible: true,
                                        labelPosition: ChartDataLabelPosition.outside,
                                        connectorLineSettings: ConnectorLineSettings(type: ConnectorType.curve, length: '25%'),
                                      ),
                                      selectionBehavior: SelectionBehavior(
                                        enable: true,
                                        toggleSelection: true,
                                      ),
                                      dataLabelMapper: (ChartData data, _) => data.description,
                                      pointColorMapper: (ChartData data, _) => data.color,
                                      xValueMapper: (ChartData data, _) => data.description,
                                      yValueMapper: (ChartData data, _) => data.totalValue,
                                      radius: '70%',
                                      innerRadius: '40%',
                                      explode: true,
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton(
                              heroTag: 'sector_allocation',
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (BuildContext context) => const PortfolioSectorScreen()),
                              ),
                              materialTapTargetSize: MaterialTapTargetSize.padded,
                              mini: true,
                              elevation: 2,
                              backgroundColor: kColorScheme.primary.withOpacity(0.4),
                              child: Icon(
                                Icons.arrow_forward,
                                size: 23.0,
                                color: kColorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void buildPortfolioGraph() async {
    double total;
    List<Map?> stocks = await getStocks();
    List<ChartData> portfolioChartData = getPortfolioChartData(stocks);
    total = stocks.last!['total']['total'].toDouble();

    if (!mounted) return;
    Provider.of<MenuProvider>(context, listen: false).setPortfolioData(portfolioChartData);
    Provider.of<PortfolioProvider>(context, listen: false).setTotal(total);
  }

  void buildSectorGraph() async {
    List<Map?> stocks = await getSectors();
    List<ChartData> portfolioChartData = getSectorChartData(stocks);

    if (!mounted) return;
    Provider.of<MenuProvider>(context, listen: false).setPortfolioSectorData(portfolioChartData);
  }

  void setDataTimer() async {
    // get data for all parts of app
    fetchStocksData(context);
    fetchWatchlistData(context);
    const oneMin = Duration(minutes: 1);
    Timer.periodic(oneMin, (Timer t) {
      fetchStocksData(context);
      fetchWatchlistData(context);
    });
  }

  void setUserDisplayName() async {
    User? authUser = FirebaseAuth.instance.currentUser;

    String? username = authUser!.displayName != '' ? authUser.displayName : authUser.email;
    if (!mounted) return;
    Provider.of<ProfileProvider>(context, listen: false).setInitials(username);
    Provider.of<ProfileProvider>(context, listen: false).setDisplayName(username);
    Provider.of<ProfileProvider>(context, listen: false).setEmail(authUser.email);
  }
}
