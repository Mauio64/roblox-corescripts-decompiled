local parent = script.Parent
local StandardBreakpoints = require(parent.CommonConfigs.StandardBreakpoints)
local InputMode = require(parent.InputMode)

return function(vector2: Vector2, p: string?)
	local maxWidth = StandardBreakpoints.sizes[StandardBreakpoints.Enum.Small].maxWidth
	local v = vector2.X < vector2.Y
	return vector2.X <= maxWidth and v and p == InputMode.Enum.Touch
end
