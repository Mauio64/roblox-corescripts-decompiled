local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dPU")

local module2 = require("@luauforge/bundled/gZR")
local module3 = require("@luauforge/bundled/gZW")

require("@luauforge/bundled/dXi")

require(CorePackages.Packages.LuauPolyfill)

local organicTTIMilestoneManager = require("@luauforge/bundled/gLF").OrganicTTIMilestoneManager

return function(p2, p3)
	return function(object)
		if (p3 and p3.categoryInfo or {}).ShowSponsored then
			organicTTIMilestoneManager.L3.sponsoredSearchStarted()

			local v5 = object:dispatch(module3(
				p2,
				module.SponsoredItemsCategoryRecommended,
				module.SponsoredItemsToFetch
			))

			if v5 and v5.andThen then
				v5:andThen(function()
					organicTTIMilestoneManager.L3.sponsoredSearchCompleted()
				end)
			end
		end

		return object:dispatch(module2(p3, p2))
	end
end
