class ApiUrl {
  static const String baseUrl = 'https://api.bhukk.com/api/';
  static const String login = 'login';
  static const String verifyOtp = 'verify-otp';
  static const String signup = 'signup';
  static const String addEmergencyContact = 'users/{user_id}/emergency-contacts';
  static const String getEmergencyContacts = 'users/{user_id}/emergency-contacts';
  static const String updateEmergencyContact = 'users/{user_id}/emergency-contacts/{id}';
  static const String deleteEmergencyContact = 'users/{user_id}/emergency-contacts/{id}';
}