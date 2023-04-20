import 'package:bank_al_dawa/app/core/models/report_models/report_log_model.dart';

class QuickSort {
  static Future<List<ReportLog>> sort(
      {required List<ReportLog> list, required int low, required int high}) {
    if (low < high) {
      final int pi = partition(list, low, high);
      // print("pivot: ${list[pi]} now at index $pi");

      sort(list: list, low: low, high: pi - 1);
      sort(list: list, low: pi + 1, high: high);
    }
    return Future.value(list);
  }

  static int partition(List<ReportLog> list, low, high) {
    // Base check
    if (list.isEmpty) {
      return 0;
    }
    // Take our last element as pivot and counter i one less than low
    final int pivot = list[high].id;

    int i = low - 1;
    for (int j = low; j < high; j++) {
      // When j is < than pivot element we increment i and swap arr[i] and arr[j]
      if (list[j].id < pivot) {
        i++;
        swap(list, i, j);
      }
    }
    // Swap the last element and place in front of the i'th element
    swap(list, i + 1, high);
    return i + 1;
  }

// Swapping using a temp variable
  static void swap(List<ReportLog> list, int i, int j) {
    final ReportLog temp = list[i];
    list[i] = list[j];
    list[j] = temp;
  }
}
