// ignore_for_file: library_private_types_in_public_api

import 'package:bank_al_dawa/app/core/widgets/widget_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaginationBuilder<T extends GetxController> extends StatefulWidget {
  const PaginationBuilder({
    required this.id,
    required this.builder,
    this.onLoadingMore,
    this.loadingMoreIndicatorPadding = const EdgeInsets.all(15),
    this.onRefresh,
    this.loadingMoreIndicatorAlignment = Alignment.bottomCenter,
    Key? key,
  }) : super(key: key);
  final Function()? onRefresh;
  final Function()? onLoadingMore;
  final String id;
  final StateBuilders builder;
  final AlignmentGeometry loadingMoreIndicatorAlignment;
  final EdgeInsetsGeometry loadingMoreIndicatorPadding;
  @override
  _PaginationBuilderState<T> createState() => _PaginationBuilderState<T>();
}

class _PaginationBuilderState<T extends GetxController>
    extends State<PaginationBuilder<T>> {
  ScrollController scrollController = ScrollController();
  StateHolder? stateHolder;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getStateHolder();
    });

    scrollController.addListener(_scrollListener);
    super.initState();
  }

  bool isLoading = false;
  void _scrollListener() async {
    if (scrollController.position.atEdge &&
        !isLoading &&
        (stateHolder!.widgetState != WidgetState.noMoreData)) {
      final bool isTop = scrollController.position.pixels == 0;
      if (!isTop && !isLoading) {
        isLoading = true;
        if (widget.onLoadingMore != null) {
          await widget.onLoadingMore!();
        }
      }
      isLoading = false;
    }
  }

  void getStateHolder() {
    for (StateHolder stateHolder in StateBuilder.stateList) {
      if (widget.id == stateHolder.id) {
        this.stateHolder = stateHolder;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      backgroundColor: Theme.of(context).backgroundColor,
      color: Theme.of(context).primaryColor,
      onRefresh: () async {
        if (widget.onRefresh != null) {
          await widget.onRefresh!();
        }
      },
      child: Stack(
        children: [
          widget.builder(scrollController),
          StateBuilder<T>(
              disableState: true,
              builder: (widgetState, controller) {
                return Visibility(
                  visible: widgetState == WidgetState.loadingMore,
                  child: Align(
                    alignment: widget.loadingMoreIndicatorAlignment,
                    child: Padding(
                      padding: widget.loadingMoreIndicatorPadding,
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Theme.of(context)
                                .backgroundColor, //Colors.white,
                            child: CircularProgressIndicator(
                                color: Theme.of(context).primaryColor)),
                      ),
                    ),
                  ),
                );
              },
              id: widget.id //+ "ProgressIndicator",
              ),
        ],
      ),
    );
  }
}

typedef StateBuilders = Widget Function(ScrollController scrollController);

class Pagination<T> {
  Pagination({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.totalPages,
    required this.page,
    required this.pagingCounter,
    required this.hasPrevPage,
    required this.hasNextPage,
  });
  List<T> docs;
  int totalDocs;
  int limit;
  int totalPages;
  int page;
  int pagingCounter;
  bool hasPrevPage;
  bool hasNextPage;
  Pagination.empty({
    this.docs = const [],
    this.totalDocs = 0,
    this.limit = 0,
    this.totalPages = 0,
    this.page = 0,
    this.pagingCounter = 0,
    this.hasPrevPage = false,
    this.hasNextPage = false,
  });
  factory Pagination.fromMap(Map<String, dynamic> json,
      T Function(Map<String, dynamic> json) fromMap) {
    return Pagination(
      docs: json["docs"] == null
          ? List<T>.from(json["courses"].map((x) => fromMap(x)))
          : List<T>.from(json["docs"].map((x) => fromMap(x))),
      totalDocs: json["totalDocs"],
      limit: json["limit"],
      totalPages: json["totalPages"],
      page: json["page"] ?? 0,
      pagingCounter: json["pagingCounter"],
      hasPrevPage: json["hasPrevPage"],
      hasNextPage: json["hasNextPage"],
    );
  }
}
