local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/Cryo")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CapturesCommon/React")

require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Enums/NavigationType")
require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Signal")
local view = Foundation.View

local useCallback = React.useCallback
local useEffect = React.useEffect
local useSnapScrollController = require("@game/CorePackages/Workspace/Packages/_Index/CapturesCommon/CapturesCommon/Hooks/useSnapScrollController")
local useState = React.useState

return function(props)
	local state, setState = useState(Vector2.new(0, 0))

	local v5 = props.active == nil or props.active
	local initialIndex = props.initialIndex or 1
	local itemAbsoluteSize = props.itemAbsoluteSize or state
	local windowSize = props.windowSize or 3

	local v6, v7, v8, v9, v10 = useSnapScrollController(v5, initialIndex, itemAbsoluteSize, #props.contents)

	local v11 = useCallback(function(p2)
		setState(p2.AbsoluteSize)
	end, {})

	useEffect(function()
		if props.onIndexChanged then
			props.onIndexChanged(v6)
		end
	end, { v6, props.onIndexChanged })

	local v12 = React.useMemo(function()
		return Cryo.List.map(props.contents, function(p2, p3)
			if p3 < v6 - windowSize or v6 + windowSize < p3 then
				return React.createElement(view, {
					key = `PLACEHOLDER-{p3}`,
					LayoutOrder = p3,
					Size = UDim2.fromOffset(itemAbsoluteSize.X, itemAbsoluteSize.Y),
					tag = "anchor-top-center bg-action-subtle position-top-center"
				})
			end

			return props.renderContent(p2, p3)
		end)
	end, { v6, itemAbsoluteSize, props.contents, props.renderContent, windowSize })

	useEffect(function()
		if not props.scrollToIndexSignal then
			return
		end

		local scrollToIndexSignalConnection = props.scrollToIndexSignal:connect(v9)
		return function()
			scrollToIndexSignalConnection:disconnect()
		end
	end, { props.scrollToIndexSignal, v9 })

	useEffect(function()
		if not props.triggerNavigationSignal then
			return
		end

		local triggerNavigationSignalConnection = props.triggerNavigationSignal:connect(v10)
		return function()
			triggerNavigationSignalConnection:disconnect()
		end
	end, { props.triggerNavigationSignal, v10 })

	return React.createElement(
		view,
		{
			onAbsoluteSizeChanged = v11,
			ref = v7,
			tag = "anchor-top-center bg-action-subtle position-top-center size-full"
		},
		{
			MotionView = React.createElement(view, {
				LayoutOrder = 1,
				ref = v8,
				Size = UDim2.fromScale(1, #props.contents),
				tag = "align-x-center anchor-top-center bg-action-subtle col no-clip position-top-center"
			}, v12)
		}
	)
end
