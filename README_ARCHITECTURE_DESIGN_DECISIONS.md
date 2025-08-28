## Architecture & Design Decisions

**Pattern & Layout.** The app uses a lightweight Clean Architecture with feature‑first folders (Authentication, Products, Cart, Profile, Map). Layers are split into **Presentation → Domain → Data** so UI, business rules, and data access evolve and test independently.

**State & DI.** `provider` (+ `ChangeNotifier`) for simple, predictable state; `get_it` for dependency injection so modules are loosely coupled and easily mockable in tests.

**Navigation.** A centralized router in `app/router.dart` keeps routes discoverable and type‑safe, and is ready for deep links and guarded routes.

**Repositories & Data Sources.** The Domain layer defines repository interfaces; the Data layer implements them with Firebase (Auth, Firestore, Storage) and any HTTP services. This abstraction makes backends swappable and unit‑test friendly.

**Config & Security.** No secrets in the client or repo. Runtime configuration is injected via `--dart-define` (e.g., `STRIPE_PUBLISHABLE_KEY`, `GOOGLE_MAPS_API_KEY`). Firebase Rules default to **auth‑required** in production; **Test Mode** is used only temporarily during development.

**Payments.** Stripe **publishable key** is used in the client; all **secret** operations (PaymentIntent, Ephemeral Keys) live on a thin backend. This prevents exposing private keys and aligns with Stripe’s recommended architecture.

**Localization & Theming.** ARB‑based i18n (EN/AR) with RTL support, and a single Material 3 theme source (`app/theme.dart`) for consistent typography, colors, and components across features.

**Media Pipeline.** Profile images are selected with `image_picker`, cropped square with `image_cropper`, stored locally (for immediate display), and uploaded to Firebase Storage with a reference stored in Firestore.

** UX Enhancements.** Native in‑app reviews via `in_app_review` behind a simple rate‑limiter (ask only after a “success moment”), responsive layouts that scale from phones to tablets, and cached images (`cached_network_image`) for smooth scrolling.

**Maps & Location.** Location features use `google_maps_flutter` and `geolocator`, isolated behind adapters in the Data layer to keep Presentation free of platform specifics.

**Quality & Performance.** Flutter lints and analysis options are enforced; critical flows have unit/widget tests. Lists use lazy loading/pagination where applicable to minimize memory and keep frame times stable.

**Why these choices?** Clean Architecture + repositories provide clear seams for testing and swapping implementations. `provider` is lightweight for current scope and can be upgraded per‑feature (e.g., Riverpod/BLoC) if complexity grows. Using `dart-define` and backend‑only secrets keeps the codebase secure across environments.

---

### ملخص بالعربية
المشروع يتبع بنية نظيفة تفصل بين العرض (Presentation)، القواعد/الدومين (Domain)، والبيانات (Data) مع تنظيم حسب الميزة. الحالة تُدار بـ `provider` وحقن الاعتماديات بـ `get_it`. الوصول إلى Firebase مخفي خلف مستودعات (Repositories) لسهولة الاختبار والتبديل. لا توجد أسرار داخل العميل؛ المفاتيح تُحقن وقت التشغيل، وعمليات Stripe السرّية على خادم صغير فقط. الواجهة تدعم التوطين عربي/إنجليزي وRTL، وقص صور البروفايل بـ `image_cropper`، وتقييم داخل التطبيق بـ `in_app_review`. قواعد Firebase آمنة للإنتاج، والأداء مراقب مع كاش للصور وتصفح كسول للقوائم.
