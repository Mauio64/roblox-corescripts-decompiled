local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)

local module = require("@luauforge/bundled/dSa")
local module2 = require("@luauforge/bundled/dME")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local function keyMapper()
	return module2.GetMarketplaceFeeKey
end

return function(p2)
	return performFetch.Single(module2.GetMarketplaceFeeKey, function(object)
		return GetExperienceSourceLanguage.GetMarketplaceFee(p2):andThen(function(p3)
			local responseBody = p3 and p3.responseBody

			if not responseBody then
				return Promise.reject()
			end

			object:dispatch(module(responseBody))
			return Promise.resolve()
		end)
	end)
end
