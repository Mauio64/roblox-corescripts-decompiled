local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent

local SetGamepadEnabled = require(parent.Actions.SetGamepadEnabled)

return (Rodux.createReducer(false, {
	[SetGamepadEnabled.name] = function(_, p)
		return p.gamepadEnabled
	end
}))
