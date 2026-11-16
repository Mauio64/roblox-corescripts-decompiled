local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dwM")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module2 = require("@luauforge/bundled/dME")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")

local module4 = require("@luauforge/bundled/dMR")
local module5 = require("@luauforge/bundled/dMS")

local module6 = require("@luauforge/bundled/dSo")
local module7 = require("@luauforge/bundled/dMQ")
local module8 = require("@luauforge/bundled/dSs")

local module9 = require("@luauforge/bundled/ecW")

local function keyMapper(p2)
	return module2.GetResellersKey .. tostring(p2)
end

return function(p2, p3, p4, p5, p6)
	module.isType(p3, "string", "GetResellers thunk expects assetId to be a string")
	return performFetch.Single(module2.GetResellersKey .. tostring(p3), function(object)
		return GetExperienceSourceLanguage.FetchAssetResellers(p2, p3, p4, p5):andThen(function(p7)
			local data = p7 and p7.responseBody and p7.responseBody.data

			if not data then
				object:dispatch(module9())
				return Promise.reject()
			end

			if not (#data > 0) then
				return Promise.resolve()
			end

			object:dispatch(module8(p7.responseBody.nextPageCursor))
			local userAssetIds = {}

			for k, v5 in data do
				table.insert(userAssetIds, (tostring(v5.userAssetId)))
			end

			object:dispatch(module6(data))

			if p4 then
				object:dispatch(module7(p3, userAssetIds))
			else
				object:dispatch(module4(p3, userAssetIds))
			end

			if p6 then
				object:dispatch(module5(p3, data[1].price))
			end

			return Promise.resolve()
		end)
	end)
end
