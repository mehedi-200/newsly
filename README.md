# Newsly

A Hacker News reader for Android and iOS, built with Flutter.

It runs the moment you clone it — the [Algolia Hacker News API](https://hn.algolia.com/api)
is public, free, and needs no key or signup, so there is nothing to configure.

## Features

- **Four feeds** — Top, New, Ask HN and Show HN, each paginated independently with
  infinite scroll and pull-to-refresh
- **Threaded comments** — the full discussion, indented by reply depth, tap to expand
- **Search** — debounced full-text search across stories, authors and domains
- **Bookmarks** — save stories for later; stored locally with Hive, survives restarts
- **Light / dark / system theme** — remembered between launches
- **Offline-aware** — typed error states with retry, shimmer placeholders while loading

## Architecture

Cubit + Repository, with a strict one-way dependency:

```
UI  →  Cubit  →  Repository  →  Api
```

The UI never touches `Api` or a model's JSON, and a repository never knows a widget exists.
Swapping the data source means changing one repository, not the screens.

```
lib/
├── main.dart                     # entry point → initializeApp()
├── app/
│   ├── app.dart                  # Hive init, app-wide BlocProviders, GetMaterialApp
│   └── routes.dart               # named routes; each screen exposes getRouteInstance()
├── cubits/                       # one cubit per feature, states declared in the same file
│   ├── bookmarks/
│   ├── settings/
│   └── stories/                  # storiesCubit, searchCubit, commentsCubit
├── data/
│   ├── models/                   # plain models with fromJson / toJson
│   └── repositories/             # storyRepository, bookmarkRepository, settingsRepository
├── ui/
│   ├── screens/<feature>/widgets/ # screen-local widgets live beside their screen
│   ├── styles/                   # colors.dart, appTheme.dart, themeExtensions/
│   └── widgets/                  # widgets shared across screens
└── utils/                        # api.dart (endpoints + Dio), constants.dart, utils.dart
```

Two conventions worth knowing before you add a feature:

- **Cubit scope.** Only truly app-wide cubits (`ThemeCubit`, `BookmarksCubit`) are provided
  in `app.dart`. Feature cubits are provided by the screen that owns them, via that screen's
  `getRouteInstance()`, so they are created and disposed with the route.
- **File names are camelCase** (`storyRepository.dart`), matching the class inside. The
  `file_names` lint is turned off in `analysis_options.yaml` on purpose.

## Stack

| Concern | Package |
|---|---|
| State management | `flutter_bloc` |
| Routing | `get` |
| Networking | `dio` |
| Local storage | `hive` / `hive_flutter` |
| Typography | `google_fonts` |
| UI | `shimmer`, `flutter_animate`, `cached_network_image` |
| Platform | `url_launcher`, `share_plus` |

## Getting started

```bash
flutter pub get
flutter run
```

Requires Flutter with Dart SDK `>=3.3.1`.

## Tests

```bash
flutter test
```

Covers JSON parsing against real API payload shapes, comment-tree flattening, the URL and
HTML helpers, and `StoriesCubit` pagination — including that a failed page-2 fetch keeps the
stories already on screen.

## API notes

All endpoints are declared in `lib/utils/api.dart`; the base URL lives in
`lib/utils/constants.dart`.

One thing that isn't obvious: Algolia's `search` endpoint ranks by points across *all time*,
so an unfiltered "Top" feed returns 2018 classics. Each popularity-ranked feed therefore
carries a recency window (`StoryFeed.recentWindow`) that becomes a `created_at_i>` numeric
filter. The "New" feed skips this and uses the chronological `search_by_date` endpoint
instead.

## License

MIT — see [LICENSE](LICENSE).
