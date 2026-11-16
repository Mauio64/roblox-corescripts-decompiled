local parent = script:FindFirstAncestor("Components").Parent.Parent
local InlineLayoutElements = script:FindFirstAncestor("InlineLayoutElements")

local Foundation = require(parent.Foundation)
local Dash = require(parent.Dash)

local RenderableInlineElement = require(InlineLayoutElements.RenderableInlineElement)
local Image = Foundation.Image

local function mapProps(p)
	return Dash.omit(p, { "id" })
end

return {
	new = function(p)
		return RenderableInlineElement.new(Image, p, mapProps)
	end
}
