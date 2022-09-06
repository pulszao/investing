import 'package:flutter/material.dart';
import 'package:investing/components/card/menu_card.dart';
import 'package:investing/screens/portfolio/portfolio.dart';
import 'package:investing/screens/portfolio_sector/portfolio_sector_screen.dart';
import 'package:investing/screens/profile/profile_screen.dart';
import 'package:investing/screens/rentability/rentability_screen.dart';
import 'package:investing/screens/transactions/transactions_screen.dart';
import 'package:investing/screens/watchlist/watchlist_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../constants.dart';
import '../../models/chart_data.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Widget _body = kCircularLoading;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      buildBody();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: _body,
        ),
      ),
    );
  }

  void buildBody() {
    Widget auxBody = Column(
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
                SfCircularChart(
                  title: ChartTitle(
                    text: 'Portfolio (R\$ 10.545,23)',
                    alignment: ChartAlignment.near,
                    textStyle: kBaseTextStyle(
                      fontSize: 20,
                    ),
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CircularSeries>[
                    DoughnutSeries<ChartData, String>(
                      dataSource: [
                        ChartData(color: Colors.greenAccent, description: 'WEGE3', totalValue: 5400),
                        ChartData(color: Colors.blueAccent, description: 'ITUB4', totalValue: 7400),
                        ChartData(description: 'LREN3', totalValue: 3400),
                        ChartData(color: Colors.purpleAccent, description: 'EGIE3', totalValue: 10400),
                        ChartData(color: Colors.lightBlueAccent, description: 'MDIA3', totalValue: 6400),
                      ],
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
                SfCircularChart(
                  title: ChartTitle(
                    text: 'Alocação por Setor',
                    alignment: ChartAlignment.near,
                    textStyle: kBaseTextStyle(
                      fontSize: 20,
                    ),
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CircularSeries>[
                    DoughnutSeries<ChartData, String>(
                      dataSource: [
                        ChartData(color: Colors.greenAccent, description: 'Bens industriais', totalValue: 5400),
                        ChartData(color: Colors.blueAccent, description: 'Comunicações', totalValue: 7400),
                        ChartData(color: Colors.redAccent, description: 'Consumo cíclico', totalValue: 3400),
                        ChartData(color: Colors.purpleAccent, description: 'Consumo não cíclico', totalValue: 10400),
                        ChartData(color: Colors.amberAccent, description: 'Financeiro', totalValue: 9400),
                        ChartData(color: Colors.orangeAccent, description: 'Materiais Básicos', totalValue: 6400),
                        ChartData(color: Colors.brown, description: 'Petróleo, Gás e Biocombustíveis', totalValue: 5400),
                        ChartData(color: Colors.white70, description: 'Tecnologia da Informação', totalValue: 6400),
                        ChartData(color: Colors.grey, description: 'Utilidade pública', totalValue: 10400),
                        ChartData(color: Colors.deepOrange, description: 'Outros', totalValue: 1),
                      ],
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
    );

    setState(() {
      _body = auxBody;
    });
  }
}
