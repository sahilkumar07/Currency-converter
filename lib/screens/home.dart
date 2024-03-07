import 'package:currency_converter/components/anyToAny.dart';
import 'package:currency_converter/components/usdToAny.dart';
import 'package:currency_converter/models/ratesmodel.dart';
import 'package:flutter/material.dart';

import '../functions/fetchrates.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<RatesModel> result;
  late Future<Map> allCurrencies;

  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    result = fetchrates();
    allCurrencies = fetchcurrencies();
  }

  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 148, 135, 23),
        title: const Text('Currency Converter'),
        centerTitle: true,
      ),
      body: Container(
          height: h,
          width: w,
          padding:const EdgeInsets.only(top: 65, left: 15, right: 15),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: FutureBuilder<RatesModel>(
                future: result,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Center(
                      child: FutureBuilder<Map>(
                    future: allCurrencies,
                    builder: (context, currSnapshot) {
                      if (currSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Column(
                        children: [
                          UsdToAny(
                              rates: snapshot.data!.rates,
                              currencies: currSnapshot.data!),
                          SizedBox(
                            height: 75,
                          ),
                          AnyToAny(
                              rates: snapshot.data!.rates,
                              currencies: currSnapshot.data!)
                        ],
                      );
                    },
                  ));
                },
              ),
            ),
          )),
    );
  }
}
