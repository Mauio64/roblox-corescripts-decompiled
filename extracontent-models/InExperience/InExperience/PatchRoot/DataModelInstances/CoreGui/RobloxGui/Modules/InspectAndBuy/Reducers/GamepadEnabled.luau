local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local SetGamepadEnabled = require(ParentParent.Actions.SetGamepadEnabled)

return (Rodux.createReducer(false, {
	[SetGamepadEnabled.name] = function(_, p2) -- line: 8
		return p2.gamepadEnabled
	end
}))
