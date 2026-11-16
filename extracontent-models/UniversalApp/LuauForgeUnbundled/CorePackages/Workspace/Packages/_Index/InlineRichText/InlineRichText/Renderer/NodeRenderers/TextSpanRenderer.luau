local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/Cryo")
local textElement = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/InlineLayout").Components.InlineLayoutElements.TextElement

require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Types")

return function(p2, p3)
	local v5 = p3.processChildren(p2, p3)
	return Cryo.List.map(v5, function(p4, p5)
		return textElement.new({
			LayoutOrder = p5,
			EngineTags = p4.engineTags,
			Text = p4.text,
			fontStyle = p3.styles.fontStyle,
			textStyle = p3.styles.textStyle
		})
	end)
end
