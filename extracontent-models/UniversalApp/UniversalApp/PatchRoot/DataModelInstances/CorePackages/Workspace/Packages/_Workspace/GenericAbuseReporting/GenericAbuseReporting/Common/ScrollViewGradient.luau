local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local React = require(GenericAbuseReporting.Parent.React)
local Foundation = require(GenericAbuseReportingParent.Foundation)
local View = Foundation.View
local ScrollView = Foundation.ScrollView
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local useLayerCollector = require(GenericAbuseReportingParent.UIBlox).Core.Layout.LayerCollector.useLayerCollector

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 21
	-- upvalues: React (copy), useLayerCollector (copy), View (copy), ScrollView (copy), ScrollBarVisibility (copy)
	local v11 = React.useRef(nil)
	local v12, v13 = React.useState(Vector2.zero)
	local v14, v15 = React.useState(Vector2.zero)
	local v16, v17 = React.useState(true)
	local v18, v19 = React.useState(false)
	local absoluteSize = useLayerCollector().absoluteSize

	React.useLayoutEffect(function() -- line: 30
		-- upvalues: v11 (copy), v13 (copy), v15 (copy)
		if v11.current then
			v13(v11.current.AbsoluteCanvasSize)
			v15(v11.current.AbsoluteWindowSize)

			local connection = v11.current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() -- line: 37
				-- upvalues: v13 (copy), v11 (copy)
				v13(v11.current.AbsoluteCanvasSize)
			end)
			local connection2 = v11.current:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function() -- line: 42
				-- upvalues: v15 (copy), v11 (copy)
				v15(v11.current.AbsoluteWindowSize)
			end)

			return function() -- line: 46
				-- upvalues: connection (copy), connection2 (copy)
				connection:Disconnect()
				connection2:Disconnect()
			end
		end

		return function() -- line: 51
		end
	end, {
		v11.current,
		absoluteSize
	})
	React.useEffect(function() -- line: 54
		-- upvalues: v11 (copy), v12 (copy), v14 (copy), v17 (copy), v19 (copy)
		if v11.current then
			local connection = v11.current:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- line: 56
				-- upvalues: v11 (copy), v12 (copy), v14 (copy), v17 (copy), v19 (copy)
				local CanvasPosition = v11.current.CanvasPosition

				if v12.Y == v14.Y then
					v17(true)
					v19(true)

					return
				end

				if CanvasPosition.Y <= 0 then
					v17(true)

					return
				end

				if CanvasPosition.Y >= v12.Y - v14.Y then
					v19(true)

					return
				end

				v17(false)
				v19(false)
			end)

			return function() -- line: 71
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end

		return function() -- line: 75
		end
	end, {
		v11.current,
		absoluteSize,
		v12,
		v14
	})

	return React.createElement(View, {
		tag = "size-full"
	}, {
		TopGradient = React.createElement(View, {
			ZIndex = 2,
			Size = UDim2.new(1, -15, 0, t1.gradientHeight),
			tag = if v16 then nil else "bg-surface-300"
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}),
		BottomGradient = React.createElement(View, {
			ZIndex = 2,
			Position = UDim2.new(0, 0, 1, -t1.gradientHeight),
			Size = UDim2.new(1, -15, 0, t1.gradientHeight),
			tag = if v18 then nil else "bg-surface-300"
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 270,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}),
		ScrollView = React.createElement(ScrollView, {
			Size = t1.Size or UDim2.new(1, 0, 1, 0),
			ZIndex = t1.ZIndex,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromOffset(0, 0),
				scrollBarVisibility = ScrollBarVisibility.Always,
				ScrollingDirection = Enum.ScrollingDirection.Y
			},
			scrollingFrameRef = v11,
			ref = p1
		}, t1.children)
	})
end))
