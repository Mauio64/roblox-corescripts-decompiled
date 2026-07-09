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
local VerticalPagerContext = require(script.Parent.VerticalPagerContext)
local VerticalPagerContext2 = VerticalPagerContext.VerticalPagerContext
local PagerItemContext = VerticalPagerContext.PagerItemContext

local function PagerItemProviderInner(t1: {[any]: any}) -- line: 56
	-- upvalues: React (copy), Signals (copy), PagerItemContext (copy), snapMath (copy)
	local index = t1.index
	local getActiveIndex = t1.getActiveIndex
	local v22 = React.useMemo(function() -- line: 60
		-- upvalues: Signals (copy), getActiveIndex (copy), index (copy)
		return Signals.createComputed(function(p1) -- line: 61
			-- upvalues: getActiveIndex (copy), index (copy)
			return getActiveIndex(p1) == index
		end)
	end, {
		getActiveIndex,
		index
	})
	local v23 = React.useMemo(function() -- line: 69
		-- upvalues: Signals (copy), getActiveIndex (copy), index (copy)
		return Signals.createComputed(function(p2) -- line: 70
			-- upvalues: getActiveIndex (copy), index (copy)
			return math.abs(getActiveIndex(p2) - index) <= 1
		end)
	end, {
		getActiveIndex,
		index
	})
	local v24 = React.useMemo(function() -- line: 75
		-- upvalues: index (copy), t1 (copy), v22 (copy), v23 (copy)
		return {
			index = index,
			item = t1.item,
			getIsActive = v22,
			getIsVisible = v23
		}
	end, {
		index,
		t1.item,
		v22,
		v23
	})

	return React.createElement(PagerItemContext.Provider, {
		value = v24
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

local v16 = React.memo(PagerItemProviderInner)

local function useNativeScrollEnabled() -- line: 120
	-- upvalues: GetFFlagMomentsDesktopWheelPaging (copy), React (copy), UserInputService (copy)
	local v25 = GetFFlagMomentsDesktopWheelPaging()

	local function isNonTouch(p3) -- line: 125
		return p3 == Enum.UserInputType.MouseWheel or (p3 == Enum.UserInputType.MouseButton1 or (p3 == Enum.UserInputType.MouseMovement or p3 == Enum.UserInputType.Keyboard))
	end

	local v27, v28 = React.useState(function() -- line: 132
		-- upvalues: v25 (copy), UserInputService (copy)
		local v68 = v25

		if v68 then
			local LastInputType = UserInputService:GetLastInputType()

			v68 = LastInputType == Enum.UserInputType.MouseWheel or (LastInputType == Enum.UserInputType.MouseButton1 or (LastInputType == Enum.UserInputType.MouseMovement or LastInputType == Enum.UserInputType.Keyboard))
		end

		return not v68
	end)

	React.useEffect(function() -- line: 136
		-- upvalues: v25 (copy), UserInputService (copy), v28 (copy)
		if not v25 then
			return
		end

		local connection = UserInputService.LastInputTypeChanged:Connect(function(p4) -- line: 140
			-- upvalues: v28 (copy)
			if p4 == Enum.UserInputType.Touch then
				v28(true)

				return
			end

			if p4 == Enum.UserInputType.MouseWheel or (p4 == Enum.UserInputType.MouseButton1 or (p4 == Enum.UserInputType.MouseMovement or p4 == Enum.UserInputType.Keyboard)) then
				v28(false)
			end
		end)

		return function() -- line: 147
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v25 })

	return v27
end
local function VerticalPager(p5) -- line: 155
	-- upvalues: Constants (copy), React (copy), useNativeScrollEnabled (copy), usePagerController (copy), usePagerInputNavigation (copy), SignalsReact (copy), snapMath (copy), v16 (copy), VerticalPagerContext2 (copy)
	local store = p5.store
	local renderItem = p5.renderItem
	local keyExtractor = p5.keyExtractor
	local analytics = p5.analytics
	local v34 = p5.tuning or {}
	local v35 = v34.snapSensitivity or Constants.DEFAULT_SNAP_SENSITIVITY
	local v36 = v34.animationSpeed or Constants.DEFAULT_ANIMATION_SPEED
	local v37 = v34.overscan or Constants.DEFAULT_OVERSCAN
	local onEndReached = p5.onEndReached
	local v39 = v34.endReachedThreshold or Constants.DEFAULT_END_REACHED_THRESHOLD
	local v40 = p5.active == nil or p5.active
	local v41 = v34.gap or 0
	local initialIndex = p5.initialIndex
	local v43 = v34.keyboardNavigation or "global"

	local function keyOf(p6, n1: number) -- line: 176
		-- upvalues: keyExtractor (copy)
		if keyExtractor ~= nil then
			return (keyExtractor(p6, n1))
		end

		return (tostring(n1))
	end

	local v45, v46 = React.useState(nil)
	local v47, v48 = React.useState(0)
	local v49 = React.useRef(nil)
	local v50 = React.useRef({})
	local v51 = React.useCallback(function(p7) -- line: 190
		-- upvalues: v46 (copy), v48 (copy)
		v46(p7)

		if p7 then
			v48(p7.AbsoluteSize.Y)
		end
	end, {})
	local v52 = React.useCallback(function(p8) -- line: 197
		-- upvalues: v48 (copy)
		v48(p8.AbsoluteSize.Y)
	end, {})
	local v53 = useNativeScrollEnabled()
	local v54 = usePagerController({
		scrollingFrame = v45,
		store = store,
		itemHeight = v47,
		gap = v41,
		snapSensitivity = v35,
		animationSpeed = v36,
		active = v40,
		nativeScrollEnabled = v53,
		analytics = analytics
	})
	local v55 = usePagerInputNavigation({
		active = v40,
		keyboardNavigation = v43,
		goNext = v54.next,
		goPrevious = v54.previous
	})
	local v56 = SignalsReact.useSignalState(store.getCount)
	local v57 = SignalsReact.useSignalState(store.getItems)
	local v58 = SignalsReact.useSignalState(v54.getActiveIndex)

	React.useEffect(function() -- line: 234
		-- upvalues: onEndReached (copy), v56 (copy), v58 (copy), v39 (copy), v49 (copy), v57 (copy)
		if onEndReached == nil or v56 <= 0 then
			return
		end

		if v58 >= v56 - v39 and v49.current ~= v57 then
			v49.current = v57
			onEndReached()
		end
	end, {
		v58,
		v56,
		v57,
		v39,
		onEndReached
	})
	React.useEffect(function() -- line: 246
		-- upvalues: analytics (copy), v56 (copy), v57 (copy), v58 (copy), keyExtractor (copy), v50 (copy)
		local v75 = if analytics == nil then nil else analytics.onItemImpression

		if v75 == nil or v56 <= 0 then
			return
		end

		local v76 = v57[v58]

		if v76 == nil then
			return
		end

		local v77 = v58
		local v78 = if keyExtractor == nil then tostring(v77) else keyExtractor(v76, v77)

		if v50.current[v78] then
			return
		end

		v50.current[v78] = true
		v75(v58, v76)
	end, {
		v58,
		v56,
		v57,
		analytics,
		keyExtractor
	})

	local v59 = React.useMemo(function() -- line: 263
		-- upvalues: store (copy), v54 (copy), analytics (copy)
		return {
			store = store,
			getActiveIndex = v54.getActiveIndex,
			getScrollState = v54.getScrollState,
			scrollToIndex = v54.scrollToIndex,
			next = v54.next,
			previous = v54.previous,
			removeItem = v54.removeItem,
			analytics = analytics
		}
	end, {
		store,
		v54,
		analytics
	})
	local v60 = React.useRef(false)

	React.useEffect(function() -- line: 282
		-- upvalues: v60 (copy), initialIndex (copy), v56 (copy), store (copy)
		if v60.current then
			return
		end

		if initialIndex == nil then
			v60.current = true

			return
		end

		if v56 < initialIndex then
			return
		end

		v60.current = true

		if initialIndex ~= store.getCurrentIndex(false) then
			store.goToItem(initialIndex)
		end
	end, {
		initialIndex,
		v56,
		store.getCurrentIndex,
		store.goToItem
	})
	React.useImperativeHandle(p5.controllerRef, function() -- line: 301
		-- upvalues: v54 (copy)
		return v54
	end, { v54 })

	local v61 = v47 + v41
	local v62 = (not (v47 > 0) or not (v56 > 0)) and 0 or (v56 - 1) * v61 + v47
	local t2 = {}

	if v47 > 0 and v56 > 0 then
		local v64 = snapMath.getVisibleWindow(v58, v37, v56)

		for i = v64.startIndex, v64.endIndex do
			local v66 = v57[i]

			if v66 ~= nil then
				table.insert(t2, React.createElement(v16, {
					key = if keyExtractor == nil then tostring(i) else keyExtractor(v66, i),
					index = i,
					item = v66,
					itemHeight = v47,
					stride = v61,
					getActiveIndex = v54.getActiveIndex,
					renderItem = renderItem
				}))
			end
		end
	end

	return React.createElement(VerticalPagerContext2.Provider, {
		value = v59
	}, {
		Container = React.createElement("Frame", {
			BackgroundTransparency = 1,
			SelectionGroup = true,
			Active = v40,
			AnchorPoint = p5.AnchorPoint,
			LayoutOrder = p5.LayoutOrder,
			Position = p5.Position,
			Selectable = v40,
			SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
			SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
			Size = p5.Size or UDim2.fromScale(1, 1),
			ZIndex = p5.ZIndex,
			ref = v55
		}, {
			Scroller = React.createElement("ScrollingFrame", {
				AutomaticCanvasSize = Enum.AutomaticSize.None,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				CanvasSize = UDim2.new(1, 0, 0, v62),
				ClipsDescendants = true,
				ScrollBarThickness = 0,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				ScrollingEnabled = v40 and (v56 > 1 and v53),
				Selectable = false,
				Size = UDim2.fromScale(1, 1),
				ref = v51,
				[React.Change.AbsoluteSize] = v52
			}, t2)
		})
	})
end

return VerticalPager
