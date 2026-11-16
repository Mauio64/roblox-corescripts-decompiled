local parent = script:FindFirstAncestor("InlineRichText").Parent

local Cryo = require(parent.Cryo)
local InlineLayout = require(parent.InlineLayout)
local Foundation = require(parent.Foundation)

local RenderableInlineElement = InlineLayout.Components.InlineLayoutElements.RenderableInlineElement
local Icon = Foundation.Icon

local function mapProps(p)
	return Cryo.Dictionary.omit(p, "id", "Size")
end

return {
	new = function(p)
		return RenderableInlineElement.new(
			Icon,
			Cryo.Dictionary.join(p, {
				Size = UDim2.fromOffset(p.size, p.size)
			}),
			mapProps
		)
	end
}
