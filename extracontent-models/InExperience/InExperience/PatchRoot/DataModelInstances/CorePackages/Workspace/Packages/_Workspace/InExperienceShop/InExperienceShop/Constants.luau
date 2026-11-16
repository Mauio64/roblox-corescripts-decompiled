local defineFastInt = game:DefineFastInt("ShopItemsPerSection", 6)
return {
	ROBUX_ICON = "icons/common/robux",
	ROBUX_PACKAGE_IMAGE = "icons/common/robux",
	MIN_TILE_WIDTH = game:DefineFastInt("ShopMinTileWidth", 98),
	MIN_COLUMNS = 2,
	ITEMS_PER_SECTION = defineFastInt,
	HOME_CATEGORY_ID = "home",
	ROBUX_CATEGORY_NAME = "Robux",
	TOP_PICKS_CATEGORY_TYPE = "TopPicks",
	BLACKLISTED_CATEGORY_NAMES = {},
	SEARCH_DEBOUNCE_SECONDS = 0.25,
	SEARCH_MIN_LENGTH = 1,
	MAX_SEARCH_RESULTS = game:DefineFastInt("ShopMaxSearchResults", 50),
	POLL_INITIAL_DELAY_SECONDS = 0.25,
	POLL_BACKOFF_MULTIPLIER = 2,
	COMPACT_BREAKPOINT_WIDTH = 480
}
