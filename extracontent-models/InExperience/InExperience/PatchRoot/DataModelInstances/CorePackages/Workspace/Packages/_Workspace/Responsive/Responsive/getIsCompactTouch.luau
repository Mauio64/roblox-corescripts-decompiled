local scriptParent = script.Parent
local StandardBreakpoints = require(scriptParent.CommonConfigs.StandardBreakpoints)
local InputMode = require(scriptParent.InputMode)

return function(vector2: Vector2, s1: string?) -- line: 5
	-- upvalues: StandardBreakpoints (copy), InputMode (copy)
	local maxWidth = StandardBreakpoints.sizes[StandardBreakpoints.Enum.Small].maxWidth
	local v7 = vector2.X < vector2.Y

	return maxWidth >= vector2.X and (v7 and s1 == InputMode.Enum.Touch)
end
