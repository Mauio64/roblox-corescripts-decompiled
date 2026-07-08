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

local function advanceCriticalDampedSpring(n1: number, n2: number, n3: number, n4: number) -- line: 60
	local v37 = n1 - n3
	local v38 = 25.132741228718345 * n4
	local v39 = math.exp(-v38)
	local v40 = n2 + 25.132741228718345 * v37
	local v41 = (v37 + v40 * n4) * v39
	local v42 = (n2 - v40 * v38) * v39

	return n3 + v41, v42
end
local function BottomSheet(p1, p2) -- line: 78
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
	local v56 = React.useMemo(function() -- line: 94
		-- upvalues: v54 (copy)
		return { v54 }
	end, { v54 })
	local v57 = v45.snapPoints or v56
	local v58 = React.useCallback(function(n5: number) -- line: 101
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
	local v67, v68 = useAnimatedBinding(1, function() -- line: 125
		-- upvalues: v66 (copy), v45 (copy)
		if v66.current then
			v45.onClose()
		end
	end)
	local v69, v70 = React.useBinding(-bottom)
	local v71, v72 = React.useBinding(0)
	local v73, v74 = React.useBinding(false)
	local v75, v76 = React.useBinding(false)
	local u77 = nil
	local u78 = nil
	local u79 = nil

	if Flags.FoundationSheetFullBleed then
		u77 = childrenHasFullBleed(v45.children)

		local v80, v81 = React.useBinding(0)

		u78 = v80
		u79 = v81
	end

	local v82 = React.useRef(0)
	local v83 = React.useRef(nil)
	local v84, v85 = React.useBinding(0)
	local v86 = if not Flags.FoundationBottomSheetInnerScrollingSync then nil else React.useRef(nil)
	local v87, v88 = React.useBinding(false)
	local v89 = React.useRef(false)
	local v90 = React.useRef(0)
	local v91 = React.useRef(nil)
	local v92 = React.useRef(false)
	local v93 = React.useRef(0)
	local v94 = React.useCallback(function() -- line: 155
		-- upvalues: v91 (copy), v90 (copy), v92 (copy)
		if v91.current then
			v91.current:Disconnect()
			v91.current = nil
		end

		v90.current = 0
		v92.current = false
	end, {})
	local v95 = React.useCallback(function(n7: number) -- line: 164
		-- upvalues: v94 (copy), v92 (copy), Flags (copy), v83 (copy), v91 (copy), v93 (copy)
		v94()
		v92.current = true

		if Flags.FoundationBottomSheetImproveSpring and v83.current then
			v83.current:ResetScrollVelocity()
		end

		local u112 = not v83.current and 0 or v83.current.CanvasPosition.Y

		v91.current = game:GetService("RunService").Heartbeat:Connect(function(dt) -- line: 176
			-- upvalues: v83 (copy), v92 (copy), v94 (copy), Flags (copy), v93 (copy), n7 (copy), u112 (ref)
			if not v83.current or not v92.current then
				v94()

				return
			end

			local CanvasPositionY = v83.current.CanvasPosition.Y
			local v147

			if Flags.FoundationBottomSheetImproveSpring then
				local current = v93.current
				local v139 = n7
				local v140 = CanvasPositionY - v139
				local v141 = 25.132741228718345 * dt
				local v142 = math.exp(-v141)
				local v143 = current + 25.132741228718345 * v140
				local v144 = (v140 + v143 * dt) * v142
				local v145 = (current - v143 * v141) * v142
				local v146 = v139 + v144

				v93.current = v145
				v83.current.CanvasPosition = Vector2.new(0, v146)
				u112 = v83.current.CanvasPosition.Y
				v147 = n7 - v83.current.CanvasPosition.Y
			else
				v147 = n7 - CanvasPositionY

				local v148 = v147 * 18 * 18
				local v149 = (CanvasPositionY - u112) / dt
				local v150 = v93

				v150.current = v150.current - v149

				local v151 = v148 + -v93.current * 2 * 0.9 * 18
				local v152 = math.min(dt, 0.03333333333333333)

				v93.current = v93.current + v151 * v152

				local v153 = CanvasPositionY + v93.current * v152

				v83.current.CanvasPosition = Vector2.new(0, v153)
				u112 = v83.current.CanvasPosition.Y
			end

			if math.abs(v147) < 0.5 and math.abs(v93.current) < 1 then
				v83.current.CanvasPosition = Vector2.new(0, n7)
				v94()
			end
		end)
	end, { v94 })
	local v96 = React.useCallback(function(n8: number) -- line: 224
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
	local v97 = React.useCallback(function(n9: number) -- line: 238
		-- upvalues: v65 (copy), v95 (copy), v96 (copy), v57 (copy)
		v65.current = n9
		v95(v96(v57[n9]))
	end, {
		v96,
		v57
	})
	local v98 = React.useCallback(function(n10: number) -- line: 243
		-- upvalues: v94 (copy), v65 (copy), v83 (copy), v96 (copy), v57 (copy)
		v94()
		v65.current = n10

		if v83.current then
			v83.current.CanvasPosition = Vector2.new(0, v96(v57[n10]))
		end
	end, {
		v94,
		v96,
		v57
	})
	local v99 = React.useCallback(function(b1: boolean?) -- line: 251
		-- upvalues: v66 (copy), reducedMotion (copy), v94 (copy), v83 (copy), v68 (copy), Otter (copy), v93 (copy), v90 (copy), v95 (copy), v47 (copy)
		if v66.current then
			return
		end

		if reducedMotion and not b1 then
			v66.current = true
			v94()

			if v83.current then
				v83.current.CanvasPosition = Vector2.new(0, 0)
			end

			v68((Otter.instant(1)))

			return
		end

		v93.current = -v90.current
		v95(0)
		v68(Otter.ease(1, {
			duration = v47.Time.Time_100
		}))
		v66.current = true
	end, {
		v95,
		v94,
		reducedMotion
	})
	local v100 = React.useCallback(function() -- line: 272
		-- upvalues: v84 (copy), v82 (copy), Flags (copy), u63 (ref), bottom (copy), v90 (copy), v89 (copy), v88 (copy)
		local v117 = v84:getValue() <= 0
		local v118 = v82.current >= if not Flags.FoundationBottomSheetImproveSpring then math.round(u63 + bottom) else math.floor(u63 + bottom)
		local v119 = not v118 and v90.current < 0

		if Flags.FoundationBottomSheetInnerScrollingSync and v119 or v90.current > 0 and v117 and v89.current then
			v88(false)

			return
		end

		if (v90.current < 0 or Flags.FoundationBottomSheetImproveSpring and v90.current == 0) and v118 then
			v88(true)
		end
	end, {
		u63,
		bottom
	})
	local v101 = React.useCallback(function() -- line: 293
		-- upvalues: v90 (copy), v82 (copy), v57 (copy), v96 (copy), v89 (copy), v93 (copy), v99 (copy), v97 (copy)
		local current = v90.current
		local v121 = v82.current - current / 2.35
		local t2 = {{
			index = 0,
			position = 0
		}}

		for v123, v124 in v57 do
			table.insert(t2, {
				index = v123,
				position = v96(v124)
			})
		end

		table.sort(t2, function(p3, p4) -- line: 311
			-- upvalues: v121 (copy)
			return math.abs(p3.position - v121) < math.abs(p4.position - v121)
		end)

		local v125 = t2[1]

		if not v89.current then
			v93.current = -current

			if v125.index == 0 then
				v99(true)

				return
			end

			v97(v125.index)
		end
	end, {
		v57,
		v97,
		v96,
		v99
	})

	React.useEffect(function() -- line: 327
		-- upvalues: v46 (copy), reducedMotion (copy), v98 (copy), v45 (copy), v68 (copy), Otter (copy), v97 (copy), v47 (copy), Flags (copy), v58 (copy), v57 (copy), u63 (ref), v88 (copy), v94 (copy)
		if v46 then
			if reducedMotion then
				v98(v45.defaultSnapPointIndex)
				v68(Otter.instant(0))
			else
				v97(v45.defaultSnapPointIndex)
				v68(Otter.ease(0, {
					duration = v47.Time.Time_100
				}))
			end

			local v126 = if not Flags.FoundationBottomSheetCapToOverlayHeight then v58(v57[v45.defaultSnapPointIndex]) == u63 else v58(v57[v45.defaultSnapPointIndex]) >= u63

			if Flags.FoundationBottomSheetInnerScrollingSync then
				v88(v126)
			elseif v126 then
				v88(true)
			end
		end

		return function() -- line: 349
			-- upvalues: v94 (copy)
			v94()
		end
	end, {
		v46,
		v57,
		v45.defaultSnapPointIndex,
		v97,
		v58,
		v98,
		reducedMotion
	})
	React.useEffect(function() -- line: 367
		-- upvalues: v90 (copy), v100 (copy), v89 (copy), v94 (copy), Flags (copy), v83 (copy), v82 (copy), u63 (ref), bottom (copy), v66 (copy), v88 (copy), v101 (copy)
		local connection = game:GetService("UserInputService").TouchPan:Connect(function(_, _, p7, _) -- line: 368
			-- upvalues: v90 (copy), v100 (copy)
			v90.current = p7.Y
			v100()
		end)
		local connection2 = game:GetService("UserInputService").InputBegan:Connect(function() -- line: 372
			-- upvalues: v89 (copy), v90 (copy), v94 (copy)
			v89.current = true
			v90.current = 0
			v94()
		end)
		local connection3 = game:GetService("UserInputService").InputEnded:Connect(function() -- line: 377
			-- upvalues: v89 (copy), Flags (copy), v83 (copy), v90 (copy), v82 (copy), u63 (ref), bottom (copy), v66 (copy), v88 (copy), v101 (copy)
			if v89.current == false then
				return
			end

			v89.current = false

			if Flags.FoundationBottomSheetImproveSpring then
				v90.current = not v83.current and 0 or v83.current:GetScrollVelocity().Y

				if v82.current >= math.floor(u63 + bottom) or v66.current then
					v88(true)

					return
				end
			else
				local v160 = nil

				if v83.current then
					local ok, result = pcall(function() -- line: 402
						-- upvalues: v83 (copy)
						return v83.current:GetScrollVelocity().Y == 0
					end)

					if ok then
						v160 = result
					end
				end

				if v160 or v66.current then
					v88(true)

					return
				end
			end

			v101()
		end)

		return function() -- line: 423
			-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
			connection:Disconnect()
			connection2:Disconnect()
			connection3:Disconnect()
		end
	end, {
		v46,
		v101,
		v100,
		v94
	})

	local v102 = React.useRef(nil)
	local v103, v104 = React.useState(nil)
	local v105, v106 = React.useState(nil)
	local v107 = ReactUtils.useComposedRef(p2, v106)

	React.useImperativeHandle(v45.sheetRef, function() -- line: 436
		-- upvalues: v99 (copy)
		return {
			close = v99
		}
	end, {})

	local v108 = React.useMemo(function() -- line: 443
		-- upvalues: v71 (copy), v72 (copy), v73 (copy), v74 (copy), v69 (copy), v70 (copy), bottom (copy), v87 (copy), v84 (copy), Flags (copy), v86 (copy), v85 (copy), v100 (copy), v75 (copy), v76 (copy), u77 (ref), u78 (ref), u79 (ref), v99 (copy), SheetType (copy), v105 (copy), v45 (copy), v102 (copy), v103 (copy), v104 (copy)
		return {
			bottomPadding = 200,
			actionsHeight = v71,
			setActionsHeight = v72,
			hasActionsDivider = v73,
			setHasActionsDivider = v74,
			sheetHeightAvailable = v69,
			setSheetHeightAvailable = v70,
			safeAreaPadding = bottom,
			innerScrollingEnabled = v87,
			innerScrollY = v84,
			innerScrollingRef = if not Flags.FoundationBottomSheetInnerScrollingSync then nil else v86,
			setInnerScrollY = function(n11: number) -- line: 456
				-- upvalues: v85 (copy), v100 (copy)
				v85(n11)
				v100()
			end,
			hasHeader = v75,
			setHasHeader = v76,
			hasFullBleed = if not Flags.FoundationSheetFullBleed then nil else u77,
			fullBleedHeight = if not Flags.FoundationSheetFullBleed then nil else u78,
			setFullBleedHeight = if not Flags.FoundationSheetFullBleed then nil else u79,
			closeSheet = v99,
			hasRadius = not not Flags.FoundationSheetFullBleed or nil,
			sheetType = SheetType.Bottom,
			innerSurface = v105,
			testId = v45.testId,
			closeAffordanceRef = v102,
			contentStartRef = v103,
			setContentStartRef = v104
		}
	end, {
		v45.testId,
		v99,
		bottom,
		v100,
		v105,
		v102,
		v103,
		u77
	})
	local v109 = React.createElement(View, {
		ZIndex = 3,
		tag = "align-y-center size-1000-100 padding-y-small radius-small",
		backgroundStyle = v47.Color.Content.Muted,
		Position = if not Flags.FoundationSheetFullBleed then nil else UDim2.new(0.5, 0, 0, if not u77 then -v47.Padding.XSmall else v47.Padding.Small),
		AnchorPoint = if not Flags.FoundationSheetFullBleed then nil else Vector2.new(0.5, 0),
		testId = `{ v45.testId }--gripper`
	}, {
		TouchTarget = React.createElement(View, {
			tag = "size-1000-600",
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			onActivated = function() -- line: 502
				-- upvalues: v89 (copy), Flags (copy), v86 (copy), v85 (copy), v57 (copy), v65 (copy), reducedMotion (copy), v98 (copy), v97 (copy), v58 (copy), u63 (ref), v88 (copy), v99 (copy)
				v89.current = false

				if Flags.FoundationBottomSheetInnerScrollingSync and v86.current then
					v85(0)
					v86.current.CanvasPosition = Vector2.new(0, 0)
					v86.current:ResetScrollVelocity()
				end

				if #v57 > 1 then
					local v130 = v65.current % #v57 + 1

					if reducedMotion then
						v98(v130)
					else
						v97(v130)
					end

					local v131 = if not Flags.FoundationBottomSheetCapToOverlayHeight then v58(v57[v130]) == u63 else v58(v57[v130]) >= u63

					if Flags.FoundationBottomSheetInnerScrollingSync then
						v88(v131)

						return
					end

					if v131 then
						v88(true)

						return
					end
				else
					v99()
				end
			end
		})
	})

	return v46 and ReactRoblox.createPortal(React.createElement(View, {
		tag = "size-full",
		ZIndex = v48.zIndex,
		ref = v107,
		selection = Types.nonSelectable,
		selectionGroup = Types.isolatedSelectionGroup,
		testId = `{ v45.testId }--surface`,
		onAbsoluteSizeChanged = if not Flags.FoundationBottomSheetCapToOverlayHeight then nil else function(p9) -- line: 544
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
		ref = v83,
		[React.Change.CanvasPosition] = function(p10) -- line: 559
			-- upvalues: v82 (copy), v70 (copy), bottom (copy), v47 (copy), v100 (copy), v99 (copy)
			v82.current = p10.CanvasPosition.Y
			v70(v82.current - bottom - v47.Margin.Small)
			v100()

			if v82.current <= 0 then
				v99()
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
				onAbsoluteSizeChanged = if v45.snapPoints ~= nil then nil else function(p11) -- line: 583
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
					["padding-top-medium"] = not u77
				}
			}, {
				GripperContainer = if not Flags.FoundationSheetFullBleed then v109 else React.createElement("Folder", nil, {
					Gripper = v109
				}),
				Content = React.createElement(SheetContext.Provider, {
					value = v108
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
			backgroundStyle = v67:map(function(n12: number) -- line: 632
				-- upvalues: v47 (copy)
				return {
					Color3 = v47.Color.Common.Backdrop.Color3,
					Transparency = math.lerp(v47.Color.Common.Backdrop.Transparency, 1, n12)
				}
			end),
			onActivated = function() -- line: 638
				-- upvalues: v99 (copy)
				v99()
			end,
			testId = `{ v45.testId }--backdrop`
		})
	})), v46)
end

return React.memo(React.forwardRef(BottomSheet))
