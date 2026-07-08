local v1 = game:DefineFastInt("ShopItemsPerSection", 6)
local v2 = game:DefineFastInt("ShopMinTileWidth", 98)
local v3 = game:DefineFastInt("ShopMaxSearchResults", 50)

return {
	ROBUX_ICON = "icons/common/robux",
	ROBUX_PACKAGE_IMAGE = "icons/common/robux",
	MIN_COLUMNS = 2,
	HOME_CATEGORY_ID = "home",
	SEARCH_DEBOUNCE_SECONDS = 0.25,
	SEARCH_MIN_LENGTH = 1,
	POLL_INITIAL_DELAY_SECONDS = 0.25,
	POLL_BACKOFF_MULTIPLIER = 2,
	MIN_TILE_WIDTH = v2,
	ITEMS_PER_SECTION = v1,
	BLACKLISTED_CATEGORY_NAMES = {},
	MAX_SEARCH_RESULTS = v3
}
