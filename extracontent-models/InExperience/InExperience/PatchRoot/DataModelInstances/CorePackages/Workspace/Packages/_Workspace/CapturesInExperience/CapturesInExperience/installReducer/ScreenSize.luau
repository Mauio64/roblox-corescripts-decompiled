local parent = script.Parent.Parent
local parent2 = parent.Parent

local Rodux = require(parent2.Rodux)

local ScreenSizeChanged = require(parent.Actions.ScreenSizeChanged)

local vector2 = Vector2.new(0, 0)

return Rodux.createReducer(vector2, {
	[ScreenSizeChanged.name] = function(_: Vector2, p)
		return p.screenSize
	end
})
