import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaceXXX/data/models/launch_model.dart';
import 'package:spaceXXX/modules/detail_screen/bloc/bloc.dart';

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
      appBar: AppBar(
        title: Text(widget.launch.name),
      ),
      body: Container(
          padding: const EdgeInsets.all(32.0),
          child:
              BlocBuilder<DetailBloc, DetailState>(builder: (context, state) {
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
                child: Column(
                  children: [
                    Column(
                      children: [
                        Center(
                          child: Text('Launch',
                              style: Theme.of(context).textTheme.titleLarge),
                        ),
                        Image(image: NetworkImage(launch.image)),
                        Center(
                          child: Text(launch.details,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [const Text('Name'), Text(launch.name)],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Type'),
                            Text(launch.launchedDate)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Company'),
                            Text(rocket.company)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Country'),
                            Text(rocket.country)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Active'),
                            Text(rocket.active ? 'Fasle' : 'True')
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Center(
                          child: Text('Rocket',
                              style: Theme.of(context).textTheme.titleLarge),
                        ),
                        Image(image: NetworkImage(rocket.flickrImages[0])),
                        Center(
                          child: Text(rocket.description,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [const Text('Name'), Text(rocket.name)],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [const Text('Type'), Text(rocket.type)],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Company'),
                            Text(rocket.company)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Country'),
                            Text(rocket.country)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Active'),
                            Text(rocket.active ? 'Fasle' : 'True')
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Center(
                          child: Text('Launchpad',
                              style: Theme.of(context).textTheme.titleLarge),
                        ),
                        Image(image: NetworkImage(launchpad.images[0])),
                        Center(
                          child: Text(launchpad.details,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [const Text('Name'), Text(launchpad.name)],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Full Name'),
                            Text(launchpad.fullName)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Locality'),
                            Text(launchpad.locality)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Region'),
                            Text(launchpad.region)
                          ],
                        )
                      ],
                    )
                  ],
                ),
              );
            }
            return Container();
          })),
    );
  }
}
