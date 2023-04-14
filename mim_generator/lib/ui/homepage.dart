import 'package:flutter/material.dart';

import 'package:mim_generator/model/services.dart';
import 'package:mim_generator/ui/detailpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future _futureData;
  @override
  void initState() {
    super.initState();

    _futureData = Services.getMemes();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _futureData = Services.getMemes();
    });
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 45.0),
                child: Center(
                    child: Text(
                  "MimGenerator",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                )),
              ),
              FutureBuilder(
                  future: _futureData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            final value = snapshot.data;

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DetailPage(
                                                    url: value![index]!.url,
                                                    width: value[index]!.width,
                                                    height:
                                                        value[index]!.height,
                                                  )),
                                        );
                                      },
                                      child:
                                          Image.network(value![index]!.url))),
                            );
                          });
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
