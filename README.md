# Cosmetics E-Commerce Flutter App

A production-quality Flutter e-commerce application for cosmetics products, built with **MVVM architecture** and **Riverpod state management**.

## 📱 Features

### ✅ Implemented Features

1. **Product Search & Discovery**
   - Real-time search filtering
   - Grid layout for products
   - Product cards with images, prices, ratings
   - Badges for NEW, DISCOUNT, BEST SELLER

2. **Advanced Filtering**
   - Filter by Brand (MAC, Dior, NARS, etc.)
   - Filter by Category (Lipstick, Foundation, etc.)
   - Price range slider (¥0 - ¥10,000)
   - Minimum rating filter
   - Quick filters (In Stock, New, Best Sellers)
   - Multiple sort options (Price, Rating, Newest, etc.)
   - Active filter chips display
   - Filter persistence across navigation

3. **Product Detail Page**
   - Image carousel with indicators
   - Product information (brand, name, price, rating)
   - Color variant selection
   - Expandable description
   - Key features list
   - Product specifications
   - Customer reviews section (expandable)
   - Add to cart functionality with animation

4. **Shopping Cart**
   - Add products to cart
   - Badge indicator on cart icon
   - State management with Riverpod
   - Success snackbar on add to cart

5. **Favorites/Wishlist**
   - Toggle favorite status
   - Heart icon animation
   - Persistent favorites state

6. **UI/UX Excellence**
   - Pink/Rose theme (#FF69B4)
   - Smooth animations
   - Cached network images
   - Responsive design
   - Material Design 3
   - Bottom navigation bar

## 🏗️ Architecture

### MVVM (Model-View-ViewModel) Pattern

```
lib/
├── core/
│   └── constants/
│       └── app_colors.dart          # Color constants
├── data/
│   ├── models/                      # Data Models
│   │   ├── product_model.dart       # Product & Review models
│   │   └── filter_model.dart        # Filter & Sort models
│   └── repositories/
│       └── mock_data.dart           # Mock data repository
├── presentation/
│   ├── providers/                   # ViewModels (Riverpod)
│   │   ├── product_provider.dart    # Product & filter logic
│   │   ├── cart_provider.dart       # Cart state management
│   │   └── favorites_provider.dart  # Favorites state management
│   ├── pages/                       # Views/Screens
│   │   ├── search_page.dart         # Main search & listing
│   │   └── product_detail_page.dart # Product details
│   └── widgets/                     # Reusable UI components
│       ├── product_card.dart        # Product grid item
│       └── filter_bottom_sheet.dart # Filter modal
└── main.dart                        # App entry point
```

### Key Architecture Decisions

1. **MVVM Pattern**
   - **Models**: Immutable data classes (`ProductModel`, `ReviewModel`, `FilterModel`)
   - **Views**: Stateless/Stateful widgets (`SearchPage`, `ProductDetailPage`)
   - **ViewModels**: Riverpod providers managing business logic and state

2. **State Management: Riverpod**
   - `Provider`: For immutable data (all products, brands, categories)
   - `StateNotifierProvider`: For mutable state (filters, cart, favorites)
   - `Family` providers: For parameterized data (product reviews, favorite status)

3. **Separation of Concerns**
   - Data layer: Models and repositories
   - Business logic: Providers (ViewModels)
   - UI layer: Pages and widgets
   - Constants: Centralized colors and styles

4. **Reusable Components**
   - `ProductCard`: Used in grid layouts
   - `FilterBottomSheet`: Modal for filters
   - Shared styling through theme

## 🚀 Getting Started

### Prerequisites

```bash
Flutter SDK: >=3.0.0 <4.0.0
Dart SDK: >=3.0.0 <4.0.0
```

### Installation

1. **Clone or create the project**
```bash
flutter create cosmetics_app
cd cosmetics_app
```

2. **Copy all files to their respective locations** as shown in the architecture above

3. **Update `pubspec.yaml`** with the dependencies provided

4. **Install dependencies**
```bash
flutter pub get
```

5. **Run the app**
```bash
flutter run
```

## 📦 Dependencies

```yaml
# State Management
flutter_riverpod: ^2.4.9

# UI Components
cached_network_image: ^3.3.0    # Image caching
carousel_slider: ^4.2.1         # Image carousel
flutter_rating_bar: ^4.0.1      # Star ratings
badges: ^3.1.2                  # Badge indicators

# Utilities
intl: ^0.18.1                   # Internationalization (currency format)
collection: ^1.18.0             # Collection utilities
```

## 🎨 Design System

### Colors
- **Primary**: `#FF69B4` (Hot Pink)
- **Primary Light**: `#FFB6D9`
- **Background**: `#FFFAFC`
- **Text Primary**: `#2D2D2D`
- **Text Secondary**: `#757575`
- **Success**: `#4CAF50`
- **Star Rating**: `#FFD700`

### Typography
- **Display Large**: 32px, Bold
- **Display Medium**: 28px, Bold
- **Headline**: 16-20px, Semi-Bold
- **Body**: 14-16px, Regular
- **Caption**: 12px, Regular

## 🔄 Data Flow

### Search & Filter Flow
```
User Input (SearchPage)
    ↓
FilterNotifier.updateSearchQuery()
    ↓
filterProvider state updated
    ↓
filteredProductsProvider recomputes
    ↓
UI rebuilds with filtered products
```

### Add to Cart Flow
```
User taps "Add to Cart" (ProductDetailPage)
    ↓
CartNotifier.addToCart()
    ↓
cartProvider state updated
    ↓
SnackBar shows success message
    ↓
Cart badge updates
```

### Favorite Toggle Flow
```
User taps heart icon
    ↓
FavoritesNotifier.toggleFavorite()
    ↓
favoritesProvider state updated
    ↓
Icon animates and updates
```

## 🧪 Testing Scenarios

### Recommended Test Cases

1. **Search Functionality**
   - Search for "lipstick"
   - Search for "MAC"
   - Clear search query
   - Search with no results

2. **Filters**
   - Apply single brand filter
   - Apply multiple filters
   - Adjust price range
   - Sort by price (low to high)
   - Reset all filters

3. **Product Interaction**
   - Open product detail
   - Change color variant
   - Add to cart
   - Toggle favorite
   - View all reviews

4. **Navigation**
   - Navigate between bottom tabs
   - Back navigation from product detail
   - Filter modal open/close

## 💡 Code Quality Features

### Best Practices Implemented

1. **Immutable Models**: All models use `const` constructors
2. **Named Parameters**: Required parameters are explicit
3. **Documentation**: Comments explain architecture decisions
4. **Null Safety**: Full null-safety compliance
5. **Error Handling**: Placeholder and error widgets for images
6. **Performance**: `const` constructors, cached images, efficient rebuilds
7. **Accessibility**: Semantic labels, proper contrast ratios
8. **Code Organization**: Clear folder structure, single responsibility

### Performance Optimizations

- **Riverpod**: Only rebuilds affected widgets
- **Cached Images**: `cached_network_image` for efficient loading
- **Const Constructors**: Reduces widget rebuilds
- **ListView Builders**: Lazy loading for long lists
- **Efficient Filters**: Single pass filtering algorithm

## 🐛 Known Limitations

1. **Mock Data**: Uses static mock data instead of real API
2. **Image Assets**: Uses external URLs (Unsplash)
3. **Navigation**: Cart, Categories, Profile pages are placeholders
4. **Persistence**: State is lost on app restart (no local storage)
5. **Authentication**: No user authentication system

## 🔮 Future Enhancements

- [ ] Real API integration
- [ ] Local storage (Hive/SharedPreferences)
- [ ] User authentication
- [ ] Payment integration
- [ ] Order history
- [ ] Product recommendations
- [ ] Image zoom functionality
- [ ] Social sharing
- [ ] Dark mode support
- [ ] Multi-language support

## 📝 Interview Notes

### Architecture Highlights for Discussion

1. **Why MVVM?**
   - Clear separation of concerns
   - Testable business logic
   - Easy to maintain and scale

2. **Why Riverpod?**
   - Compile-time safety
   - Better than Provider/Bloc for this use case
   - Automatic disposal
   - Easy to test

3. **Code Quality**
   - Follows Flutter best practices
   - Production-ready code structure
   - Comprehensive comments
   - Scalable architecture

4. **UI/UX Decisions**
   - Material Design 3
   - Smooth animations
   - User feedback (snackbars)
   - Loading states
   - Error handling