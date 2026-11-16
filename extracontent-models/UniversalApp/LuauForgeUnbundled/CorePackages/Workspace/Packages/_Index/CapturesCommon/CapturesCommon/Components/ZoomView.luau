local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/React")

local view = Foundation.View

local useZoomController = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Hooks/useZoomController")

return function(props)
	local v5, v6 = useZoomController(props.active == nil or props.active)

	React.useEffect(function()
		if props.onZoomStatusChanged then
			props.onZoomStatusChanged(v5)
		end
	end, { v5, props.onZoomStatusChanged })

	return React.createElement(
		view,
		{
			ref = v6,
			tag = "anchor-center-center position-center-center size-full bg-action-subtle",
			ZIndex = 1
		},
		{
			ZoomItem = React.createElement(React.Fragment, nil, props.children)
		}
	)
end
