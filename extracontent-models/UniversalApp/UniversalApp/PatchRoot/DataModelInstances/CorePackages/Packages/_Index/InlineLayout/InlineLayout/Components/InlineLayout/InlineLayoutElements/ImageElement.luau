local ParentParent = script:FindFirstAncestor("Components").Parent.Parent
local InlineLayoutElements = script:FindFirstAncestor("InlineLayoutElements")
local Foundation = require(ParentParent.Foundation)
local Dash = require(ParentParent.Dash)
local RenderableInlineElement = require(InlineLayoutElements.RenderableInlineElement)
local FoundationImage = Foundation.Image
local t1 = {}

local function mapProps(p1) -- line: 13
	-- upvalues: Dash (copy)
	return Dash.omit(p1, { "id" })
end

function t1.new(t2: {[any]: any}) -- line: 17
	-- upvalues: RenderableInlineElement (copy), FoundationImage (copy), mapProps (copy)
	return RenderableInlineElement.new(FoundationImage, t2, mapProps)
end

return t1
