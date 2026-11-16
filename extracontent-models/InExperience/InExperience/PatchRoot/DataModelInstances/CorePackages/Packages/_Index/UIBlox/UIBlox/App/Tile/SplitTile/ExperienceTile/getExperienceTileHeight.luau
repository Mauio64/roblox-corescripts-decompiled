local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent

require(parent2.Style.StyleTypes)
require(parent.Constants)
require(parent.Enum.AspectRatioMode)

local getExperienceTileRelativeHeight = require(parent.getExperienceTileRelativeHeight)

return function(p, p2: number, p3, p4: number?, p5: number?, p6)
	local experienceTileRelativeHeight = getExperienceTileRelativeHeight(p, p3, p4, p5, p6)

	return (math.floor(p2 * experienceTileRelativeHeight.Scale + experienceTileRelativeHeight.Offset))
end
