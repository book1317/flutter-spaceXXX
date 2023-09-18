import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_xxx/data/models/launch_model.dart';
import 'package:space_xxx/logic/utility/date_time.dart';
import 'package:space_xxx/modules/detail_screen/bloc/bloc.dart';
import 'package:space_xxx/modules/detail_screen/widget/content_text.dart';
import 'package:space_xxx/modules/detail_screen/widget/detail_container.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({
    super.key,
    required this.launch,
  });
  final Launch launch;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    BlocProvider.of<DetailBloc>(context).add(InitialDetail(
      widget.launch.rocketId,
      widget.launch.launchpadId,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<DetailBloc, DetailState>(builder: (context, state) {
        if (state is DetailLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is DetailErrorState) {
          String error = state.error;
          return Center(child: Text(error));
        }
        if (state is DetailLoadedState) {
          final launch = widget.launch;
          final rocket = state.rocket;
          final launchpad = state.launchpad;

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(bottom: 32),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 27, 27, 27),
              ),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: NetworkImage(rocket.flickrImages[0]),
                      fit: BoxFit.fill,
                    )),
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        widget.launch.name,
                        style: const TextStyle(shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black,
                            offset: Offset(2.0, 2.0),
                          )
                        ], fontWeight: FontWeight.bold, fontSize: 28),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      DetailContainer(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(launch.image),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        launch.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      Text(convertUtcStringToFormatDate(
                                          launch.launchedDate)),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Divider(
                              color: Colors.grey.shade800,
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              // margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                launch.details,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DetailContainer(
                        child: Column(
                          children: [
                            Center(
                              child: Text('Rocket',
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(rocket.description,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium),
                            Divider(
                              color: Colors.grey.shade800,
                            ),
                            ContentText(
                              title: 'Name',
                              text: rocket.name,
                            ),
                            ContentText(
                              title: 'Type',
                              text: rocket.type,
                            ),
                            ContentText(
                              title: 'Company',
                              text: rocket.company,
                            ),
                            ContentText(
                              title: 'Country',
                              text: rocket.country,
                            ),
                            ContentText(
                                title: 'Active',
                                text: rocket.active ? 'Fasle' : 'True'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        image: DecorationImage(
                          image: NetworkImage(launchpad.images[0]),
                          fit: BoxFit.fill,
                        )),
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                  ),
                  DetailContainer(
                    child: Column(
                      children: [
                        Center(
                          child: Text('Launchpad',
                              style: Theme.of(context).textTheme.titleLarge),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(launchpad.details,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium),
                        Divider(
                          color: Colors.grey.shade800,
                        ),
                        ContentText(
                          title: 'Name',
                          text: launchpad.name,
                        ),
                        ContentText(
                          title: 'Full Name',
                          text: launchpad.fullName,
                        ),
                        ContentText(
                          title: 'Locality',
                          text: launchpad.locality,
                        ),
                        ContentText(
                          title: 'Region',
                          text: launchpad.region,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
        return Container();
      }),
    );
  }
}
