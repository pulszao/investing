class StockSector {
  final String sector;

  StockSector({required this.sector});

  @override
  String toString() => sector;
}

List<StockSector> sectors = [
  StockSector(sector: 'Commercial Services'),
  StockSector(sector: 'Communications'),
  StockSector(sector: 'Consumer Durables'),
  StockSector(sector: 'Consumer Non-Durables'),
  StockSector(sector: 'Consumer Services'),
  StockSector(sector: 'Distribution Services'),
  StockSector(sector: 'Electronic Technology'),
  StockSector(sector: 'Energy Minerals'),
  StockSector(sector: 'Finance'),
  StockSector(sector: 'Health Services'),
  StockSector(sector: 'Health Technology'),
  StockSector(sector: 'Industrial Services'),
  StockSector(sector: 'Miscellaneous'),
  StockSector(sector: 'Non-Energy Minerals'),
  StockSector(sector: 'Process Industries'),
  StockSector(sector: 'Producer Manufacturing'),
  StockSector(sector: 'Retail Trade'),
  StockSector(sector: 'Technology Services'),
  StockSector(sector: 'Transportation'),
  StockSector(sector: 'Utilities'),
];
