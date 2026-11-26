local CorePackages = game:GetService("CorePackages")

local Promise = require(CorePackages.Packages.Promise)
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local Dash = require(CorePackages.Packages.Dash)

local module = require("@luauforge/bundled/dPN")
local GetExperienceSourceLanguage = require("@game/CoreGui/RobloxGui/Modules/Feedback/Network/GetExperienceSourceLanguage")
local module3 = require("@luauforge/bundled/dVl")
local module4 = require("@luauforge/bundled/dQc")
local module5 = require("@luauforge/bundled/dQd")
local module6 = require("@luauforge/bundled/dWj")
local sendAXStat = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXStat
local module7 = require("@luauforge/bundled/dPN")

return function(p2, p3, p4)
	local sponsoredItemsKey = module3.GetSponsoredItemsKey(p3, p4)
	local lastTime = os.clock()
	return performFetch.Single(sponsoredItemsKey, function(object)
		return GetExperienceSourceLanguage.FetchSponsoredItems(p2, p3, p4):andThen(function(p5)
			local data = p5.responseBody.data or {}

			object:dispatch(module6(p3, data))

			local mapped = Dash.map(data, function(p6)
				return { id = p6.id, itemType = p6.itemType }
			end)

			return (GetExperienceSourceLanguage.FetchItemDetails(p2, mapped))
		end):andThen(function(p5)
			local responseBody = p5.responseBody
			responseBody.data = responseBody.data or {}

			local v5 = {}
			local v6 = {}

			for k, v7 in responseBody.data do
				if v7.itemType == module.ItemType.Asset then
					table.insert(v5, v7)
				elseif v7.itemType == module.ItemType.Bundle then
					table.insert(v6, v7)
				end
			end

			if #v5 > 0 then
				object:dispatch(module4(v5))
			end

			if #v6 > 0 then
				object:dispatch(module5(v6))
			end

			local v7 = (os.clock() - lastTime) * 1000
			sendAXStat({
				statName = module7.Counter.Latency.Network.FetchSponsoredItems,
				deltaMs = v7
			})

			return Promise.resolve()
		end)
	end)
end
