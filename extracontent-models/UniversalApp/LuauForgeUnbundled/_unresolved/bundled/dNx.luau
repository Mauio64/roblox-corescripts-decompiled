local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local SetCollectibleResellableInstances = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Actions/SetCollectibleResellableInstances")

local module2 = require("@luauforge/bundled/dNy")
local CollectibleInstance = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Models/CollectibleInstance")

return Rodux.createReducer({}, {
	[SetCollectibleResellableInstances.name] = function(p2, p3)
		local collectibleItemId = p3.collectibleItemId

		local v6 = {}
		local collectibleInstanceIds = {}

		for k, collectibleItemInstance in p3.collectibleItemInstances do
			local v7 = CollectibleInstance.fromGetCollectibleResellers(collectibleItemInstance, collectibleItemId)
			v6[v7.collectibleInstanceId] = v7
			table.insert(collectibleInstanceIds, v7.collectibleInstanceId)
		end

		return Cryo.Dictionary.join(p2, {
			[collectibleItemId] = {
				Instances = v6,
				InstanceIdsList = collectibleInstanceIds
			}
		})
	end,
	[module2.name] = function(p2, p3)
		local collectibleItemId = p3.collectibleItemId

		local v6 = {}
		local collectibleInstanceIds = {}

		for k, collectibleItemInstance in p3.collectibleItemInstances do
			local v7 = CollectibleInstance.fromGetCollectibleResellers(collectibleItemInstance, collectibleItemId)
			v6[v7.collectibleInstanceId] = v7
			table.insert(collectibleInstanceIds, v7.collectibleInstanceId)
		end

		local v7 = p2[collectibleItemId]

		if not v7 then
			return Cryo.Dictionary.join(p2, {
				[collectibleItemId] = {
					Instances = v6,
					InstanceIdsList = collectibleInstanceIds
				}
			})
		end

		local joined = Cryo.Dictionary.join(v7.Instances, v6)

		local joined2 = Cryo.List.join(v7.InstanceIdsList, collectibleInstanceIds)

		return Cryo.Dictionary.join(p2, {
			[collectibleItemId] = { Instances = joined, InstanceIdsList = joined2 }
		})
	end
})
