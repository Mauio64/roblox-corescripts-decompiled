require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/RoduxTypes")
local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/SearchLandingPageSurface")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/PlayabilityStatusEnum")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/PlayableUxTreatmentEnum")
require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/EnumGameDetailErrorTypes")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/EnumIgrsRating")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/GameCollectionItemTypes")

local GetFIntLuaAppRecommendedGamesCount = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/Flags/GetFIntLuaAppRecommendedGamesCount")
local fFlagEnableTopSongsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/SharedFlags").FFlagEnableTopSongsSort
local fFlagLuaAppUnifyPlayButtonMobileEdp = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/SharedFlags").FFlagLuaAppUnifyPlayButtonMobileEdp
local getFFlagUIBloxUseFoundationButton = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/SharedFlags").UIBlox.GetFFlagUIBloxUseFoundationButton

local v5 = {
	OmniFeedPropsKey = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/AppCommonLib").Symbol.named("OmniFeedProps"),
	Constants = {
		SORT_INDEX_SELECTION_ORDER_MULTIPLIER = 100,
		SORT_SELECTION_ORDER_BASE = -1000,
		DEFAULT_GAME_FETCH_COUNT = 40,
		GAME_CAROUSEL_CHILD_PADDING = 12,
		GAME_CAROUSEL_PADDING = 15,
		GAME_CAROUSEL_SIDE_COMPACT_PADDING = 24,
		GAME_CAROUSEL_SIDE_WIDE_PADDING = 48,
		GAME_DETAILS_ACTION_BAR_HEIGHT = (fFlagLuaAppUnifyPlayButtonMobileEdp or getFFlagUIBloxUseFoundationButton()) and 50 or 48,
		GAME_GRID_CHILD_PADDING = 12,
		GAME_GRID_PADDING = 15,
		GAME_GRID_TILE_FOOTER_HEIGHT = 70,
		MAX_RECOMMENDED_GAMES_FETCH_COUNT = GetFIntLuaAppRecommendedGamesCount()
	},
	DataSourceType = {
		DiscoveryApi = "DiscoveryApi",
		ExploreApi = "ExploreApi",
		GamesApi = "GamesApi",
		Local = "Local",
		OmniAutocompleteApi = "OmniAutocompleteApi",
		SearchApi = "SearchApi",
		Unknown = "Unknown"
	},
	ExperienceDetailsNoticeType = { InExperiencePurchase = "InExperiencePurchase" },
	ExploreContentType = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/ExploreContentType"),
	GameBasicStatsLayoutType = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/GameBasicStatsLayoutType"),
	GameCardLayoutType = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/GameCardLayoutType"),
	EnumGameDetailErrorTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/EnumGameDetailErrorTypes"),
	EnumIgrsRating = module4,
	GameMediaImageType = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/GameMediaImageType"),
	GameSortGroups = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/GameSortGroups"),
	GameTopicIds = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/GameTopicIds"),
	OmniRecommendationsContentType = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/OmniRecommendationsContentType"),
	OmniFeedTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/OmniFeedTypes"),
	OmniFeedConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/OmniFeedConstants"),
	PlayabilityStatusEnum = module2,
	PlayableUxTreatmentEnum = module3,
	SearchSourceEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/SearchSourceEvent"),
	SearchTextTopicIds = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/SearchTextTopicIds"),
	SearchLandingPageSurface = module,
	SortContentType = 0,
	GameCollectionItemTypes = 0
}

local v6 = if fFlagEnableTopSongsSort then require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryTypes/DiscoveryTypes/SortContentType") else nil
v5.SortContentType = v6
v5.GameCollectionItemTypes = module5
return v5
