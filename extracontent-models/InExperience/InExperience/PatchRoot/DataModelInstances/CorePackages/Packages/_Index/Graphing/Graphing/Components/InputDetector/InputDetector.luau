local Graphing = script:FindFirstAncestor("Graphing")
local parent = Graphing.Parent
local React = require(parent.React)

require(Graphing.Types)
local CanvasContext = require(Graphing.CanvasContext)
local MathUtil = require(Graphing.Util.MathUtil)

function InputDetector(props)
	local v = React.useContext(CanvasContext)

	local inflate = props.Inflate or 0

	local state, setState = React.useState(false)
	local _, setState2 = React.useState(false)
	local state2, setState3 = React.useState(false)
	local state3, setState4 = React.useState(false)
	local state4, setState5 = React.useState(Vector2.zero)

	local v2 = React.useCallback(function(vector2: Vector2)
		local x = vector2.X
		local y = vector2.Y

		if props.XSnap then
			x = MathUtil.roundToNearest(x, props.XSnap)
		end

		if props.YSnap then
			y = MathUtil.roundToNearest(y, props.YSnap)
		end

		return Vector2.new(x, y)
	end, { props.XSnap, props.YSnap })

	local v3 = React.useCallback(function(_, p)
		local v3 = v2(v.mouseToPlot(p.Position))

		if p.UserInputType == Enum.UserInputType.MouseMovement then
			setState(true)

			if props.OnHoverStart then
				props.OnHoverStart(v.mouseToPlot(p.Position), p)
			end
		elseif p.UserInputType == Enum.UserInputType.MouseButton1 or p.UserInputType == Enum.UserInputType.Touch then
			setState3(false)

			if props.OnPress then
				props.OnPress(v3, p)
			end
		elseif p.UserInputType == Enum.UserInputType.MouseButton2 then
			setState4(false)

			if props.OnRightPress then
				props.OnRightPress(v3, p)
			end
		end
	end, {
		setState,
		setState3,
		setState4,
		v,
		props.OnHoverStart,
		props.OnPress,
		props.OnRightPress,
		v2
	})

	local v4 = React.useCallback(function(_, p)
		if props.OnHoverMoved and state and p.UserInputType == Enum.UserInputType.MouseMovement then
			props.OnHoverMoved(v2(v.mouseToPlot(p.Position)), p)
		elseif props.OnScroll and p.UserInputType == Enum.UserInputType.MouseWheel then
			props.OnScroll(p.Position.Z, p)
		end
	end, { state, v, props.OnHoverMoved, props.OnScroll, v2 })

	local v5 = React.useCallback(function(_, p)
		local v5 = v2(v.mouseToPlot(p.Position))

		if p.UserInputType == Enum.UserInputType.MouseMovement then
			setState(false)

			if props.OnHoverEnded then
				props.OnHoverEnded(v5, p)
			end
		elseif p.UserInputType == Enum.UserInputType.MouseButton1 or p.UserInputType == Enum.UserInputType.Touch then
			if props.OnRelease then
				props.OnRelease(v5, p)
			end

			if props.OnClick and state and not state2 then
				props.OnClick(v5, p)
			end
		elseif p.UserInputType == Enum.UserInputType.MouseButton2 then
			if props.OnRightRelease then
				props.OnRightRelease(v5, p)
			end

			if props.OnRightClick and state and not state3 then
				props.OnRightClick(v5, p)
			end
		end
	end, {
		setState,
		state,
		state2,
		state3,
		v,
		props.OnHoverEnded,
		props.OnClick,
		props.OnRightClick,
		props.OnRelease,
		props.OnRightRelease,
		v2
	})

	local v6 = React.useCallback(function(p, vector2: Vector2)
		setState2(true)

		local v6 = Vector2.zero
		local parent2

		if p.Parent then
			parent2 = p.Parent.Parent
		end

		if parent2 and parent2:IsA("GuiObject") then
			local anchorPoint = props.AnchorPoint or parent2.AnchorPoint
			v6 = parent2.AbsolutePosition + parent2.AbsoluteSize * anchorPoint
		end

		local v7 = v.absToView(vector2) - v.absToView(v6)

		if props.TreatMouseAsAnchor then
			v7 = Vector2.zero
		end

		setState5(v7)

		if props.OnDragStart then
			local v8 = v.absToView(vector2) - v7
			local vector2_2 = Vector2.new(math.clamp(v8.X, 0, 1), (math.clamp(v8.Y, 0, 1)))
			props.OnDragStart(v2(v.viewToPlot(vector2_2)), vector2)
		end
	end, {
		v,
		setState5,
		setState2,
		props.OnDragStart,
		props.AnchorPoint,
		props.TreatMouseAsAnchor,
		v2
	})

	local v7 = React.useCallback(function(_, vector2: Vector2)
		setState3(true)
		setState4(true)

		if props.OnDragMoved then
			local v7 = v.absToView(vector2) - state4
			local vector2_2 = Vector2.new(math.clamp(v7.X, 0, 1), (math.clamp(v7.Y, 0, 1)))
			props.OnDragMoved(v2(v.viewToPlot(vector2_2)), vector2)
		end
	end, { v, setState3, setState4, state4, props.OnDragMoved, v2 })

	local v8 = React.useCallback(function(_, vector2: Vector2)
		setState2(false)

		if props.OnDragEnded then
			local v8 = v.absToView(vector2) - state4
			local vector2_2 = Vector2.new(math.clamp(v8.X, 0, 1), (math.clamp(v8.Y, 0, 1)))
			props.OnDragEnded(v2(v.viewToPlot(vector2_2)), vector2)
		end
	end, { v, setState2, props.OnDragEnded, state4, v2 })

	return React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, inflate * 2, 1, inflate * 2),
		BackgroundTransparency = props.DebugColor3 == nil and 1 or 0,
		BackgroundColor3 = props.DebugColor3,
		BorderSizePixel = 0,
		ZIndex = props.ZIndex,
		[React.Event.InputBegan] = v3,
		[React.Event.InputChanged] = v4,
		[React.Event.InputEnded] = v5
	}, {
		DragDetector = React.createElement("UIDragDetector", {
			DragStyle = Enum.UIDragDetectorDragStyle.Scriptable,
			ReferenceUIInstance = v.getViewport(),
			[React.Event.DragStart] = v6,
			[React.Event.DragContinue] = v7,
			[React.Event.DragEnd] = v8
		})
	})
end

return InputDetector
