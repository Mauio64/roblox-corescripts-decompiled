local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local SetAssets = require(ParentParent.Actions.SetAssets)

return (Rodux.createReducer(false, {
	[SetAssets.name] = function(_, _) -- line: 8
		return true
	end
}))
