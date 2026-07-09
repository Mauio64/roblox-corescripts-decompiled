local Parent = script:FindFirstAncestor("DiscoveryTypes").Parent
local FFlagLuaAppEnableHomepageOneByTwoTile = require(Parent.SharedFlags).FFlagLuaAppEnableHomepageOneByTwoTile

return {
	Game = "Game",
	CatalogAsset = "CatalogAsset",
	CatalogBundle = "CatalogBundle",
	RecommendedFriend = "RecommendedFriend",
	GameCoPlay = "GameCoPlay",
	TrendingSearches = "TrendingSearches",
	Song = "Song",
	AdLink = if not FFlagLuaAppEnableHomepageOneByTwoTile then nil else "AdLink"
}
