/// Base URL of the Algolia Hacker News Search API.
///
/// Public, free, no API key and no signup required — which is why this project
/// runs for anyone who clones it. Docs: https://hn.algolia.com/api
const String baseUrl = "https://hn.algolia.com/api/v1/";

/// Where a story's comment thread lives on the web.
const String hackerNewsItemUrl = "https://news.ycombinator.com/item?id=";

/// Items requested per page. The API caps this at 1000, but 20 keeps the
/// infinite-scroll pages small and the first paint fast.
const int storiesPerPage = 20;

/// How long a cached feed page stays fresh before it is refetched.
const Duration feedCacheDuration = Duration(minutes: 10);
