local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local FetchCatalogSearchWithSponsoredItems = require(Modules.AvatarExperience.Catalog.Thunks.FetchCatalogSearchWithSponsoredItems)
local Logging = require(CorePackages.Workspace.Packages.AppCommonLib).Logging

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local Promise = require(CorePackages.Packages.Promise)

require(Modules.AvatarExperience.Catalog.SearchTypes)

local function fetchCatalogSearchWithSponsoredItems(p1, p2, s1: string, p3, s2: string?) -- line: 26
	-- upvalues: Promise (copy), FetchCatalogSearchWithSponsoredItems (copy), Logging (copy)
	return Promise.new(function(resolve, reject) -- line: 33
		-- upvalues: s1 (copy), p3 (copy), s2 (copy), p1 (copy), FetchCatalogSearchWithSponsoredItems (copy), p2 (copy), Logging (copy)
		local t1 = {
			recordSearchTime = true,
			searchUuid = s1,
			categoryInfo = p3
		}

		if s2 then
			t1.searchKeyword = s2
		end

		local v15 = p1(FetchCatalogSearchWithSponsoredItems(p2, t1))

		if v15 and v15.andThen then
			v15:andThen(function(p4) -- line: 45
				-- upvalues: resolve (copy)
				resolve(p4)
			end, function(p5) -- line: 47
				-- upvalues: Logging (copy), reject (copy)
				Logging.warn("fetchCatalogSearchWithSponsoredItems: Catalog search with sponsored items fetch failed: " .. tostring(p5))
				reject(p5)
			end)

			return
		end

		resolve(true)
	end)
end

return fetchCatalogSearchWithSponsoredItems
