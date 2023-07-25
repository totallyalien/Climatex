# Climatex
A beautiful and dynamic weather app built using Flutter that fetches real-time weather data from an API and provides a user-friendly interface to display the weather information.
Creating a weather app using Flutter with a dynamic UI involves fetching weather data from an API and presenting it in a visually appealing and interactive manner.

# Weather App with Dynamic UI using Flutter

[![Flutter](https://img.shields.io/badge/Flutter-2.2.3-blue.svg?style=flat)](https://flutter.dev/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A beautiful and dynamic weather app built using Flutter that fetches real-time weather data from an API and provides a user-friendly interface to display the weather information.

## Features

- **Real-time Weather Data**: Get accurate and up-to-date weather data from a reliable API to ensure users get the most recent weather information.

- **Dynamic UI**: The app features a dynamically changing user interface, adapting to weather conditions, such as sunny, rainy, cloudy, and more.

- **Location-based Forecast**: Fetch weather data based on the user's location, providing hyper-local weather updates.

- **Weather Details**: View detailed weather information such as temperature, humidity and more for the current location.

- **Hourly Forecast**: Provide an hourly weather forecast to keep users informed throughout the day.

- **Weather Icons**: Utilize weather icons to visually represent different weather conditions, improving the user experience.

- **Responsive Design**: Ensure a seamless experience on various devices, including smartphones and tablets.

- **User-friendly Interface**: Create an intuitive and easy-to-use interface for a positive user experience.

## Screenshots
![Screenshot_20230601_190737](https://github.com/totallyalien/Climatex/assets/97169836/a119f5a7-4254-4a8f-93f7-1df3f8882345)
![Screenshot_20230601_190658](https://github.com/totallyalien/Climatex/assets/97169836/efdb78b8-2d39-4c09-b0ca-25703f87b316)
![Screenshot_20230601_190837](https://github.com/totallyalien/Climatex/assets/97169836/f3d6f8ad-18e1-4138-a61a-abd01d68dddb)
## Getting Started

To run this app locally on your machine, follow these steps:

1. Make sure you have [Flutter](https://flutter.dev/) installed on your system.

2. Clone this repository using the following command:

```
git clone https://github.com/totallyalien/climatex.git
```

3. Navigate to the project directory and fetch the dependencies:

```
cd weather-app
flutter pub get
```

4. Obtain an API key from a weather data provider like OpenWeatherMap,Accuweather and replace `YOUR_API_KEY` in `lib/ui/testing.dart`.

5. Run the app on your preferred device:

```
flutter run
```

## API Used

This app fetches weather data from [OpenWeatherMap API](https://openweathermap.org/api)/[AccuWeather](https://developer.accuweather.com/).

## Libraries Used

- [http](https://pub.dev/packages/http): For making API requests.
- [geolocator](https://pub.dev/packages/geolocator): For obtaining user location.
- [flutter_svg](https://pub.dev/packages/flutter_svg): For displaying SVG weather icons.
- [intl](https://pub.dev/packages/intl): For formatting date and time.
- dynamic_color, flutter_animate, free_place_search, google_nav_bar, home_widget, http, lottie, and sleek_circular_slider

## Contributions

Contributions to this project are welcome! If you find any issues or want to add new features, feel free to open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Feel free to use this GitHub description as a starting point for your weather app project using Flutter and a dynamic UI. Adjust the features, APIs, and libraries used to suit your specific implementation. Happy coding!
