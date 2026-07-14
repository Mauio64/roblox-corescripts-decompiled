local Foundation = script:FindFirstAncestor("Foundation")
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
local SheetContext = require(script.Parent.SheetContext)
local Types = require(script.Parent.Types)
local SheetType = require(script.Parent.SheetType)
local childrenHasFullBleed = require(script.Parent.childrenHasFullBleed)
local useHardwareInsets = require(script.Parent.useHardwareInsets)
local useScreenHeight = require(script.Parent.useScreenHeight)
local Flags = require(Foundation.Utility.Flags)
local Image = require(Foundation.Components.Image)
local View = require(Foundation.Components.View)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local t1 = {
	defaultSnapPointIndex = 1,
	testId = "--foundation-sheet"
}
local SHADOW_IMAGE = Constants.SHADOW_IMAGE
local SHADOW_SIZE = Constants.SHADOW_SIZE

local function advanceCriticalDampedSpring(n1: number, n2: number, n3: number, n4: number) -- line: 61
	local v37 = n1 - n3
	local v38 = 25.132741228718345 * n4
	local v39 = math.exp(-v38)
	local v40 = n2 + 25.132741228718345 * v37
	local v41 = (v37 + v40 * n4) * v39
	local v42 = (n2 - v40 * v38) * v39

	return n3 + v41, v42
end
local function BottomSheet(p1, p2) -- line: 79
	-- upvalues: withDefaults (copy), t1 (copy), useOverlay (copy), useTokens (copy), useElevation (copy), ElevationLayer (copy), usePreferences (copy), useScreenHeight (copy), Flags (copy), React (copy), useHardwareInsets (copy), useAnimatedBinding (copy), childrenHasFullBleed (copy), Otter (copy), ReactUtils (copy), SheetType (copy), View (copy), StateLayerAffordance (copy), ReactRoblox (copy), Types (copy), Dash (copy), SheetContext (copy), ElevationOwnerScope (copy), Image (copy), SHADOW_IMAGE (copy), SHADOW_SIZE (copy)
	local v45 = withDefaults(p1, t1)
	local v46 = useOverlay()
	local v47 = useTokens()
	local v48 = useElevation(ElevationLayer.Sheet, {
		stackAboveOwner = false
	})
	local reducedMotion = usePreferences().reducedMotion
	local v50 = useScreenHeight()
	local v51 = nil
	local u52 = nil

	if Flags.FoundationBottomSheetCapToOverlayHeight then
		local v53

		v51, v53 = React.useState(not v46 and 0 or v46.AbsoluteSize.Y)
		u52 = v53
	end

	local v54, v55 = React.useState(0)
	local v56 = React.useMemo(function() -- line: 95
		-- upvalues: v54 (copy)
		return { v54 }
	end, { v54 })
	local v57 = v45.snapPoints or v56
	local v58 = React.useCallback(function(n5: number) -- line: 102
		-- upvalues: v50 (copy)
		if n5 > 1 then
			return n5
		end

		return n5 * v50
	end, { v50 })
	local n6 = 0

	for _, v61 in v57 do
		local v62 = v58(v61)

		if n6 < v62 then
			n6 = v62
		end
	end

	local u63 = math.min(n6, v50)

	if Flags.FoundationBottomSheetCapToOverlayHeight and v51 > 0 then
		u63 = math.min(u63, v51)
	end

	local bottom = useHardwareInsets(v46).bottom
	local v65 = React.useRef(0)
	local v66 = React.useRef(false)
	local v67 = if not Flags.FoundationBottomSheetOnSnapPointChanged then nil else React.useRef(v45.onSnapPointChanged)

	if Flags.FoundationBottomSheetOnSnapPointChanged then
		v67.current = v45.onSnapPointChanged
	end

	local v68, v69 = useAnimatedBinding(1, function() -- line: 137
		-- upvalues: v66 (copy), v45 (copy)
		if v66.current then
			v45.onClose()
		end
	end)
	local v70, v71 = React.useBinding(-bottom)
	local v72, v73 = React.useBinding(0)
	local v74, v75 = React.useBinding(false)
	local v76, v77 = React.useBinding(false)
	local u78 = nil
	local u79 = nil
	local u80 = nil

	if Flags.FoundationSheetFullBleed then
		u78 = childrenHasFullBleed(v45.children)

		local v81, v82 = React.useBinding(0)

		u79 = v81
		u80 = v82
	end

	local v83 = React.useRef(0)
	local v84 = React.useRef(nil)
	local v85, v86 = React.useBinding(0)
	local v87 = if not Flags.FoundationBottomSheetInnerScrollingSync then nil else React.useRef(nil)
	local v88, v89 = React.useBinding(false)
	local v90 = React.useRef(false)
	local v91 = React.useRef(0)
	local v92 = React.useRef(nil)
	local v93 = React.useRef(false)
	local v94 = React.useRef(0)
	local v95 = React.useCallback(function() -- line: 167
		-- upvalues: v92 (copy), v91 (copy), v93 (copy)
		if v92.current then
			v92.current:Disconnect()
			v92.current = nil
		end

		v91.current = 0
		v93.current = false
	end, {})
	local v96 = React.useCallback(function(n7: number) -- line: 176
		-- upvalues: v95 (copy), v93 (copy), Flags (copy), v84 (copy), v92 (copy), v94 (copy)
		v95()
		v93.current = true

		if Flags.FoundationBottomSheetImproveSpring and v84.current then
			v84.current:ResetScrollVelocity()
		end

		local u114 = not v84.current and 0 or v84.current.CanvasPosition.Y

		v92.current = game:GetService("RunService").Heartbeat:Connect(function(dt) -- line: 188
			-- upvalues: v84 (copy), v93 (copy), v95 (copy), Flags (copy), v94 (copy), n7 (copy), u114 (ref)
			if not v84.current or not v93.current then
				v95()

				return
			end

			local CanvasPositionY = v84.current.CanvasPosition.Y
			local v150

			if Flags.FoundationBottomSheetImproveSpring then
				local current = v94.current
				local v142 = n7
				local v143 = CanvasPositionY - v142
				local v144 = 25.132741228718345 * dt
				local v145 = math.exp(-v144)
				local v146 = current + 25.132741228718345 * v143
				local v147 = (v143 + v146 * dt) * v145
				local v148 = (current - v146 * v144) * v145
				local v149 = v142 + v147

				v94.current = v148
				v84.current.CanvasPosition = Vector2.new(0, v149)
				u114 = v84.current.CanvasPosition.Y
				v150 = n7 - v84.current.CanvasPosition.Y
			else
				v150 = n7 - CanvasPositionY

				local v151 = v150 * 18 * 18
				local v152 = (CanvasPositionY - u114) / dt
				local v153 = v94

				v153.current = v153.current - v152

				local v154 = v151 + -v94.current * 2 * 0.9 * 18
				local v155 = math.min(dt, 0.03333333333333333)

				v94.current = v94.current + v154 * v155

				local v156 = CanvasPositionY + v94.current * v155

				v84.current.CanvasPosition = Vector2.new(0, v156)
				u114 = v84.current.CanvasPosition.Y
			end

			if math.abs(v150) < 0.5 and math.abs(v94.current) < 1 then
				v84.current.CanvasPosition = Vector2.new(0, n7)
				v95()
			end
		end)
	end, { v95 })
	local v97 = React.useCallback(function(n8: number) -- line: 236
		-- upvalues: Flags (copy), v58 (copy), u63 (ref), bottom (copy)
		if Flags.FoundationBottomSheetCapToOverlayHeight then
			return math.min(v58(n8), u63) + bottom
		end

		return v58(n8) + bottom
	end, {
		bottom,
		v58,
		if not Flags.FoundationBottomSheetCapToOverlayHeight then nil else u63
	})
	local v98 = React.useCallback(function(n9: number) -- line: 250
		-- upvalues: v65 (copy), v96 (copy), v97 (copy), v57 (copy), Flags (copy), v67 (copy)
		v65.current = n9
		v96(v97(v57[n9]))

		if Flags.FoundationBottomSheetOnSnapPointChanged and v67.current then
			v67.current(v57[n9], n9)
		end
	end, {
		v97,
		v57
	})
	local v99 = React.useCallback(function(n10: number) -- line: 258
		-- upvalues: v95 (copy), v65 (copy), v84 (copy), v97 (copy), v57 (copy), Flags (copy), v67 (copy)
		v95()
		v65.current = n10

		if v84.current then
			v84.current.CanvasPosition = Vector2.new(0, v97(v57[n10]))
		end

		if Flags.FoundationBottomSheetOnSnapPointChanged and v67.current then
			v67.current(v57[n10], n10)
		end
	end, {
		v95,
		v97,
		v57
	})
	local v100 = React.useCallback(function(b1: boolean?) -- line: 269
		-- upvalues: v66 (copy), reducedMotion (copy), v95 (copy), v84 (copy), v69 (copy), Otter (copy), v94 (copy), v91 (copy), v96 (copy), v47 (copy)
		if v66.current then
			return
		end

		if reducedMotion and not b1 then
			v66.current = true
			v95()

			if v84.current then
				v84.current.CanvasPosition = Vector2.new(0, 0)
			end

			v69((Otter.instant(1)))

			return
		end

		v94.current = -v91.current
		v96(0)
		v69(Otter.ease(1, {
			duration = v47.Time.Time_100
		}))
		v66.current = true
	end, {
		v96,
		v95,
		reducedMotion
	})
	local v101 = if not Flags.FoundationBottomSheetScrollAtMaxTolerance then nil else React.useCallback(function() -- line: 291
		-- upvalues: u63 (ref), bottom (copy), v83 (copy)
		local v119 = math.floor(u63 + bottom)

		return v83.current >= v119 - 0.01
	end, {
		u63,
		bottom
	})
	local v102 = React.useCallback(function() -- line: 298
		-- upvalues: v85 (copy), Flags (copy), v101 (copy), v83 (copy), u63 (ref), bottom (copy), v91 (copy), v90 (copy), v89 (copy)
		local v120 = v85:getValue() <= 0
		local v121 = if not Flags.FoundationBottomSheetScrollAtMaxTolerance then v83.current >= if not Flags.FoundationBottomSheetImproveSpring then math.round(u63 + bottom) else math.floor(u63 + bottom) else v101()
		local v122 = not v121 and v91.current < 0

		if Flags.FoundationBottomSheetInnerScrollingSync and v122 or v91.current > 0 and v120 and v90.current then
			v89(false)

			return
		end

		if (v91.current < 0 or Flags.FoundationBottomSheetImproveSpring and v91.current == 0) and v121 then
			v89(true)
		end
	end, if not Flags.FoundationBottomSheetScrollAtMaxTolerance then {
		u63,
		bottom
	} else { v101 })
	local v103 = React.useCallback(function() -- line: 326
		-- upvalues: v91 (copy), v83 (copy), v57 (copy), v97 (copy), v90 (copy), v94 (copy), v100 (copy), v98 (copy)
		local current = v91.current
		local v124 = v83.current - current / 2.35
		local t2 = {{
			index = 0,
			position = 0
		}}

		for v126, v127 in v57 do
			table.insert(t2, {
				index = v126,
				position = v97(v127)
			})
		end

		table.sort(t2, function(p3, p4) -- line: 344
			-- upvalues: v124 (copy)
			return math.abs(p3.position - v124) < math.abs(p4.position - v124)
		end)

		local v128 = t2[1]

		if not v90.current then
			v94.current = -current

			if v128.index == 0 then
				v100(true)

				return
			end

			v98(v128.index)
		end
	end, {
		v57,
		v98,
		v97,
		v100
	})

	React.useEffect(function() -- line: 360
		-- upvalues: v46 (copy), reducedMotion (copy), v99 (copy), v45 (copy), v69 (copy), Otter (copy), v98 (copy), v47 (copy), Flags (copy), v58 (copy), v57 (copy), u63 (ref), v89 (copy), v95 (copy)
		if v46 then
			if reducedMotion then
				v99(v45.defaultSnapPointIndex)
				v69(Otter.instant(0))
			else
				v98(v45.defaultSnapPointIndex)
				v69(Otter.ease(0, {
					duration = v47.Time.Time_100
				}))
			end

			local v129 = if not Flags.FoundationBottomSheetCapToOverlayHeight then v58(v57[v45.defaultSnapPointIndex]) == u63 else v58(v57[v45.defaultSnapPointIndex]) >= u63

			if Flags.FoundationBottomSheetInnerScrollingSync then
				v89(v129)
			elseif v129 then
				v89(true)
			end
		end

		return function() -- line: 382
			-- upvalues: v95 (copy)
			v95()
		end
	end, {
		v46,
		v57,
		v45.defaultSnapPointIndex,
		v98,
		v58,
		v99,
		reducedMotion
	})
	React.useEffect(function() -- line: 401
		-- upvalues: v91 (copy), v102 (copy), v90 (copy), v95 (copy), Flags (copy), v84 (copy), v101 (copy), v83 (copy), u63 (ref), bottom (copy), v66 (copy), v89 (copy), v103 (copy)
		local connection = game:GetService("UserInputService").TouchPan:Connect(function(_, _, p7, _) -- line: 402
			-- upvalues: v91 (copy), v102 (copy)
			v91.current = p7.Y
			v102()
		end)
		local connection2 = game:GetService("UserInputService").InputBegan:Connect(function() -- line: 406
			-- upvalues: v90 (copy), v91 (copy), v95 (copy)
			v90.current = true
			v91.current = 0
			v95()
		end)
		local connection3 = game:GetService("UserInputService").InputEnded:Connect(function() -- line: 411
			-- upvalues: v90 (copy), Flags (copy), v84 (copy), v91 (copy), v101 (copy), v83 (copy), u63 (ref), bottom (copy), v66 (copy), v89 (copy), v103 (copy)
			if v90.current == false then
				return
			end

			v90.current = false

			if Flags.FoundationBottomSheetImproveSpring then
				v91.current = not v84.current and 0 or v84.current:GetScrollVelocity().Y

				if ((if not Flags.FoundationBottomSheetScrollAtMaxTolerance then v83.current >= math.floor(u63 + bottom) else v101())) or v66.current then
					v89(true)

					return
				end
			else
				local v163 = nil

				if v84.current then
					local ok, result = pcall(function() -- line: 439
						-- upvalues: v84 (copy)
						return v84.current:GetScrollVelocity().Y == 0
					end)

					if ok then
						v163 = result
					end
				end

				if v163 or v66.current then
					v89(true)

					return
				end
			end

			v103()
		end)

		return function() -- line: 460
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, if not Flags.FoundationBottomSheetScrollAtMaxTolerance then {
		v46,
		v103,
		v102,
		v95
	} else {
		v46,
		v103,
		v102,
		v95,
		v101
	})

	local v104 = React.useRef(nil)
	local v105, v106 = React.useState(nil)
	local v107, v108 = React.useState(nil)
	local v109 = ReactUtils.useComposedRef(p2, v108)

	React.useImperativeHandle(v45.sheetRef, function() -- line: 488
		-- upvalues: v100 (copy)
		return {
			close = v100
		}
	end, {})

	local v110 = React.useMemo(function() -- line: 495
		-- upvalues: v72 (copy), v73 (copy), v74 (copy), v75 (copy), v70 (copy), v71 (copy), bottom (copy), v88 (copy), v85 (copy), Flags (copy), v87 (copy), v86 (copy), v102 (copy), v76 (copy), v77 (copy), u78 (ref), u79 (ref), u80 (ref), v100 (copy), SheetType (copy), v107 (copy), v45 (copy), v104 (copy), v105 (copy), v106 (copy)
		return {
			bottomPadding = 200,
			actionsHeight = v72,
			setActionsHeight = v73,
			hasActionsDivider = v74,
			setHasActionsDivider = v75,
			sheetHeightAvailable = v70,
			setSheetHeightAvailable = v71,
			safeAreaPadding = bottom,
			innerScrollingEnabled = v88,
			innerScrollY = v85,
			innerScrollingRef = if not Flags.FoundationBottomSheetInnerScrollingSync then nil else v87,
			setInnerScrollY = function(n11: number) -- line: 508
				-- upvalues: v86 (copy), v102 (copy)
				v86(n11)
				v102()
			end,
			hasHeader = v76,
			setHasHeader = v77,
			hasFullBleed = if not Flags.FoundationSheetFullBleed then nil else u78,
			fullBleedHeight = if not Flags.FoundationSheetFullBleed then nil else u79,
			setFullBleedHeight = if not Flags.FoundationSheetFullBleed then nil else u80,
			closeSheet = v100,
			hasRadius = not not Flags.FoundationSheetFullBleed or nil,
			sheetType = SheetType.Bottom,
			innerSurface = v107,
			testId = v45.testId,
			closeAffordanceRef = v104,
			contentStartRef = v105,
			setContentStartRef = v106
		}
	end, {
		v45.testId,
		v100,
		bottom,
		v102,
		v107,
		v104,
		v105,
		u78
	})
	local v111 = React.createElement(View, {
		ZIndex = 3,
		tag = "align-y-center size-1000-100 padding-y-small radius-small",
		backgroundStyle = v47.Color.Content.Muted,
		Position = if not Flags.FoundationSheetFullBleed then nil else UDim2.new(0.5, 0, 0, if not u78 then -v47.Padding.XSmall else v47.Padding.Small),
		AnchorPoint = if not Flags.FoundationSheetFullBleed then nil else Vector2.new(0.5, 0),
		testId = `{ v45.testId }--gripper`
	}, {
		TouchTarget = React.createElement(View, {
			tag = "size-1000-600",
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			onActivated = function() -- line: 554
				-- upvalues: v90 (copy), Flags (copy), v87 (copy), v86 (copy), v57 (copy), v65 (copy), reducedMotion (copy), v99 (copy), v98 (copy), v58 (copy), u63 (ref), v89 (copy), v100 (copy)
				v90.current = false

				if Flags.FoundationBottomSheetInnerScrollingSync and v87.current then
					v86(0)
					v87.current.CanvasPosition = Vector2.new(0, 0)
					v87.current:ResetScrollVelocity()
				end

				if #v57 > 1 then
					local v133 = v65.current % #v57 + 1

					if reducedMotion then
						v99(v133)
					else
						v98(v133)
					end

					local v134 = if not Flags.FoundationBottomSheetCapToOverlayHeight then v58(v57[v133]) == u63 else v58(v57[v133]) >= u63

					if Flags.FoundationBottomSheetInnerScrollingSync then
						v89(v134)

						return
					end

					if v134 then
						v89(true)

						return
					end
				else
					v100()
				end
			end
		})
	})

	return v46 and ReactRoblox.createPortal(React.createElement(View, {
		tag = "size-full",
		ZIndex = v48.zIndex,
		ref = v109,
		selection = Types.nonSelectable,
		selectionGroup = Types.isolatedSelectionGroup,
		testId = `{ v45.testId }--surface`,
		onAbsoluteSizeChanged = if not Flags.FoundationBottomSheetCapToOverlayHeight then nil else function(p9) -- line: 596
			-- upvalues: u52 (ref)
			u52(p9.AbsoluteSize.Y)
		end
	}, React.createElement("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		CanvasSize = if not Flags.FoundationSheetPreventCloseOnResize then UDim2.new(1, 0, 0, v50 + u63 + bottom) else UDim2.new(1, 0, 1, u63 + bottom),
		ClipsDescendants = false,
		BackgroundTransparency = 1,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 0,
		ref = v84,
		[React.Change.CanvasPosition] = function(p10) -- line: 611
			-- upvalues: v83 (copy), v71 (copy), bottom (copy), v47 (copy), v102 (copy), v100 (copy)
			v83.current = p10.CanvasPosition.Y
			v71(v83.current - bottom - v47.Margin.Small)
			v102()

			if v83.current <= 0 then
				v100()
			end
		end
	}, {
		SheetContainer = React.createElement(View, {
			ZIndex = 3,
			Size = if not Flags.FoundationSheetPreventCloseOnResize then UDim2.new(1, 0, 0, v50 + 200) else UDim2.new(1, 0, 1, 200 - u63 - bottom),
			Position = if not Flags.FoundationSheetPreventCloseOnResize then UDim2.fromOffset(0, v50 + bottom) else UDim2.new(0, 0, 1, -u63)
		}, {
			Sheet = React.createElement(View, {
				Size = if v45.snapPoints ~= nil then UDim2.new(1, 0, 0, u63 + 200) else UDim2.fromScale(1, 0),
				AutomaticSize = if v45.snapPoints ~= nil then nil else Enum.AutomaticSize.Y,
				onAbsoluteSizeChanged = if v45.snapPoints ~= nil then nil else function(p11) -- line: 635
					-- upvalues: v55 (copy)
					v55(p11.AbsoluteSize.Y - 200)
				end,
				stateLayer = {
					affordance = StateLayerAffordance.None
				},
				onActivated = Dash.noop,
				testId = v45.testId,
				tag = not Flags.FoundationSheetFullBleed and "col items-center padding-top-small radius-large clip bg-surface-100" or {
					["col items-center radius-large clip bg-surface-100"] = true,
					["padding-top-medium"] = not u78
				}
			}, {
				GripperContainer = if not Flags.FoundationSheetFullBleed then v111 else React.createElement("Folder", nil, {
					Gripper = v111
				}),
				Content = React.createElement(SheetContext.Provider, {
					value = v110
				}, React.createElement(ElevationOwnerScope, {
					owner = v48
				}, v45.children))
			})
		}),
		Shadow = React.createElement(Image, {
			ZIndex = 2,
			Image = SHADOW_IMAGE,
			Size = UDim2.new(1, SHADOW_SIZE * 2, 0, u63 + 200 + SHADOW_SIZE * 2),
			Position = if not Flags.FoundationSheetPreventCloseOnResize then UDim2.fromOffset(-SHADOW_SIZE, v50 + bottom - SHADOW_SIZE) else UDim2.new(-SHADOW_SIZE, 0, 1, -u63 - SHADOW_SIZE),
			slice = {
				scale = 2,
				center = Rect.new(SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE + 1, SHADOW_SIZE + 1)
			},
			imageStyle = v47.Color.Extended.Black.Black_10
		}),
		Backdrop = React.createElement(View, {
			ZIndex = 1,
			Size = UDim2.fromScale(1, 2),
			Position = UDim2.fromScale(0, -0.5),
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			backgroundStyle = v68:map(function(n12: number) -- line: 684
				-- upvalues: v47 (copy)
				return {
					Color3 = v47.Color.Common.Backdrop.Color3,
					Transparency = math.lerp(v47.Color.Common.Backdrop.Transparency, 1, n12)
				}
			end),
			onActivated = function() -- line: 690
				-- upvalues: v100 (copy)
				v100()
			end,
			testId = `{ v45.testId }--backdrop`
		})
	})), v46)
end

return React.memo(React.forwardRef(BottomSheet))
