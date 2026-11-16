local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local UserInputService = game:GetService("UserInputService")

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local Constants = require(script.Parent.Constants)
require(script.Parent.Types)
local snapMath = require(script.Parent.snapMath)
local usePagerController = require(script.Parent.usePagerController)
local usePagerInputNavigation = require(script.Parent.usePagerInputNavigation)
local FFlagMomentsFeedSwipeSensitivityConfig = require(Moments.Flags.FFlagMomentsFeedSwipeSensitivityConfig)
local FIntMomentsFeedSnapSensitivityMilli = require(Moments.Flags.FIntMomentsFeedSnapSensitivityMilli)
local FIntMomentsFeedAnimationSpeed = require(Moments.Flags.FIntMomentsFeedAnimationSpeed)

local VerticalPagerContext = require(script.Parent.VerticalPagerContext)
local verticalPagerContext = VerticalPagerContext.VerticalPagerContext
local PagerItemContext = VerticalPagerContext.PagerItemContext

local function PagerItemProviderInner(props)
	local index = props.index
	local getActiveIndex = props.getActiveIndex

	local getIsActive = React.useMemo(function()
		return Signals.createComputed(function(p): boolean
			return getActiveIndex(p) == index
		end)
	end, { getActiveIndex, index })

	local getIsVisible = React.useMemo(function()
		return Signals.createComputed(function(p): boolean
			return math.abs(getActiveIndex(p) - index) <= 1
		end)
	end, { getActiveIndex, index })

	local v = React.useMemo(function()
		return {
			index = index,
			item = props.item,
			getIsActive = getIsActive,
			getIsVisible = getIsVisible
		}
	end, { index, props.item, getIsActive, getIsVisible })

	return React.createElement(PagerItemContext.Provider, { value = v }, {
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
	local function isNonTouch(p): boolean -- 1 equivalent call inferred from this helper
		return p == Enum.UserInputType.MouseWheel
			or p == Enum.UserInputType.MouseButton1
			or p == Enum.UserInputType.MouseMovement
			or p == Enum.UserInputType.Keyboard
	end

	local state, setState = React.useState(function(): boolean
		local lastInputType = UserInputService:GetLastInputType()
		return lastInputType ~= Enum.UserInputType.MouseWheel
			and lastInputType ~= Enum.UserInputType.MouseButton1
			and lastInputType ~= Enum.UserInputType.MouseMovement
			and lastInputType ~= Enum.UserInputType.Keyboard
	end)

	React.useEffect(function()
		local lastInputTypeChangedConnection = UserInputService.LastInputTypeChanged:Connect(function(p)
			if p == Enum.UserInputType.Touch then
				setState(true)
			elseif isNonTouch(p) then -- inferred equivalent call
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

	local v = Constants.DEFAULT_SNAP_SENSITIVITY
	local v2 = Constants.DEFAULT_ANIMATION_SPEED

	if FFlagMomentsFeedSwipeSensitivityConfig then
		v = FIntMomentsFeedSnapSensitivityMilli / 1000
		v2 = FIntMomentsFeedAnimationSpeed
	end

	local snapSensitivity = tuning.snapSensitivity or v
	local animationSpeed = tuning.animationSpeed or v2
	local overscan = tuning.overscan or Constants.DEFAULT_OVERSCAN
	local onEndReached = props.onEndReached
	local endReachedThreshold = tuning.endReachedThreshold or Constants.DEFAULT_END_REACHED_THRESHOLD
	local v3 = props.active == nil or props.active
	local gap = tuning.gap or 0
	local initialIndex = props.initialIndex

	local keyboardNavigation = tuning.keyboardNavigation or "global"

	local function keyOf(p, p2: number) -- 2 equivalent calls inferred from this helper
		if keyExtractor == nil then
			return (tostring(p2))
		end

		return (keyExtractor(p, p2))
	end

	local state, setState = React.useState(nil)
	local state2, setState2 = React.useState(0)

	local ref = React.useRef(nil)

	local ref2 = React.useRef({})

	local ref4 = React.useCallback(function(p)
		setState(p)

		if p then
			setState2(p.AbsoluteSize.Y)
		end
	end, {})

	local v4 = React.useCallback(function(p)
		setState2(p.AbsoluteSize.Y)
	end, {})

	local v5 = useNativeScrollEnabled()

	local v6 = usePagerController({
		scrollingFrame = state,
		store = store,
		itemHeight = state2,
		gap = gap,
		snapSensitivity = snapSensitivity,
		animationSpeed = animationSpeed,
		active = v3,
		nativeScrollEnabled = v5,
		analytics = analytics
	})

	local ref5 = usePagerInputNavigation({
		active = v3,
		keyboardNavigation = keyboardNavigation,
		goNext = v6.next,
		goPrevious = v6.previous
	})

	local v7 = SignalsReact.useSignalState(store.getCount)
	local current = SignalsReact.useSignalState(store.getItems)
	local v8 = SignalsReact.useSignalState(v6.getActiveIndex)

	React.useEffect(function()
		if onEndReached == nil or v7 <= 0 then
			return
		end

		if v7 - endReachedThreshold <= v8 and ref.current ~= current then
			ref.current = current
			onEndReached()
		end
	end, { v8, v7, current, endReachedThreshold, onEndReached })

	React.useEffect(function()
		local onItemImpression

		if analytics ~= nil then
			onItemImpression = analytics.onItemImpression
		end

		if onItemImpression == nil or v7 <= 0 then
			return
		end

		local v9 = current[v8]

		if v9 == nil then
			return
		end

		local v10 = keyOf(v9, v8) -- inferred equivalent call

		if ref2.current[v10] then
			return
		end

		ref2.current[v10] = true
		onItemImpression(v8, v9)
	end, { v8, v7, current, analytics, keyExtractor })

	local v9 = React.useMemo(function()
		return {
			store = store,
			getActiveIndex = v6.getActiveIndex,
			getScrollState = v6.getScrollState,
			scrollToIndex = v6.scrollToIndex,
			next = v6.next,
			previous = v6.previous,
			removeItem = v6.removeItem,
			analytics = analytics
		}
	end, { store, v6, analytics })

	local ref3 = React.useRef(false)
	React.useEffect(function()
		if ref3.current then
			return
		end

		if initialIndex == nil then
			ref3.current = true
			return
		end

		if v7 < initialIndex then
			return
		end

		ref3.current = true

		if initialIndex ~= store.getCurrentIndex(false) then
			store.goToItem(initialIndex)
		end
	end, { initialIndex, v7, store.getCurrentIndex, store.goToItem })

	React.useImperativeHandle(props.controllerRef, function()
		return v6
	end, { v6 })

	local stride = state2 + gap
	local v10 = not (state2 > 0 and v7 > 0) and 0 or (v7 - 1) * stride + state2

	local children = {}

	if state2 > 0 and v7 > 0 then
		local visibleWindow = snapMath.getVisibleWindow(v8, overscan, v7)

		for i = visibleWindow.startIndex, visibleWindow.endIndex do
			local v11 = current[i]

			if v11 == nil then
				continue
			end

			local createElement = React.createElement
			local v12 = {
				key = keyOf(v11, i), -- inferred equivalent call
				index = i,
				item = v11,
				itemHeight = state2,
				stride = stride,
				getActiveIndex = v6.getActiveIndex,
				renderItem = renderItem
			}
			table.insert(children, createElement(memo, v12))
		end
	end

	local createElement = React.createElement
	local provider = verticalPagerContext.Provider

	local createElement2 = React.createElement
	local v11 = {
		Active = v3,
		AnchorPoint = props.AnchorPoint,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		Position = props.Position,
		Selectable = v3,
		SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
		SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
		SelectionGroup = true,
		Size = props.Size or UDim2.fromScale(1, 1),
		ZIndex = props.ZIndex,
		ref = ref5
	}

	local createElement3 = React.createElement
	local v12 = {}
	v12.AutomaticCanvasSize = Enum.AutomaticSize.None
	v12.BackgroundTransparency = 1
	v12.BorderSizePixel = 0
	v12.CanvasSize = UDim2.new(1, 0, 0, v10)
	v12.ClipsDescendants = true
	v12.ScrollBarThickness = 0
	v12.ScrollingDirection = Enum.ScrollingDirection.Y

	if v3 then
		if not (v7 > 1) then
			v5 = false
		end
	else
		v5 = v3
	end

	v12.ScrollingEnabled = v5

	v12.Selectable = false
	v12.Size = UDim2.fromScale(1, 1)
	v12.ref = ref4
	v12[React.Change.AbsoluteSize] = v4
	return createElement(provider, { value = v9 }, {
		Container = createElement2("Frame", v11, {
			Scroller = createElement3("ScrollingFrame", v12, children)
		})
	})
end

return VerticalPager
