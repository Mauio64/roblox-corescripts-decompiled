local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dwM")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module2 = require("@luauforge/bundled/dME")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")

local module4 = require("@luauforge/bundled/dNr")

local function keyMapper(p2)
	return module2.FetchCollectibleResellableInstancesKey .. tostring(p2)
end

return function(p2, p3, p4)
	module.isType(p3, "string", "FetchCollectibleResellableInstances thunk expects collectibleItemId")
	module.isType(p4, "string", "FetchCollectibleResellableInstances thunk expects userId")
	return performFetch.Single(
		module2.FetchCollectibleResellableInstancesKey .. tostring(p3),
		function(object)
			return GetExperienceSourceLanguage.FetchCollectibleResellableInstances(p2, p3, p4):andThen(function(p5)
				local itemInstances = p5 and p5.responseBody and p5.responseBody.itemInstances

				if not itemInstances then
					return Promise.reject()
				end

				object:dispatch(module4(p3, itemInstances))
				return Promise.resolve()
			end)
		end
	)
end
