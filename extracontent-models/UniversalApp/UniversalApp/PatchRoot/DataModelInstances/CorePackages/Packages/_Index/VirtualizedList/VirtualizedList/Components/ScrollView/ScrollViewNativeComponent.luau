local parent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local console = LuauPolyfill.console
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

local React = require(parent.React)
local Change = React.Change
local Event = React.Event

local Otter = require(parent.Otter)

local v = { restingPositionLimit = 1, restingVelocityLimit = 10 }

local extended = React.Component:extend("ScrollViewNativeComponent")
function extended:init(props)
	self.props = props
	self._nativeRef = React.createRef()
	self.lastScrollEventTime = 0
	local animationConfig

	if self.props.animationConfig then
		animationConfig = self.props.animationConfig
	else
		animationConfig = v
	end

	self.animationConfig = animationConfig

	self.motor = Otter.createGroupMotor({ x = 0, y = 0 })

	self.motorStepDisconnect = self.motor:onStep(function(p)
		self._nativeRef.current.CanvasPosition = Vector2.new(p.x, p.y)
	end)

	function self._nativeRef.animateScrollTo(p, p2)
		self:_startAnimatedScroll(p, p2)
	end
end

function extended:_validateAnimatedScrollInputs(p: number, p2: number)
	if not self._nativeRef.current then
		console.error("scrollTo animation failed: ScrollViewNativeComponent._nativeRef instance is undefined")
	end

	if self._nativeRef.current.ScrollingDirection == Enum.ScrollingDirection.X then
		if self._nativeRef.current.AbsoluteCanvasSize.X < p then
			console.warn("scrollTo animation goal out of bounds, setting X goal to: " .. tostring(self._nativeRef.current.AbsoluteCanvasSize.X - self._nativeRef.current.AbsoluteWindowSize.X))
		elseif p < 0 then
			console.warn("scrollTo animation goal out of bounds, setting X goal to: 0")
		end
	elseif self._nativeRef.current.AbsoluteCanvasSize.Y < p2 then
		console.warn("scrollTo animation goal out of bounds, setting Y goal to: " .. tostring(self._nativeRef.current.AbsoluteCanvasSize.Y - self._nativeRef.current.AbsoluteWindowSize.Y))
	elseif p2 < 0 then
		console.warn("scrollTo animation goal out of bounds, setting Y goal to: 0")
	end
end

function extended:_startAnimatedScroll(p, p2)
	if _G.__DEV__ then
		self:_validateAnimatedScrollInputs(p, p2)
	end

	local canvasPosition = self._nativeRef.current.CanvasPosition

	self.motor:setGoal({
		x = Otter.instant(canvasPosition.X),
		y = Otter.instant(canvasPosition.Y)
	})

	self.motor:step(0)

	self.motor:setGoal({
		x = Otter.spring(p, self.animationConfig),
		y = Otter.spring(p2, self.animationConfig)
	})
end

function extended:render()
	local v2

	if Array.isArray(self.props.style) then
		v2 = Array.reduce(self.props.style, function(p, p2)
			return Object.assign(p, p2)
		end, {})
	else
		v2 = self.props.style
	end

	local v3 = Object.assign({
		Name = "RCTScrollView",
		ScrollingEnabled = self.props.scrollEnabled == nil or self.props.scrollEnabled,
		Size = UDim2.new(1, 0, 1, 0),
		CanvasPosition = self.props.CanvasPosition,
		CanvasSize = self.props.CanvasSize or UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = self.props.AutomaticCanvasSize or Enum.AutomaticSize.XY,
		ScrollBarThickness = (self.props.horizontal and self.props.showsHorizontalScrollIndicator == false or not self.props.horizontal and self.props.showsVerticalScrollIndicator == false) and 0 or nil,
		ref = self._nativeRef,
		[Change.AbsoluteWindowSize] = self.props.onLayout,
		[Change.CanvasPosition] = function(p)
			local lastScrollEventTime = os.clock() * 1000

			if (self.props.scrollEventThrottle or 0) < lastScrollEventTime - self.lastScrollEventTime then
				self.props.onScroll(p)
				self.lastScrollEventTime = lastScrollEventTime
			end
		end,
		[Event.InputBegan] = function(p, p2)
			if
				(p2.UserInputType == Enum.UserInputType.MouseWheel or p2.UserInputType == Enum.UserInputType.Touch)
				and self.motor ~= nil
			then
				self.motor:stop()
			end

			if p2.UserInputType == Enum.UserInputType.Touch then
				self.props.onTouchStart(p, p2)
			end
		end,
		[Event.InputEnded] = function(p, p2)
			if p2.UserInputType == Enum.UserInputType.Touch then
				self.props.onTouchEnd(p, p2)
			end
		end,
		[Event.InputChanged] = function(p, p2)
			if p2.UserInputType == Enum.UserInputType.Touch then
				self.props.onTouchMove(p, p2)
			end
		end,
		[Event.SelectionChanged] = self.props.onSelectionChanged and function(p, p2, p3, p4)
			self.props.onSelectionChanged(p, p2, p3, p4)
		end or nil
	}, v2)

	local createElement = React.createElement
	local layout

	if self.props.inverted and not self.props.getItemLayout then
		local createElement2 = React.createElement
		local horizontalAlignment

		if self.props.horizontal then
			horizontalAlignment = Enum.HorizontalAlignment.Right
		else
			horizontalAlignment = Enum.HorizontalAlignment.Center
		end

		local verticalAlignment

		if self.props.horizontal then
			verticalAlignment = Enum.VerticalAlignment.Center
		else
			verticalAlignment = Enum.VerticalAlignment.Bottom
		end

		layout = createElement2("UIListLayout", {
			HorizontalAlignment = horizontalAlignment,
			VerticalAlignment = verticalAlignment
		})
	end

	return createElement("ScrollingFrame", v3, {
		Layout = layout,
		self.props.children
	})
end

function extended.willUnmount(p)
	if p.motor ~= nil then
		p.motor:destroy()
	end

	if p.motorStepDisconnect ~= nil then
		p.motorStepDisconnect()
	end
end

return extended
