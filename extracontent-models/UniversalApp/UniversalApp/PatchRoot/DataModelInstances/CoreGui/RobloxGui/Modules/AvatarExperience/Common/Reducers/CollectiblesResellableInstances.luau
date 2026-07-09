local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SetCollectibleResellableInstances = require(Modules.AvatarExperience.Catalog.Actions.SetCollectibleResellableInstances)
local UpdateCollectibleResellableInstance = require(Modules.AvatarExperience.Catalog.Actions.UpdateCollectibleResellableInstance)
local CollectibleInstance = require(Modules.AvatarExperience.Common.Models.CollectibleInstance)

return Rodux.createReducer({}, {
	[SetCollectibleResellableInstances.name] = function(t1: {[any]: any}, p1) -- line: 24
		-- upvalues: CollectibleInstance (copy), Cryo (copy)
		local collectibleItemId = p1.collectibleItemId
		local t2 = {}

		for _, v13 in p1.collectibleItemInstances do
			local v14 = CollectibleInstance.fromGetCollectibleItemInstances(v13)

			t2[v14.collectibleInstanceId] = v14
		end

		return Cryo.Dictionary.join(t1, {
			[collectibleItemId] = t2
		})
	end,
	[UpdateCollectibleResellableInstance.name] = function(t3: {[any]: any}, p2) -- line: 36
		-- upvalues: Cryo (copy)
		local collectibleItemId = p2.collectibleItemId
		local collectibleInstanceId = p2.collectibleInstanceId
		local collectibleInstanceData = p2.collectibleInstanceData
		local v20 = t3[collectibleItemId]

		if not v20 then
			return t3
		end

		local v21 = Cryo.Dictionary.join(v20, {
			[collectibleInstanceId] = collectibleInstanceData
		})

		return Cryo.Dictionary.join(t3, {
			[collectibleItemId] = v21
		})
	end
})
