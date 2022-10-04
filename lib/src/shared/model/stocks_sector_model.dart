class StockSector {
  final String sector;

  StockSector({required this.sector});

  @override
  String toString() => sector;
}

List<StockSector> sectors = [
  StockSector(sector: 'Consumer Discretionary'),
  StockSector(sector: 'Consumer Staples'),
  StockSector(sector: 'Energy'),
  StockSector(sector: 'Finance'),
  StockSector(sector: 'Health'),
  StockSector(sector: 'Industrials'),
  StockSector(sector: 'Materials'),
  StockSector(sector: 'Real Estate'),
  StockSector(sector: 'Technology'),
  StockSector(sector: 'Communication Services'),
  StockSector(sector: 'Utilities'),
  // StockSector(sector: 'Commercial Services'),
  // StockSector(sector: 'Consumer Durables'),
  // StockSector(sector: 'Consumer Non-Durables'),
  // StockSector(sector: 'Consumer Services'),
  // StockSector(sector: 'Distribution Services'),
  // StockSector(sector: 'Electronic Technology'),
  // StockSector(sector: 'Health Services'),
  // StockSector(sector: 'Health Technology'),
  // StockSector(sector: 'Miscellaneous'),
  // StockSector(sector: 'Non-Energy Minerals'),
  // StockSector(sector: 'Process Industries'),
  // StockSector(sector: 'Producer Manufacturing'),
  // StockSector(sector: 'Retail Trade'),
  // StockSector(sector: 'Transportation'),
];
