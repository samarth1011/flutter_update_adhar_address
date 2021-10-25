import 'package:geocoding/geocoding.dart';

class LocationHandler {
  Future<bool> compareAddress({landLordAddress, userEditedAddress}) async {
    try {
      List<Location> landLordAddressLocations =
          await locationFromAddress(landLordAddress);
      print(landLordAddressLocations);

      List<Location> userEditedAddressLocations =
          await locationFromAddress(userEditedAddress);
      print(userEditedAddressLocations);

      double landLordAddressLocationsLatitide =
          landLordAddressLocations[0].latitude;
      double landLordAddressLocationsLongitude =
          landLordAddressLocations[0].longitude;

      double userEditedAddressLocationsLatitide =
          userEditedAddressLocations[0].latitude;
      double userEditedAddressLocationsLongitude =
          userEditedAddressLocations[0].longitude;
      print(
          "userEditedAddressLocationsLongitude $userEditedAddressLocationsLongitude");
      print(
          "landLordAddressLocationsLongitude $landLordAddressLocationsLongitude");
      print(
          "userEditedAddressLocationsLatitide $userEditedAddressLocationsLatitide");
      print(
          "landLordAddressLocationsLatitide $landLordAddressLocationsLatitide");

      if (userEditedAddressLocationsLatitide ==
              landLordAddressLocationsLatitide &&
          userEditedAddressLocationsLongitude ==
              landLordAddressLocationsLongitude) {
        return true;
      }
    } catch (e) {
      print("Some erro ocurred in getting cordinates - $e");
    }
    return false;
  }
}
