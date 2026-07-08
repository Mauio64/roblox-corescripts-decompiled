local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent
local Cryo = require(InlineRichTextParent.Cryo)
local TextElement = require(InlineRichTextParent.InlineLayout).Components.InlineLayoutElements.TextElement

require(InlineRichText.Types)

return function(p1, p2) -- line: 10
	-- upvalues: Cryo (copy), TextElement (copy)
	local v7 = p2.processChildren(p1, p2)

	return Cryo.List.map(v7, function(p3, p4) -- line: 12
		-- upvalues: TextElement (copy), p2 (copy)
		return TextElement.new({
			LayoutOrder = p4,
			EngineTags = p3.engineTags,
			Text = p3.text,
			fontStyle = p2.styles.fontStyle,
			textStyle = p2.styles.textStyle
		})
	end)
end
