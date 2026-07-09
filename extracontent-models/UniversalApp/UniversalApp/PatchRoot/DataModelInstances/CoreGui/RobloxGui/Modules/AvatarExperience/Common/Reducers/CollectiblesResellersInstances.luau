local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetCollectibleResellersInstances = require(Modules.AvatarExperience.Catalog.Actions.SetCollectibleResellersInstances)
local AppendCollectibleResellersInstances = require(Modules.AvatarExperience.Catalog.Actions.AppendCollectibleResellersInstances)
local CollectibleInstance = require(Modules.AvatarExperience.Common.Models.CollectibleInstance)

return Rodux.createReducer({}, {
	[SetCollectibleResellersInstances.name] = function(p1, p2) -- line: 25
		-- upvalues: CollectibleInstance (copy), Cryo (copy)
		local collectibleItemId = p2.collectibleItemId
		local t1 = {}
		local t2 = {}

		for _, v14 in p2.collectibleItemInstances do
			local v15 = CollectibleInstance.fromGetCollectibleResellers(v14, collectibleItemId)

			t1[v15.collectibleInstanceId] = v15
			table.insert(t2, v15.collectibleInstanceId)
		end

		return Cryo.Dictionary.join(p1, {
			[collectibleItemId] = {
				Instances = t1,
				InstanceIdsList = t2
			}
		})
	end,
	[AppendCollectibleResellersInstances.name] = function(p3, p4) -- line: 44
		-- upvalues: CollectibleInstance (copy), Cryo (copy)
		local collectibleItemId = p4.collectibleItemId
		local t3 = {}
		local t4 = {}

		for _, v22 in p4.collectibleItemInstances do
			local v23 = CollectibleInstance.fromGetCollectibleResellers(v22, collectibleItemId)

			t3[v23.collectibleInstanceId] = v23
			table.insert(t4, v23.collectibleInstanceId)
		end

		local v24 = p3[collectibleItemId]

		if v24 then
			local v25 = Cryo.Dictionary.join(v24.Instances, t3)
			local v26 = Cryo.List.join(v24.InstanceIdsList, t4)

			return Cryo.Dictionary.join(p3, {
				[collectibleItemId] = {
					Instances = v25,
					InstanceIdsList = v26
				}
			})
		end

		return Cryo.Dictionary.join(p3, {
			[collectibleItemId] = {
				Instances = t3,
				InstanceIdsList = t4
			}
		})
	end
})
