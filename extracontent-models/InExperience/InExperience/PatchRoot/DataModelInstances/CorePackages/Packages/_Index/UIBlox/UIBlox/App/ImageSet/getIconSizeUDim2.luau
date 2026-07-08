local scriptParent = script.Parent
local IconSize = require(scriptParent.Enum.IconSize)
local getIconSize = require(scriptParent.getIconSize)

return function(p1) -- line: 6
	-- upvalues: IconSize (copy), getIconSize (copy)
	assert(IconSize.isEnumValue(p1))

	local v5 = getIconSize(p1)

	return UDim2.fromOffset(v5, v5)
end
