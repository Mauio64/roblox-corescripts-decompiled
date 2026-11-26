local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/Cryo")
local InlineLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/InlineLayout")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/Foundation")

local renderableInlineElement = InlineLayout.Components.InlineLayoutElements.RenderableInlineElement
local icon = Foundation.Icon

local function mapProps(p2)
	return Cryo.Dictionary.omit(p2, "id", "Size")
end

return {
	new = function(p2)
		return renderableInlineElement.new(
			icon,
			Cryo.Dictionary.join(p2, {
				Size = UDim2.fromOffset(p2.size, p2.size)
			}),
			mapProps
		)
	end
}
