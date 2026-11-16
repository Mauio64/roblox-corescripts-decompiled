local parent = script.Parent.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local React = require(parent.React)
local Change = React.Change

local extended = React.Component:extend("View")
function extended:init(props)
	self.props = props
	self._nativeRef = self.props.nativeRef or React.createRef()
end

function extended:render()
	local v

	if Array.isArray(self.props.style) then
		v = Array.reduce(self.props.style, function(p, p2)
			return Object.assign(p, p2)
		end, {})
	else
		v = self.props.style
	end

	local v2 = Object.assign(table.clone(self.props), v)

	local onLayoutsByAbsoluteSize = {
		ref = self._nativeRef,
		BackgroundColor3 = v2.BackgroundColor3,
		Name = v2.Name or "View",
		Size = v2.Size or UDim2.new(1, 0, 0, 0),
		AutomaticSize = v2.AutomaticSize or Enum.AutomaticSize.Y,
		ZIndex = v2.ZIndex or nil,
		LayoutOrder = v2.LayoutOrder or nil,
		BorderSizePixel = v2.BorderSizePixel or 0,
		BackgroundTransparency = v2.BackgroundTransparency or 1,
		SelectionGroup = v2.SelectionGroup,
		SelectionBehaviorLeft = v2.SelectionBehaviorLeft,
		SelectionBehaviorRight = v2.SelectionBehaviorRight,
		SelectionBehaviorUp = v2.SelectionBehaviorUp,
		SelectionBehaviorDown = v2.SelectionBehaviorDown,
		[Change.AbsoluteSize] = v2.onLayout
	}
	self.nativeProps = onLayoutsByAbsoluteSize

	return React.createElement("Frame", self.nativeProps, self.props.children)
end

return extended
