local parent = script:FindFirstAncestor("DiscoveryTypes").Parent
local SharedFlags = require(parent.SharedFlags)
return {
	Game = "Game",
	CatalogAsset = "CatalogAsset",
	CatalogBundle = "CatalogBundle",
	RecommendedFriend = "RecommendedFriend",
	GameCoPlay = "GameCoPlay",
	TrendingSearches = "TrendingSearches",
	Song = "Song",
	AdLink = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile and "AdLink" or nil
}
