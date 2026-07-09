local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent
local HardBreakElement = require(InlineRichTextParent.InlineLayout).Components.InlineLayoutElements.HardBreakElement

require(InlineRichText.Types)

return function(_, _) -- line: 9
	-- upvalues: HardBreakElement (copy)
	return { HardBreakElement }
end
