local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local parent = SduiCoreSystem.Parent
local SduiDataBindingContentType = require(SduiCoreSystem.ClientBinding.SduiDataBindingContentType)

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiMarketplaceCatalogCategorySupport = SharedFlags.FFlagSduiMarketplaceCatalogCategorySupport
local FFlagSduiMarketplaceCatalogSortSupport = SharedFlags.FFlagSduiMarketplaceCatalogSortSupport
local FFlagSduiDevStoreSeeAllSupport = SharedFlags.FFlagSduiDevStoreSeeAllSupport
local FFlagSduiAddCollectibleItemDataHydration = SharedFlags.FFlagSduiAddCollectibleItemDataHydration
local FFlagSduiLeaderboardComponent = SharedFlags.FFlagSduiLeaderboardComponent
local FFlagSduiBuyRobuxHydration = SharedFlags.FFlagSduiBuyRobuxHydration

return {
	[SduiDataBindingContentType.badge] = { "badge_id" },
	[SduiDataBindingContentType.creator] = { "creator_key" },
	[SduiDataBindingContentType.universe] = { "universe_id" },
	[SduiDataBindingContentType.ageRecommendation] = { "universe_id" },
	[SduiDataBindingContentType.socialLink] = { "social_link_id" },
	[SduiDataBindingContentType.marketplaceCatalogCategory] = FFlagSduiMarketplaceCatalogCategorySupport and { "marketplace_catalog_category_item_id" } or nil,
	[SduiDataBindingContentType.song] = { "song_id" },
	[SduiDataBindingContentType.marketplaceCatalogSort] = FFlagSduiMarketplaceCatalogSortSupport and { "catalog_sort_id" } or nil,
	[SduiDataBindingContentType.gamePass] = { "game_pass_id" },
	[SduiDataBindingContentType.gameDeveloperProduct] = FFlagSduiDevStoreSeeAllSupport and { "developer_product_id" } or nil,
	[SduiDataBindingContentType.gameSubscription] = FFlagSduiDevStoreSeeAllSupport and { "subscription_id" } or nil,
	[SduiDataBindingContentType.playability] = { "universe_id" },
	[SduiDataBindingContentType.universeUserVoteFeedbackMetadata] = { "root_place_id" },
	[SduiDataBindingContentType.userProfile] = { "user_id" },
	[SduiDataBindingContentType.collectibleItem] = FFlagSduiAddCollectibleItemDataHydration and { "collectible_item_id" } or nil,
	[SduiDataBindingContentType.leaderboardStats] = FFlagSduiLeaderboardComponent and { "stats_id" } or nil,
	[SduiDataBindingContentType.buyRobuxOneTimeProduct] = FFlagSduiBuyRobuxHydration and { "product_id" } or nil,
	[SduiDataBindingContentType.buyRobuxSubscriptionProduct] = FFlagSduiBuyRobuxHydration and { "product_id" } or nil,
	[SduiDataBindingContentType.buyRobuxPendingTransfer] = FFlagSduiBuyRobuxHydration and { "transfer_request_id" } or nil,
	[SduiDataBindingContentType.buyRobuxBonusItem] = FFlagSduiBuyRobuxHydration and { "bonus_id" } or nil
}
