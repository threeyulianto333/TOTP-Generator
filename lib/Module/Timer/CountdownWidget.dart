import 'package:flutter/material.dart';

class CountdownWidget extends StatefulWidget {
  const CountdownWidget({super.key, required this.data, this.onChanged});

  /// Data
  final int data;

  ///
  final ValueChanged<int>? onChanged;

  @override
  State<CountdownWidget> createState() => _CountdownWidgetState();
}

class _CountdownWidgetState extends State<CountdownWidget> {
  @override
  Widget build(BuildContext context) {
    /// jika timer belum habis
    if (Duration(seconds: widget.data).inSeconds > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          /// decrement timer
          widget.onChanged?.call(widget.data - 1);
        });
      });
    }

    /// jika timer sudah habis
    // else {
    //   /// jika timer belum 0
    //   if (timer.inSeconds ==) {
    //     setState(() {
    //       timer = const Duration(seconds: 0);
    //       widget.onChanged?.call(0);
    //     });
    //   }
    // }

    return Text(widget.data.toString());
  }
}
