// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:space_xxx/constants/sort_order.dart';
import 'package:space_xxx/data/models/launch_model.dart';
import 'package:space_xxx/data/repositories/launch_repository.dart';
import 'package:space_xxx/modules/home_screen/bloc/bloc.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late HomeBloc bloc;
  late LaunchRepository repository;

  setUp(() {
    repository = LaunchRepositoryMock();
    bloc = HomeBloc(repository);
  });

  tearDown(() {
    bloc.close();
  });

  group('HomeBloc', () {
    blocTest<HomeBloc, HomeState>(
      'Fetch Launches List',
      build: () {
        when(
          () => repository.getlaunchesList(
            const FetchDetail(
              page: 1,
              limit: 10,
              sorter: Sorter(
                key: 'name',
                sortOrder: SorterOrder.none,
              ),
            ),
          ),
        ).thenAnswer(
          (_) => Future.value(
            const LaunchDetail(
              launchs: [],
              pageDetail:
                  PageDetail(page: 1, totalPages: 10, hasNextPage: true),
            ),
          ),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const FetchLaunches(
          FetchDetail(
            page: 1,
            limit: 10,
            sorter: Sorter(
              key: 'name',
              sortOrder: SorterOrder.none,
            ),
          ),
        ),
      ),
      expect: () => [
        HomeLoadingState(),
        HomeLoadedState(
          launches: const [],
          isLoadingMore: false,
          hasNextPage: true,
        ),
      ],
    );

    blocTest<HomeBloc, HomeState>(
      'Fetch More',
      build: () {
        when(
          () => repository.getlaunchesList(
            const FetchDetail(
              page: 1,
              limit: 10,
              sorter: Sorter(
                key: 'name',
                sortOrder: SorterOrder.none,
              ),
            ),
          ),
        ).thenAnswer(
          (_) => Future.value(
            const LaunchDetail(
              launchs: [],
              pageDetail:
                  PageDetail(page: 2, totalPages: 10, hasNextPage: true),
            ),
          ),
        );
        return bloc;
      },
      act: (bloc) {
        bloc.emit(
          HomeLoadedState(
            launches: [],
            isLoadingMore: false,
            hasNextPage: true,
          ),
        );
        bloc.add(
          const FetchLaunchesMore(
            [],
            FetchDetail(
              page: 1,
              limit: 10,
              sorter: Sorter(
                key: 'name',
                sortOrder: SorterOrder.none,
              ),
            ),
          ),
        );
      },
      expect: () => [
        HomeLoadedState(
          launches: [],
          isLoadingMore: false,
          hasNextPage: true,
        ),
        HomeLoadedState(
          launches: [],
          isLoadingMore: true,
          hasNextPage: true,
        ),
        HomeLoadedState(
          launches: [],
          isLoadingMore: false,
          hasNextPage: true,
        ),
      ],
    );
  });
}

class LaunchRepositoryMock extends Mock implements LaunchRepository {}
