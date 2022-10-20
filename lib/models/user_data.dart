class UserData {
  final int userId;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final double latitude;
  final double longitude;
  final String country;
  final String countryCode;
  final String region;
  final String state;
  final String city;
  final String postalCode;
  final int advertise;
  final int credits;
  final int darkTheme;
  final int termsAgreed;
  final int cautionDismissed;
  final int dev;

  UserData(
      {required this.userId,
      required this.firstName,
      required this.lastName,
      required this.userName,
      required this.email,
      required this.latitude,
      required this.longitude,
      required this.country,
      required this.countryCode,
      required this.region,
      required this.state,
      required this.city,
      required this.postalCode,
      required this.advertise,
      required this.credits,
      required this.darkTheme,
      required this.termsAgreed,
      required this.cautionDismissed,
      required this.dev});

  // Convert userData into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'latitude': latitude,
      'longitude': longitude,
      'country': country,
      'countryCode': countryCode,
      'region': region,
      'state': state,
      'city': city,
      'postalCode': postalCode,
      'advertise': advertise,
      'credits': credits,
      'darkTheme': darkTheme,
      'termsAgreed': termsAgreed,
      'cautionDismissed': cautionDismissed,
      'dev': dev,
    };
  }

  // Implement toString to make it easier to see information about
  // userData when using the print statement.
  @override
  String toString() {
    return 'UserData {userId: $userId, firstName: $firstName, lastName: $lastName, userName: $userName, email: $email, latitude: $latitude, longitude: $longitude, country: $country, country code: $countryCode, region: $region, state: $state, city: $city, postal code: $postalCode, advertise: $advertise, credits: $credits, darkTheme: $darkTheme, termsAgreed: $termsAgreed, cautionDismissed: $cautionDismissed}, dev: $dev}';
  }
}
