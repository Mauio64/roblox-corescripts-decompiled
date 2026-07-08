local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local SetAssetToBundlesMapping = require(ParentParent.Actions.SetAssetToBundlesMapping)

return Rodux.createReducer({}, {
	[SetAssetToBundlesMapping.name] = function(p1, p2) -- line: 19
		-- upvalues: Cryo (copy)
		local str = tostring(p2.assetId)
		local bundleIds = p2.bundleIds

		return Cryo.Dictionary.join(p1, {
			[str] = bundleIds
		})
	end
})
