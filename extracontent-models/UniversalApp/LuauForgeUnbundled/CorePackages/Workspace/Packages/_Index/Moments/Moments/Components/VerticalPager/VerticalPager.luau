local UserInputService = game:GetService("UserInputService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SignalsReact")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/Constants")
require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/Types")
local snapMath = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/snapMath")
local usePagerController = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/usePagerController")
local usePagerInputNavigation = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/usePagerInputNavigation")
local FFlagMomentsFeedSwipeSensitivityConfig = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsFeedSwipeSensitivityConfig")
local FIntMomentsFeedSnapSensitivityMilli = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FIntMomentsFeedSnapSensitivityMilli")
local FIntMomentsFeedAnimationSpeed = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FIntMomentsFeedAnimationSpeed")

local VerticalPagerContext = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/VerticalPager/VerticalPagerContext")
local verticalPagerContext = VerticalPagerContext.VerticalPagerContext
local pagerItemContext = VerticalPagerContext.PagerItemContext

local function PagerItemProviderInner(props)
	local index = props.index
	local getActiveIndex = props.getActiveIndex

	local v5 = React.useMemo(function()
		return Signals.createComputed(function(p2): boolean
			return getActiveIndex(p2) == index
		end)
	end, { getActiveIndex, index })

	local v6 = React.useMemo(function()
		return Signals.createComputed(function(p2): boolean
			return math.abs(getActiveIndex(p2) - index) <= 1
		end)
	end, { getActiveIndex, index })

	local v7 = React.useMemo(function()
		return { index = index, item = props.item, getIsActive = v5, getIsVisible = v6 }
	end, { index, props.item, v5, v6 })

	return React.createElement(pagerItemContext.Provider, { value = v7 }, {
		Item = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(0, snapMath.offsetForIndex(index, props.stride)),
				Size = UDim2.new(1, 0, 0, props.itemHeight)
			},
			{
				Content = props.renderItem(props.item, index)
			}
		)
	})
end

local memo = React.memo(PagerItemProviderInner)

local function useNativeScrollEnabled()
	local function isNonTouch(p2): boolean
		return p2 == Enum.UserInputType.MouseWheel
			or p2 == Enum.UserInputType.MouseButton1
			or p2 == Enum.UserInputType.MouseMovement
			or p2 == Enum.UserInputType.Keyboard
	end

	local state, setState = React.useState(function(): boolean
		local lastInputType = UserInputService:GetLastInputType()
		return lastInputType ~= Enum.UserInputType.MouseWheel
			and lastInputType ~= Enum.UserInputType.MouseButton1
			and lastInputType ~= Enum.UserInputType.MouseMovement
			and lastInputType ~= Enum.UserInputType.Keyboard
	end)

	React.useEffect(function()
		local lastInputTypeChangedConnection = UserInputService.LastInputTypeChanged:Connect(function(p2)
			if p2 == Enum.UserInputType.Touch then
				setState(true)
			elseif
				p2 == Enum.UserInputType.MouseWheel
				or p2 == Enum.UserInputType.MouseButton1
				or p2 == Enum.UserInputType.MouseMovement
				or p2 == Enum.UserInputType.Keyboard
			then
				setState(false)
			end
		end)
		return function()
			lastInputTypeChangedConnection:Disconnect()
		end
	end, {})

	return state
end

local function VerticalPager(props)
	local store = props.store
	local renderItem = props.renderItem
	local keyExtractor = props.keyExtractor
	local analytics = props.analytics
	local tuning = props.tuning or {}

	local v5 = Constants.DEFAULT_SNAP_SENSITIVITY
	local v6 = Constants.DEFAULT_ANIMATION_SPEED

	if FFlagMomentsFeedSwipeSensitivityConfig then
		v5 = FIntMomentsFeedSnapSensitivityMilli / 1000
		v6 = FIntMomentsFeedAnimationSpeed
	end

	local snapSensitivity = tuning.snapSensitivity or v5
	local animationSpeed = tuning.animationSpeed or v6
	local overscan = tuning.overscan or Constants.DEFAULT_OVERSCAN
	local onEndReached = props.onEndReached
	local endReachedThreshold = tuning.endReachedThreshold or Constants.DEFAULT_END_REACHED_THRESHOLD
	local v7 = props.active == nil or props.active
	local gap = tuning.gap or 0
	local initialIndex = props.initialIndex

	local keyboardNavigation = tuning.keyboardNavigation or "global"

	local function keyOf(p2, p3)
		if keyExtractor == nil then
			return (tostring(p3))
		end

		return (keyExtractor(p2, p3))
	end

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(0)

	local ref = React.useRef(nil)

	local ref2 = React.useRef({})

	local v8 = React.useCallback(function(p2)
		setState(p2)

		if p2 then
			setState2(p2.AbsoluteSize.Y)
		end
	end, {})

	local v9 = React.useCallback(function(p2)
		setState2(p2.AbsoluteSize.Y)
	end, {})

	local v10 = useNativeScrollEnabled()

	local v11 = usePagerController({
		scrollingFrame = state,
		store = store,
		itemHeight = state2,
		gap = gap,
		snapSensitivity = snapSensitivity,
		animationSpeed = animationSpeed,
		active = v7,
		nativeScrollEnabled = v10,
		analytics = analytics
	})

	local v12 = usePagerInputNavigation({
		active = v7,
		keyboardNavigation = keyboardNavigation,
		goNext = v11.next,
		goPrevious = v11.previous
	})

	local v13 = SignalsReact.useSignalState(store.getCount)
	local v14 = SignalsReact.useSignalState(store.getItems)
	local v15 = SignalsReact.useSignalState(v11.getActiveIndex)

	React.useEffect(function()
		if onEndReached == nil or v13 <= 0 then
			return
		end

		if v13 - endReachedThreshold <= v15 and ref.current ~= v14 then
			ref.current = v14
			onEndReached()
		end
	end, { v15, v13, v14, endReachedThreshold, onEndReached })

	React.useEffect(function()
		local onItemImpression = if analytics ~= nil then analytics.onItemImpression else nil

		if onItemImpression == nil or v13 <= 0 then
			return
		end

		local v16 = v14[v15]

		if v16 == nil then
			return
		end

		local v17 = v15
		local v18 = if keyExtractor == nil then tostring(v17) else keyExtractor(v16, v17)

		if ref2.current[v18] then
			return
		end

		ref2.current[v18] = true
		onItemImpression(v15, v16)
	end, { v15, v13, v14, analytics, keyExtractor })

	local v16 = React.useMemo(function()
		return {
			store = store,
			getActiveIndex = v11.getActiveIndex,
			getScrollState = v11.getScrollState,
			scrollToIndex = v11.scrollToIndex,
			next = v11.next,
			previous = v11.previous,
			removeItem = v11.removeItem,
			analytics = analytics
		}
	end, { store, v11, analytics })

	local ref3 = React.useRef(false)
	React.useEffect(function()
		if ref3.current then
			return
		end

		if initialIndex == nil then
			ref3.current = true
			return
		end

		if v13 < initialIndex then
			return
		end

		ref3.current = true

		if initialIndex ~= store.getCurrentIndex(false) then
			store.goToItem(initialIndex)
		end
	end, { initialIndex, v13, store.getCurrentIndex, store.goToItem })

	React.useImperativeHandle(props.controllerRef, function()
		return v11
	end, { v11 })

	local v17 = state2 + gap
	local v18 = not (state2 > 0 and v13 > 0) and 0 or (v13 - 1) * v17 + state2

	local children = {}

	if state2 > 0 and v13 > 0 then
		local visibleWindow = snapMath.getVisibleWindow(v15, overscan, v13)

		for i = visibleWindow.startIndex, visibleWindow.endIndex do
			local v19 = v14[i]

			if v19 == nil then
				continue
			end

			local createElement = React.createElement
			local v22 = if keyExtractor == nil then tostring(i) else keyExtractor(v19, i)

			local v21 = {
				key = v22,
				index = i,
				item = v19,
				itemHeight = state2,
				stride = v17,
				getActiveIndex = v11.getActiveIndex,
				renderItem = renderItem
			}
			table.insert(children, createElement(memo, v21))
		end
	end

	local createElement = React.createElement
	local provider = verticalPagerContext.Provider

	local createElement2 = React.createElement
	local v22 = {
		Active = v7,
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		Position = props.Position,
		Selectable = v7,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
		SelectionGroup = true,
		Size = props.Size or UDim2.fromScale(1, 1),
		ZIndex = props.ZIndex,
		ref = v12
	}

	local createElement3 = React.createElement
	local v25 = {}
	v25.AutomaticCanvasSize = Enum.AutomaticSize.None
	v25.BackgroundTransparency = 1
	v25.BorderSizePixel = 0
	v25.CanvasSize = UDim2.new(1, 0, 0, v18)
	v25.ClipsDescendants = true
	v25.ScrollBarThickness = 0
	v25.ScrollingDirection = Enum.ScrollingDirection.Y

	if v7 then
		if not (v13 > 1) then
			v10 = false
		end
	else
		v10 = v7
	end

	v25.ScrollingEnabled = v10

	v25.Selectable = false
	v25.Size = UDim2.fromScale(1, 1)
	v25.ref = v8
	v25[React.Change.AbsoluteSize] = v9
	return createElement(provider, { value = v16 }, {
		Container = createElement2("Frame", v22, {
			Scroller = createElement3("ScrollingFrame", v25, children)
		})
	})
end

return VerticalPager
