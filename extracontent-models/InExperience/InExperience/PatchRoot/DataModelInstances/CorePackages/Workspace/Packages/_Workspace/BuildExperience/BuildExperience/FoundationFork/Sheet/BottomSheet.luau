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
local Image = require(Foundation.Components.Image)
local View = require(Foundation.Components.View)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local v29 = game:DefineFastInt("FoundationBottomSheetIOSInsetWorkaroundDelayMs", 100)
local v30 = game:DefineFastFlag("FoundationBottomSheetIOSInsetWorkaround", false)
local t1 = {
	defaultSnapPointIndex = 1,
	testId = "--foundation-sheet"
}
local SHADOW_IMAGE = Constants.SHADOW_IMAGE
local SHADOW_SIZE = Constants.SHADOW_SIZE

local function advanceCriticalDampedSpring(n1: number, n2: number, n3: number, n4: number) -- line: 62
	local v44 = n1 - n3
	local v45 = 25.132741228718345 * n4
	local v46 = math.exp(-v45)
	local v47 = n2 + 25.132741228718345 * v44
	local v48 = (v44 + v47 * n4) * v46
	local v49 = (n2 - v47 * v45) * v46

	return n3 + v48, v49
end
local function useStableGuiHeight(p1) -- line: 79
	-- upvalues: React (copy), v29 (copy)
	local v51 = not p1 and 0 or p1.AbsoluteSize.Y
	local v52, v53 = React.useState(v51)
	local v54 = React.useRef(v51)
	local v55 = React.useRef(0)
	local v56 = React.useCallback(function(n5: number) -- line: 85
		-- upvalues: v54 (copy), v53 (copy)
		if n5 == v54.current then
			return
		end

		v54.current = n5
		v53(n5)
	end, {})

	React.useLayoutEffect(function() -- line: 94
		-- upvalues: v55 (copy), p1 (copy), v56 (copy), v54 (copy), v29 (copy)
		local v138 = v55

		v138.current = v138.current + 1

		if not p1 then
			v56(0)

			return function() -- line: 99
				-- upvalues: v55 (copy)
				local v170 = v55

				v170.current = v170.current + 1
			end
		end

		local function updateHeight() -- line: 104
			-- upvalues: p1 (copy), v54 (copy), v55 (copy), v56 (copy), v29 (copy)
			local AbsoluteSizeY = p1.AbsoluteSize.Y

			if v54.current <= 0 or AbsoluteSizeY <= v54.current then
				local v172 = v55

				v172.current = v172.current + 1
				v56(AbsoluteSizeY)

				return
			end

			local v173 = v55

			v173.current = v173.current + 1

			local current = v55.current

			task.delay(v29 / 1000, function() -- line: 116
				-- upvalues: v55 (copy), current (copy), p1 (copy), AbsoluteSizeY (copy), v56 (copy)
				if v55.current ~= current or p1.AbsoluteSize.Y ~= AbsoluteSizeY then
					return
				end

				v56(AbsoluteSizeY)
			end)
		end

		updateHeight()

		local connection = p1:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateHeight)

		return function() -- line: 128
			-- upvalues: v55 (copy), connection (copy)
			local v175 = v55

			v175.current = v175.current + 1
			connection:Disconnect()
		end
	end, {
		p1,
		v56
	})

	return v52
end
local function useStableScreenHeight() -- line: 137
	-- upvalues: useScreen (copy), useStableGuiHeight (copy)
	local v57 = useScreen()

	return (useStableGuiHeight(v57))
end
local function useStableBottomSafeAreaPadding(p2) -- line: 142
	-- upvalues: getHardwareSafeAreaInsets (copy), React (copy), v29 (copy)
	local bottom = getHardwareSafeAreaInsets().bottom
	local v60, v61 = React.useState(bottom)
	local v62 = React.useRef(bottom)
	local v63 = React.useRef(0)
	local v64 = React.useCallback(function(n6: number) -- line: 148
		-- upvalues: v62 (copy), v61 (copy)
		if n6 == v62.current then
			return
		end

		v62.current = n6
		v61(n6)
	end, {})

	React.useEffect(function() -- line: 157
		-- upvalues: v63 (copy), p2 (copy), getHardwareSafeAreaInsets (copy), v62 (copy), v64 (copy), v29 (copy)
		local v142 = v63

		v142.current = v142.current + 1

		if not p2 then
			return function() -- line: 161
				-- upvalues: v63 (copy)
				local v176 = v63

				v176.current = v176.current + 1
			end
		end

		local function updateBottomInset() -- line: 166
			-- upvalues: getHardwareSafeAreaInsets (copy), v62 (copy), v63 (copy), v64 (copy), v29 (copy)
			local bottom2 = getHardwareSafeAreaInsets().bottom

			if bottom2 >= v62.current then
				local v178 = v63

				v178.current = v178.current + 1
				v64(bottom2)

				return
			end

			local v179 = v63

			v179.current = v179.current + 1

			local current = v63.current

			task.delay(v29 / 1000, function() -- line: 178
				-- upvalues: getHardwareSafeAreaInsets (copy), v63 (copy), current (copy), bottom2 (copy), v64 (copy)
				local bottom3 = getHardwareSafeAreaInsets().bottom

				if v63.current ~= current or bottom3 ~= bottom2 then
					return
				end

				v64(bottom2)
			end)
		end

		updateBottomInset()

		local connection = p2:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateBottomInset)

		return function() -- line: 191
			-- upvalues: v63 (copy), connection (copy)
			local v181 = v63

			v181.current = v181.current + 1
			connection:Disconnect()
		end
	end, {
		p2,
		v64
	})

	return v60
end
local function getIOSInsetWorkaroundValues(p3) -- line: 200
	-- upvalues: useScreen (copy), useStableGuiHeight (copy), useStableBottomSafeAreaPadding (copy)
	local v66 = useScreen()

	return useStableGuiHeight(v66), useStableGuiHeight(p3), (useStableBottomSafeAreaPadding(p3))
end
local function BottomSheet(p4, p5) -- line: 204
	-- upvalues: withDefaults (copy), t1 (copy), useOverlay (copy), useTokens (copy), useElevation (copy), ElevationLayer (copy), usePreferences (copy), v30 (copy), useScreen (copy), useStableGuiHeight (copy), useStableBottomSafeAreaPadding (copy), useScreenHeight (copy), React (copy), useHardwareInsets (copy), useAnimatedBinding (copy), childrenHasFullBleed (copy), Otter (copy), ReactUtils (copy), SheetType (copy), View (copy), StateLayerAffordance (copy), ReactRoblox (copy), Types (copy), Dash (copy), SheetContext (copy), ElevationOwnerScope (copy), Image (copy), SHADOW_IMAGE (copy), SHADOW_SIZE (copy)
	local v69 = withDefaults(p4, t1)
	local v70 = useOverlay()
	local v71 = useTokens()
	local v72 = useElevation(ElevationLayer.Sheet, {
		stackAboveOwner = false
	})
	local reducedMotion = usePreferences().reducedMotion
	local u74 = nil
	local u75 = nil
	local u80, u81

	if v30 then
		local v76 = useScreen()
		local v77 = useStableGuiHeight(v76)
		local v78 = useStableGuiHeight(v70)
		local v79 = useStableBottomSafeAreaPadding(v70)

		u80 = v77
		u81 = v78
		u75 = v79
	else
		u80 = useScreenHeight()

		local v82, v83 = React.useState(not v70 and 0 or v70.AbsoluteSize.Y)

		u81 = v82
		u74 = v83
	end

	local v84, v85 = React.useState(0)
	local v86 = React.useMemo(function() -- line: 225
		-- upvalues: v84 (copy)
		return { v84 }
	end, { v84 })
	local v87 = v69.snapPoints or v86
	local v88 = React.useCallback(function(n7: number) -- line: 232
		-- upvalues: u80 (ref)
		if n7 > 1 then
			return n7
		end

		return n7 * u80
	end, { u80 })
	local n8 = 0

	for _, v91 in v87 do
		local v92 = v88(v91)

		if n8 < v92 then
			n8 = v92
		end
	end

	local u93 = math.min(n8, u80)

	if u81 > 0 then
		u93 = math.min(u93, u81)
	end

	if not v30 then
		u75 = useHardwareInsets(v70).bottom
		React.useLayoutEffect(function() -- line: 254
			-- upvalues: v70 (copy), u74 (ref)
			if not v70 then
				u74(0)

				return
			end

			local function updateOverlayAvailableHeight() -- line: 260
				-- upvalues: u74 (ref), v70 (copy)
				u74(v70.AbsoluteSize.Y)
			end

			u74(v70.AbsoluteSize.Y)

			local connection = v70:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateOverlayAvailableHeight)

			return function() -- line: 267
				-- upvalues: connection (copy)
				connection:Disconnect()
			end
		end, { v70 })
	end

	local v94 = React.useRef(0)
	local v95 = React.useRef(false)
	local v96, v97 = useAnimatedBinding(1, function() -- line: 276
		-- upvalues: v95 (copy), v69 (copy)
		if v95.current then
			v69.onClose()
		end
	end)
	local v98, v99 = React.useBinding(-u75)
	local v100, v101 = React.useBinding(0)
	local v102, v103 = React.useBinding(false)
	local v104, v105 = React.useBinding(false)
	local v106 = childrenHasFullBleed(v69.children)
	local v107, v108 = React.useBinding(0)
	local v109 = React.useRef(0)
	local v110 = React.useRef(nil)
	local v111, v112 = React.useBinding(0)
	local v113, v114 = React.useBinding(false)
	local v115 = React.useRef(false)
	local v116 = React.useRef(0)
	local v117 = React.useRef(nil)
	local v118 = React.useRef(false)
	local v119 = React.useRef(0)
	local v120 = React.useCallback(function() -- line: 299
		-- upvalues: v117 (copy), v116 (copy), v118 (copy)
		if v117.current then
			v117.current:Disconnect()
			v117.current = nil
		end

		v116.current = 0
		v118.current = false
	end, {})
	local v121 = React.useCallback(function(n9: number) -- line: 308
		-- upvalues: v120 (copy), v118 (copy), v110 (copy), v117 (copy), v119 (copy)
		v120()
		v118.current = true

		if v110.current then
			v110.current:ResetScrollVelocity()
		end

		v117.current = game:GetService("RunService").Heartbeat:Connect(function(dt) -- line: 317
			-- upvalues: v110 (copy), v118 (copy), v120 (copy), v119 (copy), n9 (copy)
			if not v110.current or not v118.current then
				v120()

				return
			end

			local CanvasPositionY = v110.current.CanvasPosition.Y
			local current = v119.current
			local v185 = n9
			local v186 = CanvasPositionY - v185
			local v187 = 25.132741228718345 * dt
			local v188 = math.exp(-v187)
			local v189 = current + 25.132741228718345 * v186
			local v190 = (v186 + v189 * dt) * v188
			local v191 = (current - v189 * v187) * v188
			local v192 = v185 + v190

			v119.current = v191
			v110.current.CanvasPosition = Vector2.new(0, v192)

			if math.abs(n9 - v110.current.CanvasPosition.Y) < 0.5 and math.abs(v119.current) < 1 then
				v110.current.CanvasPosition = Vector2.new(0, n9)
				v120()
			end
		end)
	end, { v120 })
	local v122 = React.useCallback(function(n10: number) -- line: 341
		-- upvalues: v88 (copy), u93 (ref), u75 (ref)
		return math.min(v88(n10), u93) + u75
	end, {
		u75,
		v88,
		u93
	})
	local v123 = React.useCallback(function(n11: number) -- line: 345
		-- upvalues: v94 (copy), v121 (copy), v122 (copy), v87 (copy)
		v94.current = n11
		v121(v122(v87[n11]))
	end, {
		v122,
		v87
	})
	local v124 = React.useCallback(function(n12: number) -- line: 350
		-- upvalues: v120 (copy), v94 (copy), v110 (copy), v122 (copy), v87 (copy)
		v120()
		v94.current = n12

		if v110.current then
			v110.current.CanvasPosition = Vector2.new(0, v122(v87[n12]))
		end
	end, {
		v120,
		v122,
		v87
	})
	local v125 = React.useRef(0)

	React.useEffect(function() -- line: 360
		-- upvalues: v70 (copy), v125 (copy), u81 (ref), v94 (copy), v87 (copy), v69 (copy), reducedMotion (copy), v124 (copy), v123 (copy)
		if not v70 then
			return
		end

		local current = v125.current

		v125.current = u81

		if current <= 0 or current == u81 then
			return
		end

		local current2 = v94.current

		if current2 <= 0 or current2 > #v87 then
			current2 = v69.defaultSnapPointIndex
		end

		if reducedMotion then
			v124(current2)

			return
		end

		v123(current2)
	end, {
		v70,
		u81,
		v123,
		v124,
		reducedMotion,
		v69.defaultSnapPointIndex,
		v87
	})

	local v126 = React.useCallback(function(b1: boolean?) -- line: 393
		-- upvalues: v95 (copy), reducedMotion (copy), v120 (copy), v110 (copy), v97 (copy), Otter (copy), v119 (copy), v116 (copy), v121 (copy), v71 (copy)
		if v95.current then
			return
		end

		if reducedMotion and not b1 then
			v95.current = true
			v120()

			if v110.current then
				v110.current.CanvasPosition = Vector2.new(0, 0)
			end

			v97((Otter.instant(1)))

			return
		end

		v119.current = -v116.current
		v121(0)
		v97(Otter.ease(1, {
			duration = v71.Time.Time_100
		}))
		v95.current = true
	end, {
		v121,
		v120,
		reducedMotion
	})
	local v127 = React.useCallback(function() -- line: 414
		-- upvalues: v111 (copy), v109 (copy), u93 (ref), u75 (ref), v116 (copy), v115 (copy), v114 (copy)
		local v155 = v111:getValue() <= 0
		local v156 = v109.current >= math.floor(u93 + u75)

		if v116.current > 0 and v155 and v115.current then
			v114(false)

			return
		end

		if v116.current <= 0 and v156 then
			v114(true)
		end
	end, {
		u93,
		u75
	})
	local v128 = React.useCallback(function() -- line: 425
		-- upvalues: v116 (copy), v109 (copy), v87 (copy), v122 (copy), v115 (copy), v119 (copy), v126 (copy), v123 (copy)
		local current = v116.current
		local v158 = v109.current - current / 2.35
		local t2 = {{
			index = 0,
			position = 0
		}}

		for v160, v161 in v87 do
			table.insert(t2, {
				index = v160,
				position = v122(v161)
			})
		end

		table.sort(t2, function(p6, p7) -- line: 443
			-- upvalues: v158 (copy)
			return math.abs(p6.position - v158) < math.abs(p7.position - v158)
		end)

		local v162 = t2[1]

		if not v115.current then
			v119.current = -current

			if v162.index == 0 then
				v126(true)

				return
			end

			v123(v162.index)
		end
	end, {
		v87,
		v123,
		v122,
		v126
	})

	React.useEffect(function() -- line: 459
		-- upvalues: v70 (copy), reducedMotion (copy), v124 (copy), v69 (copy), v97 (copy), Otter (copy), v123 (copy), v71 (copy), v88 (copy), v87 (copy), u93 (ref), v114 (copy), v120 (copy)
		if v70 then
			if reducedMotion then
				v124(v69.defaultSnapPointIndex)
				v97(Otter.instant(0))
			else
				v123(v69.defaultSnapPointIndex)
				v97(Otter.ease(0, {
					duration = v71.Time.Time_100
				}))
			end

			if math.min(v88(v87[v69.defaultSnapPointIndex]), u93) == u93 then
				v114(true)
			end
		end

		return function() -- line: 480
			-- upvalues: v120 (copy)
			v120()
		end
	end, {
		v70,
		v87,
		v69.defaultSnapPointIndex,
		v123,
		v88,
		v124,
		reducedMotion
	})
	React.useEffect(function() -- line: 498
		-- upvalues: v116 (copy), v127 (copy), v115 (copy), v120 (copy), v110 (copy), v109 (copy), u93 (ref), u75 (ref), v95 (copy), v114 (copy), v128 (copy)
		local connection = game:GetService("UserInputService").TouchPan:Connect(function(_, _, p10, _) -- line: 499
			-- upvalues: v116 (copy), v127 (copy)
			v116.current = p10.Y
			v127()
		end)
		local connection2 = game:GetService("UserInputService").InputBegan:Connect(function() -- line: 503
			-- upvalues: v115 (copy), v116 (copy), v120 (copy)
			v115.current = true
			v116.current = 0
			v120()
		end)
		local connection3 = game:GetService("UserInputService").InputEnded:Connect(function() -- line: 508
			-- upvalues: v115 (copy), v116 (copy), v110 (copy), v109 (copy), u93 (ref), u75 (ref), v95 (copy), v114 (copy), v128 (copy)
			if v115.current == false then
				return
			end

			v115.current = false
			v116.current = not v110.current and 0 or v110.current:GetScrollVelocity().Y

			if v109.current >= math.floor(u93 + u75) or v95.current then
				v114(true)

				return
			end

			v128()
		end)

		return function() -- line: 531
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, {
		v70,
		v128,
		v127,
		v120
	})

	local v129 = React.useRef(nil)
	local v130, v131 = React.useState(nil)
	local v132, v133 = React.useState(nil)
	local v134 = ReactUtils.useComposedRef(p5, v133)

	React.useImperativeHandle(v69.sheetRef, function() -- line: 544
		-- upvalues: v126 (copy)
		return {
			close = v126
		}
	end, {})

	local v135 = React.useMemo(function() -- line: 551
		-- upvalues: v100 (copy), v101 (copy), v102 (copy), v103 (copy), v98 (copy), v99 (copy), u75 (ref), v113 (copy), v111 (copy), v112 (copy), v127 (copy), v104 (copy), v105 (copy), v106 (copy), v107 (copy), v108 (copy), v126 (copy), SheetType (copy), v132 (copy), v69 (copy), v129 (copy), v130 (copy), v131 (copy)
		return {
			bottomPadding = 200,
			hasRadius = true,
			actionsHeight = v100,
			setActionsHeight = v101,
			hasActionsDivider = v102,
			setHasActionsDivider = v103,
			sheetHeightAvailable = v98,
			setSheetHeightAvailable = v99,
			safeAreaPadding = u75,
			innerScrollingEnabled = v113,
			innerScrollY = v111,
			setInnerScrollY = function(n13: number) -- line: 563
				-- upvalues: v112 (copy), v127 (copy)
				v112(n13)
				v127()
			end,
			hasHeader = v104,
			setHasHeader = v105,
			hasFullBleed = v106,
			fullBleedHeight = v107,
			setFullBleedHeight = v108,
			closeSheet = v126,
			sheetType = SheetType.Bottom,
			innerSurface = v132,
			testId = v69.testId,
			closeAffordanceRef = v129,
			contentStartRef = v130,
			setContentStartRef = v131
		}
	end, {
		v69.testId,
		v126,
		u75,
		v127,
		v132,
		v129,
		v130,
		v106
	})
	local v136 = React.createElement(View, {
		ZIndex = 3,
		tag = "align-y-center size-1000-100 padding-y-small radius-small",
		backgroundStyle = v71.Color.Content.Muted,
		Position = UDim2.new(0.5, 0, 0, if not v106 then -v71.Padding.XSmall else v71.Padding.Small),
		AnchorPoint = Vector2.new(0.5, 0),
		testId = `{ v69.testId }--gripper`
	}, {
		TouchTarget = React.createElement(View, {
			tag = "size-1000-600",
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			onActivated = function() -- line: 607
				-- upvalues: v115 (copy), v87 (copy), v94 (copy), reducedMotion (copy), v124 (copy), v123 (copy), v88 (copy), u93 (ref), v114 (copy), v126 (copy)
				v115.current = false

				if #v87 > 1 then
					local v166 = v94.current % #v87 + 1

					if reducedMotion then
						v124(v166)
					else
						v123(v166)
					end

					if math.min(v88(v87[v166]), u93) == u93 then
						v114(true)

						return
					end
				else
					v126()
				end
			end
		})
	})

	return v70 and ReactRoblox.createPortal(React.createElement(View, {
		ZIndex = v72.zIndex,
		ref = v134,
		selection = Types.nonSelectable,
		selectionGroup = Types.isolatedSelectionGroup,
		Size = if not v30 then nil else UDim2.new(1, 0, 0, u81),
		tag = not v30 and "size-full" or nil,
		testId = `{ v69.testId }--surface`
	}, React.createElement("ScrollingFrame", {
		Size = if not v30 then UDim2.fromScale(1, 1) else UDim2.new(1, 0, 0, u81),
		CanvasSize = UDim2.new(1, 0, 1, u93 + u75),
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 0,
		ref = v110,
		[React.Change.CanvasPosition] = function(p12) -- line: 654
			-- upvalues: v109 (copy), v99 (copy), u75 (ref), v71 (copy), v127 (copy), v126 (copy)
			v109.current = p12.CanvasPosition.Y
			v99(v109.current - u75 - v71.Margin.Small)
			v127()

			if v109.current <= 0 then
				v126()
			end
		end
	}, {
		SheetContainer = React.createElement(View, {
			ZIndex = 3,
			Size = UDim2.new(1, 0, 1, 200 - u93 - u75),
			Position = UDim2.new(0, 0, 1, -u93)
		}, {
			Sheet = React.createElement(View, {
				Size = if v69.snapPoints ~= nil then UDim2.new(1, 0, 0, u93 + 200) else UDim2.fromScale(1, 0),
				AutomaticSize = if v69.snapPoints ~= nil then nil else Enum.AutomaticSize.Y,
				onAbsoluteSizeChanged = if v69.snapPoints ~= nil then nil else function(p13) -- line: 674
					-- upvalues: v85 (copy)
					v85(p13.AbsoluteSize.Y - 200)
				end,
				stateLayer = {
					affordance = StateLayerAffordance.None
				},
				onActivated = Dash.noop,
				testId = v69.testId,
				tag = {
					["col items-center radius-large clip bg-surface-100"] = true,
					["padding-top-medium"] = not v106
				}
			}, {
				GripperContainer = React.createElement("Folder", nil, {
					Gripper = v136
				}),
				Content = React.createElement(SheetContext.Provider, {
					value = v135
				}, React.createElement(ElevationOwnerScope, {
					owner = v72
				}, v69.children))
			})
		}),
		Shadow = React.createElement(Image, {
			ZIndex = 2,
			Image = SHADOW_IMAGE,
			Size = UDim2.new(1, SHADOW_SIZE * 2, 0, u93 + 200 + SHADOW_SIZE * 2),
			Position = UDim2.new(-SHADOW_SIZE, 0, 1, -u93 - SHADOW_SIZE),
			slice = {
				scale = 2,
				center = Rect.new(SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE + 1, SHADOW_SIZE + 1)
			},
			imageStyle = v71.Color.Extended.Black.Black_10
		}),
		Backdrop = React.createElement(View, {
			ZIndex = 1,
			Size = UDim2.fromScale(1, 2),
			Position = UDim2.fromScale(0, -0.5),
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			backgroundStyle = v96:map(function(n14: number) -- line: 717
				-- upvalues: v71 (copy)
				return {
					Color3 = v71.Color.Common.Backdrop.Color3,
					Transparency = math.lerp(v71.Color.Common.Backdrop.Transparency, 1, n14)
				}
			end),
			onActivated = function() -- line: 723
				-- upvalues: v126 (copy)
				v126()
			end,
			testId = `{ v69.testId }--backdrop`
		})
	})), v70)
end

return React.memo(React.forwardRef(BottomSheet))
