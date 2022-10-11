# Investing

This app was designed using Flutter 3.0.0

## Description

This is a portfolio manager app, where you can search and keep track of your stocks. I believe that it might be helpful for the investors to keep track of their portfolio and performance.

### Here you are able to:
- Add stocks to your watchlist;
- Add your transactions (buy or sell operations);
- Keep track of your portfolio based on your transactions (quantity, rentability, average price, etc.);
- See your portfolio allocation by sector.

## Running the project

To run the project, you need to create your own API key on [IEX Cloud API](https://iexcloud.io/).
Add your api key to `lib/src/constants.dart`:
```
const String kIEXToken = 'YOUR_API_TOKEN';
```
Then you need to install the packages listed on pubspec.yaml by running:
```
pub get
```
Then you can run the app:
```
flutter run
```
