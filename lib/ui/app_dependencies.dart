import 'package:country/app.dart';
import 'package:flutter/material.dart';

/// Widget with dependencies that live all runtime.
class AppDependencies extends StatefulWidget {
  final App app;

  const AppDependencies({required this.app, Key? key}) : super(key: key);

  @override
  State<AppDependencies> createState() => _AppDependenciesState();
}

class _AppDependenciesState extends State<AppDependencies> {
  late final Dio _http;
  late final DefaultErrorHandler _defaultErrorHandler;
  late final CountryClient _countryClient;
  late final CountryRepository _countryRepository;
  late final CountryListScreenModel _countryListScreenModel;

  late final ThemeWrapper _themeWrapper;

  @override
  void initState() {
    super.initState();

    _http = Dio();
    _defaultErrorHandler = DefaultErrorHandler();
    _countryClient = CountryClient(_http);
    _countryRepository = CountryRepository(_countryClient);
    // Uncomment to use mock instead real backend
    // _countryRepository = MockCountryRepository();

    _countryListScreenModel = CountryListScreenModel(
      _countryRepository,
      _defaultErrorHandler,
    );

    _themeWrapper = ThemeWrapper();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CountryListScreenModel>(
          create: (_) => _countryListScreenModel,
        ),
        Provider<ThemeWrapper>(
          create: (_) => _themeWrapper,
        ),
      ],
      child: widget.app,
    );
  }
}

class Dio {}
