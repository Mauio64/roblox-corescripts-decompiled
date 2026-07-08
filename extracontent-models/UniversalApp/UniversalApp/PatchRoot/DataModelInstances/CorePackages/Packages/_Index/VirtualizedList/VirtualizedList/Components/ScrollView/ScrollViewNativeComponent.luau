local ParentParent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local console = LuauPolyfill.console
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object
local React = require(ParentParent.React)
local Change = React.Change
local Event = React.Event
local Otter = require(ParentParent.Otter)
local t1 = {
	restingPositionLimit = 1,
	restingVelocityLimit = 10
}
local v11 = React.Component:extend("ScrollViewNativeComponent")

function v11.init(t2: {[any]: any}, t3: {[any]: any}) -- line: 62
	-- upvalues: React (copy), t1 (copy), Otter (copy)
	t2.props = t3
	t2._nativeRef = React.createRef()
	t2.lastScrollEventTime = 0
	t2.animationConfig = if not t2.props.animationConfig then t1 else t2.props.animationConfig
	t2.motor = Otter.createGroupMotor({
		x = 0,
		y = 0
	})
	t2.motorStepDisconnect = t2.motor:onStep(function(p1) -- line: 74
		-- upvalues: t2 (copy)
		t2._nativeRef.current.CanvasPosition = Vector2.new(p1.x, p1.y)
	end)

	function t2._nativeRef.animateScrollTo(p2, p3) -- line: 78
		-- upvalues: t2 (copy)
		t2:_startAnimatedScroll(p2, p3)
	end
end
function v11._validateAnimatedScrollInputs(t4: {[any]: any}, n1: number, n2: number) -- line: 83
	-- upvalues: console (copy)
	if not t4._nativeRef.current then
		console.error("scrollTo animation failed: ScrollViewNativeComponent._nativeRef instance is undefined")
	end

	if t4._nativeRef.current.ScrollingDirection == Enum.ScrollingDirection.X then
		if n1 > t4._nativeRef.current.AbsoluteCanvasSize.X then
			console.warn("scrollTo animation goal out of bounds, setting X goal to: " .. tostring(t4._nativeRef.current.AbsoluteCanvasSize.X - t4._nativeRef.current.AbsoluteWindowSize.X))

			return
		end

		if n1 < 0 then
			console.warn("scrollTo animation goal out of bounds, setting X goal to: 0")

			return
		end
	else
		if n2 > t4._nativeRef.current.AbsoluteCanvasSize.Y then
			console.warn("scrollTo animation goal out of bounds, setting Y goal to: " .. tostring(t4._nativeRef.current.AbsoluteCanvasSize.Y - t4._nativeRef.current.AbsoluteWindowSize.Y))

			return
		end

		if n2 < 0 then
			console.warn("scrollTo animation goal out of bounds, setting Y goal to: 0")
		end
	end
end
function v11._startAnimatedScroll(p4, p5, p6) -- line: 113
	-- upvalues: Otter (copy)
	if _G.__DEV__ then
		p4:_validateAnimatedScrollInputs(p5, p6)
	end

	local CanvasPosition = p4._nativeRef.current.CanvasPosition

	p4.motor:setGoal({
		x = Otter.instant(CanvasPosition.X),
		y = Otter.instant(CanvasPosition.Y)
	})
	p4.motor:step(0)
	p4.motor:setGoal({
		x = Otter.spring(p5, p4.animationConfig),
		y = Otter.spring(p6, p4.animationConfig)
	})
end
function v11.render(p7) -- line: 136
	-- upvalues: Array (copy), Object (copy), Change (copy), Event (copy), React (copy)
	local v22 = if not Array.isArray(p7.props.style) then p7.props.style else Array.reduce(p7.props.style, function(p8, p9) -- line: 138
		-- upvalues: Object (copy)
		return Object.assign(p8, p9)
	end, {})
	local v23 = Object.assign({
		Name = "RCTScrollView",
		ScrollingEnabled = p7.props.scrollEnabled == nil or p7.props.scrollEnabled,
		Size = UDim2.new(1, 0, 1, 0),
		CanvasPosition = p7.props.CanvasPosition,
		CanvasSize = p7.props.CanvasSize or UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = p7.props.AutomaticCanvasSize or Enum.AutomaticSize.XY,
		ScrollBarThickness = if not (not not p7.props.horizontal and p7.props.showsHorizontalScrollIndicator == false) and (p7.props.horizontal or p7.props.showsVerticalScrollIndicator ~= false) then nil else 0,
		ref = p7._nativeRef,
		[Change.AbsoluteWindowSize] = p7.props.onLayout,
		[Change.CanvasPosition] = function(p10) -- line: 157
			-- upvalues: p7 (copy)
			local v31 = os.clock() * 1000

			if (p7.props.scrollEventThrottle or 0) < v31 - p7.lastScrollEventTime then
				p7.props.onScroll(p10)
				p7.lastScrollEventTime = v31
			end
		end,
		[Event.InputBegan] = function(p11, p12) -- line: 165
			-- upvalues: p7 (copy)
			if (p12.UserInputType == Enum.UserInputType.MouseWheel or p12.UserInputType == Enum.UserInputType.Touch) and p7.motor ~= nil then
				p7.motor:stop()
			end

			if p12.UserInputType == Enum.UserInputType.Touch then
				p7.props.onTouchStart(p11, p12)
			end
		end,
		[Event.InputEnded] = function(p13, p14) -- line: 179
			-- upvalues: p7 (copy)
			if p14.UserInputType == Enum.UserInputType.Touch then
				p7.props.onTouchEnd(p13, p14)
			end
		end,
		[Event.InputChanged] = function(p15, p16) -- line: 184
			-- upvalues: p7 (copy)
			if p16.UserInputType == Enum.UserInputType.Touch then
				p7.props.onTouchMove(p15, p16)
			end
		end,
		[Event.SelectionChanged] = if not p7.props.onSelectionChanged then nil else function(p17, p18, p19, p20) -- line: 190
			-- upvalues: p7 (copy)
			p7.props.onSelectionChanged(p17, p18, p19, p20)
		end
	}, v22)

	return React.createElement("ScrollingFrame", v23, {
		Layout = if not p7.props.inverted or p7.props.getItemLayout then nil else React.createElement("UIListLayout", {
			HorizontalAlignment = if not p7.props.horizontal then Enum.HorizontalAlignment.Center else Enum.HorizontalAlignment.Right,
			VerticalAlignment = if not p7.props.horizontal then Enum.VerticalAlignment.Bottom else Enum.VerticalAlignment.Center
		}),
		[1] = p7.props.children
	})
end
function v11.willUnmount(p21) -- line: 212
	if p21.motor ~= nil then
		p21.motor:destroy()
	end

	if p21.motorStepDisconnect ~= nil then
		p21.motorStepDisconnect()
	end
end

return v11
