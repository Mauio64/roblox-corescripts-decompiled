local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local ScreenSizeUpdated = require(ParentParent.Actions.ScreenSizeUpdated)

return (Rodux.createReducer(Vector2.new(0, 0), {
	[ScreenSizeUpdated.name] = function(_, p2) -- line: 11
		return p2.screenSize
	end
}))
