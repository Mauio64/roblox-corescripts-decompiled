local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/Rodux")

local ScreenSizeChanged = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesInExperience/CapturesInExperience/Actions/ScreenSizeChanged")

local vector2 = Vector2.new(0, 0)

return Rodux.createReducer(vector2, {
	[ScreenSizeChanged.name] = function(p2, p3)
		return p3.screenSize
	end
})
