local Parent = script:FindFirstAncestor("InlineRichText").Parent
local Cryo = require(Parent.Cryo)
local InlineLayout = require(Parent.InlineLayout)
local Foundation = require(Parent.Foundation)
local RenderableInlineElement = InlineLayout.Components.InlineLayoutElements.RenderableInlineElement
local Icon = Foundation.Icon
local t1 = {}

local function mapProps(p1) -- line: 13
	-- upvalues: Cryo (copy)
	return Cryo.Dictionary.omit(p1, "id", "Size")
end

function t1.new(t2: {[any]: any}) -- line: 25
	-- upvalues: RenderableInlineElement (copy), Icon (copy), Cryo (copy), mapProps (copy)
	return RenderableInlineElement.new(Icon, Cryo.Dictionary.join(t2, {
		Size = UDim2.fromOffset(t2.size, t2.size)
	}), mapProps)
end

return t1
