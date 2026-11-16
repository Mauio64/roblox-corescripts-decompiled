local CorePackages = game:GetService("CorePackages")

local logging = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Logging
local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dwM")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local module3 = require("@luauforge/bundled/dSQ")

return function(p2)
	module.isType(p2, "function", "GetCatalogMetadata thunk expects networkImpl to be a function")

	return performFetch.Single("catalog.getcatalogmetadata", function(object)
		return GetExperienceSourceLanguage.GetCatalogMetadata(p2):andThen(function(p3)
			local responseBody = p3.responseBody

			if responseBody then
				object:dispatch(module3(responseBody))
			end

			return responseBody
		end, function(p3)
			logging.warn("WebApi failure in GetCatalogMetadata")

			object:dispatch(module3({}))

			Promise.reject(p3)
		end)
	end)
end
