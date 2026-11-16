local CorePackages = game:GetService("CorePackages")

require("@luauforge/bundled/dHK")

local module = require("@luauforge/bundled/dME")
local memoize = require("@game/CorePackages/Workspace/Packages/AppCommonLib").memoize
local Dash = require(CorePackages.Packages.Dash)
require("@luauforge/bundled/dMc")

local sponsoredItemsCategoryRecommended = module.SponsoredItemsCategoryRecommended

local v5 = memoize(function(p2, p3)
	return Dash.map(p2, function(p4)
		local v6 = p3[p4.id]

		if v6 and v6.product then
			return (Dash.join(p4, { productId = v6.product.id }))
		end

		return p4
	end)
end)

local function selectSponsoredItems(p2)
	local sponsoredItem = p2.AvatarExperience.Catalog.SponsoredItems[sponsoredItemsCategoryRecommended]
	local assetInfos = p2.AvatarExperience.Common.AssetInfos

	if sponsoredItem then
		return (v5(sponsoredItem, assetInfos))
	end

	return nil
end

return selectSponsoredItems
