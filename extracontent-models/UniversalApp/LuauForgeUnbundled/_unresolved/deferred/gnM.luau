local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module = require("@luauforge/bundled/dNv")
local module2 = require("@luauforge/bundled/dME")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")

local function keyMapper(p2)
	return module2.GetCollectibleMarketplaceResaleParametersKey .. tostring(p2)
end

return function(p2, p3, p4)
	return performFetch.Single(
		module2.GetCollectibleMarketplaceResaleParametersKey .. tostring(p3),
		function(object)
			return GetExperienceSourceLanguage.GetCollectibleMarketplaceResaleParameters(p2, p3):andThen(function(p5)
				local responseBody = p5 and p5.responseBody

				if not responseBody then
					return Promise.reject()
				end

				object:dispatch(module(p3, responseBody, p4))

				return Promise.resolve()
			end)
		end
	)
end
