local parent = script.Parent.Parent.Parent.Parent
local Cryo = require(parent.Cryo)
local Roact = require(parent.Roact)
local t = require(parent.t)

local getPageMargin = require(script.Parent.getPageMargin)

local extended = Roact.Component:extend("PageMargin")

extended.validateProps = t.interface({
	anchorPoint = t.optional(t.Vector2),
	position = t.optional(t.UDim2),
	backgroundColor3 = t.optional(t.Color3),
	backgroundTransparency = t.optional(t.number),
	layoutOrder = t.optional(t.number),
	size = t.optional(t.UDim2),
	useAutomaticSizing = t.optional(t.boolean),
	zIndex = t.optional(t.number)
})

extended.defaultProps = {
	anchorPoint = Vector2.new(0, 0),
	position = UDim2.new(),
	size = UDim2.fromScale(1, 1),
	backgroundTransparency = 0,
	layoutOrder = 0,
	useAutomaticSizing = false
}

function extended:init()
	self.state = {}
	self.ref = Roact.createRef()
	function self.onResize(p)
		if self.mounted then
			local x = p.AbsoluteSize.X
			self:setState(function(p2)
				local pageMargin = getPageMargin(x)

				if p2.margin == pageMargin then
					return nil
				end

				return { margin = pageMargin }
			end)
		end
	end
end

function extended.render(props)
	return Roact.createElement("Frame", {
		AnchorPoint = props.props.anchorPoint,
		AutomaticSize = props.props.useAutomaticSizing and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
		BackgroundColor3 = props.props.backgroundColor3,
		BackgroundTransparency = props.props.backgroundTransparency,
		BorderSizePixel = 0,
		Position = props.props.position,
		Size = props.props.size,
		[Roact.Change.AbsoluteSize] = props.onResize,
		[Roact.Ref] = props.ref,
		LayoutOrder = props.props.layoutOrder,
		ZIndex = props.props.zIndex
	}, Cryo.Dictionary.join(props.props[Roact.Children], {
		padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, props.state.margin),
			PaddingRight = UDim.new(0, props.state.margin)
		})
	}))
end

function extended:didMount()
	self.mounted = true

	if self.ref.current then
		self.onResize(self.ref.current)
	end
end

function extended:willUnmount()
	self.mounted = false
end

return extended
