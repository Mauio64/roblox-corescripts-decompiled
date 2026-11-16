local parent = script.Parent.Parent
local parent2 = parent.Parent

local Foundation = require(parent2.Foundation)
local React = require(parent2.React)

local View = Foundation.View

local useZoomController = require(parent.Hooks.useZoomController)

return function(props)
	local v, ref = useZoomController(props.active == nil or props.active)

	React.useEffect(function()
		if props.onZoomStatusChanged then
			props.onZoomStatusChanged(v)
		end
	end, { v, props.onZoomStatusChanged })

	return React.createElement(
		View,
		{
			ref = ref,
			tag = "anchor-center-center position-center-center size-full bg-action-subtle",
			ZIndex = 1
		},
		{
			ZoomItem = React.createElement(React.Fragment, nil, props.children)
		}
	)
end
