require(script.RoduxTypes)

local SearchLandingPageSurface = require(script.SearchLandingPageSurface)
local PlayabilityStatusEnum = require(script.PlayabilityStatusEnum)
local PlayableUxTreatmentEnum = require(script.PlayableUxTreatmentEnum)

require(script.EnumGameDetailErrorTypes)

local EnumIgrsRating = require(script.EnumIgrsRating)
local GameCollectionItemTypes = require(script.GameCollectionItemTypes)
local GetFIntLuaAppRecommendedGamesCount = require(script.Flags.GetFIntLuaAppRecommendedGamesCount)
local FFlagEnableTopSongsSort = require(script.Parent.SharedFlags).FFlagEnableTopSongsSort
local FFlagLuaAppUnifyPlayButtonMobileEdp = require(script.Parent.SharedFlags).FFlagLuaAppUnifyPlayButtonMobileEdp
local GetFFlagUIBloxUseFoundationButton = require(script.Parent.SharedFlags).UIBlox.GetFFlagUIBloxUseFoundationButton
local FFlagSearchOmniAutocompletePage = require(script.Parent.SharedFlags).FFlagSearchOmniAutocompletePage
local scriptParent = script.Parent

return {
	OmniFeedPropsKey = require(scriptParent.AppCommonLib).Symbol.named("OmniFeedProps"),
	Constants = {
		SORT_INDEX_SELECTION_ORDER_MULTIPLIER = 100,
		SORT_SELECTION_ORDER_BASE = -1000,
		DEFAULT_GAME_FETCH_COUNT = 40,
		GAME_CAROUSEL_CHILD_PADDING = 12,
		GAME_CAROUSEL_PADDING = 15,
		GAME_CAROUSEL_SIDE_COMPACT_PADDING = 24,
		GAME_CAROUSEL_SIDE_WIDE_PADDING = 48,
		GAME_GRID_CHILD_PADDING = 12,
		GAME_GRID_PADDING = 15,
		GAME_GRID_TILE_FOOTER_HEIGHT = 70,
		GAME_DETAILS_ACTION_BAR_HEIGHT = not FFlagLuaAppUnifyPlayButtonMobileEdp and not GetFFlagUIBloxUseFoundationButton() and 48 or 50,
		MAX_RECOMMENDED_GAMES_FETCH_COUNT = GetFIntLuaAppRecommendedGamesCount()
	},
	DataSourceType = {
		DiscoveryApi = "DiscoveryApi",
		ExploreApi = "ExploreApi",
		GamesApi = "GamesApi",
		Local = "Local",
		SearchApi = "SearchApi",
		Unknown = "Unknown",
		OmniAutocompleteApi = if not FFlagSearchOmniAutocompletePage then nil else "OmniAutocompleteApi"
	},
	ExperienceDetailsNoticeType = {
		InExperiencePurchase = "InExperiencePurchase"
	},
	ExploreContentType = require(script.ExploreContentType),
	GameBasicStatsLayoutType = require(script.GameBasicStatsLayoutType),
	GameCardLayoutType = require(script.GameCardLayoutType),
	EnumGameDetailErrorTypes = require(script.EnumGameDetailErrorTypes),
	EnumIgrsRating = EnumIgrsRating,
	GameMediaImageType = require(script.GameMediaImageType),
	GameSortGroups = require(script.GameSortGroups),
	GameTopicIds = require(script.GameTopicIds),
	OmniRecommendationsContentType = require(script.OmniRecommendationsContentType),
	OmniFeedTypes = require(script.OmniFeedTypes),
	OmniFeedConstants = require(script.OmniFeedConstants),
	PlayabilityStatusEnum = PlayabilityStatusEnum,
	PlayableUxTreatmentEnum = PlayableUxTreatmentEnum,
	SearchSourceEvent = require(script.SearchSourceEvent),
	SearchTextTopicIds = require(script.SearchTextTopicIds),
	SearchLandingPageSurface = SearchLandingPageSurface,
	SortContentType = if not FFlagEnableTopSongsSort then nil else require(script.SortContentType),
	GameCollectionItemTypes = GameCollectionItemTypes,
	["jest.config"] = script["jest.config"]
}
