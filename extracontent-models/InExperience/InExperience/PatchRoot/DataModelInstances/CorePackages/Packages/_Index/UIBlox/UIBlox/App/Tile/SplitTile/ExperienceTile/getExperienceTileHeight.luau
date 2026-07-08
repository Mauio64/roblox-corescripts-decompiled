local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent

require(ParentParent.Style.StyleTypes)
require(scriptParent.Constants)
require(scriptParent.Enum.AspectRatioMode)

local getExperienceTileRelativeHeight = require(scriptParent.getExperienceTileRelativeHeight)

return function(p1, n1: number, p2, n2: number?, n3: number?, p3) -- line: 18
	-- upvalues: getExperienceTileRelativeHeight (copy)
	local v10 = getExperienceTileRelativeHeight(p1, p2, n2, n3, p3)

	return (math.floor(n1 * v10.Scale + v10.Offset))
end
