local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dzP")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module2 = require("@luauforge/bundled/dPU")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")

local module4 = require("@luauforge/bundled/dQE")

local function keyMapper(p2)
	return module2.FetchCollectibleResaleDataKey .. tostring(p2)
end

return function(p2, p3)
	module.isType(p3, "string", "FetchCollectibleResaleData thunk expects collectibleItemId")
	return performFetch.Single(module2.FetchCollectibleResaleDataKey .. tostring(p3), function(object)
		return GetExperienceSourceLanguage.FetchCollectibleResaleData(p2, p3):andThen(function(p4)
			local responseBody = p4 and p4.responseBody

			if not responseBody then
				return Promise.reject()
			end

			object:dispatch(module4(p3, responseBody))
			return Promise.resolve()
		end)
	end)
end
