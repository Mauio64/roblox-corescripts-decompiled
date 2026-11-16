local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dwM")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module2 = require("@luauforge/bundled/dME")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")

local module4 = require("@luauforge/bundled/dSd")

local module5 = require("@luauforge/bundled/dSh")

local module6 = require("@luauforge/bundled/dSo")

local function keyMapper(p2)
	return module2.GetSellPageDataKey .. tostring(p2)
end

return function(p2, p3, p4)
	module.isType(p3, "string", "FetchSellPageData thunk expects itemId to be a string")
	module.isType(p4, "string", "FetchSellPageData thunk expects userId to be a string")
	return performFetch.Single(module2.GetSellPageDataKey .. tostring(p3), function(object)
		return GetExperienceSourceLanguage.FetchSellPageData(p2, p3, p4):andThen(function(p5)
			local data = p5 and p5.responseBody and p5.responseBody.data

			if not data then
				return Promise.reject()
			end

			local userAssetIds = {}
			local userAssetIds2 = {}

			for k, v5 in data do
				local userAssetId = tostring(v5.userAssetId)

				if v5.price then
					table.insert(userAssetIds, userAssetId)
				else
					table.insert(userAssetIds2, userAssetId)
				end
			end

			object:dispatch(module6(data))
			object:dispatch(module4(p3, userAssetIds2))
			object:dispatch(module5(p3, userAssetIds))
			return Promise.resolve()
		end)
	end)
end
