local parent = script.Parent

local IconSize = require(parent.Enum.IconSize)
local getIconSize = require(parent.getIconSize)

return function(p)
	assert(IconSize.isEnumValue(p))
	local iconSize = getIconSize(p)
	return UDim2.fromOffset(iconSize, iconSize)
end
