class ApiUrl {
  static const String baseUrl = 'http://localhost:8001/api/';
  // static const String baseUrl = 'https://api.bhukk.com/api/';
  static const String login = 'login';
  static const String verifyOtp = 'verify-otp';
  static const String signup = 'signup';
  static const String addEmergencyContact = 'users/{user_id}/emergency-contacts';
  static const String getEmergencyContacts = 'users/{user_id}/emergency-contacts';
  static const String updateEmergencyContact = 'users/{user_id}/emergency-contacts/{id}';
  static const String deleteEmergencyContact = 'users/{user_id}/emergency-contacts/{id}';
  static const String restaurants = 'v1/restaurants/';
  static const String restaurantDetails = 'v1/restaurants/id/';
  static const String restaurantMenu = 'v1/restaurants/id/menu/';
  static const String carousels = 'v1/carousel/'; 
}