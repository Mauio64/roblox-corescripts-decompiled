local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent

local Cryo = require(parent.Cryo)
local InlineLayout = require(parent.InlineLayout)
local TextElement = InlineLayout.Components.InlineLayoutElements.TextElement

require(InlineRichText.Types)

return function(p, p2)
	local v = p2.processChildren(p, p2)
	return Cryo.List.map(v, function(p3, layoutOrder)
		return TextElement.new({
			LayoutOrder = layoutOrder,
			EngineTags = p3.engineTags,
			Text = p3.text,
			fontStyle = p2.styles.fontStyle,
			textStyle = p2.styles.textStyle
		})
	end)
end
