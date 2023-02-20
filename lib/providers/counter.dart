import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:provider_cho_udemy/providers/bg_color.dart';
import 'package:state_notifier/state_notifier.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CounterState extends Equatable {
  final int counter;
  CounterState({
    required this.counter,
  });

  @override
  List<Object> get props => [counter];

  @override
  bool get stringify => true;

  CounterState copyWith({
    int? counter,
  }) {
    return CounterState(
      counter: counter ?? this.counter,
    );
  }
}

class Counter extends StateNotifier<CounterState> with LocatorMixin {
  Counter() : super(CounterState(counter: 0));

  void increment() {
    //state = state.copyWith(counter: state.counter + 1);
    print(read<BgColor>().state);

    Color currentColor = read<BgColor>().state.color;

    if (currentColor == Colors.black) {
      state = state.copyWith(counter: state.counter + 10);
    } else if (currentColor == Colors.red) {
      state = state.copyWith(counter: state.counter - 10);
    } else {
      state = state.copyWith(counter: state.counter + 1);
    }
  }

  @override
  void update(Locator watch) {
    print('in Counter StateNotifier: ${watch<BgColorState>().color}');
    super.update(watch);
  }
}
