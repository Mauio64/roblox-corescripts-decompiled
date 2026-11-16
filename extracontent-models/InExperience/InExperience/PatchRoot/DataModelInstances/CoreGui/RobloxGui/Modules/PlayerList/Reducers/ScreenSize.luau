local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local Actions = script.Parent.Parent.Actions
local SetScreenSize = require(Actions.SetScreenSize)

return (Rodux.createReducer({ X = 1000, Y = 1000 }, {
	[SetScreenSize.name] = function(_, p)
		return { X = p.sizeX, Y = p.sizeY }
	end
}))
