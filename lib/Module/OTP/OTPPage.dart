import 'package:flutter/material.dart';
import 'package:totp_generator/Module/Timer/CountdownWidget.dart';

import '../../Helper/Otp.dart';

class Otppage extends StatefulWidget {
  const Otppage({super.key});

  @override
  State<Otppage> createState() => _OtppageState();
}

class _OtppageState extends State<Otppage> {
  /// Input
  TextEditingController teOtp = TextEditingController();
  bool isGoogle = false;
  int msSinceEpoch = DateTime.now().millisecondsSinceEpoch;

  /// Hasil
  TextEditingController teHasil = TextEditingController();

  /// to invalidate OTP
  int durationToInvalidate = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // settingan OTP
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // dropdown button
                DropdownButton<String>(
                  value: 'Milliseconds', // Default value
                  items: const [
                    DropdownMenuItem(
                      value: 'Milliseconds',
                      child: Text('Milliseconds Since Epoch'),
                    ),
                    DropdownMenuItem(
                      value: 'Date',
                      child: Text('Date'),
                    ),
                  ],
                  onChanged: (String? value) {
                    // Handle dropdown selection
                    if (value == 'Date') {
                      // Logic for date input
                      debugPrint('Date selected');
                    } else {
                      // Logic for milliseconds input
                      debugPrint('Milliseconds selected');
                    }
                  },
                ),

                // msSinceEpoch
                Flexible(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Milliseconds Since Epoch",
                      hintText: "1633036800000",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        msSinceEpoch = int.tryParse(value) ??
                            DateTime.now().millisecondsSinceEpoch;
                      });
                    },
                  ),
                ),
                const SizedBox.square(dimension: 20),

                // is Google Authenticator
                Checkbox(
                    value: isGoogle,
                    onChanged: (value) {
                      setState(() {
                        isGoogle = value ?? false;
                      });
                    }),
                const Text('Google Authenticator'),
              ],
            ),
            const SizedBox.square(dimension: 20),

            // otp input dan button
            Row(
              children: [
                /// OTP input
                Expanded(
                  child: TextField(
                    controller: teOtp,
                    decoration: const InputDecoration(
                      labelText: "Enter OTP Key",
                      hintText: "1skdi3knfcjoq3sdlmfsjdfl",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox.square(dimension: 20),

                /// Generate OTP button
                ElevatedButton(
                    onPressed: onPressed, child: const Text('Get OTP')),
              ],
            ),
            const SizedBox.square(dimension: 20),

            /// Result
            Row(
              children: [
                /// OTP result
                Expanded(
                  child: TextField(
                    controller: teHasil,
                    decoration: const InputDecoration(
                      labelText: "Generated OTP",
                      hintText: "Generated OTP will appear here",
                      border: OutlineInputBorder(),
                    ),
                    readOnly: true,
                  ),
                ),
                const SizedBox.square(dimension: 20),

                /// Counter
                CountdownWidget(
                    data: durationToInvalidate,
                    onChanged: (int value) {
                      /// jika counter belum habis
                      if (value > 0) {
                        debugPrint('Counter: $value');
                        setState(() => durationToInvalidate = value);
                      }
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Function to generate OTP
  void onPressed() {
    String key = teOtp.text;
    Map<String, dynamic> result = GenerateOtp()
        .generateOtp(key: key, msSinceEpoch: msSinceEpoch, isGoogle: isGoogle);

    /// Check if OTP generation was successful
    if (result['status']) {
      setState(() {
        teHasil.text = result['key'];
        durationToInvalidate = result['counter'];
      });
    }

    /// If there was an error, display the message
    else {
      setState(() {
        teHasil.text = result['msg'];
      });
    }
  }
}
