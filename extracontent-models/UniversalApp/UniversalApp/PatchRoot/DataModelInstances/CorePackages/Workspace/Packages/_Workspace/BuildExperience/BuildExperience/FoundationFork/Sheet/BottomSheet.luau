local Foundation = game:GetService("CorePackages").Packages._Index.Foundation.Foundation
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local Otter = require(FoundationParent.Otter)
local React = require(FoundationParent.React)
local ReactOtter = require(FoundationParent.ReactOtter)
local ReactRoblox = require(FoundationParent.ReactRoblox)
local ReactUtils = require(FoundationParent.ReactUtils)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local useElevation = require(Foundation.Providers.Elevation.useElevation)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)
local ElevationOwnerScope = require(Foundation.Providers.Elevation.ElevationProvider).ElevationOwnerScope
local ElevationLayer = require(Foundation.Enums.ElevationLayer)
local Constants = require(Foundation.Constants)
local useScreen = require(Foundation.Providers.Overlay.useScreen)
local SheetContext = require(script.Parent.SheetContext)
local Types = require(script.Parent.Types)
local SheetType = require(script.Parent.SheetType)
local childrenHasFullBleed = require(script.Parent.childrenHasFullBleed)
local getHardwareSafeAreaInsets = require(script.Parent.getHardwareSafeAreaInsets)
local useHardwareInsets = require(script.Parent.useHardwareInsets)
local useScreenHeight = require(script.Parent.useScreenHeight)
local Flags = require(Foundation.Utility.Flags)
local Image = require(Foundation.Components.Image)
local View = require(Foundation.Components.View)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local v30 = game:DefineFastInt("FoundationBottomSheetIOSInsetWorkaroundDelayMs", 100)
local v31 = game:DefineFastFlag("FoundationBottomSheetIOSInsetWorkaround", false)
local t1 = {
	defaultSnapPointIndex = 1,
	testId = "--foundation-sheet"
}
local SHADOW_IMAGE = Constants.SHADOW_IMAGE
local SHADOW_SIZE = Constants.SHADOW_SIZE

local function advanceCriticalDampedSpring(n1: number, n2: number, n3: number, n4: number) -- line: 65
	local v45 = n1 - n3
	local v46 = 25.132741228718345 * n4
	local v47 = math.exp(-v46)
	local v48 = n2 + 25.132741228718345 * v45
	local v49 = (v45 + v48 * n4) * v47
	local v50 = (n2 - v48 * v46) * v47

	return n3 + v49, v50
end
local function useStableGuiHeight(p1) -- line: 82
	-- upvalues: React (copy), v30 (copy)
	local v52 = not p1 and 0 or p1.AbsoluteSize.Y
	local v53, v54 = React.useState(v52)
	local v55 = React.useRef(v52)
	local v56 = React.useRef(0)
	local v57 = React.useCallback(function(n5: number) -- line: 88
		-- upvalues: v55 (copy), v54 (copy)
		if n5 == v55.current then
			return
		end

		v55.current = n5
		v54(n5)
	end, {})

	React.useLayoutEffect(function() -- line: 97
		-- upvalues: v56 (copy), p1 (copy), v57 (copy), v55 (copy), v30 (copy)
		local v141 = v56

		v141.current = v141.current + 1

		if not p1 then
			v57(0)

			return function() -- line: 102
				-- upvalues: v56 (copy)
				local v174 = v56

				v174.current = v174.current + 1
			end
		end

		local function updateHeight() -- line: 107
			-- upvalues: p1 (copy), v55 (copy), v56 (copy), v57 (copy), v30 (copy)
			local AbsoluteSizeY = p1.AbsoluteSize.Y

			if v55.current <= 0 or AbsoluteSizeY <= v55.current then
				local v176 = v56

				v176.current = v176.current + 1
				v57(AbsoluteSizeY)

				return
			end

			local v177 = v56

			v177.current = v177.current + 1

			local current = v56.current

			task.delay(v30 / 1000, function() -- line: 119
				-- upvalues: v56 (copy), current (copy), p1 (copy), AbsoluteSizeY (copy), v57 (copy)
				if v56.current ~= current or p1.AbsoluteSize.Y ~= AbsoluteSizeY then
					return
				end

				v57(AbsoluteSizeY)
			end)
		end

		updateHeight()

		local connection = p1:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateHeight)

		return function() -- line: 131
			-- upvalues: v56 (copy), connection (copy)
			local v179 = v56

			v179.current = v179.current + 1
			connection:Disconnect()
		end
	end, {
		p1,
		v57
	})

	return v53
end
local function useStableScreenHeight() -- line: 140
	-- upvalues: Flags (copy), useScreen (copy), useOverlay (copy), useStableGuiHeight (copy)
	local v58 = if not Flags.FoundationOverlayKeyboardAwarenessHardened then useOverlay() else useScreen()

	return (useStableGuiHeight(v58))
end
local function useStableBottomSafeAreaPadding(p2) -- line: 145
	-- upvalues: getHardwareSafeAreaInsets (copy), React (copy), v30 (copy)
	local bottom = getHardwareSafeAreaInsets().bottom
	local v61, v62 = React.useState(bottom)
	local v63 = React.useRef(bottom)
	local v64 = React.useRef(0)
	local v65 = React.useCallback(function(n6: number) -- line: 151
		-- upvalues: v63 (copy), v62 (copy)
		if n6 == v63.current then
			return
		end

		v63.current = n6
		v62(n6)
	end, {})

	React.useEffect(function() -- line: 160
		-- upvalues: v64 (copy), p2 (copy), getHardwareSafeAreaInsets (copy), v63 (copy), v65 (copy), v30 (copy)
		local v145 = v64

		v145.current = v145.current + 1

		if not p2 then
			return function() -- line: 164
				-- upvalues: v64 (copy)
				local v180 = v64

				v180.current = v180.current + 1
			end
		end

		local function updateBottomInset() -- line: 169
			-- upvalues: getHardwareSafeAreaInsets (copy), v63 (copy), v64 (copy), v65 (copy), v30 (copy)
			local bottom2 = getHardwareSafeAreaInsets().bottom

			if bottom2 >= v63.current then
				local v182 = v64

				v182.current = v182.current + 1
				v65(bottom2)

				return
			end

			local v183 = v64

			v183.current = v183.current + 1

			local current = v64.current

			task.delay(v30 / 1000, function() -- line: 181
				-- upvalues: getHardwareSafeAreaInsets (copy), v64 (copy), current (copy), bottom2 (copy), v65 (copy)
				local bottom3 = getHardwareSafeAreaInsets().bottom

				if v64.current ~= current or bottom3 ~= bottom2 then
					return
				end

				v65(bottom2)
			end)
		end

		updateBottomInset()

		local connection = p2:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateBottomInset)

		return function() -- line: 194
			-- upvalues: v64 (copy), connection (copy)
			local v185 = v64

			v185.current = v185.current + 1
			connection:Disconnect()
		end
	end, {
		p2,
		v65
	})

	return v61
end
local function getIOSInsetWorkaroundValues(p3) -- line: 203
	-- upvalues: Flags (copy), useScreen (copy), useOverlay (copy), useStableGuiHeight (copy), useStableBottomSafeAreaPadding (copy)
	local v67 = if not Flags.FoundationOverlayKeyboardAwarenessHardened then useOverlay() else useScreen()

	return useStableGuiHeight(v67), useStableGuiHeight(p3), (useStableBottomSafeAreaPadding(p3))
end
local function BottomSheet(p4, p5) -- line: 207
	-- upvalues: withDefaults (copy), t1 (copy), useOverlay (copy), useTokens (copy), useElevation (copy), ElevationLayer (copy), usePreferences (copy), v31 (copy), Flags (copy), useScreen (copy), useStableGuiHeight (copy), useStableBottomSafeAreaPadding (copy), useScreenHeight (copy), React (copy), useHardwareInsets (copy), useAnimatedBinding (copy), childrenHasFullBleed (copy), Otter (copy), ReactUtils (copy), SheetType (copy), View (copy), StateLayerAffordance (copy), ReactRoblox (copy), Types (copy), Dash (copy), SheetContext (copy), ElevationOwnerScope (copy), Image (copy), SHADOW_IMAGE (copy), SHADOW_SIZE (copy)
	local v70 = withDefaults(p4, t1)
	local v71 = useOverlay()
	local v72 = useTokens()
	local v73 = useElevation(ElevationLayer.Sheet, {
		stackAboveOwner = false
	})
	local reducedMotion = usePreferences().reducedMotion
	local u75 = nil
	local u76 = nil
	local u81, u82

	if v31 then
		local v77 = if not Flags.FoundationOverlayKeyboardAwarenessHardened then useOverlay() else useScreen()
		local v78 = useStableGuiHeight(v77)
		local v79 = useStableGuiHeight(v71)
		local v80 = useStableBottomSafeAreaPadding(v71)

		u81 = v78
		u82 = v79
		u76 = v80
	else
		u81 = useScreenHeight()

		local v83, v84 = React.useState(not v71 and 0 or v71.AbsoluteSize.Y)

		u82 = v83
		u75 = v84
	end

	local v85, v86 = React.useState(0)
	local v87 = React.useMemo(function() -- line: 228
		-- upvalues: v85 (copy)
		return { v85 }
	end, { v85 })
	local v88 = v70.snapPoints or v87
	local v89 = React.useCallback(function(n7: number) -- line: 235
		-- upvalues: u81 (ref)
		if n7 > 1 then
			return n7
		end

		return n7 * u81
	end, { u81 })
	local n8 = 0

	for _, v92 in v88 do
		local v93 = v89(v92)

		if n8 < v93 then
			n8 = v93
		end
	end

	local u94 = math.min(n8, u81)

	if Flags.FoundationOverlayKeyboardAwareness and u82 > 0 then
		u94 = math.min(u94, u82)
	end

	if not v31 then
		u76 = useHardwareInsets(v71).bottom
		React.useLayoutEffect(function() -- line: 257
			-- upvalues: v71 (copy), u75 (ref)
			if not v71 then
				u75(0)

				return
			end

			local function updateOverlayAvailableHeight() -- line: 263
				-- upvalues: u75 (ref), v71 (copy)
				u75(v71.AbsoluteSize.Y)
			end

			u75(v71.AbsoluteSize.Y)

			local connection = v71:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateOverlayAvailableHeight)

			return function() -- line: 270
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end, { v71 })
	end

	local v95 = React.useRef(0)
	local v96 = React.useRef(false)
	local v97, v98 = useAnimatedBinding(1, function() -- line: 279
		-- upvalues: v96 (copy), v70 (copy)
		if v96.current then
			v70.onClose()
		end
	end)
	local v99, v100 = React.useBinding(-u76)
	local v101, v102 = React.useBinding(0)
	local v103, v104 = React.useBinding(false)
	local v105, v106 = React.useBinding(false)
	local u107 = nil
	local u108 = nil
	local u109 = nil

	if Flags.FoundationSheetFullBleed then
		u107 = childrenHasFullBleed(v70.children)

		local v110, v111 = React.useBinding(0)

		u108 = v110
		u109 = v111
	end

	local v112 = React.useRef(0)
	local v113 = React.useRef(nil)
	local v114, v115 = React.useBinding(0)
	local v116, v117 = React.useBinding(false)
	local v118 = React.useRef(false)
	local v119 = React.useRef(0)
	local v120 = React.useRef(nil)
	local v121 = React.useRef(false)
	local v122 = React.useRef(0)
	local v123 = React.useCallback(function() -- line: 306
		-- upvalues: v120 (copy), v119 (copy), v121 (copy)
		if v120.current then
			v120.current:Disconnect()
			v120.current = nil
		end

		v119.current = 0
		v121.current = false
	end, {})
	local v124 = React.useCallback(function(n9: number) -- line: 315
		-- upvalues: v123 (copy), v121 (copy), Flags (copy), v113 (copy), v120 (copy), v122 (copy)
		v123()
		v121.current = true

		if Flags.FoundationBottomSheetImproveSpring and v113.current then
			v113.current:ResetScrollVelocity()
		end

		local u152 = not v113.current and 0 or v113.current.CanvasPosition.Y

		v120.current = game:GetService("RunService").Heartbeat:Connect(function(dt) -- line: 327
			-- upvalues: v113 (copy), v121 (copy), v123 (copy), Flags (copy), v122 (copy), n9 (copy), u152 (ref)
			if not v113.current or not v121.current then
				v123()

				return
			end

			local CanvasPositionY = v113.current.CanvasPosition.Y
			local v197

			if Flags.FoundationBottomSheetImproveSpring then
				local current = v122.current
				local v189 = n9
				local v190 = CanvasPositionY - v189
				local v191 = 25.132741228718345 * dt
				local v192 = math.exp(-v191)
				local v193 = current + 25.132741228718345 * v190
				local v194 = (v190 + v193 * dt) * v192
				local v195 = (current - v193 * v191) * v192
				local v196 = v189 + v194

				v122.current = v195
				v113.current.CanvasPosition = Vector2.new(0, v196)
				u152 = v113.current.CanvasPosition.Y
				v197 = n9 - v113.current.CanvasPosition.Y
			else
				v197 = n9 - CanvasPositionY

				local v198 = v197 * 18 * 18
				local v199 = (CanvasPositionY - u152) / dt
				local v200 = v122

				v200.current = v200.current - v199

				local v201 = v198 + -v122.current * 2 * 0.9 * 18
				local v202 = math.min(dt, 0.03333333333333333)

				v122.current = v122.current + v201 * v202

				local v203 = CanvasPositionY + v122.current * v202

				v113.current.CanvasPosition = Vector2.new(0, v203)
				u152 = v113.current.CanvasPosition.Y
			end

			if math.abs(v197) < 0.5 and math.abs(v122.current) < 1 then
				v113.current.CanvasPosition = Vector2.new(0, n9)
				v123()
			end
		end)
	end, { v123 })
	local v125 = React.useCallback(function(n10: number) -- line: 374
		-- upvalues: v89 (copy), u94 (ref), u76 (ref)
		return math.min(v89(n10), u94) + u76
	end, {
		u76,
		v89,
		u94
	})
	local v126 = React.useCallback(function(n11: number) -- line: 378
		-- upvalues: v95 (copy), v124 (copy), v125 (copy), v88 (copy)
		v95.current = n11
		v124(v125(v88[n11]))
	end, {
		v125,
		v88
	})
	local v127 = React.useCallback(function(n12: number) -- line: 383
		-- upvalues: v123 (copy), v95 (copy), v113 (copy), v125 (copy), v88 (copy)
		v123()
		v95.current = n12

		if v113.current then
			v113.current.CanvasPosition = Vector2.new(0, v125(v88[n12]))
		end
	end, {
		v123,
		v125,
		v88
	})
	local v128 = React.useRef(0)

	React.useEffect(function() -- line: 393
		-- upvalues: v71 (copy), Flags (copy), v128 (copy), u82 (ref), v95 (copy), v88 (copy), v70 (copy), reducedMotion (copy), v127 (copy), v126 (copy)
		if not v71 or not Flags.FoundationOverlayKeyboardAwareness then
			return
		end

		local current = v128.current

		v128.current = u82

		if current <= 0 or current == u82 then
			return
		end

		local current2 = v95.current

		if current2 <= 0 or current2 > #v88 then
			current2 = v70.defaultSnapPointIndex
		end

		if reducedMotion then
			v127(current2)

			return
		end

		v126(current2)
	end, {
		v71,
		u82,
		v126,
		v127,
		reducedMotion,
		v70.defaultSnapPointIndex,
		v88
	})

	local v129 = React.useCallback(function(b1: boolean?) -- line: 426
		-- upvalues: v96 (copy), reducedMotion (copy), v123 (copy), v113 (copy), v98 (copy), Otter (copy), v122 (copy), v119 (copy), v124 (copy), v72 (copy)
		if v96.current then
			return
		end

		if reducedMotion and not b1 then
			v96.current = true
			v123()

			if v113.current then
				v113.current.CanvasPosition = Vector2.new(0, 0)
			end

			v98((Otter.instant(1)))

			return
		end

		v122.current = -v119.current
		v124(0)
		v98(Otter.ease(1, {
			duration = v72.Time.Time_100
		}))
		v96.current = true
	end, {
		v124,
		v123,
		reducedMotion
	})
	local v130 = React.useCallback(function() -- line: 447
		-- upvalues: v114 (copy), v112 (copy), Flags (copy), u94 (ref), u76 (ref), v119 (copy), v118 (copy), v117 (copy)
		local v159 = v114:getValue() <= 0
		local v160 = v112.current >= if not Flags.FoundationBottomSheetImproveSpring then math.round(u94 + u76) else math.floor(u94 + u76)

		if v119.current > 0 and v159 and v118.current then
			v117(false)

			return
		end

		if (v119.current < 0 or Flags.FoundationBottomSheetImproveSpring and v119.current == 0) and v160 then
			v117(true)
		end
	end, {
		u94,
		u76
	})
	local v131 = React.useCallback(function() -- line: 464
		-- upvalues: v119 (copy), v112 (copy), v88 (copy), v125 (copy), v118 (copy), v122 (copy), v129 (copy), v126 (copy)
		local current = v119.current
		local v162 = v112.current - current / 2.35
		local t2 = {{
			index = 0,
			position = 0
		}}

		for v164, v165 in v88 do
			table.insert(t2, {
				index = v164,
				position = v125(v165)
			})
		end

		table.sort(t2, function(p6, p7) -- line: 482
			-- upvalues: v162 (copy)
			return math.abs(p6.position - v162) < math.abs(p7.position - v162)
		end)

		local v166 = t2[1]

		if not v118.current then
			v122.current = -current

			if v166.index == 0 then
				v129(true)

				return
			end

			v126(v166.index)
		end
	end, {
		v88,
		v126,
		v125,
		v129
	})

	React.useEffect(function() -- line: 498
		-- upvalues: v71 (copy), reducedMotion (copy), v127 (copy), v70 (copy), v98 (copy), Otter (copy), v126 (copy), v72 (copy), v89 (copy), v88 (copy), u94 (ref), v117 (copy), v123 (copy)
		if v71 then
			if reducedMotion then
				v127(v70.defaultSnapPointIndex)
				v98(Otter.instant(0))
			else
				v126(v70.defaultSnapPointIndex)
				v98(Otter.ease(0, {
					duration = v72.Time.Time_100
				}))
			end

			if math.min(v89(v88[v70.defaultSnapPointIndex]), u94) == u94 then
				v117(true)
			end
		end

		return function() -- line: 519
			-- upvalues: v123 (copy)
			v123()
		end
	end, {
		v71,
		v88,
		v70.defaultSnapPointIndex,
		v126,
		v89,
		v127,
		reducedMotion
	})
	React.useEffect(function() -- line: 537
		-- upvalues: v119 (copy), v130 (copy), v118 (copy), v123 (copy), Flags (copy), v113 (copy), v112 (copy), u94 (ref), u76 (ref), v96 (copy), v117 (copy), v131 (copy)
		local connection = game:GetService("UserInputService").TouchPan:Connect(function(_, _, p10, _) -- line: 538
			-- upvalues: v119 (copy), v130 (copy)
			v119.current = p10.Y
			v130()
		end)
		local connection2 = game:GetService("UserInputService").InputBegan:Connect(function() -- line: 542
			-- upvalues: v118 (copy), v119 (copy), v123 (copy)
			v118.current = true
			v119.current = 0
			v123()
		end)
		local connection3 = game:GetService("UserInputService").InputEnded:Connect(function() -- line: 547
			-- upvalues: v118 (copy), Flags (copy), v113 (copy), v119 (copy), v112 (copy), u94 (ref), u76 (ref), v96 (copy), v117 (copy), v131 (copy)
			if v118.current == false then
				return
			end

			v118.current = false

			if Flags.FoundationBottomSheetImproveSpring then
				v119.current = not v113.current and 0 or v113.current:GetScrollVelocity().Y

				if v112.current >= math.floor(u94 + u76) or v96.current then
					v117(true)

					return
				end
			else
				local v210 = nil

				if v113.current then
					local ok, result = pcall(function() -- line: 572
						-- upvalues: v113 (copy)
						return v113.current:GetScrollVelocity().Y == 0
					end)

					if ok then
						v210 = result
					end
				end

				if v210 or v96.current then
					v117(true)

					return
				end
			end

			v131()
		end)

		return function() -- line: 593
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, {
		v71,
		v131,
		v130,
		v123
	})

	local v132 = React.useRef(nil)
	local v133, v134 = React.useState(nil)
	local v135, v136 = React.useState(nil)
	local v137 = ReactUtils.useComposedRef(p5, v136)

	React.useImperativeHandle(v70.sheetRef, function() -- line: 606
		-- upvalues: v129 (copy)
		return {
			close = v129
		}
	end, {})

	local v138 = React.useMemo(function() -- line: 613
		-- upvalues: v101 (copy), v102 (copy), v103 (copy), v104 (copy), v99 (copy), v100 (copy), u76 (ref), v116 (copy), v114 (copy), v115 (copy), v130 (copy), v105 (copy), v106 (copy), Flags (copy), u107 (ref), u108 (ref), u109 (ref), v129 (copy), SheetType (copy), v135 (copy), v70 (copy), v132 (copy), v133 (copy), v134 (copy)
		return {
			bottomPadding = 200,
			actionsHeight = v101,
			setActionsHeight = v102,
			hasActionsDivider = v103,
			setHasActionsDivider = v104,
			sheetHeightAvailable = v99,
			setSheetHeightAvailable = v100,
			safeAreaPadding = u76,
			innerScrollingEnabled = v116,
			innerScrollY = v114,
			setInnerScrollY = function(n13: number) -- line: 625
				-- upvalues: v115 (copy), v130 (copy)
				v115(n13)
				v130()
			end,
			hasHeader = v105,
			setHasHeader = v106,
			hasFullBleed = if not Flags.FoundationSheetFullBleed then nil else u107,
			fullBleedHeight = if not Flags.FoundationSheetFullBleed then nil else u108,
			setFullBleedHeight = if not Flags.FoundationSheetFullBleed then nil else u109,
			closeSheet = v129,
			hasRadius = not not Flags.FoundationSheetFullBleed or nil,
			sheetType = SheetType.Bottom,
			innerSurface = v135,
			testId = v70.testId,
			closeAffordanceRef = v132,
			contentStartRef = v133,
			setContentStartRef = v134
		}
	end, {
		v70.testId,
		v129,
		u76,
		v130,
		v135,
		v132,
		v133,
		u107
	})
	local v139 = React.createElement(View, {
		ZIndex = 3,
		tag = "align-y-center size-1000-100 padding-y-small radius-small",
		backgroundStyle = v72.Color.Content.Muted,
		Position = if not Flags.FoundationSheetFullBleed then nil else UDim2.new(0.5, 0, 0, if not u107 then -v72.Padding.XSmall else v72.Padding.Small),
		AnchorPoint = if not Flags.FoundationSheetFullBleed then nil else Vector2.new(0.5, 0),
		testId = `{ v70.testId }--gripper`
	}, {
		TouchTarget = React.createElement(View, {
			tag = "size-1000-600",
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			onActivated = function() -- line: 671
				-- upvalues: v118 (copy), v88 (copy), v95 (copy), reducedMotion (copy), v127 (copy), v126 (copy), v89 (copy), u94 (ref), v117 (copy), v129 (copy)
				v118.current = false

				if #v88 > 1 then
					local v170 = v95.current % #v88 + 1

					if reducedMotion then
						v127(v170)
					else
						v126(v170)
					end

					if math.min(v89(v88[v170]), u94) == u94 then
						v117(true)

						return
					end
				else
					v129()
				end
			end
		})
	})

	return v71 and ReactRoblox.createPortal(React.createElement(View, {
		ZIndex = v73.zIndex,
		ref = v137,
		selection = Types.nonSelectable,
		selectionGroup = Types.isolatedSelectionGroup,
		Size = if not v31 then nil else UDim2.new(1, 0, 0, u82),
		tag = not v31 and "size-full" or nil,
		testId = `{ v70.testId }--surface`
	}, React.createElement("ScrollingFrame", {
		Size = if not v31 then UDim2.fromScale(1, 1) else UDim2.new(1, 0, 0, u82),
		CanvasSize = if not Flags.FoundationSheetPreventCloseOnResize then UDim2.new(1, 0, 0, u81 + u94 + u76) else UDim2.new(1, 0, 1, u94 + u76),
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 0,
		ref = v113,
		[React.Change.CanvasPosition] = function(p12) -- line: 720
			-- upvalues: v112 (copy), v100 (copy), u76 (ref), v72 (copy), v130 (copy), v129 (copy)
			v112.current = p12.CanvasPosition.Y
			v100(v112.current - u76 - v72.Margin.Small)
			v130()

			if v112.current <= 0 then
				v129()
			end
		end
	}, {
		SheetContainer = React.createElement(View, {
			ZIndex = 3,
			Size = if not Flags.FoundationSheetPreventCloseOnResize then UDim2.new(1, 0, 0, u81 + 200) else UDim2.new(1, 0, 1, 200 - u94 - u76),
			Position = if not Flags.FoundationSheetPreventCloseOnResize then UDim2.fromOffset(0, u81 + u76) else UDim2.new(0, 0, 1, -u94)
		}, {
			Sheet = React.createElement(View, {
				Size = if v70.snapPoints ~= nil then UDim2.new(1, 0, 0, u94 + 200) else UDim2.fromScale(1, 0),
				AutomaticSize = if v70.snapPoints ~= nil then nil else Enum.AutomaticSize.Y,
				onAbsoluteSizeChanged = if v70.snapPoints ~= nil then nil else function(p13) -- line: 744
					-- upvalues: v86 (copy)
					v86(p13.AbsoluteSize.Y - 200)
				end,
				stateLayer = {
					affordance = StateLayerAffordance.None
				},
				onActivated = Dash.noop,
				testId = v70.testId,
				tag = not Flags.FoundationSheetFullBleed and "col items-center padding-top-small radius-large clip bg-surface-100" or {
					["col items-center radius-large clip bg-surface-100"] = true,
					["padding-top-medium"] = not u107
				}
			}, {
				GripperContainer = if not Flags.FoundationSheetFullBleed then v139 else React.createElement("Folder", nil, {
					Gripper = v139
				}),
				Content = React.createElement(SheetContext.Provider, {
					value = v138
				}, React.createElement(ElevationOwnerScope, {
					owner = v73
				}, v70.children))
			})
		}),
		Shadow = React.createElement(Image, {
			ZIndex = 2,
			Image = SHADOW_IMAGE,
			Size = UDim2.new(1, SHADOW_SIZE * 2, 0, u94 + 200 + SHADOW_SIZE * 2),
			Position = if not Flags.FoundationSheetPreventCloseOnResize then UDim2.fromOffset(-SHADOW_SIZE, u81 + u76 - SHADOW_SIZE) else UDim2.new(-SHADOW_SIZE, 0, 1, -u94 - SHADOW_SIZE),
			slice = {
				scale = 2,
				center = Rect.new(SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE + 1, SHADOW_SIZE + 1)
			},
			imageStyle = v72.Color.Extended.Black.Black_10
		}),
		Backdrop = React.createElement(View, {
			ZIndex = 1,
			Size = UDim2.fromScale(1, 2),
			Position = UDim2.fromScale(0, -0.5),
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			backgroundStyle = v97:map(function(n14: number) -- line: 793
				-- upvalues: v72 (copy)
				return {
					Color3 = v72.Color.Common.Backdrop.Color3,
					Transparency = math.lerp(v72.Color.Common.Backdrop.Transparency, 1, n14)
				}
			end),
			onActivated = function() -- line: 799
				-- upvalues: v129 (copy)
				v129()
			end,
			testId = `{ v70.testId }--backdrop`
		})
	})), v71)
end

return React.memo(React.forwardRef(BottomSheet))
