import 'package:flutter/material.dart';
import 'package:investing/src/menu/controller/menu_controller.dart';
import 'package:investing/src/portfolio/controller/portfolio_controller.dart';
import 'package:investing/src/portfolio/view/portfolio_screen.dart';
import 'package:investing/src/portfolio/view/portfolio_sector_screen.dart';
import 'package:investing/src/profile/view/profile_screen.dart';
import 'package:investing/src/rentability/view/rentability_screen.dart';
import 'package:investing/src/shared/model/chart_data_model.dart';
import 'package:investing/src/shared/view/cards/menu_card.dart';
import 'package:investing/src/transactions/view/transactions_screen.dart';
import 'package:investing/src/watchlist/view/watchlist_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constants.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    buildPortfolioGraph();
    buildSectorGraph();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool rebuild = Provider.of<MenuProvider>(context).getRebuild();
    double total = Provider.of<MenuProvider>(context).getTotal();
    List<ChartData> portfolioChartData = Provider.of<MenuProvider>(context).getPortfolioData();
    List<ChartData> sectorChartData = Provider.of<MenuProvider>(context).getPortfolioSectorData();

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
                        'Lucas Canale Pulsz',
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
                                'LP',
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
                                Text('Perfil'),
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
                        description: 'Rentabilidade',
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
                        description: 'Transações',
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'IBOVESPA:',
                            style: kBaseTextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            ' +0,72%',
                            style: kBaseTextStyle(
                              fontSize: 18,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'PORTFOLIO:',
                            style: kBaseTextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            ' +1,23%',
                            style: kBaseTextStyle(
                              fontSize: 18,
                              color: Colors.greenAccent,
                            ),
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
                                  'Patrimônio: R\$ $total',
                                  style: kBaseTextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          portfolioChartData.isNotEmpty
                              ? SfCircularChart(
                                  tooltipBehavior: TooltipBehavior(enable: true),
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
                              'Alocação por Setor',
                              style: kBaseTextStyle(
                                fontSize: 26,
                              ),
                            ),
                          ),
                          sectorChartData.isNotEmpty
                              ? SfCircularChart(
                                  tooltipBehavior: TooltipBehavior(enable: true),
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
    total = stocks.last!['total']['total'];

    if (!mounted) return;
    Provider.of<MenuProvider>(context, listen: false).setPortfolioData(portfolioChartData);
    Provider.of<MenuProvider>(context, listen: false).setTotal(total);
  }

  void buildSectorGraph() async {
    List<Map?> stocks = await getSectors();
    List<ChartData> portfolioChartData = getSectorChartData(stocks);

    if (!mounted) return;
    Provider.of<MenuProvider>(context, listen: false).setPortfolioSectorData(portfolioChartData);
  }
}
