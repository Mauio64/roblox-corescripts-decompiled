local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local SetEquippedAssets = require(ParentParent.Actions.SetEquippedAssets)

return Rodux.createReducer({}, {
	[SetEquippedAssets.name] = function(_, p2) -- line: 11
		local t1 = {}

		for _, v in ipairs(p2.equippedAssets) do
			t1[tostring(v.assetId)] = true
		end

		return t1
	end
})
