local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/React")

local view = Foundation.View

local useZoomController = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Hooks/useZoomController")

return function(props)
	local v6, v7 = useZoomController(props.active == nil or props.active)

	React.useEffect(function()
		if props.onZoomStatusChanged then
			props.onZoomStatusChanged(v6)
		end
	end, { v6, props.onZoomStatusChanged })

	return React.createElement(
		view,
		{
			ref = v7,
			tag = "anchor-center-center position-center-center size-full bg-action-subtle",
			ZIndex = 1
		},
		{
			ZoomItem = React.createElement(React.Fragment, nil, props.children)
		}
	)
end
