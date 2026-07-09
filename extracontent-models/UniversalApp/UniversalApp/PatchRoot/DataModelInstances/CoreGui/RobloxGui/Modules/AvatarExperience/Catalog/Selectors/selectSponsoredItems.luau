local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local memoize = require(CorePackages.Workspace.Packages.AppCommonLib).memoize
local Dash = require(CorePackages.Packages.Dash)

require(Modules.AvatarExperience.Common.Types)

local SponsoredItemsCategoryRecommended = CatalogConstants.SponsoredItemsCategoryRecommended
local v8 = memoize(function(p1, p2) -- line: 26
	-- upvalues: Dash (copy)
	return Dash.map(p1, function(p3) -- line: 27
		-- upvalues: p2 (copy), Dash (copy)
		local v16 = p2[p3.id]

		if v16 and v16.product then
			return (Dash.join(p3, {
				productId = v16.product.id
			}))
		end

		return p3
	end)
end)

local function selectSponsoredItems(p4) -- line: 37
	-- upvalues: SponsoredItemsCategoryRecommended (copy), v8 (copy)
	local v13 = p4.AvatarExperience.Catalog.SponsoredItems[SponsoredItemsCategoryRecommended]
	local AssetInfos = p4.AvatarExperience.Common.AssetInfos

	if v13 then
		return (v8(v13, AssetInfos))
	end

	return nil
end

return selectSponsoredItems
