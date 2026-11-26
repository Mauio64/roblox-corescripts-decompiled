local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local module = require("@luauforge/bundled/dzP")
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch

local module2 = require("@luauforge/bundled/dPU")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")

local SetCollectibleResellableInstances = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Actions/SetCollectibleResellableInstances")

local module5 = require("@luauforge/bundled/dQO")
local module6 = require("@luauforge/bundled/dVN")

local function keyMapper(p2)
	return module2.GetResellersKey .. tostring(p2)
end

return function(p2, p3, p4, p5)
	module.isType(p3, "string", "FetchCollectibResellersInstances thunk expects collectibleItemId")
	return performFetch.Single(module2.GetResellersKey .. tostring(p3), function(object)
		return GetExperienceSourceLanguage.GetCollectibleResellers(p2, p3, p4, p5):andThen(function(p6)
			local data = p6 and p6.responseBody and p6.responseBody.data

			if not data then
				return Promise.reject()
			end

			local nextPageCursor = p6.responseBody.nextPageCursor

			if nextPageCursor and nextPageCursor == "" then
				nextPageCursor = nil
			end

			object:dispatch(module6(nextPageCursor))

			if p4 then
				object:dispatch(module5(p3, data))
			else
				object:dispatch(SetCollectibleResellableInstances(p3, data))
			end

			return Promise.resolve()
		end)
	end)
end
