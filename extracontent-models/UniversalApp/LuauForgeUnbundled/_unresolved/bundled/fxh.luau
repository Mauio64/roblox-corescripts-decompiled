return {
	Api = { autocompleteUnifiedSuggest = require("@luauforge/bundled/fxi") },
	Components = {
		SearchBar = require("@luauforge/bundled/fxn"),
		SearchViewExposureLogger = require("@luauforge/bundled/fxx")
	},
	Features = {
		SearchLandingPage = require("@luauforge/bundled/fxA"),
		useSearchLandingPageProps = require("@luauforge/bundled/fyn")
	},
	Utils = {
		RecentSearchTermsAppStorage = require("@luauforge/bundled/fyr"),
		RecentlyViewedSearchItemsAppStorage = require("@luauforge/bundled/fxW"),
		normalizeKeyword = require("@luauforge/bundled/fyq"),
		getAutocompleteQueryKey = require("@luauforge/bundled/fys")
	},
	Enums = {
		Counter = require("@luauforge/bundled/fxV"),
		Stat = require("@luauforge/bundled/fyv"),
		SearchLandingPageWidgetEnum = require("@luauforge/bundled/fxS")
	},
	Flags = { GetFFlagAXRecentlyViewedCounters = require("@luauforge/bundled/fyy") }
}
