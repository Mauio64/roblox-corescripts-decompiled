local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent
local InlineLayout = require(parent.InlineLayout)

local HardBreakElement = InlineLayout.Components.InlineLayoutElements.HardBreakElement

require(InlineRichText.Types)

return function(_, _)
	return { HardBreakElement }
end
