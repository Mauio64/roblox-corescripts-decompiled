local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local parent = script.Parent.Parent

local ScreenSizeUpdated = require(parent.Actions.ScreenSizeUpdated)

return (Rodux.createReducer(Vector2.new(0, 0), {
	[ScreenSizeUpdated.name] = function(_, p)
		return p.screenSize
	end
}))
