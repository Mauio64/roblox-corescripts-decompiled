local parent = script:FindFirstAncestor("Utils").Parent

local HardBreakElement = require(parent.Components.InlineLayout.InlineLayoutElements.HardBreakElement)
local InlineElementType = require(parent.Utils.InlineElementType)

local function isInlineElement(p): boolean
	if p == HardBreakElement then
		return true
	end

	if type(p) ~= "table" then
		return false
	end

	local metatable = getmetatable(p)
	return metatable ~= nil and metatable.__type == InlineElementType
end

return isInlineElement
