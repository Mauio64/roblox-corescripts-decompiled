local module = require("@luauforge/bundled/dSQ")
local module2 = require("@luauforge/bundled/dSS")
local module3 = require("@luauforge/bundled/dSU")
local module4 = require("@luauforge/bundled/dVs")
local module5 = require("@luauforge/bundled/dVt")
local module6 = require("@luauforge/bundled/dVw")
local module7 = require("@luauforge/bundled/dVF")
local module8 = require("@luauforge/bundled/dVH")
local module9 = require("@luauforge/bundled/dVI")
local module10 = require("@luauforge/bundled/dVM")
local module11 = require("@luauforge/bundled/dVO")
local module12 = require("@luauforge/bundled/dWi")
local module13 = require("@luauforge/bundled/dWk")
local module14 = require("@luauforge/bundled/dWm")
local module15 = require("@luauforge/bundled/dWs")

local fFlagAXUseSignalsForAvatarsTabSearchInfo = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXUseSignalsForAvatarsTabSearchInfo

return function(options, p2)
	local v5 = options or {}
	local v6 = {
		AssetFavorites = module2(v5.AssetFavorites, p2),
		BundleFavorites = module(v5.BundleFavorites, p2),
		Categories = module3(v5.Categories, p2),
		SearchCategories = module4(v5.SearchCategories, p2),
		Topics = module7(v5.Topics, p2),
		TopicsFetchTimes = module8(v5.TopicsFetchTimes, p2),
		MarketplaceFee = module5(v5.MarketplaceFee, p2),
		Sell = module6(v5.Sell, p2),
		ResellerCursor = module10(v5.ResellerCursor, p2),
		UserAssets = module9(v5.UserAssets, p2),
		SortAndFilters = module11(v5.SortAndFilters, p2),
		SponsoredItems = module12(v5.SponsoredItems, p2),
		Metadata = module13(v5.Metadata, p2),
		ResultsList = module14(v5.ResultsList, p2),
		AvatarsTabSearchInfo = 0
	}

	local v7 = if not fFlagAXUseSignalsForAvatarsTabSearchInfo then module15(v5.AvatarsTabSearchInfo, p2) else nil
	v6.AvatarsTabSearchInfo = v7
	return v6
end
