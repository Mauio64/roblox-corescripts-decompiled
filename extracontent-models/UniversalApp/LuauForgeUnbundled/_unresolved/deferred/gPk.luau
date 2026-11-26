local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dzP")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module2 = require("@luauforge/bundled/dPU")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")

local module4 = require("@luauforge/bundled/dQj")

local function keyMapper(p2)
	return module2.GetAssetResalesDataKey .. tostring(p2)
end

return function(p2, p3)
	return function(object)
		module.isType(p3, "string", "FetchAssetResaleData thunk expects assetId to be a string")

		local assetInfo = object:getState().AvatarExperience.Common.AssetInfos[p3]

		if assetInfo and assetInfo.receivedFromResaleData then
			return Promise.resolve("We already have the asset resale data")
		end

		return performFetch.Single(module2.GetAssetResalesDataKey .. tostring(p3), function(object2)
			return GetExperienceSourceLanguage.FetchAssetResaleData(p2, p3):andThen(function(p4)
				local responseBody = p4 and p4.responseBody

				if not responseBody then
					return Promise.reject()
				end

				object2:dispatch(module4(p3, responseBody))
				return Promise.resolve()
			end)
		end)(object)
	end
end
