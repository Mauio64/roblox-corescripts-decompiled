local CorePackages = game:GetService("CorePackages")
local Otter = require(CorePackages.Packages.Otter)
local ReactOtter = require(CorePackages.Packages.ReactOtter)

local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local React = require(CorePackages.Packages.React)
local useEffect = React.useEffect
local useCallback = React.useCallback
local useRef = React.useRef
local useMotor = ReactOtter.useMotor

local ScrollingListWithArrowsAndGradient = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Control/HorizontalNav/ScrollingListWithArrowsAndGradient")
require("@game/CorePackages/Workspace/Packages/AppCommonLib")

local v5 = {
	frequency = 2,
	dampingRatio = 0.9,
	restingPositionLimit = 0.5,
	restingVelocityLimit = 0.1
}

local function getScrollToLocation(buttonPadding, p2, current)
	if typeof(p2) ~= "table" or p2.current == nil or current == nil then
		return nil
	end

	local x = p2.current.AbsolutePosition.X
	local x2 = p2.current.AbsoluteWindowSize.X
	local x3 = p2.current.CanvasPosition.X
	local x4 = current.AbsolutePosition.X
	local v6 = current.AbsoluteSize.X + (buttonPadding or 0)

	local v7 = math.floor(x2 / 2) - math.floor(v6 / 2)

	local v8 = x4 < x

	local v9 = x2 - (x4 - x) < v6

	if v8 then
		return (math.max(x3 - (x - x4) - v7, 0))
	end

	if v9 then
		return x3 + (v6 - (x2 - (x4 - x))) + v7
	end

	return nil
end

return React.memo(function(props)
	local v6 = RoactGamepad.useRefCache()
	local v7 = useRef(nil)
	local state, setState = React.useState(nil)

	local v8 = React.useCallback(function(p2)
		if v7.current then
			v7.current.CanvasPosition = Vector2.new(p2, 0)
		end
	end, {})

	local v9 = useMotor(not v7.current and 0 or v7.current.CanvasPosition.X, v8)

	local v10 = useCallback(function(p2)
		local v11 = props.selectedItemKey and v6[props.selectedItemKey]

		if v11 then
			setState(v11.current)
			local v12 = (props.enableSnapToSelectedItem or p2)
				and getScrollToLocation(props.buttonPadding, v7, v11.current)

			if v12 then
				v9(Otter.spring(v12, v5))
			end
		end
	end, { props.selectedItemKey, props.enableSnapToSelectedItem, props.buttonPadding })

	useEffect(function()
		v10()
	end, {
		v10,
		props.selectedItemKey,
		props.enableSnapToSelectedItem,
		props.buttonPadding
	})

	local resetPositionSignal = props.resetPositionSignal

	local v11 = useCallback(function()
		v10(true)
	end, { v10, props.buttonPadding, props.selectedItemKey })

	useEffect(function()
		local connection = if resetPositionSignal then resetPositionSignal:connect(v11) else nil

		return function()
			if connection then
				connection:disconnect()
			end
		end
	end, { nil, resetPositionSignal, props.selectedItemKey })

	local v12 = useCallback(function(p2)
		return v6[p2]
	end, {})

	local v13 = useCallback(function(p2)
		if v7.current then
			v7.current.CanvasSize = UDim2.new(0, p2.AbsoluteSize.X, 1, 0)
		end
	end, {})

	local v14 = useCallback(function()
		return v7
	end, {})

	local createElement = React.createElement
	local v16 = {
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		LayoutOrder = props.LayoutOrder,
		AutomaticSize = 0,
		Size = 0,
		ZIndex = 0
	}
	local v17 = if props.AutomaticSize then props.AutomaticSize else nil
	v16.AutomaticSize = v17
	local v18 = if props.navHeight then UDim2.new(1, 0, 0, props.navHeight) else UDim2.new(1, 0, 1, 0)
	v16.Size = v18
	v16.ZIndex = props.ZIndex

	local createElement2 = React.createElement
	local v21 = {
		getScollingListContent = useCallback(function()
			return props.renderScrollingListContent({
				getScrollingFrameItemRef = v12,
				getScrollingFrameRef = v14,
				onNavFrameSizeChanged = v13,
				selectedItemInstance = state
			})
		end, { props.renderScrollingListContent, v12, v14, v13, state }),
		scrollingFrameRef = v7,
		buttonRefs = v6,
		buttonPadding = props.buttonPadding or 0,
		childWidgetIndex = 0,
		useIntroScroll = 0
	}
	local v22 = if props.enableIntroScroll then tostring(props.index) else nil
	v21.childWidgetIndex = v22
	v21.useIntroScroll = props.enableIntroScroll or false
	return createElement("Frame", v16, { ScrollingList = createElement2(ScrollingListWithArrowsAndGradient, v21) })
end)
