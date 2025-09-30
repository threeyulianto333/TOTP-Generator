import 'package:otp/otp.dart';

class GenerateOtp {

  /// generate OTP
  /// key: secret key
  /// msSinceEpoch: time in milliseconds since epoch, default is current time
  /// isGoogle: whether to use Google Authenticator algorithm, default is false
  Map<String, dynamic> generateOtp({required String key, int? msSinceEpoch, bool? isGoogle}) {
    Map<String, dynamic> retval = {
      'key': '',
      'msg': '',
      'status': false,
      'counter': 0,
    };
    int p2 = msSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;
    bool p3 = isGoogle ?? false;

    try {
      // Generate initial OTP
      String otp = OTP.generateTOTPCodeString(key, p2, isGoogle: p3);

      /// counter in second to invalidate OTP
      int counter = OTP.remainingSeconds();

      retval['key'] = otp;
      retval['msg'] = 'Success';
      retval['status'] = true;
      retval['counter'] = counter;
    } catch (e) {
      retval['msg'] = e.toString();
      retval['status'] = false;
      retval['counter'] = 0;
    }
    return retval;
  }
}
