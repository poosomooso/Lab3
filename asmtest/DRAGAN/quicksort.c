#include <stdio.h>

int partition(int *arr, int start, int end) {
  int pivot = arr[end];
  int i = start - 1;
  for (int j = start; j <= end - 1; j++) {
    if (arr[j] <= pivot) {
      i++;
      int temp = arr[i];
      arr[i] = arr[j];
      arr[j] = temp;
    }
  }
  int temp = arr[i + 1];
  arr[i + 1] = arr[end];
  arr[end] = temp;
  return i + 1;
}

void quicksort(int *arr, int start, int end) {
  if (start < end) {
    int pivot = partition(arr, start, end);
    quicksort(arr, start, pivot - 1);
    quicksort(arr, pivot + 1, end);
  }
}

int main() {
  int arr[] = { 9, 5, 3, 6, 2, 8, 7, 3, 1, 4 };
  quicksort(arr, 0, 9);
  for (int i = 0; i < 10; i++) {
    printf("%d\n", arr[i]);
  }
  return 0;
}
