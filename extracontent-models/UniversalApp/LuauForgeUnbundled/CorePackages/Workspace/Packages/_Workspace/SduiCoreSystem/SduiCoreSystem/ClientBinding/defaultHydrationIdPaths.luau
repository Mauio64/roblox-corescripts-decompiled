local SduiDataBindingContentType = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiDataBindingContentType")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags")
local fFlagSduiMarketplaceCatalogCategorySupport = SharedFlags.FFlagSduiMarketplaceCatalogCategorySupport
local fFlagSduiMarketplaceCatalogSortSupport = SharedFlags.FFlagSduiMarketplaceCatalogSortSupport
local fFlagSduiDevStoreSeeAllSupport = SharedFlags.FFlagSduiDevStoreSeeAllSupport
local fFlagSduiAddCollectibleItemDataHydration = SharedFlags.FFlagSduiAddCollectibleItemDataHydration
local fFlagSduiLeaderboardComponent = SharedFlags.FFlagSduiLeaderboardComponent
local fFlagSduiBuyRobuxHydration = SharedFlags.FFlagSduiBuyRobuxHydration

return {
	[SduiDataBindingContentType.badge] = { "badge_id" },
	[SduiDataBindingContentType.creator] = { "creator_key" },
	[SduiDataBindingContentType.universe] = { "universe_id" },
	[SduiDataBindingContentType.ageRecommendation] = { "universe_id" },
	[SduiDataBindingContentType.socialLink] = { "social_link_id" },
	[SduiDataBindingContentType.marketplaceCatalogCategory] = fFlagSduiMarketplaceCatalogCategorySupport and { "marketplace_catalog_category_item_id" } or nil,
	[SduiDataBindingContentType.song] = { "song_id" },
	[SduiDataBindingContentType.marketplaceCatalogSort] = fFlagSduiMarketplaceCatalogSortSupport and { "catalog_sort_id" } or nil,
	[SduiDataBindingContentType.gamePass] = { "game_pass_id" },
	[SduiDataBindingContentType.gameDeveloperProduct] = fFlagSduiDevStoreSeeAllSupport and { "developer_product_id" } or nil,
	[SduiDataBindingContentType.gameSubscription] = fFlagSduiDevStoreSeeAllSupport and { "subscription_id" } or nil,
	[SduiDataBindingContentType.playability] = { "universe_id" },
	[SduiDataBindingContentType.universeUserVoteFeedbackMetadata] = { "root_place_id" },
	[SduiDataBindingContentType.userProfile] = { "user_id" },
	[SduiDataBindingContentType.collectibleItem] = fFlagSduiAddCollectibleItemDataHydration and { "collectible_item_id" } or nil,
	[SduiDataBindingContentType.leaderboardStats] = fFlagSduiLeaderboardComponent and { "stats_id" } or nil,
	[SduiDataBindingContentType.buyRobuxOneTimeProduct] = fFlagSduiBuyRobuxHydration and { "product_id" } or nil,
	[SduiDataBindingContentType.buyRobuxSubscriptionProduct] = fFlagSduiBuyRobuxHydration and { "product_id" } or nil,
	[SduiDataBindingContentType.buyRobuxPendingTransfer] = fFlagSduiBuyRobuxHydration and { "transfer_request_id" } or nil,
	[SduiDataBindingContentType.buyRobuxBonusItem] = fFlagSduiBuyRobuxHydration and { "bonus_id" } or nil
}
