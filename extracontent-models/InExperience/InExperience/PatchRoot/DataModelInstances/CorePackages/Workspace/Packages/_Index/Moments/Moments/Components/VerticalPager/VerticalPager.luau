local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local UserInputService = game:GetService("UserInputService")
local React = require(MomentsParent.React)
local Signals = require(MomentsParent.Signals)
local SignalsReact = require(MomentsParent.SignalsReact)
local Constants = require(script.Parent.Constants)

require(script.Parent.Types)

local snapMath = require(script.Parent.snapMath)
local usePagerController = require(script.Parent.usePagerController)
local usePagerInputNavigation = require(script.Parent.usePagerInputNavigation)
local GetFFlagMomentsDesktopWheelPaging = require(Moments.Flags.GetFFlagMomentsDesktopWheelPaging)
local FFlagMomentsFeedSwipeSensitivityConfig = require(Moments.Flags.FFlagMomentsFeedSwipeSensitivityConfig)
local FIntMomentsFeedSnapSensitivityMilli = require(Moments.Flags.FIntMomentsFeedSnapSensitivityMilli)
local FIntMomentsFeedAnimationSpeed = require(Moments.Flags.FIntMomentsFeedAnimationSpeed)
local VerticalPagerContext = require(script.Parent.VerticalPagerContext)
local VerticalPagerContext2 = VerticalPagerContext.VerticalPagerContext
local PagerItemContext = VerticalPagerContext.PagerItemContext

local function PagerItemProviderInner(t1: {[any]: any}) -- line: 59
	-- upvalues: React (copy), Signals (copy), PagerItemContext (copy), snapMath (copy)
	local index = t1.index
	local getActiveIndex = t1.getActiveIndex
	local v25 = React.useMemo(function() -- line: 63
		-- upvalues: Signals (copy), getActiveIndex (copy), index (copy)
		return Signals.createComputed(function(p1) -- line: 64
			-- upvalues: getActiveIndex (copy), index (copy)
			return getActiveIndex(p1) == index
		end)
	end, {
		getActiveIndex,
		index
	})
	local v26 = React.useMemo(function() -- line: 72
		-- upvalues: Signals (copy), getActiveIndex (copy), index (copy)
		return Signals.createComputed(function(p2) -- line: 73
			-- upvalues: getActiveIndex (copy), index (copy)
			return math.abs(getActiveIndex(p2) - index) <= 1
		end)
	end, {
		getActiveIndex,
		index
	})
	local v27 = React.useMemo(function() -- line: 78
		-- upvalues: index (copy), t1 (copy), v25 (copy), v26 (copy)
		return {
			index = index,
			item = t1.item,
			getIsActive = v25,
			getIsVisible = v26
		}
	end, {
		index,
		t1.item,
		v25,
		v26
	})

	return React.createElement(PagerItemContext.Provider, {
		value = v27
	}, {
		Item = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(0, snapMath.offsetForIndex(index, t1.stride)),
			Size = UDim2.new(1, 0, 0, t1.itemHeight)
		}, {
			Content = t1.renderItem(t1.item, index)
		})
	})
end

local v19 = React.memo(PagerItemProviderInner)

local function useNativeScrollEnabled() -- line: 123
	-- upvalues: GetFFlagMomentsDesktopWheelPaging (copy), React (copy), UserInputService (copy)
	local v28 = GetFFlagMomentsDesktopWheelPaging()

	local function isNonTouch(p3) -- line: 128
		return p3 == Enum.UserInputType.MouseWheel or (p3 == Enum.UserInputType.MouseButton1 or (p3 == Enum.UserInputType.MouseMovement or p3 == Enum.UserInputType.Keyboard))
	end

	local v30, v31 = React.useState(function() -- line: 135
		-- upvalues: v28 (copy), UserInputService (copy)
		local v73 = v28

		if v73 then
			local LastInputType = UserInputService:GetLastInputType()

			v73 = LastInputType == Enum.UserInputType.MouseWheel or (LastInputType == Enum.UserInputType.MouseButton1 or (LastInputType == Enum.UserInputType.MouseMovement or LastInputType == Enum.UserInputType.Keyboard))
		end

		return not v73
	end)

	React.useEffect(function() -- line: 139
		-- upvalues: v28 (copy), UserInputService (copy), v31 (copy)
		if not v28 then
			return
		end

		local connection = UserInputService.LastInputTypeChanged:Connect(function(p4) -- line: 143
			-- upvalues: v31 (copy)
			if p4 == Enum.UserInputType.Touch then
				v31(true)

				return
			end

			if p4 == Enum.UserInputType.MouseWheel or (p4 == Enum.UserInputType.MouseButton1 or (p4 == Enum.UserInputType.MouseMovement or p4 == Enum.UserInputType.Keyboard)) then
				v31(false)
			end
		end)

		return function() -- line: 150
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v28 })

	return v30
end
local function VerticalPager(p5) -- line: 158
	-- upvalues: Constants (copy), FFlagMomentsFeedSwipeSensitivityConfig (copy), FIntMomentsFeedSnapSensitivityMilli (copy), FIntMomentsFeedAnimationSpeed (copy), React (copy), useNativeScrollEnabled (copy), usePagerController (copy), usePagerInputNavigation (copy), SignalsReact (copy), snapMath (copy), v19 (copy), VerticalPagerContext2 (copy)
	local store = p5.store
	local renderItem = p5.renderItem
	local keyExtractor = p5.keyExtractor
	local analytics = p5.analytics
	local v37 = p5.tuning or {}
	local DEFAULT_SNAP_SENSITIVITY = Constants.DEFAULT_SNAP_SENSITIVITY
	local DEFAULT_ANIMATION_SPEED = Constants.DEFAULT_ANIMATION_SPEED

	if FFlagMomentsFeedSwipeSensitivityConfig then
		DEFAULT_SNAP_SENSITIVITY = FIntMomentsFeedSnapSensitivityMilli / 1000
		DEFAULT_ANIMATION_SPEED = FIntMomentsFeedAnimationSpeed
	end

	local v40 = v37.snapSensitivity or DEFAULT_SNAP_SENSITIVITY
	local v41 = v37.animationSpeed or DEFAULT_ANIMATION_SPEED
	local v42 = v37.overscan or Constants.DEFAULT_OVERSCAN
	local onEndReached = p5.onEndReached
	local v44 = v37.endReachedThreshold or Constants.DEFAULT_END_REACHED_THRESHOLD
	local v45 = p5.active == nil or p5.active
	local v46 = v37.gap or 0
	local initialIndex = p5.initialIndex
	local v48 = v37.keyboardNavigation or "global"

	local function keyOf(p6, n1: number) -- line: 189
		-- upvalues: keyExtractor (copy)
		if keyExtractor ~= nil then
			return (keyExtractor(p6, n1))
		end

		return (tostring(n1))
	end

	local v50, v51 = React.useState(nil)
	local v52, v53 = React.useState(0)
	local v54 = React.useRef(nil)
	local v55 = React.useRef({})
	local v56 = React.useCallback(function(p7) -- line: 203
		-- upvalues: v51 (copy), v53 (copy)
		v51(p7)

		if p7 then
			v53(p7.AbsoluteSize.Y)
		end
	end, {})
	local v57 = React.useCallback(function(p8) -- line: 210
		-- upvalues: v53 (copy)
		v53(p8.AbsoluteSize.Y)
	end, {})
	local v58 = useNativeScrollEnabled()
	local v59 = usePagerController({
		scrollingFrame = v50,
		store = store,
		itemHeight = v52,
		gap = v46,
		snapSensitivity = v40,
		animationSpeed = v41,
		active = v45,
		nativeScrollEnabled = v58,
		analytics = analytics
	})
	local v60 = usePagerInputNavigation({
		active = v45,
		keyboardNavigation = v48,
		goNext = v59.next,
		goPrevious = v59.previous
	})
	local v61 = SignalsReact.useSignalState(store.getCount)
	local v62 = SignalsReact.useSignalState(store.getItems)
	local v63 = SignalsReact.useSignalState(v59.getActiveIndex)

	React.useEffect(function() -- line: 247
		-- upvalues: onEndReached (copy), v61 (copy), v63 (copy), v44 (copy), v54 (copy), v62 (copy)
		if onEndReached == nil or v61 <= 0 then
			return
		end

		if v63 >= v61 - v44 and v54.current ~= v62 then
			v54.current = v62
			onEndReached()
		end
	end, {
		v63,
		v61,
		v62,
		v44,
		onEndReached
	})
	React.useEffect(function() -- line: 259
		-- upvalues: analytics (copy), v61 (copy), v62 (copy), v63 (copy), keyExtractor (copy), v55 (copy)
		local v80 = if analytics == nil then nil else analytics.onItemImpression

		if v80 == nil or v61 <= 0 then
			return
		end

		local v81 = v62[v63]

		if v81 == nil then
			return
		end

		local v82 = v63
		local v83 = if keyExtractor == nil then tostring(v82) else keyExtractor(v81, v82)

		if v55.current[v83] then
			return
		end

		v55.current[v83] = true
		v80(v63, v81)
	end, {
		v63,
		v61,
		v62,
		analytics,
		keyExtractor
	})

	local v64 = React.useMemo(function() -- line: 276
		-- upvalues: store (copy), v59 (copy), analytics (copy)
		return {
			store = store,
			getActiveIndex = v59.getActiveIndex,
			getScrollState = v59.getScrollState,
			scrollToIndex = v59.scrollToIndex,
			next = v59.next,
			previous = v59.previous,
			removeItem = v59.removeItem,
			analytics = analytics
		}
	end, {
		store,
		v59,
		analytics
	})
	local v65 = React.useRef(false)

	React.useEffect(function() -- line: 295
		-- upvalues: v65 (copy), initialIndex (copy), v61 (copy), store (copy)
		if v65.current then
			return
		end

		if initialIndex == nil then
			v65.current = true

			return
		end

		if v61 < initialIndex then
			return
		end

		v65.current = true

		if initialIndex ~= store.getCurrentIndex(false) then
			store.goToItem(initialIndex)
		end
	end, {
		initialIndex,
		v61,
		store.getCurrentIndex,
		store.goToItem
	})
	React.useImperativeHandle(p5.controllerRef, function() -- line: 314
		-- upvalues: v59 (copy)
		return v59
	end, { v59 })

	local v66 = v52 + v46
	local v67 = (not (v52 > 0) or not (v61 > 0)) and 0 or (v61 - 1) * v66 + v52
	local t2 = {}

	if v52 > 0 and v61 > 0 then
		local v69 = snapMath.getVisibleWindow(v63, v42, v61)

		for i = v69.startIndex, v69.endIndex do
			local v71 = v62[i]

			if v71 ~= nil then
				table.insert(t2, React.createElement(v19, {
					key = if keyExtractor == nil then tostring(i) else keyExtractor(v71, i),
					index = i,
					item = v71,
					itemHeight = v52,
					stride = v66,
					getActiveIndex = v59.getActiveIndex,
					renderItem = renderItem
				}))
			end
		end
	end

	return React.createElement(VerticalPagerContext2.Provider, {
		value = v64
	}, {
		Container = React.createElement("Frame", {
			BackgroundTransparency = 1,
			SelectionGroup = true,
			Active = v45,
			AnchorPoint = p5.AnchorPoint,
			LayoutOrder = p5.LayoutOrder,
			Position = p5.Position,
			Selectable = v45,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			Size = p5.Size or UDim2.fromScale(1, 1),
			ZIndex = p5.ZIndex,
			ref = v60
		}, {
			Scroller = React.createElement("ScrollingFrame", {
				AutomaticCanvasSize = Enum.AutomaticSize.None,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				CanvasSize = UDim2.new(1, 0, 0, v67),
				ClipsDescendants = true,
				ScrollBarThickness = 0,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollingEnabled = v45 and (v61 > 1 and v58),
				Selectable = false,
				Size = UDim2.fromScale(1, 1),
				ref = v56,
				[React.Change.AbsoluteSize] = v57
			}, t2)
		})
	})
end

return VerticalPager
