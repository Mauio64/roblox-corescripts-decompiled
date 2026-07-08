local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local ParentParent = script.Parent.Parent
local SetCollectibleResellableInstances = require(ParentParent.Actions.SetCollectibleResellableInstances)
local CollectibleInstance = require(ParentParent.Models.CollectibleInstance)

return Rodux.createReducer({}, {
	[SetCollectibleResellableInstances.name] = function(p1, p2) -- line: 13
		-- upvalues: CollectibleInstance (copy), Cryo (copy)
		local collectibleItemId = p2.collectibleItemId
		local t1 = {}

		for _, v12 in p2.collectibleItemInstances do
			local v13 = CollectibleInstance.fromGetCollectibleItemInstances(v12)

			t1[v13.collectibleInstanceId] = v13
		end

		return Cryo.Dictionary.join(p1, {
			[collectibleItemId] = t1
		})
	end
})
