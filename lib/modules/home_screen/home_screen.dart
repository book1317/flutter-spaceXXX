import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:space_xxx/constants/sort_order.dart';
import 'package:space_xxx/data/models/launch_model.dart';
import 'package:space_xxx/data/repositories/launch_repository.dart';
import 'package:space_xxx/modules/home_screen/bloc/bloc.dart';
import 'package:space_xxx/modules/home_screen/widget/drawer_sorter.dart';
import 'package:space_xxx/modules/home_screen/widget/launch_item.dart';
import 'package:space_xxx/routes.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _debounce;
  FetchDetail fetchDetail = const FetchDetail(
      page: 1,
      limit: 10,
      query: '',
      sorter: Sorter(key: 'name', sortOrder: SorterOrder.none));
  bool isLoadingMore = false;

  @override
  void initState() {
    context.read<HomeBloc>().add(FetchLaunches(fetchDetail));
    super.initState();
  }

  _loadMore(launches, filter) async {
    fetchDetail = fetchDetail.copyWith(page: fetchDetail.page + 1);
    context.read<HomeBloc>().add(FetchLaunchesMore(launches, fetchDetail));
    await Future.delayed(Duration.zero);
    isLoadingMore = false;
  }

  _onSearchChanged(String query) {
    print('query ${query}');
    print('query.length:${query.length}');
    print('query.characters.length:${query.characters.length}');
    print('query.runes.length:${query.runes.length}');
    print('utf8.encode(query).length:${utf8.encode(query).length}');
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 2000), () {
      fetchDetail = fetchDetail.copyWith(query: query, page: 1);
      context.read<HomeBloc>().add(FetchLaunches(fetchDetail));
    });
  }

  _onToggleSortOrder(String key) {
    Map<String, dynamic>? mapSorter = fetchDetail.sorter.toMap();
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

    FetchDetail newFetchDetail = fetchDetail.copyWith(
      page: 1,
      sorter: Sorter(
        key: key,
        sortOrder: newSortOrder,
      ),
    );
    setState(() {
      fetchDetail = newFetchDetail;
    });
    context.read<HomeBloc>().add(FetchLaunches(newFetchDetail));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Launches'),
        actions: <Widget>[Container()], // for hide EndDrawer icon
        backgroundColor: const Color(0x44000000),
        elevation: 0,
      ),
      body: Builder(builder: (context) {
        return Container(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 32.0),
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
                          maxLength: 5,
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
                              state.hasNextPage &&
                              !isLoadingMore) {
                            isLoadingMore = true;
                            _loadMore(
                              launches,
                              fetchDetail,
                            );
                          }
                          return false;
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
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
                                                        vertical: 10,
                                                        horizontal: 8),
                                                child: LaunchItem(
                                                  index: index + 1,
                                                  name: launches[index].name,
                                                  launchedDate: launches[index]
                                                      .launchedDate,
                                                  success:
                                                      launches[index].success,
                                                  image: launches[index].image,
                                                ))),
                                      ),
                                    );
                                  }),
                            ),
                            Visibility(
                              visible: state.isLoadingMore,
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                height: 35,
                                width: 35,
                                child: const CircularProgressIndicator(),
                              ),
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
      endDrawer: DrawerSorter(
        sorter: fetchDetail.sorter,
        onToggleSortOrder: _onToggleSortOrder,
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
