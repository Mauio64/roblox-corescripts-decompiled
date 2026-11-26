local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local module = require("@luauforge/bundled/dQH")

local module2 = require("@luauforge/bundled/dQI")
local CollectibleInstance = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Models/CollectibleInstance")

return Rodux.createReducer({}, {
	[module.name] = function(p2, p3)
		local collectibleItemId = p3.collectibleItemId

		local v6 = {}

		for k, collectibleItemInstance in p3.collectibleItemInstances do
			local v7 = CollectibleInstance.fromGetCollectibleItemInstances(collectibleItemInstance)
			v6[v7.collectibleInstanceId] = v7
		end

		return Cryo.Dictionary.join(p2, { [collectibleItemId] = v6 })
	end,
	[module2.name] = function(p2, data)
		local collectibleItemId = data.collectibleItemId
		local collectibleInstanceId = data.collectibleInstanceId
		local collectibleInstanceData = data.collectibleInstanceData

		local v6 = p2[collectibleItemId]

		if not v6 then
			return p2
		end

		local joined = Cryo.Dictionary.join(v6, {
			[collectibleInstanceId] = collectibleInstanceData
		})
		return Cryo.Dictionary.join(p2, { [collectibleItemId] = joined })
	end
})
