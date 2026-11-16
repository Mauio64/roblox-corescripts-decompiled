local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local module3 = require("@luauforge/bundled/dMx")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)

local useStyle = UIBlox.Core.Style.useStyle

local adaptiveScrollingContext = AvatarExperienceCommon.Hooks.AdaptiveScrollingContext

local module4 = require("@luauforge/deferred/gpi")
local fullView = AvatarExperienceCommon.Enums.FullView
local module5 = require("@luauforge/deferred/gpj")
local externalEventConnection = require("@game/CorePackages/Workspace/Packages/RoactUtils").ExternalEventConnection
local Otter = require(CorePackages.Packages.Otter)
local useAnimatedVisibility = AvatarExperienceCommon.Stores.AnimatedVisibilityStore.useAnimatedVisibility

local module6 = require("@luauforge/bundled/dOc")
local v5 = game:DefineFastFlag("AXAdaptiveScrollingEnableViewModeTransitionProp2", false) and module6()
local defineFastInt = game:DefineFastInt("AXAdaptiveScrollingOverscrollThreshold", 20)

local fFlagAXExpandPeekViewOnFirstScroll = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXExpandPeekViewOnFirstScroll

local fFlagAXSlotsPeekViewScrollFix = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSlotsPeekViewScrollFix

local defineFastInt2 = game:DefineFastInt("AXMaxScrollDirectionChangeAttempts", 2)

local fFlagAXHideMenuOnScroll = AvatarExperienceFlags.FFlagAXHideMenuOnScroll
local fFlagAXCatalogOffersBannerEnabled = AvatarExperienceFlags.FFlagAXCatalogOffersBannerEnabled

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAppIaScopedScrollAway = SharedFlags.FFlagAppIaScopedScrollAway
local fFlagEnableBottomNavOnMarketplace = SharedFlags.FFlagEnableBottomNavOnMarketplace

local v6 = { dampingRatio = 1, frequency = 5 }

local v7 = game:DefineFastInt("AXAdaptiveScrollingJustSelectedMillis", 500) / 1000

local function blendShiftFillForOpaqueGuiObject(shift_200, color)
	local v8 = 1 - math.clamp(shift_200.Transparency, 0, 1)
	return Color3.new(
		shift_200.Color3.R * v8 + color.R * (1 - v8),
		shift_200.Color3.G * v8 + color.G * (1 - v8),
		shift_200.Color3.B * v8 + color.B * (1 - v8)
	)
end

local v8 = { NONE = 0, UP = 1, DOWN = -1 }

local sceneFullView = fullView.SceneFullView
local none = fullView.None
local uiFullView = fullView.UIFullView

local function nearlyEquals(p2, p3): boolean
	return math.abs(p2 - p3) < 0.0001
end

local function withinThreshold(p2, p3, p4): boolean
	return math.abs(p2 - p3) < p4
end

local function AdaptiveScrollingView(props)
	local fullHeight = props.fullHeight
	local midHeight = props.midHeight
	local alwaysShowingHeight = props.alwaysShowingHeight

	local v9 = fullHeight - alwaysShowingHeight

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v10, v11 = React.useBinding(false)

	local animatedMenusStore = nil
	local ref3, ref4, ref5

	if fFlagAXHideMenuOnScroll then
		local v12 = useAnimatedVisibility()

		if v12 then
			animatedMenusStore = v12.animatedMenusStore
		end

		ref3 = React.useRef(0)
		ref4 = React.useRef(nil)
		ref5 = React.useRef(false)
	else
		ref4 = nil
		ref5 = nil
		ref3 = nil
	end

	local ref6 = React.useRef(nil)
	local ref7 = React.useRef(nil)

	local v12 = Foundation.Hooks.useTokens()
	local topBarHeight = props.topBarHeight or 0
	local size_900 = v12.Size.Size_900
	local size_100 = v12.Size.Size_100
	local fullHeightOptions = props.fullHeightOptions or {}

	local state, setState = React.useState({ instance = nil, time = 0 })

	local v13 = React.useCallback(function(p2): boolean
		return p2 == uiFullView or p2 == none
	end, {})

	local fn = not fFlagAXExpandPeekViewOnFirstScroll and function()
		if ref6.current then
			ref6.current:destroy()
			ref6.current = nil
		end
	end or React.useCallback(function()
		if ref6.current then
			ref6.current:destroy()
			ref6.current = nil
		end
	end, {})
	local v14

	if fFlagAXHideMenuOnScroll then
		v14 = React.useCallback(function()
			if ref4.current then
				task.cancel(ref4.current)
				ref4.current = nil
			end
		end, {})
	else
		v14 = nil
	end

	React.useEffect(function()
		return function()
			fn()

			if ref7 and ref7.current then
				ref7.current:destroy()
				ref7.current = nil
			end

			if fFlagAXHideMenuOnScroll then
				v14()
			end
		end
	end, {})

	local v15 = useStyle()
	local theme = v15.Theme
	local v16, v17, v18, v19

	if fFlagAXCatalogOffersBannerEnabled then
		local v20 = props.peekHeaderBackgroundActive == false
		v16 = props.peekHeaderUsesElevatedBackground ~= nil
		local v21 = props.peekHeaderUsesElevatedBackground == true and not v20

		v17 = React.useMemo(function()
			return {
				onPeekHeaderBackgroundActiveChanged = props.onPeekHeaderBackgroundActiveChanged
			}
		end, { props.onPeekHeaderBackgroundActiveChanged })

		if v21 then
			v18 = blendShiftFillForOpaqueGuiObject(v12.Color.Shift.Shift_200, theme.BackgroundDefault.Color)
		else
			v18 = theme.BackgroundDefault.Color
		end

		v19 = if v21 then 0 else theme.BackgroundDefault.Transparency
	end

	local function getGoToHeight(p2)
		if p2 == uiFullView then
			return fullHeight
		end

		if p2 == sceneFullView then
			return alwaysShowingHeight
		end

		return midHeight
	end

	local v20, v21 = React.useBinding(0)

	local v22, v23 = module5()
	local ref8 = React.useRef(v22)
	ref8.current = v22

	local v24, v25 = React.useBinding(v13(v22))
	local v26, v27, ref9, ref10, ref11

	if fFlagAXExpandPeekViewOnFirstScroll then
		v26, v27 = React.useBinding(true)
		ref9 = React.useRef(0)
		ref10 = React.useRef(0)
		ref11 = React.useRef(0)
	else
		ref11 = nil
		ref9 = nil
		v27 = nil
		ref10 = nil
	end

	local function isAnimating(): boolean
		return ref6.current ~= nil
	end

	local function adjustScrollingFramePosition()
		if v22 ~= none or v7 < tick() - state.time then
			return
		end

		local instance = state.instance

		if not instance then
			return
		end

		assert(instance, "")

		local rctScrollView = instance:FindFirstAncestor("RCTScrollView")
			or instance:FindFirstAncestor("scrollingFrame")
			or instance:FindFirstAncestorWhichIsA("ScrollingFrame")

		if not rctScrollView or rctScrollView == ref2.current then
			return
		end

		assert(rctScrollView, "")

		local y = instance.AbsolutePosition.Y
		local y2 = rctScrollView.CanvasPosition.Y

		local v28 = y - rctScrollView.AbsolutePosition.Y

		if math.abs(v28) > 5 then
			y2 += v28 - module3.WidgetListVerticalMargin
		end

		if not fFlagAXExpandPeekViewOnFirstScroll then
			y2 = math.clamp(y2, 0, rctScrollView.AbsoluteCanvasSize.Y - rctScrollView.AbsoluteWindowSize.Y)
		end

		if ref7 then
			if fFlagAXHideMenuOnScroll then
				ref5.current = true

				if props.enableAnimatedVisibility and animatedMenusStore then
					animatedMenusStore.show()
				end
			end

			local singleMotor = Otter.createSingleMotor(rctScrollView.CanvasPosition.Y)
			ref7.current = singleMotor
			singleMotor:onStep(function(p2)
				rctScrollView.ScrollVelocity = Vector2.new(0, 0)
				rctScrollView.CanvasPosition = Vector2.new(0, p2)
			end)
			singleMotor:onComplete(function()
				if ref7 and ref7.current then
					ref7.current:destroy()
					ref7.current = nil
				end

				if fFlagAXHideMenuOnScroll then
					ref5.current = false
				end
			end)
			singleMotor:setGoal(Otter.spring(y2, v6))
		end
	end

	local useCallback = React.useCallback
	local function fn2(p2, p3)
		local current = ref2.current

		if not current then
			return
		end

		assert(current, "")

		local y = current.CanvasPosition.Y
		local v28

		if p2 == uiFullView then
			v28 = fullHeight
		else
			v28 = if p2 == sceneFullView then alwaysShowingHeight else midHeight
		end

		local v29 = v28 - alwaysShowingHeight

		if ref6.current ~= nil then
			return
		end

		v25(v13(p2))

		if p2 == v22 and math.abs(v29 - y) < 0.0001 then
			return
		end

		v23(p2)

		if fFlagAXExpandPeekViewOnFirstScroll and p2 == none then
			adjustScrollingFramePosition()
		end

		if fFlagAXHideMenuOnScroll and props.enableAnimatedVisibility and animatedMenusStore then
			animatedMenusStore.show()
		end

		local singleMotor = Otter.createSingleMotor(y)
		ref6.current = singleMotor

		singleMotor:onStep(function(p4)
			current.ScrollVelocity = Vector2.new(0, 0)
			current.CanvasPosition = Vector2.new(0, p4)
		end)

		singleMotor:onComplete(function(p4)
			fn()

			if not fFlagAXExpandPeekViewOnFirstScroll then
				adjustScrollingFramePosition()
			end
		end)

		if p3 then
			singleMotor:setGoal(Otter.spring(v29, v6))
		else
			singleMotor:setGoal(Otter.instant(v29))
		end
	end

	local enableAnimatedVisibility = if fFlagAXHideMenuOnScroll then props.enableAnimatedVisibility else nil
	local v30 = useCallback(fn2, {
		v22,
		v23,
		alwaysShowingHeight,
		midHeight,
		fullHeight,
		enableAnimatedVisibility,
		if fFlagAXHideMenuOnScroll then animatedMenusStore else nil
	})

	React.useEffect(function()
		v30(ref8.current, false)
	end, { alwaysShowingHeight, midHeight, fullHeight })

	React.useEffect(function()
		v30(v22, true)
	end, { v22 })

	React.useEffect(function()
		if state.instance and v22 == none and ref6.current == nil then
			adjustScrollingFramePosition()
		end
	end, { state.instance, v22 })
	local v31

	if fFlagAXHideMenuOnScroll then
		v31 = React.useCallback(function(current)
			if not (props.enableAnimatedVisibility and animatedMenusStore) then
				return
			end

			local v32 = current - ref3.current

			v14()

			if math.abs(v32) > 1 then
				local v33 = v32 > 0
				local isVisible = animatedMenusStore.getIsVisible(false)
				local current2 = ref5.current
				local value = v10:getValue()

				if v33 and isVisible and not current2 and value then
					animatedMenusStore.hide()
				elseif not v33 and not isVisible and not current2 and value then
					animatedMenusStore.show()
				end
			end

			ref4.current = task.delay(0.5, function()
				animatedMenusStore.show()
				ref4.current = nil
			end)

			ref3.current = current
		end, { animatedMenusStore, props.enableAnimatedVisibility, v14, v10 })
	else
		v31 = nil
	end

	local useCallback2 = React.useCallback
	local function fn3(p2)
		local value = v10:getValue()

		if p2 < -defineFastInt and value then
			v25(false)
		end

		if fFlagAXHideMenuOnScroll and props.enableAnimatedVisibility then
			v31(p2)
		end
	end

	local enableAnimatedVisibility2 = if fFlagAXHideMenuOnScroll then props.enableAnimatedVisibility else nil
	local v34 = useCallback2(fn3, {
		v10,
		enableAnimatedVisibility2,
		if fFlagAXHideMenuOnScroll then v31 else nil
	})
	local ref12

	if fFlagAppIaScopedScrollAway and fFlagEnableBottomNavOnMarketplace then
		ref12 = React.useRef(0)
	else
		ref12 = nil
	end

	local useMemo = React.useMemo
	local function fn4()
		local v35 = {
			scrollingEnabledBinding = v24,
			onCanvasYChanged = 0,
			onCanvasPositionChanged = 0,
			setSelectedItemInstance = 0
		}
		local v36

		if fFlagAppIaScopedScrollAway and fFlagEnableBottomNavOnMarketplace then
			v36 = function(current)
				if not ref12 then
					return
				end

				local value = v10:getValue()

				if props.onCanvasYDelta and value then
					local v37 = current - ref12.current

					if v37 ~= 0 then
						props.onCanvasYDelta(v37)
					end
				end

				ref12.current = current

				if v34 then
					v34(current)
				end
			end
		else
			v36 = v34
		end

		v35.onCanvasYChanged = v36

		function v35.onCanvasPositionChanged(p2)
			if v34 then
				v34(p2.CanvasPosition.Y)
			end
		end

		function v35.setSelectedItemInstance(p2)
			if p2 then
				setState({ instance = p2, time = tick() })
			else
				setState({ instance = nil, time = 0 })
			end
		end

		return v35
	end

	local v36 = if fFlagAppIaScopedScrollAway and fFlagEnableBottomNavOnMarketplace then props.onCanvasYDelta else nil
	local v37 = useMemo(fn4, { v24, v34, v36 })

	local function onCanvasPositionChanged(p2)
		v21(p2.CanvasPosition.Y)
	end

	local function getTargetViewModeInRange(p2, p3, p4, p5)
		local v38

		if p4 == uiFullView then
			v38 = fullHeight
		else
			v38 = if p4 == sceneFullView then alwaysShowingHeight else midHeight
		end

		local v39

		if p3 == uiFullView then
			v39 = fullHeight
		else
			v39 = if p3 == sceneFullView then alwaysShowingHeight else midHeight
		end

		local v40 = v38 - v39

		local v41 = p5 < 0
		local v42 = p5 > 0

		if v22 == p4 then
			if v42 or p2 < v39 + v40 * 0.8 then
				return p3
			end

			return p4
		elseif v41 or v39 + v40 * 0.2 < p2 then
			return p4
		else
			return p3
		end
	end

	local v38 = React.useCallback(function()
		local current = ref2.current

		if not current then
			return nil
		end

		assert(current, "")

		local v39 = alwaysShowingHeight + current.CanvasPosition.Y

		local y = current.ScrollVelocity.Y
		local v40 = v22 == sceneFullView and math.abs(v39 - alwaysShowingHeight) < 1
		local v41 = v22 == uiFullView and math.abs(v39 - fullHeight) < 1
		local v42 = v22 == none and math.abs(v39 - midHeight) < 1

		if (v40 or v41 or v42) and y == 0 then
			return nil
		end

		if midHeight < v39 then
			local v43 = none
			local v44 = uiFullView
			local v45

			if v44 == uiFullView then
				v45 = fullHeight
			else
				v45 = if v44 == sceneFullView then alwaysShowingHeight else midHeight
			end

			local v46

			if v43 == uiFullView then
				v46 = fullHeight
			else
				v46 = if v43 == sceneFullView then alwaysShowingHeight else midHeight
			end

			local v47 = v45 - v46

			local v48 = y < 0
			local v49 = y > 0

			if v22 == v44 then
				if v49 or v39 < v46 + v47 * 0.8 then
					return v43
				end

				return v44
			elseif v48 or v46 + v47 * 0.2 < v39 then
				return v44
			else
				return v43
			end
		else
			local v43 = sceneFullView
			local v44 = none
			local v45

			if v44 == uiFullView then
				v45 = fullHeight
			else
				v45 = if v44 == sceneFullView then alwaysShowingHeight else midHeight
			end

			local v46

			if v43 == uiFullView then
				v46 = fullHeight
			else
				v46 = if v43 == sceneFullView then alwaysShowingHeight else midHeight
			end

			local v47 = v45 - v46

			local v48 = y < 0
			local v49 = y > 0

			if v22 == v44 then
				if v49 or v39 < v46 + v47 * 0.8 then
					return v43
				end

				return v44
			elseif v48 or v46 + v47 * 0.2 < v39 then
				return v44
			else
				return v43
			end
		end
	end, { v22, fullHeight, midHeight, alwaysShowingHeight })
	local v39

	if fFlagAXExpandPeekViewOnFirstScroll then
		v39 = React.useCallback(function()
			ref11.current = 0
			ref9.current = 0
			v27(true)
			v25(v13(v22))
		end, { v22, v27, v25, v13 })
	else
		v39 = nil
	end

	local useCallback3 = React.useCallback
	local function fn5(p2)
		if p2.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		v11(true)

		if fFlagAXExpandPeekViewOnFirstScroll and props.enableExpandPeekViewOnUpwardScroll then
			v39()
			ref10.current = p2.Position.Y
		end

		fn()
	end

	local v41 = if fFlagAXExpandPeekViewOnFirstScroll then v11 else nil
	local v42 = if fFlagAXExpandPeekViewOnFirstScroll then fn else nil
	local enableExpandPeekViewOnUpwardScroll

	if fFlagAXExpandPeekViewOnFirstScroll then
		enableExpandPeekViewOnUpwardScroll = props.enableExpandPeekViewOnUpwardScroll
	end

	local v44 = useCallback3(fn5, {
		v41,
		v42,
		enableExpandPeekViewOnUpwardScroll,
		if fFlagAXExpandPeekViewOnFirstScroll then v39 else nil
	})
	local v45

	if fFlagAXExpandPeekViewOnFirstScroll then
		v45 = React.useCallback(function(p2)
			if not (props.enableExpandPeekViewOnUpwardScroll and p2.UserInputType == Enum.UserInputType.Touch and v22 == none) then
				return
			end

			local v46 = p2.Position.Y - ref10.current

			if math.abs(v46) > 5 then
				local v47 = v46 > 0 and -1 or 1
				ref10.current = p2.Position.Y

				if ref9.current ~= v47 then
					ref11.current += 1

					if defineFastInt2 < ref11.current then
						local v49 = v38()

						if v49 then
							v30(v49, true)
						end
					else
						ref9.current = v47

						if v47 == -1 then
							v27(false)
						else
							v25(false)
							v27(true)
						end
					end
				end
			end
		end, {
			v22,
			v30,
			v38,
			v27,
			v25,
			v13,
			v11,
			v39,
			props.enableExpandPeekViewOnUpwardScroll
		})
	end

	local useCallback4 = React.useCallback
	local function fn6(p2)
		if p2.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		if
			fFlagAppIaScopedScrollAway
			and fFlagEnableBottomNavOnMarketplace
			and props.onScrollTouchEnded
		then
			props.onScrollTouchEnded()
		end

		if fFlagAXExpandPeekViewOnFirstScroll and props.enableExpandPeekViewOnUpwardScroll then
			v39()
		end

		v11(false)

		local v46 = v38()

		if v46 then
			v30(v46, true)
		else
			v25(v13(ref8.current))
		end
	end

	local v47 = if fFlagAppIaScopedScrollAway and fFlagEnableBottomNavOnMarketplace then props.onScrollTouchEnded else nil
	local v48 = useCallback4(fn6, { v30, v38, v47 })

	local v49 = React.useCallback(function()
		if v22 == uiFullView or v22 == sceneFullView then
			v30(none, true)
		else
			v30(uiFullView, true)
		end
	end, { v22, v30 })

	local v50 = React.useCallback(function(p2)
		local v51 = v9 - p2

		if v51 > 100 then
			return 1
		end

		return v51 / 80
	end, {})

	local v51 = React.useCallback(function(p2)
		local v52 = v9 - p2

		if v52 > 50 then
			return UDim2.new(0, size_900, 0, size_100)
		end

		local v53 = v52 / 50
		local v54 = size_900 * v53
		local v55 = math.clamp(size_100 * v53, 1, size_100)
		return UDim2.new(1 - v53, v54, 0, v55)
	end, {})
	local v52, v53

	if fFlagAXHideMenuOnScroll then
		v52 = React.useCallback(function(p2)
			return math.clamp((fullHeight - (p2 + alwaysShowingHeight)) / (fullHeight - midHeight), 0, 1) * 12
		end, { fullHeight, alwaysShowingHeight, midHeight })

		v53 = React.useCallback(function(p2)
			local v54 = v9 - p2

			if v54 > 50 then
				return module3.PeekHeaderHeight
			end

			local v55 = v54 / 50

			return module3.PeekHeaderMinHeight + (module3.PeekHeaderHeight - module3.PeekHeaderMinHeight) * v55
		end, { v9 })
	else
		v53 = nil
		v52 = nil
	end

	local createElement = React.createElement
	local v55 = { BackgroundTransparency = 1, Size = UDim2.new(1, 1, 1, 0), ref = ref }

	local v56 = {
		DropShadowBackground = React.createElement("Frame", {
			ZIndex = 0,
			Size = UDim2.new(1, 0, 0, 36),
			Position = v20:map(function(p2)
				return UDim2.new(0, 0, 1, -p2 - alwaysShowingHeight - 30)
			end)
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, v15.Theme.DropShadow.Color),
					ColorSequenceKeypoint.new(1, v15.Theme.DropShadow.Color)
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0.7)
				})
			})
		}),
		AdaptiveScrollingViewOpaqueBackground = 0,
		ClipFrame = 0
	}

	local v57 = if fullHeightOptions and fullHeightOptions.opaqueBackground then React.createElement("Frame", {
		ZIndex = 1,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromOffset(0, -topBarHeight),
		BackgroundTransparency = v20:map(v50),
		BackgroundColor3 = theme.BackgroundDefault.Color,
		BorderSizePixel = 0
	}) else nil
	v56.AdaptiveScrollingViewOpaqueBackground = v57

	local createElement2 = React.createElement
	local v59 = {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 1),
		Size = v20:map(function(p2)
			return UDim2.new(1, 0, 0, p2 + alwaysShowingHeight)
		end),
		ZIndex = 2
	}

	local createElement3 = React.createElement
	local onCanvasPositionChangedsByCanvasPosition = {}
	onCanvasPositionChangedsByCanvasPosition.ref = ref2
	onCanvasPositionChangedsByCanvasPosition.AnchorPoint = Vector2.new(0.5, 1)
	onCanvasPositionChangedsByCanvasPosition.Position = UDim2.fromScale(0.5, 1)
	onCanvasPositionChangedsByCanvasPosition.Size = UDim2.new(1, 0, 0, fullHeight)
	onCanvasPositionChangedsByCanvasPosition.CanvasSize = UDim2.new(1, 0, 0, fullHeight + v9)
	onCanvasPositionChangedsByCanvasPosition.BackgroundTransparency = 1
	local v62

	if fFlagAXSlotsPeekViewScrollFix and props.disableViewChangeByScroll then
		v62 = props.disableViewChangeByScroll:map(function(p2)
			if p2 then
				return Enum.ScrollingDirection.X
			end

			return Enum.ScrollingDirection.Y
		end)
	else
		v62 = Enum.ScrollingDirection.Y
	end

	onCanvasPositionChangedsByCanvasPosition.ScrollingDirection = v62

	onCanvasPositionChangedsByCanvasPosition.ScrollBarThickness = 0
	local v63

	if v5 then
		if props.enableViewModeTransition == nil then
			v63 = not fFlagAXExpandPeekViewOnFirstScroll or v26
		else
			v63 = props.enableViewModeTransition
		end
	end

	onCanvasPositionChangedsByCanvasPosition.ScrollingEnabled = v63

	onCanvasPositionChangedsByCanvasPosition.ElasticBehavior = Enum.ElasticBehavior.Never
	onCanvasPositionChangedsByCanvasPosition[React.Change.CanvasPosition] = onCanvasPositionChanged
	local children = {
		VerticalLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center
		}),
		Spacer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Active = false,
			Size = UDim2.new(1, 0, 0, v9),
			LayoutOrder = 1
		}),
		PeekHeader = 0,
		Banner = 0,
		ExpandingContent = 0,
		OnInputBegan = 0,
		OnInputChanged = 0,
		OnInputEnded = 0
	}

	local createElement4 = React.createElement
	local v66

	if fFlagAXHideMenuOnScroll and fullHeightOptions and fullHeightOptions.draggerToDivider then
		v66 = v20:map(function(p2)
			return UDim2.new(1, 0, 0, v53(p2))
		end)
	else
		v66 = UDim2.new(1, 0, 0, module3.PeekHeaderHeight)
	end

	local v65 = {
		Text = "",
		LayoutOrder = 2,
		ZIndex = 2,
		BackgroundTransparency = 1,
		Size = v66,
		BorderSizePixel = 0,
		[React.Event.Activated] = v49
	}

	local createElement5 = React.createElement
	local v69

	if fFlagAXHideMenuOnScroll and fullHeightOptions and fullHeightOptions.draggerToDivider then
		v69 = v20:map(function(p2)
			local v70 = v52(p2)
			return UDim2.new(1, 0, 0, v53(p2) + v70)
		end)
	else
		v69 = UDim2.new(1, 0, 0, module3.PeekHeaderHeight + 12)
	end

	local v70 = if fFlagAXCatalogOffersBannerEnabled and v16 then v19 else theme.BackgroundDefault.Transparency
	local v71

	if fFlagAXCatalogOffersBannerEnabled and v16 then
		v71 = v18
	else
		v71 = if props.banner then theme.BackgroundContrast.Color else theme.BackgroundDefault.Color
	end

	local createElement6 = React.createElement
	local v75

	if fFlagAXHideMenuOnScroll and fullHeightOptions and fullHeightOptions.draggerToDivider then
		v75 = v20:map(function(p2)
			return UDim.new(0, v52(p2))
		end)
	else
		v75 = UDim.new(0, 12)
	end

	local children2 = {
		PeekHeaderBackground = createElement5("Frame", {
			LayoutOrder = 2,
			ZIndex = 1,
			Size = v69,
			BackgroundTransparency = v70,
			BackgroundColor3 = v71,
			BorderSizePixel = 0,
			Active = false
		}, {
			UICorner = createElement6("UICorner", { CornerRadius = v75 })
		}),
		Dragger = 0
	}

	local createElement7 = React.createElement
	local v77 = {
		ZIndex = 2,
		BackgroundColor3 = v12.Color.Stroke.Emphasis.Color3,
		BackgroundTransparency = v12.Color.Stroke.Emphasis.Transparency,
		Size = 0,
		AnchorPoint = 0,
		Position = 0,
		BorderSizePixel = 0,
		Active = false
	}
	local v78 = if fullHeightOptions and fullHeightOptions.draggerToDivider then v20:map(v51) else UDim2.new(0, size_900, 0, size_100)
	v77.Size = v78

	v77.AnchorPoint = Vector2.new(0.5, 0.5)
	v77.Position = UDim2.fromScale(0.5, 0.5)
	children2.Dragger = createElement7("Frame", v77, {
		DraggerUICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 12)
		})
	})
	children.PeekHeader = createElement4("TextButton", v65, children2)
	local v79

	if props.banner then
		local createElement8 = React.createElement

		if not (fFlagAXCatalogOffersBannerEnabled and v16) then
			v19 = nil
		end

		if not (fFlagAXCatalogOffersBannerEnabled and v16) then
			v18 = theme.BackgroundContrast.Color
		end

		v79 = createElement8("Frame", {
			BackgroundTransparency = v19,
			BackgroundColor3 = v18,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 3,
			ZIndex = 3,
			BorderSizePixel = 0
		}, { Content = props.banner })
	end

	children.Banner = v79

	local createElement8 = React.createElement
	local v81 = {
		BackgroundTransparency = 1,
		Size = v20:map(function(p2)
			return UDim2.new(1, 0, 0, p2 + alwaysShowingHeight)
		end),
		LayoutOrder = 4,
		ZIndex = 3
	}

	local v83 = if fFlagAXCatalogOffersBannerEnabled then React.createElement(
		adaptiveScrollingContext.Provider,
		{ value = v37 },
		{
			PeekHeaderBackground = React.createElement(module4.Provider, { value = v17 }, props.children)
		}
	) else React.createElement(adaptiveScrollingContext.Provider, { value = v37 }, props.children)
	children.ExpandingContent = createElement8("Frame", v81, {
		AdaptiveScrollingProvider = v83
	})

	children.OnInputBegan = React.createElement(externalEventConnection, {
		event = UserInputService.InputBegan,
		callback = v44
	})

	local v84 = if fFlagAXExpandPeekViewOnFirstScroll then React.createElement(externalEventConnection, {
		event = UserInputService.InputChanged,
		callback = v45
	}) else nil
	children.OnInputChanged = v84

	children.OnInputEnded = React.createElement(externalEventConnection, {
		event = UserInputService.InputEnded,
		callback = v48
	})
	v56.ClipFrame = createElement2("Frame", v59, {
		ScrollingFrame = createElement3(
			"ScrollingFrame",
			onCanvasPositionChangedsByCanvasPosition,
			children
		)
	})
	return createElement("Frame", v55, v56)
end

return AdaptiveScrollingView
