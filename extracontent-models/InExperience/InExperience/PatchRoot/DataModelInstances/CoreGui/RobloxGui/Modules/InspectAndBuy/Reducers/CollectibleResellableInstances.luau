local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local parent = script.Parent.Parent
local SetCollectibleResellableInstances = require(parent.Actions.SetCollectibleResellableInstances)
local CollectibleInstance = require(parent.Models.CollectibleInstance)

return Rodux.createReducer({}, {
	[SetCollectibleResellableInstances.name] = function(p, p2)
		local collectibleItemId = p2.collectibleItemId

		local v = {}

		for _, collectibleItemInstance in p2.collectibleItemInstances do
			local v2 = CollectibleInstance.fromGetCollectibleItemInstances(collectibleItemInstance)
			v[v2.collectibleInstanceId] = v2
		end

		return Cryo.Dictionary.join(p, { [collectibleItemId] = v })
	end
})
