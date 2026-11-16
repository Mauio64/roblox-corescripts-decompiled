return {
	Api = { autocompleteUnifiedSuggest = require("@luauforge/bundled/fpO") },
	Components = {
		SearchBar = require("@luauforge/bundled/fpT"),
		SearchViewExposureLogger = require("@luauforge/bundled/fqd")
	},
	Features = {
		SearchLandingPage = require("@luauforge/bundled/fqg"),
		useSearchLandingPageProps = require("@luauforge/bundled/fqT")
	},
	Utils = {
		RecentSearchTermsAppStorage = require("@luauforge/bundled/fqX"),
		RecentlyViewedSearchItemsAppStorage = require("@luauforge/bundled/fqC"),
		normalizeKeyword = require("@luauforge/bundled/fqW"),
		getAutocompleteQueryKey = require("@luauforge/bundled/fqY")
	},
	Enums = {
		Counter = require("@luauforge/bundled/fqB"),
		Stat = require("@luauforge/bundled/frb"),
		SearchLandingPageWidgetEnum = require("@luauforge/bundled/fqy")
	},
	Flags = { GetFFlagAXRecentlyViewedCounters = require("@luauforge/bundled/fre") }
}
