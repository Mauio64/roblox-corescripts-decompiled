local parent = script.Parent.Parent.Parent
local Foundation = require(parent.Foundation)
local getTextSizeOffset = Foundation.Utility.getTextSizeOffset

return function(_)
	local textSizeOffset = getTextSizeOffset()
	return textSizeOffset ~= nil, textSizeOffset
end
