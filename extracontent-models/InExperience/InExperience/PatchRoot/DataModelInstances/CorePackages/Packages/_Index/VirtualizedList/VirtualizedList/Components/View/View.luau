local ParentParent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local React = require(ParentParent.React)
local Change = React.Change
local v7 = React.Component:extend("View")

function v7.init(t1: {[any]: any}, t2: {[any]: any}) -- line: 46
	-- upvalues: React (copy)
	t1.props = t2
	t1._nativeRef = t1.props.nativeRef or React.createRef()
end
function v7.render(p1) -- line: 51
	-- upvalues: Array (copy), Object (copy), Change (copy), React (copy)
	local v11 = if not Array.isArray(p1.props.style) then p1.props.style else Array.reduce(p1.props.style, function(p2, p3) -- line: 53
		-- upvalues: Object (copy)
		return Object.assign(p2, p3)
	end, {})
	local v12 = Object.assign(table.clone(p1.props), v11)

	p1.nativeProps = {
		ref = p1._nativeRef,
		BackgroundColor3 = v12.BackgroundColor3,
		Name = v12.Name or "View",
		Size = v12.Size or UDim2.new(1, 0, 0, 0),
		AutomaticSize = v12.AutomaticSize or Enum.AutomaticSize.Y,
		ZIndex = v12.ZIndex or nil,
		LayoutOrder = v12.LayoutOrder or nil,
		BorderSizePixel = v12.BorderSizePixel or 0,
		BackgroundTransparency = v12.BackgroundTransparency or 1,
		SelectionGroup = v12.SelectionGroup,
		SelectionBehaviorLeft = v12.SelectionBehaviorLeft,
		SelectionBehaviorRight = v12.SelectionBehaviorRight,
		SelectionBehaviorUp = v12.SelectionBehaviorUp,
		SelectionBehaviorDown = v12.SelectionBehaviorDown,
		[Change.AbsoluteSize] = v12.onLayout
	}

	return React.createElement("Frame", p1.nativeProps, p1.props.children)
end

return v7
