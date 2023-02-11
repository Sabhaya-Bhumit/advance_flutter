import 'package:get/get.dart';
import 'package:state_management_2/modals/CounterModal.dart';

class CounterController extends GetxController {
  CounterModal counterModal = CounterModal(count: 0);

  void Increment() {
    counterModal.count++;
    update();
  }

  void decrement() {
    counterModal.count--;
    update();
  }
}
