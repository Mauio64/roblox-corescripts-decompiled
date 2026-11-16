local parent = script.Parent
local getModalWindowWidth = require(parent.getModalWindowWidth)

local function getPartialPageModalMiddleContentWidth(p: number, value: number?)
	return getModalWindowWidth(p) - 2 * (value or 24)
end

return getPartialPageModalMiddleContentWidth
