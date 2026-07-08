local Parent = script:FindFirstAncestor("Utils").Parent
local HardBreakElement = require(Parent.Components.InlineLayout.InlineLayoutElements.HardBreakElement)
local InlineElementType = require(Parent.Utils.InlineElementType)

local function isInlineElement(p1) -- line: 6
	-- upvalues: HardBreakElement (copy), InlineElementType (copy)
	if p1 == HardBreakElement then
		return true
	end

	if type(p1) == "table" then
		local mt = getmetatable(p1)

		return mt ~= nil and mt.__type == InlineElementType
	end

	return false
end

return isInlineElement
