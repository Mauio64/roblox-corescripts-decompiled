local ParentParent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local React = require(ParentParent.React)
local Change = React.Change
local v7 = React.Component:extend("ScrollContentViewNativeComponent")

function v7.init(p1, p2) -- line: 27
	p1.props = p2
end
function v7.render(p3) -- line: 31
	-- upvalues: Array (copy), Object (copy), Change (copy), React (copy)
	local v11 = if not Array.isArray(p3.props.style) then p3.props.style else Array.reduce(p3.props.style, function(p4, p5) -- line: 33
		-- upvalues: Object (copy)
		return Object.assign(p4, p5)
	end, {})
	local v12 = Object.assign({
		Name = "RCTScrollContentView",
		[Change.AbsoluteSize] = p3.props.onLayout,
		Size = UDim2.new(1, 0, 1, 0)
	}, if not p3.props.AutomaticSize then nil else {
		AutomaticSize = p3.props.AutomaticSize
	}, v11)

	return React.createElement("Frame", v12, p3.props.children)
end

return v7
