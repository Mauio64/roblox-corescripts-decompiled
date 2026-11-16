local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local Actions = script.Parent.Parent.Actions
local SetSettings = require(Actions.SetSettings)

return (Rodux.createReducer({ preferredTransparency = 1, reducedMotion = false }, {
	[SetSettings.name] = function(_, p)
		return { preferredTransparency = p.preferredTransparency, reducedMotion = p.reducedMotion }
	end
}))
