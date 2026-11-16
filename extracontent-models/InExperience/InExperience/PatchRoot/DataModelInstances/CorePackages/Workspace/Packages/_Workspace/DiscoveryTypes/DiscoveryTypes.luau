require(script.RoduxTypes)
local SearchLandingPageSurface = require(script.SearchLandingPageSurface)
local PlayabilityStatusEnum = require(script.PlayabilityStatusEnum)
local PlayableUxTreatmentEnum = require(script.PlayableUxTreatmentEnum)
require(script.EnumGameDetailErrorTypes)
local EnumIgrsRating = require(script.EnumIgrsRating)
local GameCollectionItemTypes = require(script.GameCollectionItemTypes)

local GetFIntLuaAppRecommendedGamesCount = require(script.Flags.GetFIntLuaAppRecommendedGamesCount)
local SharedFlags = require(script.Parent.SharedFlags)
local FFlagEnableTopSongsSort = SharedFlags.FFlagEnableTopSongsSort
local SharedFlags2 = require(script.Parent.SharedFlags)
local FFlagLuaAppUnifyPlayButtonMobileEdp = SharedFlags2.FFlagLuaAppUnifyPlayButtonMobileEdp
local SharedFlags3 = require(script.Parent.SharedFlags)
local GetFFlagUIBloxUseFoundationButton = SharedFlags3.UIBlox.GetFFlagUIBloxUseFoundationButton

local parent = script.Parent
local AppCommonLib = require(parent.AppCommonLib)
local DiscoveryTypes = {
	["OmniFeedPropsKey"] = AppCommonLib.Symbol.named("OmniFeedProps"),
	Constants = {
		SORT_INDEX_SELECTION_ORDER_MULTIPLIER = 100,
		SORT_SELECTION_ORDER_BASE = -1000,
		DEFAULT_GAME_FETCH_COUNT = 40,
		GAME_CAROUSEL_CHILD_PADDING = 12,
		GAME_CAROUSEL_PADDING = 15,
		GAME_CAROUSEL_SIDE_COMPACT_PADDING = 24,
		GAME_CAROUSEL_SIDE_WIDE_PADDING = 48,
		GAME_DETAILS_ACTION_BAR_HEIGHT = (FFlagLuaAppUnifyPlayButtonMobileEdp or GetFFlagUIBloxUseFoundationButton()) and 50 or 48,
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
	SearchLandingPageSurface = SearchLandingPageSurface
}
local sortContentType

if FFlagEnableTopSongsSort then
	sortContentType = require(script.SortContentType)
end

DiscoveryTypes.SortContentType = sortContentType
DiscoveryTypes.GameCollectionItemTypes = GameCollectionItemTypes
DiscoveryTypes["jest.config"] = script["jest.config"]
return DiscoveryTypes
