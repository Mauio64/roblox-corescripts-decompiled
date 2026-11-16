local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent
local SetEquippedAssets = require(parent.Actions.SetEquippedAssets)

return Rodux.createReducer({}, {
	[SetEquippedAssets.name] = function(_, p)
		local assetIdSet = {}

		for _, equippedAsset in ipairs(p.equippedAssets) do
			assetIdSet[tostring(equippedAsset.assetId)] = true
		end

		return assetIdSet
	end
})
