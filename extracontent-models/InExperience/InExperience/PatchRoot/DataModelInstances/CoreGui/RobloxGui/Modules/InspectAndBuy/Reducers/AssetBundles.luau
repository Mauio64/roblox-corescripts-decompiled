local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent
local SetAssetToBundlesMapping = require(parent.Actions.SetAssetToBundlesMapping)

return Rodux.createReducer({}, {
	[SetAssetToBundlesMapping.name] = function(p, p2)
		local assetId = tostring(p2.assetId)
		local bundleIds = p2.bundleIds

		return Cryo.Dictionary.join(p, { [assetId] = bundleIds })
	end
})
