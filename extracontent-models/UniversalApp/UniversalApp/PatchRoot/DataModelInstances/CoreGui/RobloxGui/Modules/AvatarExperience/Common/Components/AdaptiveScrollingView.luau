local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Modules = CoreGui.RobloxGui.Modules
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local useStyle = UIBlox.Core.Style.useStyle
local AdaptiveScrollingContext = AvatarExperienceCommon.Hooks.AdaptiveScrollingContext
local AdaptiveScrollingViewPeekHeaderBackgroundContext = require(script.Parent.AdaptiveScrollingViewPeekHeaderBackgroundContext)
local FullView = AvatarExperienceCommon.Enums.FullView
local useFullView = require(Modules.AvatarExperience.Common.Hooks.useFullView)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local Otter = require(CorePackages.Packages.Otter)
local useAnimatedVisibility = AvatarExperienceCommon.Stores.AnimatedVisibilityStore.useAnimatedVisibility
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local v20 = game:DefineFastFlag("AXAdaptiveScrollingEnableViewModeTransitionProp2", false) and GetFFlagAXEnableSlotBasedEditor()
local v21 = game:DefineFastInt("AXAdaptiveScrollingOverscrollThreshold", 20)
local v22 = game:DefineFastFlag("AXFixAdaptiveScrollingDraggerColor", false)
local FFlagAXExpandPeekViewOnFirstScroll = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXExpandPeekViewOnFirstScroll
local FFlagAXSlotsPeekViewScrollFix = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotsPeekViewScrollFix
local v25 = game:DefineFastInt("AXMaxScrollDirectionChangeAttempts", 2)
local FFlagAXHideMenuOnScroll = AvatarExperienceFlags.FFlagAXHideMenuOnScroll
local FFlagAXAdaptiveScrollingViewBanner = AvatarExperienceFlags.FFlagAXAdaptiveScrollingViewBanner
local FFlagAXCatalogOffersBannerEnabled = AvatarExperienceFlags.FFlagAXCatalogOffersBannerEnabled
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAppIaScopedScrollAway = SharedFlags.FFlagAppIaScopedScrollAway
local FFlagEnableBottomNavOnMarketplace = SharedFlags.FFlagEnableBottomNavOnMarketplace
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local t1 = {
	dampingRatio = 1,
	frequency = 5
}
local v34 = game:DefineFastInt("AXAdaptiveScrollingJustSelectedMillis", 500) / 1000

local function blendShiftFillForOpaqueGuiObject(t2: {[any]: any}, color3: Color3) -- line: 123
	local v45 = 1 - math.clamp(t2.Transparency, 0, 1)

	return Color3.new(t2.Color3.R * v45 + color3.R * (1 - v45), t2.Color3.G * v45 + color3.G * (1 - v45), t2.Color3.B * v45 + color3.B * (1 - v45))
end

local _ = {
	NONE = 0,
	UP = 1,
	DOWN = -1
}
local SceneFullView = FullView.SceneFullView
local None = FullView.None
local UIFullView = FullView.UIFullView

local function nearlyEquals(n1: number, n2: number) -- line: 168
	return math.abs(n1 - n2) < 0.0001
end
local function withinThreshold(n3: number, n4: number, n5: number) -- line: 172
	return n5 > math.abs(n3 - n4)
end
local function AdaptiveScrollingView(t3: {[any]: any}) -- line: 179
	-- upvalues: React (copy), FFlagAXHideMenuOnScroll (copy), useAnimatedVisibility (copy), Foundation (copy), UIFullView (copy), None (copy), FFlagAXExpandPeekViewOnFirstScroll (copy), useStyle (copy), FFlagAXCatalogOffersBannerEnabled (copy), blendShiftFillForOpaqueGuiObject (copy), SceneFullView (copy), useFullView (copy), v34 (copy), Constants (copy), Otter (copy), t1 (copy), v21 (copy), FFlagAppIaScopedScrollAway (copy), FFlagEnableBottomNavOnMarketplace (copy), v25 (copy), FFlagAXAdaptiveScrollingViewBanner (copy), FFlagAXSlotsPeekViewScrollFix (copy), v20 (copy), v22 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), AdaptiveScrollingContext (copy), AdaptiveScrollingViewPeekHeaderBackgroundContext (copy), ExternalEventConnection (copy), UserInputService (copy)
	local fullHeight = t3.fullHeight
	local midHeight = t3.midHeight
	local alwaysShowingHeight = t3.alwaysShowingHeight
	local v55 = fullHeight - alwaysShowingHeight
	local v56 = React.useRef(nil)
	local v57 = React.useRef(nil)
	local v58, v59 = React.useBinding(false)
	local animatedMenusStore = nil
	local u61 = nil
	local u62 = nil
	local u63 = nil

	if FFlagAXHideMenuOnScroll then
		local v64 = useAnimatedVisibility()

		if v64 then
			animatedMenusStore = v64.animatedMenusStore
		end

		u61 = React.useRef(0)
		u62 = React.useRef(nil)
		u63 = React.useRef(false)
	end

	local v65 = React.useRef(nil)
	local v66 = React.useRef(nil)
	local v67 = Foundation.Hooks.useTokens()
	local v68 = t3.topBarHeight or 0
	local Size_900 = v67.Size.Size_900
	local Size_100 = v67.Size.Size_100
	local v71 = t3.fullHeightOptions or {}
	local v72, v73 = React.useState({
		instance = nil,
		time = 0
	})
	local v74 = React.useCallback(function(p1) -- line: 218
		-- upvalues: UIFullView (copy), None (copy)
		return p1 == UIFullView or p1 == None
	end, {})
	local u75 = not FFlagAXExpandPeekViewOnFirstScroll and function() -- line: 231
		-- upvalues: v65 (copy)
		if v65.current then
			v65.current:destroy()
			v65.current = nil
		end
	end or React.useCallback(function() -- line: 224
		-- upvalues: v65 (copy)
		if v65.current then
			v65.current:destroy()
			v65.current = nil
		end
	end, {})
	local u76 = nil

	if FFlagAXHideMenuOnScroll then
		u76 = React.useCallback(function() -- line: 250
			-- upvalues: u62 (ref)
			if u62.current then
				task.cancel(u62.current)
				u62.current = nil
			end
		end, {})
	end

	React.useEffect(function() -- line: 258
		-- upvalues: u75 (ref), v66 (copy), FFlagAXHideMenuOnScroll (copy), u76 (ref)
		return function() -- line: 259
			-- upvalues: u75 (ref), v66 (copy), FFlagAXHideMenuOnScroll (copy), u76 (ref)
			u75()

			if v66 and v66.current then
				v66.current:destroy()
				v66.current = nil
			end

			if FFlagAXHideMenuOnScroll then
				u76()
			end
		end
	end, {})

	local v77 = useStyle()
	local Theme = v77.Theme
	local v79 = nil
	local v80 = nil
	local v81 = nil
	local v82 = nil

	if FFlagAXCatalogOffersBannerEnabled then
		local v83 = t3.peekHeaderBackgroundActive == false

		v80 = t3.peekHeaderUsesElevatedBackground ~= nil

		local v84 = t3.peekHeaderUsesElevatedBackground == true and not v83

		v79 = React.useMemo(function() -- line: 278
			-- upvalues: t3 (copy)
			return {
				onPeekHeaderBackgroundActiveChanged = t3.onPeekHeaderBackgroundActiveChanged
			}
		end, { t3.onPeekHeaderBackgroundActiveChanged })
		v81 = if not v84 then Theme.BackgroundDefault.Color else blendShiftFillForOpaqueGuiObject(v67.Color.Shift.Shift_200, Theme.BackgroundDefault.Color)
		v82 = if not v84 then Theme.BackgroundDefault.Transparency else 0
	end

	local function getGoToHeight(p2) -- line: 291
		-- upvalues: UIFullView (copy), fullHeight (copy), SceneFullView (copy), alwaysShowingHeight (copy), midHeight (copy)
		if p2 == UIFullView then
			return fullHeight
		end

		if p2 == SceneFullView then
			return alwaysShowingHeight
		end

		return midHeight
	end

	local v86, v87 = React.useBinding(0)
	local v88, v89 = useFullView()
	local v90 = React.useRef(v88)

	v90.current = v88

	local v91, v92 = React.useBinding(v74(v88))
	local v93 = nil
	local u94 = nil
	local u95 = nil
	local u96 = nil
	local u97 = nil

	if FFlagAXExpandPeekViewOnFirstScroll then
		local v98

		v93, v98 = React.useBinding(true)
		u94 = v98
		u95 = React.useRef(0)
		u96 = React.useRef(0)
		u97 = React.useRef(0)
	end

	local function isAnimating() -- line: 317
		-- upvalues: v65 (copy)
		return v65.current ~= nil
	end
	local function adjustScrollingFramePosition() -- line: 323
		-- upvalues: v88 (copy), None (copy), v72 (copy), v34 (copy), v57 (copy), Constants (copy), FFlagAXExpandPeekViewOnFirstScroll (copy), v66 (copy), FFlagAXHideMenuOnScroll (copy), u63 (ref), t3 (copy), animatedMenusStore (ref), Otter (copy), t1 (copy)
		if v88 ~= None then
			return
		end

		if tick() - v72.time > v34 then
			return
		end

		local instance = v72.instance

		if not instance then
			return
		end

		assert(instance, "")

		local u121 = instance:FindFirstAncestor("RCTScrollView") or (instance:FindFirstAncestor("scrollingFrame") or instance:FindFirstAncestorWhichIsA("ScrollingFrame"))

		if not u121 or u121 == v57.current then
			return
		end

		assert(u121, "")

		local AbsolutePositionY = instance.AbsolutePosition.Y
		local CanvasPositionY = u121.CanvasPosition.Y
		local v124 = AbsolutePositionY - u121.AbsolutePosition.Y

		if math.abs(v124) > 5 then
			CanvasPositionY += v124 - Constants.WidgetListVerticalMargin
		end

		if not FFlagAXExpandPeekViewOnFirstScroll then
			CanvasPositionY = math.clamp(CanvasPositionY, 0, u121.AbsoluteCanvasSize.Y - u121.AbsoluteWindowSize.Y)
		end

		if v66 then
			if FFlagAXHideMenuOnScroll then
				u63.current = true

				if t3.enableAnimatedVisibility and animatedMenusStore then
					animatedMenusStore.show()
				end
			end

			local v125 = Otter.createSingleMotor(u121.CanvasPosition.Y)

			v66.current = v125
			v125:onStep(function(p3) -- line: 383
				-- upvalues: u121 (ref)
				u121.ScrollVelocity = Vector2.new(0, 0)
				u121.CanvasPosition = Vector2.new(0, p3)
			end)
			v125:onComplete(function() -- line: 387
				-- upvalues: v66 (copy), FFlagAXHideMenuOnScroll (copy), u63 (ref)
				if v66 and v66.current then
					v66.current:destroy()
					v66.current = nil
				end

				if FFlagAXHideMenuOnScroll then
					u63.current = false
				end
			end)
			v125:setGoal(Otter.spring(CanvasPositionY, t1))
		end
	end

	local v101 = React.useCallback(function(p4, b1: boolean) -- line: 397
		-- upvalues: v57 (copy), UIFullView (copy), fullHeight (copy), SceneFullView (copy), alwaysShowingHeight (copy), midHeight (copy), v65 (copy), v92 (copy), v74 (copy), v88 (copy), v89 (copy), FFlagAXExpandPeekViewOnFirstScroll (copy), None (copy), adjustScrollingFramePosition (copy), FFlagAXHideMenuOnScroll (copy), t3 (copy), animatedMenusStore (ref), Otter (copy), u75 (ref), t1 (copy)
		local current = v57.current

		if not current then
			return
		end

		assert(current, "")

		local CanvasPositionY = current.CanvasPosition.Y
		local v130 = ((if p4 ~= UIFullView then (if p4 ~= SceneFullView then midHeight else alwaysShowingHeight) else fullHeight)) - alwaysShowingHeight

		if v65.current ~= nil then
			return
		end

		v92(v74(p4))

		if p4 == v88 and math.abs(v130 - CanvasPositionY) < 0.0001 then
			return
		end

		v89(p4)

		if FFlagAXExpandPeekViewOnFirstScroll and p4 == None then
			adjustScrollingFramePosition()
		end

		if FFlagAXHideMenuOnScroll and t3.enableAnimatedVisibility and animatedMenusStore then
			animatedMenusStore.show()
		end

		local v131 = Otter.createSingleMotor(CanvasPositionY)

		v65.current = v131
		v131:onStep(function(p5) -- line: 431
			-- upvalues: current (copy)
			current.ScrollVelocity = Vector2.new(0, 0)
			current.CanvasPosition = Vector2.new(0, p5)
		end)
		v131:onComplete(function(_) -- line: 436
			-- upvalues: u75 (ref), FFlagAXExpandPeekViewOnFirstScroll (copy), adjustScrollingFramePosition (copy)
			u75()

			if not FFlagAXExpandPeekViewOnFirstScroll then
				adjustScrollingFramePosition()
			end
		end)

		if b1 then
			v131:setGoal(Otter.spring(v130, t1))

			return
		end

		v131:setGoal(Otter.instant(v130))
	end, {
		v88,
		v89,
		alwaysShowingHeight,
		midHeight,
		fullHeight,
		if not FFlagAXHideMenuOnScroll then nil else t3.enableAnimatedVisibility,
		if not FFlagAXHideMenuOnScroll then nil else animatedMenusStore
	})

	React.useEffect(function() -- line: 459
		-- upvalues: v101 (copy), v90 (copy)
		v101(v90.current, false)
	end, {
		alwaysShowingHeight,
		midHeight,
		fullHeight
	})
	React.useEffect(function() -- line: 464
		-- upvalues: v101 (copy), v88 (copy)
		v101(v88, true)
	end, { v88 })
	React.useEffect(function() -- line: 469
		-- upvalues: v72 (copy), v88 (copy), None (copy), v65 (copy), adjustScrollingFramePosition (copy)
		if v72.instance and (v88 == None and v65.current == nil) then
			adjustScrollingFramePosition()
		end
	end, {
		v72.instance,
		v88
	})

	local u102 = nil

	if FFlagAXHideMenuOnScroll then
		u102 = React.useCallback(function(n6: number) -- line: 478
			-- upvalues: t3 (copy), animatedMenusStore (ref), u61 (ref), u76 (ref), u63 (ref), v58 (copy), u62 (ref)
			if not t3.enableAnimatedVisibility or not animatedMenusStore then
				return
			end

			local v133 = n6 - u61.current

			u76()

			if math.abs(v133) > 1 then
				local v134 = v133 > 0
				local v135 = animatedMenusStore.getIsVisible(false)
				local current = u63.current
				local v137 = v58:getValue()

				if v134 and v135 and not current and v137 then
					animatedMenusStore.hide()
				elseif not v134 and not v135 and not current and v137 then
					animatedMenusStore.show()
				end
			end

			u62.current = task.delay(0.5, function() -- line: 511
				-- upvalues: animatedMenusStore (ref), u62 (ref)
				animatedMenusStore.show()
				u62.current = nil
			end)
			u61.current = n6
		end, {
			animatedMenusStore,
			t3.enableAnimatedVisibility,
			u76,
			v58
		})
	end

	local v103 = React.useCallback(function(n7: number) -- line: 528
		-- upvalues: v58 (copy), v21 (copy), v92 (copy), FFlagAXHideMenuOnScroll (copy), t3 (copy), u102 (ref)
		local v139 = v58:getValue()

		if n7 < -v21 and v139 then
			v92(false)
		end

		if FFlagAXHideMenuOnScroll and t3.enableAnimatedVisibility then
			u102(n7)
		end
	end, {
		v58,
		if not FFlagAXHideMenuOnScroll then nil else t3.enableAnimatedVisibility,
		if not FFlagAXHideMenuOnScroll then nil else u102
	})
	local v104 = if not FFlagAppIaScopedScrollAway or not FFlagEnableBottomNavOnMarketplace then nil else React.useRef(0)
	local v105 = React.useMemo(function() -- line: 551
		-- upvalues: v91 (copy), FFlagAppIaScopedScrollAway (copy), FFlagEnableBottomNavOnMarketplace (copy), v104 (copy), v58 (copy), t3 (copy), v103 (copy), v73 (copy)
		return {
			scrollingEnabledBinding = v91,
			onCanvasYChanged = if not FFlagAppIaScopedScrollAway or not FFlagEnableBottomNavOnMarketplace then v103 else function(n8: number) -- line: 556
				-- upvalues: v104 (copy), v58 (copy), t3 (copy), v103 (copy)
				if not v104 then
					return
				end

				local v202 = v58:getValue()

				if t3.onCanvasYDelta and v202 then
					local v203 = n8 - v104.current

					if v203 ~= 0 then
						t3.onCanvasYDelta(v203)
					end
				end

				v104.current = n8

				if v103 then
					v103(n8)
				end
			end,
			onCanvasPositionChanged = function(p7) -- line: 575
				-- upvalues: v103 (copy)
				if v103 then
					v103(p7.CanvasPosition.Y)
				end
			end,
			setSelectedItemInstance = function(p8) -- line: 581
				-- upvalues: v73 (copy)
				if not p8 then
					v73({
						instance = nil,
						time = 0
					})

					return
				end

				v73({
					instance = p8,
					time = tick()
				})
			end
		}
	end, {
		v91,
		v103,
		if not FFlagAppIaScopedScrollAway or not FFlagEnableBottomNavOnMarketplace then nil else t3.onCanvasYDelta
	})

	local function onCanvasPositionChanged(p9) -- line: 604
		-- upvalues: v87 (copy)
		v87(p9.CanvasPosition.Y)
	end
	local function getTargetViewModeInRange(n9: number, p10, p11, n10: number) -- line: 619
		-- upvalues: UIFullView (copy), fullHeight (copy), SceneFullView (copy), alwaysShowingHeight (copy), midHeight (copy), v88 (copy)
		local v145 = if p11 ~= UIFullView then if p11 ~= SceneFullView then midHeight else alwaysShowingHeight else fullHeight
		local v146 = if p10 ~= UIFullView then if p10 ~= SceneFullView then midHeight else alwaysShowingHeight else fullHeight
		local v147 = v145 - v146
		local v148 = n10 < 0
		local v149 = n10 > 0

		if p11 == v88 then
			if v149 or n9 < v146 + v147 * 0.8 then
				return p10
			end

			return p11
		end

		if v148 or n9 > v146 + v147 * 0.2 then
			return p11
		end

		return p10
	end

	local v108 = React.useCallback(function() -- line: 647
		-- upvalues: v57 (copy), alwaysShowingHeight (copy), v88 (copy), SceneFullView (copy), UIFullView (copy), fullHeight (copy), None (copy), midHeight (copy)
		local current = v57.current

		if not current then
			return nil
		end

		assert(current, "")

		local CanvasPositionY = current.CanvasPosition.Y
		local v152 = alwaysShowingHeight + CanvasPositionY
		local ScrollVelocityY = current.ScrollVelocity.Y
		local v154 = v88 == SceneFullView and math.abs(v152 - alwaysShowingHeight) < 1
		local v155 = v88 == UIFullView and math.abs(v152 - fullHeight) < 1
		local v156 = v88 == None and math.abs(v152 - midHeight) < 1

		if (v154 or v155 or v156) and ScrollVelocityY == 0 then
			return nil
		end

		if v152 > midHeight then
			local v157 = None
			local v158 = UIFullView
			local v159 = if v158 ~= UIFullView then if v158 ~= SceneFullView then midHeight else alwaysShowingHeight else fullHeight
			local v160 = if v157 ~= UIFullView then if v157 ~= SceneFullView then midHeight else alwaysShowingHeight else fullHeight
			local v161 = v159 - v160
			local v162 = ScrollVelocityY < 0
			local v163 = ScrollVelocityY > 0

			if v158 == v88 then
				if v163 or v152 < v160 + v161 * 0.8 then
					return v157
				end

				return v158
			end

			if v162 or v152 > v160 + v161 * 0.2 then
				return v158
			end

			return v157
		end

		local v164 = SceneFullView
		local v165 = None
		local v166 = if v165 ~= UIFullView then if v165 ~= SceneFullView then midHeight else alwaysShowingHeight else fullHeight
		local v167 = if v164 ~= UIFullView then if v164 ~= SceneFullView then midHeight else alwaysShowingHeight else fullHeight
		local v168 = v166 - v167
		local v169 = ScrollVelocityY < 0
		local v170 = ScrollVelocityY > 0

		if v165 == v88 then
			if v170 or v152 < v167 + v168 * 0.8 then
				return v164
			end

			return v165
		end

		if v169 or v152 > v167 + v168 * 0.2 then
			return v165
		end

		return v164
	end, {
		v88,
		fullHeight,
		midHeight,
		alwaysShowingHeight
	})
	local u109 = nil

	if FFlagAXExpandPeekViewOnFirstScroll then
		u109 = React.useCallback(function() -- line: 677
			-- upvalues: u97 (ref), u95 (ref), u94 (ref), v92 (copy), v74 (copy), v88 (copy)
			u97.current = 0
			u95.current = 0
			u94(true)
			v92(v74(v88))
		end, {
			v88,
			u94,
			v92,
			v74
		})
	end

	local v110 = React.useCallback(function(p12) -- line: 686
		-- upvalues: v59 (copy), FFlagAXExpandPeekViewOnFirstScroll (copy), t3 (copy), u109 (ref), u96 (ref), u75 (ref)
		if p12.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		v59(true)

		if FFlagAXExpandPeekViewOnFirstScroll and t3.enableExpandPeekViewOnUpwardScroll then
			u109()
			u96.current = p12.Position.Y
		end

		u75()
	end, {
		if not FFlagAXExpandPeekViewOnFirstScroll then nil else v59,
		if not FFlagAXExpandPeekViewOnFirstScroll then nil else u75,
		if not FFlagAXExpandPeekViewOnFirstScroll then nil else t3.enableExpandPeekViewOnUpwardScroll,
		if not FFlagAXExpandPeekViewOnFirstScroll then nil else u109
	})
	local v111 = nil

	if FFlagAXExpandPeekViewOnFirstScroll then
		v111 = React.useCallback(function(p13) -- line: 711
			-- upvalues: t3 (copy), v88 (copy), None (copy), u96 (ref), u95 (ref), u97 (ref), v25 (copy), v108 (copy), v101 (copy), u94 (ref), v92 (copy)
			if not t3.enableExpandPeekViewOnUpwardScroll then
				return
			end

			if p13.UserInputType ~= Enum.UserInputType.Touch then
				return
			end

			if v88 ~= None then
				return
			end

			local v173 = p13.Position.Y - u96.current

			if math.abs(v173) > 5 then
				local v174 = not (v173 > 0) and 1 or -1

				u96.current = p13.Position.Y

				if v174 ~= u95.current then
					local v175 = u97

					v175.current = v175.current + 1

					if u97.current > v25 then
						local v176 = v108()

						if v176 then
							v101(v176, true)
						end

						return
					end

					u95.current = v174

					if v174 == -1 then
						u94(false)

						return
					end

					v92(false)
					u94(true)
				end
			end
		end, {
			v88,
			v101,
			v108,
			u94,
			v92,
			v74,
			v59,
			u109,
			t3.enableExpandPeekViewOnUpwardScroll
		})
	end

	local v112 = React.useCallback(function(p14) -- line: 773
		-- upvalues: FFlagAppIaScopedScrollAway (copy), FFlagEnableBottomNavOnMarketplace (copy), t3 (copy), FFlagAXExpandPeekViewOnFirstScroll (copy), u109 (ref), v59 (copy), v108 (copy), v101 (copy), v92 (copy), v74 (copy), v90 (copy)
		if p14.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		if FFlagAppIaScopedScrollAway and FFlagEnableBottomNavOnMarketplace and t3.onScrollTouchEnded then
			t3.onScrollTouchEnded()
		end

		if FFlagAXExpandPeekViewOnFirstScroll and t3.enableExpandPeekViewOnUpwardScroll then
			u109()
		end

		v59(false)

		local v178 = v108()

		if v178 then
			v101(v178, true)

			return
		end

		v92(v74(v90.current))
	end, {
		v101,
		v108,
		if not FFlagAppIaScopedScrollAway or not FFlagEnableBottomNavOnMarketplace then nil else t3.onScrollTouchEnded
	})
	local v113 = React.useCallback(function() -- line: 805
		-- upvalues: v88 (copy), UIFullView (copy), SceneFullView (copy), v101 (copy), None (copy)
		if v88 == UIFullView or v88 == SceneFullView then
			v101(None, true)

			return
		end

		v101(UIFullView, true)
	end, {
		v88,
		v101
	})
	local v114 = React.useCallback(function(n11: number) -- line: 813
		-- upvalues: v55 (copy)
		local v180 = v55 - n11

		if v180 > 100 then
			return 1
		end

		return v180 / 80
	end, {})
	local v115 = React.useCallback(function(n12: number) -- line: 823
		-- upvalues: v55 (copy), Size_900 (copy), Size_100 (copy)
		local v182 = v55 - n12

		if v182 > 50 then
			return UDim2.new(0, Size_900, 0, Size_100)
		end

		local v183 = v182 / 50
		local v184 = Size_900 * v183
		local v185 = math.clamp(Size_100 * v183, 1, Size_100)

		return UDim2.new(1 - v183, v184, 0, v185)
	end, {})
	local u116 = nil
	local u117 = nil

	if FFlagAXHideMenuOnScroll then
		u117 = React.useCallback(function(n13: number) -- line: 840
			-- upvalues: fullHeight (copy), alwaysShowingHeight (copy), midHeight (copy)
			return math.clamp((fullHeight - (n13 + alwaysShowingHeight)) / (fullHeight - midHeight), 0, 1) * 12
		end, {
			fullHeight,
			alwaysShowingHeight,
			midHeight
		})
		u116 = React.useCallback(function(n14: number) -- line: 849
			-- upvalues: v55 (copy), Constants (copy)
			local v188 = v55 - n14

			if v188 > 50 then
				return Constants.PeekHeaderHeight
			end

			local v189 = v188 / 50

			return Constants.PeekHeaderMinHeight + (Constants.PeekHeaderHeight - Constants.PeekHeaderMinHeight) * v189
		end, { v55 })
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 1, 1, 0),
		ref = v56
	}, {
		DropShadowBackground = React.createElement("Frame", {
			ZIndex = 0,
			Size = UDim2.new(1, 0, 0, 36),
			Position = v86:map(function(n15: number) -- line: 876
				-- upvalues: alwaysShowingHeight (copy)
				return UDim2.new(0, 0, 1, -n15 - alwaysShowingHeight - 30)
			end)
		}, {
			UIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, v77.Theme.DropShadow.Color),
					ColorSequenceKeypoint.new(1, v77.Theme.DropShadow.Color)
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0.7)
				})
			})
		}),
		AdaptiveScrollingViewOpaqueBackground = if not v71 or not v71.opaqueBackground then nil else React.createElement("Frame", {
			ZIndex = 1,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromOffset(0, -v68),
			BackgroundTransparency = v86:map(v114),
			BackgroundColor3 = Theme.BackgroundDefault.Color
		}),
		ClipFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.fromScale(0.5, 1),
			Size = v86:map(function(n16: number) -- line: 910
				-- upvalues: alwaysShowingHeight (copy)
				return UDim2.new(1, 0, 0, n16 + alwaysShowingHeight)
			end),
			ZIndex = if not FFlagAXAdaptiveScrollingViewBanner then nil else 2
		}, {
			ScrollingFrame = React.createElement("ScrollingFrame", {
				ref = v57,
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.fromScale(0.5, 1),
				Size = UDim2.new(1, 0, 0, fullHeight),
				CanvasSize = UDim2.new(1, 0, 0, fullHeight + v55),
				BackgroundTransparency = 1,
				ScrollingDirection = if not FFlagAXSlotsPeekViewScrollFix or not t3.disableViewChangeByScroll then Enum.ScrollingDirection.Y else t3.disableViewChangeByScroll:map(function(p15) -- line: 923
					if p15 then
						return Enum.ScrollingDirection.X
					end

					return Enum.ScrollingDirection.Y
				end),
				ScrollBarThickness = 0,
				ScrollingEnabled = if not v20 then nil else if t3.enableViewModeTransition == nil then not FFlagAXExpandPeekViewOnFirstScroll or v93 else t3.enableViewModeTransition,
				ElasticBehavior = Enum.ElasticBehavior.Never,
				[React.Change.CanvasPosition] = onCanvasPositionChanged
			}, {
				VerticalLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				Spacer = React.createElement("Frame", {
					BackgroundTransparency = 1,
					Active = false,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, v55)
				}),
				PeekHeader = React.createElement("TextButton", {
					Text = "",
					LayoutOrder = 2,
					ZIndex = 2,
					BackgroundTransparency = 1,
					Size = if not FFlagAXHideMenuOnScroll or (not v71 or not v71.draggerToDivider) then UDim2.new(1, 0, 0, Constants.PeekHeaderHeight) else v86:map(function(p16) -- line: 955
						-- upvalues: u116 (ref)
						return UDim2.new(1, 0, 0, u116(p16))
					end),
					BorderSizePixel = 0,
					[React.Event.Activated] = v113
				}, {
					PeekHeaderBackground = React.createElement("Frame", {
						LayoutOrder = 2,
						ZIndex = 1,
						BorderSizePixel = 0,
						Active = false,
						Size = if not FFlagAXHideMenuOnScroll or (not v71 or not v71.draggerToDivider) then UDim2.new(1, 0, 0, Constants.PeekHeaderHeight + 12) else v86:map(function(p17) -- line: 971
							-- upvalues: u117 (ref), u116 (ref)
							local v195 = u117(p17)

							return UDim2.new(1, 0, 0, u116(p17) + v195)
						end),
						BackgroundTransparency = if not FFlagAXCatalogOffersBannerEnabled or not v80 then Theme.BackgroundDefault.Transparency else v82,
						BackgroundColor3 = if not FFlagAXCatalogOffersBannerEnabled or not v80 then if not FFlagAXAdaptiveScrollingViewBanner or not t3.banner then Theme.BackgroundDefault.Color else Theme.BackgroundContrast.Color else v81
					}, {
						UICorner = React.createElement("UICorner", {
							CornerRadius = if not FFlagAXHideMenuOnScroll or (not v71 or not v71.draggerToDivider) then UDim.new(0, 12) else v86:map(function(n17: number) -- line: 995
								-- upvalues: u117 (ref)
								return UDim.new(0, u117(n17))
							end)
						})
					}),
					Dragger = React.createElement("Frame", {
						ZIndex = 2,
						BorderSizePixel = 0,
						Active = false,
						BackgroundColor3 = if not v22 then v67.Color.Extended.White.White_10.Color3 else ((if not FFlagRenameDeprecatedUIBloxTokens then v67.Semantic.Color.Common.Divider else v67.Color.Stroke.Emphasis)).Color3,
						BackgroundTransparency = if not v22 then v67.Color.Extended.White.White_10.Transparency else ((if not FFlagRenameDeprecatedUIBloxTokens then v67.Semantic.Color.Common.Divider else v67.Color.Stroke.Emphasis)).Transparency,
						Size = if not v71 or not v71.draggerToDivider then UDim2.new(0, Size_900, 0, Size_100) else v86:map(v115),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5)
					}, {
						DraggerUICorner = React.createElement("UICorner", {
							CornerRadius = UDim.new(0, 12)
						})
					})
				}),
				Banner = if not FFlagAXAdaptiveScrollingViewBanner or not t3.banner then nil else React.createElement("Frame", {
					LayoutOrder = 3,
					ZIndex = 3,
					BorderSizePixel = 0,
					BackgroundTransparency = if not FFlagAXCatalogOffersBannerEnabled or not v80 then nil else v82,
					BackgroundColor3 = if not FFlagAXCatalogOffersBannerEnabled or not v80 then Theme.BackgroundContrast.Color else v81,
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}, {
					Content = t3.banner
				}),
				ExpandingContent = React.createElement("Frame", {
					BackgroundTransparency = 1,
					ZIndex = 3,
					Size = v86:map(function(n18: number) -- line: 1047
						-- upvalues: alwaysShowingHeight (copy)
						return UDim2.new(1, 0, 0, n18 + alwaysShowingHeight)
					end),
					LayoutOrder = not FFlagAXAdaptiveScrollingViewBanner and 3 or 4
				}, {
					AdaptiveScrollingProvider = if not FFlagAXCatalogOffersBannerEnabled then React.createElement(AdaptiveScrollingContext.Provider, {
						value = v105
					}, t3.children) else React.createElement(AdaptiveScrollingContext.Provider, {
						value = v105
					}, {
						PeekHeaderBackground = React.createElement(AdaptiveScrollingViewPeekHeaderBackgroundContext.Provider, {
							value = v79
						}, t3.children)
					})
				}),
				OnInputBegan = React.createElement(ExternalEventConnection, {
					event = UserInputService.InputBegan,
					callback = v110
				}),
				OnInputChanged = if not FFlagAXExpandPeekViewOnFirstScroll then nil else React.createElement(ExternalEventConnection, {
					event = UserInputService.InputChanged,
					callback = v111
				}),
				OnInputEnded = React.createElement(ExternalEventConnection, {
					event = UserInputService.InputEnded,
					callback = v112
				})
			})
		})
	})
end

return AdaptiveScrollingView
