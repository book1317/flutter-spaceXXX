import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spaceXXX/constants/enums.dart';
import 'package:spaceXXX/data/models/launch_model.dart';
import 'package:spaceXXX/logic/utility/dateTime.dart';
import 'package:spaceXXX/modules/home_screen/bloc/bloc.dart';
import 'package:spaceXXX/modules/home_screen/widget/drawer_sorter.dart';
import 'package:spaceXXX/routes.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _debounce;
  Sorter sorter = const Sorter({'name': SorterOrder.none});
  String query = '';

  @override
  void initState() {
    context.read<HomeBloc>().add(const FetchLaunches(
          Filter(name: '', page: 1, limit: 10),
          Sorter({'name': SorterOrder.none}),
        ));
    super.initState();
  }

  _loadMore(launches, filter) {
    context.read<HomeBloc>().add(FetchLaunchesMore(launches, filter, sorter));
  }

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<HomeBloc>().add(FetchLaunches(
            Filter(name: query, page: 1, limit: 10),
            sorter,
          ));
      setState(() {
        this.query = query;
      });
    });
  }

  _onToggleSortOrder(String key) {
    Map<String, dynamic> mapSorter = sorter.toMap();
    String newSortOrder = SorterOrder.none;

    switch (mapSorter[key]) {
      case SorterOrder.asc:
        newSortOrder = SorterOrder.desc;
        break;
      case SorterOrder.desc:
        newSortOrder = SorterOrder.none;
        break;
      default:
        newSortOrder = SorterOrder.asc;
        break;
    }

    setState(() {
      sorter = Sorter({key: newSortOrder});
    });

    context.read<HomeBloc>().add(FetchLaunches(
          Filter(name: query, page: 1, limit: 100),
          sorter,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[Container()] // for hide EndDrawer icon
          ),
      body: Builder(builder: (context) {
        return Container(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: TextField(
                          onChanged: _onSearchChanged,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder(),
                            // hintText: 'Enter a search term',
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.sort),
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                    if (state is HomeLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is HomeErrorState) {
                      String error = state.error;
                      return Center(child: Text(error));
                    }
                    if (state is HomeLoadedState) {
                      List<Launch> launches = state.launches;

                      return NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent &&
                              state.hasNextPage) {
                            // _loadMore(
                            //   launches,
                            //   state.filter,
                            // );
                          }
                          return false;
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  // shrinkWrap: true,
                                  // physics: const NeverScrollableScrollPhysics(),
                                  itemCount: launches.length,
                                  itemBuilder: (_, index) {
                                    return GestureDetector(
                                      onTap: () => Navigator.pushNamed(
                                          context, RouteNames.detailScreen,
                                          arguments: launches[index]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 4),
                                        child: Card(
                                            color:
                                                Theme.of(context).primaryColor,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 8),
                                              child: ListTile(
                                                  title: Text(
                                                    launches[index].name,
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        convertUtcStringToFormatDate(
                                                            launches[index]
                                                                .launchedDate),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Text(
                                                        launches[index].success
                                                            ? 'success'
                                                            : 'fail',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                  trailing:
                                                      Text('#${index + 1}'),
                                                  leading: CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            launches[index]
                                                                .image),
                                                  )),
                                            )),
                                      ),
                                    );
                                  }),
                            ),
                            Visibility(
                              visible: state.isLoadingMore == true,
                              child: Container(
                                  padding: const EdgeInsets.all(5),
                                  height: 35,
                                  width: 35,
                                  child: const CircularProgressIndicator()),
                            )
                          ],
                        ),
                      );
                    }
                    return Container();
                  }),
                ),
              ],
            ));
      }),
      endDrawer: Builder(builder: (context) {
        return DrawerSorter(
          sorter: sorter,
          onToggleSortOrder: _onToggleSortOrder,
        );
      }),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
