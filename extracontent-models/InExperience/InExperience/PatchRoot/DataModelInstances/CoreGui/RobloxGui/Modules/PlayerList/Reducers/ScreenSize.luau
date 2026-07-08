local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Actions = script.Parent.Parent.Actions
local SetScreenSize = require(Actions.SetScreenSize)

return (Rodux.createReducer({
	X = 1000,
	Y = 1000
}, {
	[SetScreenSize.name] = function(_, p2) -- line: 12
		return {
			X = p2.sizeX,
			Y = p2.sizeY
		}
	end
}))
