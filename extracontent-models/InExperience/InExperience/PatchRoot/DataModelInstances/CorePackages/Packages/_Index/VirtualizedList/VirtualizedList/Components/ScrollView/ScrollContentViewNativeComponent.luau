local parent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local React = require(parent.React)
local Change = React.Change

local extended = React.Component:extend("ScrollContentViewNativeComponent")

function extended:init(props)
	self.props = props
end

function extended.render(p)
	local v

	if Array.isArray(p.props.style) then
		v = Array.reduce(p.props.style, function(p2, p3)
			return Object.assign(p2, p3)
		end, {})
	else
		v = p.props.style
	end

	local v2 = Object.assign(
		{
			Name = "RCTScrollContentView",
			[Change.AbsoluteSize] = p.props.onLayout,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0)
		},
		p.props.AutomaticSize and { AutomaticSize = p.props.AutomaticSize } or nil,
		v
	)

	return React.createElement("Frame", v2, p.props.children)
end

return extended
