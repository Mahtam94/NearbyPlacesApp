# 📍 Nearby Places App – SwiftUI + Geoapify

A modern iOS app that allows users to search for nearby restaurants, cafés, cinemas, and clubs in any city. Built with SwiftUI and MapKit, it features dynamic category filtering, real-time map pins, and full gesture interaction support like zooming and panning.

---

## 🔄 Project Evolution

### ✨ Old Version
- Only used current location (no manual input)
- No filtering or category selection
- No zoom/pan gestures
- Flat UI and limited logic separation

### 🌟 New Version
- ✅ User can **enter any city or area** manually
- ✅ **Dynamic category filters** via checkboxes (Restaurants, Cafes, Clubs, Cinemas)
- ✅ **Zoomable and pannable map** using `Map` + gesture support
- ✅ Pins show **place names** on the map
- ✅ Clean separation of logic via `GeocoderManager` and `PlaceManager`

---

## 🧠 Technologies Used

- SwiftUI
- MapKit
- Geoapify Places API
- CoreLocation
- MV-like structure (logic extracted to separate files)


## 📄 License

This project is built for educational and portfolio purposes.  
Please respect [Geoapify’s Terms of Use](https://www.geoapify.com/terms-of-use/) for API access.
