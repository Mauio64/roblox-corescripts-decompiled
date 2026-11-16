local parent = script:FindFirstAncestor("Components").Parent
local parent2 = parent.Parent

local React = require(parent2.React)

local Dash = require(parent2.Dash)

local InlineElementType = require(parent.Utils.InlineElementType)

local join = Dash.join

local RenderableInlineElement = {}
RenderableInlineElement.__index = RenderableInlineElement
RenderableInlineElement.__type = InlineElementType

function RenderableInlineElement.new(element, props, p)
	local self = setmetatable({}, RenderableInlineElement)
	self.props = props
	self.mapProps = p or Dash.identity
	self.Element = element
	return self
end

function RenderableInlineElement.getWidth(p)
	return p.props.Size.Width.Offset
end

function RenderableInlineElement.split(p)
	return RenderableInlineElement.new(p.Element, join(p.props))
end

function RenderableInlineElement.render(props, id: string, layoutOrder: number)
	return React.createElement(
		props.Element,
		props.mapProps(Dash.assign(props.props, {
			id = id,
			key = tostring(layoutOrder),
			LayoutOrder = layoutOrder
		}))
	)
end

return RenderableInlineElement
