local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local ApiFetchCatalogSearch = require(Modules.AvatarExperience.Catalog.Thunks.ApiFetchCatalogSearch)
local FetchSponsoredItems = require(Modules.AvatarExperience.Catalog.Thunks.FetchSponsoredItems)

require(Modules.AvatarExperience.Catalog.SearchTypes)
require(CorePackages.Packages.LuauPolyfill)

local OrganicTTIMilestoneManager = require(CorePackages.Workspace.Packages.AvatarExperienceTTIPerformance).OrganicTTIMilestoneManager

return function(p1: ((...any) -> ...any), p2) -- line: 26
	-- upvalues: OrganicTTIMilestoneManager (copy), FetchSponsoredItems (copy), CatalogConstants (copy), ApiFetchCatalogSearch (copy)
	return function(p3) -- line: 27
		-- upvalues: p2 (copy), OrganicTTIMilestoneManager (copy), FetchSponsoredItems (copy), p1 (copy), CatalogConstants (copy), ApiFetchCatalogSearch (copy)
		if (p2 and p2.categoryInfo or {}).ShowSponsored then
			OrganicTTIMilestoneManager.L3.sponsoredSearchStarted()

			local v11 = p3:dispatch(FetchSponsoredItems(p1, CatalogConstants.SponsoredItemsCategoryRecommended, CatalogConstants.SponsoredItemsToFetch))

			if v11 and v11.andThen then
				v11:andThen(function() -- line: 40
					-- upvalues: OrganicTTIMilestoneManager (copy)
					OrganicTTIMilestoneManager.L3.sponsoredSearchCompleted()
				end)
			end
		end

		return p3:dispatch(ApiFetchCatalogSearch(p2, p1))
	end
end
