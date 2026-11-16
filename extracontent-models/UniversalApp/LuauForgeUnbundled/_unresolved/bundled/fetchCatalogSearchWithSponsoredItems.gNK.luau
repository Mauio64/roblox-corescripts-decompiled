local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/gNL")
local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local Promise = require(CorePackages.Packages.Promise)
require("@luauforge/bundled/dTN")

local function fetchCatalogSearchWithSponsoredItems(callback, p2, p3, p4, searchKeyword)
	return Promise.new(function(callback2, callback3)
		local v5 = { searchUuid = p3, categoryInfo = p4, recordSearchTime = true }

		if searchKeyword then
			v5.searchKeyword = searchKeyword
		end

		local v6 = callback(module(p2, v5))

		if v6 and v6.andThen then
			v6:andThen(function(p5)
				callback2(p5)
			end, function(p5)
				logging.warn("fetchCatalogSearchWithSponsoredItems: Catalog search with sponsored items fetch failed: " .. tostring(p5))

				callback3(p5)
			end)
		else
			callback2(true)
		end
	end)
end

return fetchCatalogSearchWithSponsoredItems
