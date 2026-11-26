local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local view = Foundation.View
local scrollView = Foundation.ScrollView
local scrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local useLayerCollector = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/UIBlox").Core.Layout.LayerCollector.useLayerCollector

return (React.forwardRef(function(props, p2)
	local ref = React.useRef(nil)
	local state, setState = React.useState(Vector2.zero)
	local state2, setState2 = React.useState(Vector2.zero)
	local state3, setState3 = React.useState(true)
	local state4, setState4 = React.useState(false)
	local absoluteSize = useLayerCollector().absoluteSize

	React.useLayoutEffect(function()
		if not ref.current then
			return function() end
		end

		setState(ref.current.AbsoluteCanvasSize)
		setState2(ref.current.AbsoluteWindowSize)
		local absoluteCanvasSizeChangedConnection = ref.current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
			setState(ref.current.AbsoluteCanvasSize)
		end)
		local absoluteWindowSizeChangedConnection = ref.current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
			setState2(ref.current.AbsoluteWindowSize)
		end)

		return function()
			absoluteCanvasSizeChangedConnection:Disconnect()
			absoluteWindowSizeChangedConnection:Disconnect()
		end
	end, { ref.current, absoluteSize })

	React.useEffect(function()
		if not ref.current then
			return function() end
		end

		local canvasPositionChangedConnection = ref.current:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
			local canvasPosition = ref.current.CanvasPosition

			if state.Y == state2.Y then
				setState3(true)
				setState4(true)
			else
				if canvasPosition.Y <= 0 then
					setState3(true)
					return
				end

				if canvasPosition.Y >= state.Y - state2.Y then
					setState4(true)
					return
				end

				setState3(false)
				setState4(false)
			end
		end)

		return function()
			canvasPositionChangedConnection:Disconnect()
		end
	end, { ref.current, absoluteSize, state, state2 })

	return React.createElement(view, { tag = "size-full" }, {
		TopGradient = React.createElement(view, {
			Size = UDim2.new(1, -15, 0, props.gradientHeight),
			tag = not state3 and "bg-surface-300" or nil,
			ZIndex = 2
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}),
		BottomGradient = React.createElement(view, {
			Position = UDim2.new(0, 0, 1, -props.gradientHeight),
			Size = UDim2.new(1, -15, 0, props.gradientHeight),
			tag = not state4 and "bg-surface-300" or nil,
			ZIndex = 2
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 270,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}),
		ScrollView = React.createElement(scrollView, {
			Size = props.Size or UDim2.new(1, 0, 1, 0),
			ZIndex = props.ZIndex,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromOffset(0, 0),
				scrollBarVisibility = scrollBarVisibility.Always,
				ScrollingDirection = Enum.ScrollingDirection.Y
			},
			scrollingFrameRef = ref,
			ref = p2
		}, props.children)
	})
end))
