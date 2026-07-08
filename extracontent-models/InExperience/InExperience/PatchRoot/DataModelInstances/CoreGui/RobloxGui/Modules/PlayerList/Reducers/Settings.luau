local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Actions = script.Parent.Parent.Actions
local SetSettings = require(Actions.SetSettings)

return (Rodux.createReducer({
	preferredTransparency = 1,
	reducedMotion = false
}, {
	[SetSettings.name] = function(_, p2) -- line: 12
		return {
			preferredTransparency = p2.preferredTransparency,
			reducedMotion = p2.reducedMotion
		}
	end
}))
