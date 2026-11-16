local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent

local SetAssets = require(parent.Actions.SetAssets)

return (Rodux.createReducer(false, {
	[SetAssets.name] = function(_, _): boolean
		return true
	end
}))
