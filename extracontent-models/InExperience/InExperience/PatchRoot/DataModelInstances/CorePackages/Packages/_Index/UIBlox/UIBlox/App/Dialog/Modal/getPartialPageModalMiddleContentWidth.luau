local scriptParent = script.Parent
local getModalWindowWidth = require(scriptParent.getModalWindowWidth)

local function getPartialPageModalMiddleContentWidth(n1: number, n2: number?) -- line: 9
	-- upvalues: getModalWindowWidth (copy)
	return getModalWindowWidth(n1) - 2 * (n2 or 24)
end

return getPartialPageModalMiddleContentWidth
