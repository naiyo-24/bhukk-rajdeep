# Bhukk App Documentation

## Overview
Bhukk is a food and liquor delivery app similar to Zomato, with added table booking functionality. The app allows users to browse restaurants, book tables, order food and liquor, and track their orders.

## Key Features
- Restaurant browsing and search
- Table booking with different dining themes
- Food ordering
- Liquor ordering
- Order tracking
- User accounts and profiles

## Project Structure
- `lib/main.dart` - Entry point of the application
- `lib/models/` - Data models
- `lib/providers/` - State management providers
- `lib/route/` - GetX route definitions
- `lib/screens/` - UI screens
- `lib/services/` - API services and backend interaction
- `lib/theme/` - App theme definitions
- `lib/widgets/` - Reusable UI components

## Navigation System
The app uses GetX for navigation and route management. Routes are defined in `lib/route/routes.dart`. To navigate to a screen:

```dart
Get.toNamed(Routes.routeName, arguments: {...});
```

## Handling Missing Data
The app includes placeholder widgets to handle cases where data may be missing:
- Use `PlaceholderWidgets` class for consistent placeholder UI
- Restaurant model has `Restaurant.dummy()` and `Restaurant.dummyList()` methods to create placeholder data
- Error handling widgets provide a consistent user experience for various error states

## State Management
The app uses Provider for state management. Key providers:
- `CartProvider` - Manages shopping cart state

## Common UI Components
- Restaurant cards
- Food item cards 
- Loading shimmer effects
- Error and placeholder widgets

## App Theme
The app uses a custom theme with orange as the primary color.

## Adding New Features
When adding new features:
1. Create model classes in the `models` directory if needed
2. Add the corresponding screen in the `screens` directory
3. Register the route in `routes.dart`
4. Use GetX for navigation and Provider for state management
5. Ensure proper error handling and placeholders for missing data

## Common Error Cases and Handling
- Network errors: Use `ErrorHandlingWidgets.networkErrorWidget`
- Missing data: Use placeholder widgets and dummy data
- Server errors: Use `ErrorHandlingWidgets.serverErrorWidget`

## Best Practices
- Use dummy data instead of showing error screens when data is missing
- Implement proper loading states using Shimmer
- Follow GetX routing patterns for consistent navigation
- Document complex functions and widgets
- Use cached network images for better performance
