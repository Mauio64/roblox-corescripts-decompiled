local Modules = game:GetService("CoreGui").RobloxGui.Modules
local BundleFavorites = require(Modules.AvatarExperience.Catalog.Reducers.BundleFavorites)
local AssetFavorites = require(Modules.AvatarExperience.Catalog.Reducers.AssetFavorites)
local Categories = require(Modules.AvatarExperience.Catalog.Reducers.Categories)
local SearchCategories = require(Modules.AvatarExperience.Catalog.Reducers.SearchCategories)
local MarketplaceFee = require(Modules.AvatarExperience.Catalog.Reducers.MarketplaceFee)
local Sell = require(Modules.AvatarExperience.Catalog.Reducers.Sell)
local Topics = require(Modules.AvatarExperience.Catalog.Reducers.Topics)
local TopicsFetchTimes = require(Modules.AvatarExperience.Catalog.Reducers.TopicsFetchTimes)
local UserAssets = require(Modules.AvatarExperience.Catalog.Reducers.UserAssets)
local ResellerCursor = require(Modules.AvatarExperience.Catalog.Reducers.ResellerCursor)
local SortAndFilters = require(Modules.AvatarExperience.Catalog.Reducers.SortAndFilters)
local SponsoredItems = require(Modules.AvatarExperience.Catalog.Reducers.SponsoredItems)
local Metadata = require(Modules.AvatarExperience.Catalog.Reducers.Metadata)
local ResultsList = require(Modules.AvatarExperience.Catalog.Reducers.ResultsList)
local AvatarsTabSearchInfo = require(Modules.AvatarExperience.Catalog.Reducers.AvatarsTabSearchInfo)

return function(p1, p2) -- line: 39
	-- upvalues: AssetFavorites (copy), BundleFavorites (copy), Categories (copy), SearchCategories (copy), Topics (copy), TopicsFetchTimes (copy), MarketplaceFee (copy), Sell (copy), ResellerCursor (copy), UserAssets (copy), SortAndFilters (copy), SponsoredItems (copy), Metadata (copy), ResultsList (copy), AvatarsTabSearchInfo (copy)
	local v19 = p1 or {}

	return {
		AssetFavorites = AssetFavorites(v19.AssetFavorites, p2),
		BundleFavorites = BundleFavorites(v19.BundleFavorites, p2),
		Categories = Categories(v19.Categories, p2),
		SearchCategories = SearchCategories(v19.SearchCategories, p2),
		Topics = Topics(v19.Topics, p2),
		TopicsFetchTimes = TopicsFetchTimes(v19.TopicsFetchTimes, p2),
		MarketplaceFee = MarketplaceFee(v19.MarketplaceFee, p2),
		Sell = Sell(v19.Sell, p2),
		ResellerCursor = ResellerCursor(v19.ResellerCursor, p2),
		UserAssets = UserAssets(v19.UserAssets, p2),
		SortAndFilters = SortAndFilters(v19.SortAndFilters, p2),
		SponsoredItems = SponsoredItems(v19.SponsoredItems, p2),
		Metadata = Metadata(v19.Metadata, p2),
		ResultsList = ResultsList(v19.ResultsList, p2),
		AvatarsTabSearchInfo = AvatarsTabSearchInfo(v19.AvatarsTabSearchInfo, p2)
	}
end
