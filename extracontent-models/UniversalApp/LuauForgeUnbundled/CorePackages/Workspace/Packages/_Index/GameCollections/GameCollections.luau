local gameCollectionItemTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/DiscoveryTypes").GameCollectionItemTypes

local module = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/isSeeAllTileEnabled")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useCountdownSubtitleTextBinding")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useGetGameTileHeight")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useRenderGameCollectionItem")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/GameCollectionLayoutCalculators")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useGameCollectionLayoutParams")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useNavigateToSortLinkWebView")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useGameSortHeaderButtonParams")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/PlaceholderGameGrid")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/GameCollectionNavigationBindings")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useGameSortAnalytics")
local module12 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/Impressions/GameSortImpressionsDetector")
local module13 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/Impressions/SendGameImpressions")
local module14 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/Impressions/useGameSortImpressionsParams")
local module15 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useGameSortData")
local module16 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useIsHoldToPlayEnabledForGames")
local module17 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/useGameSortTooltipParams")
local module18 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/Impressions/WaitForPropWrapper")
local module19 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/SeeAllTile")
local module20 = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/GameCollectionItemBuilder")

return {
	GameCollectionGrid = require("@game/CorePackages/Workspace/Packages/_Index/GameCollections/GameCollections/GameCollectionGrid"),
	isSeeAllTileEnabled = module,
	useCountdownSubtitleTextBinding = module2,
	useGameCollectionLayoutParams = module6,
	useGameSortAnalytics = module11,
	useGameSortData = module15,
	useGameSortHeaderButtonParams = module8,
	useGameSortImpressionsParams = module14,
	useGameSortTooltipParams = module17,
	useGetGameTileHeight = module3,
	useIsHoldToPlayEnabledForGames = module16,
	useNavigateToSortLinkWebView = module7,
	useRenderGameCollectionItem = module4,
	GameCollectionLayoutCalculators = module5,
	GameCollectionNavigationBindings = module10,
	GameSortImpressionsDetector = module12,
	PlaceholderGameGrid = module9,
	SendGameImpressions = module13,
	WaitForPropWrapper = module18,
	SeeAllTile = module19,
	GameCollectionItemBuilder = module20,
	GameCollectionItemTypes = gameCollectionItemTypes
}
