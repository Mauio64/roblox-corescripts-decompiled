local Foundation = game:GetService("CorePackages").Packages._Index.Foundation.Foundation
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local Otter = require(FoundationParent.Otter)
local React = require(FoundationParent.React)
local ReactOtter = require(FoundationParent.ReactOtter)
local ReactRoblox = require(FoundationParent.ReactRoblox)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local CloseAffordanceVariant = require(Foundation.Enums.CloseAffordanceVariant)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)
local DIALOG_SIZES = require(Foundation.Components.Dialog.useDialogVariants).DIALOG_SIZES
local Constants = require(Foundation.Constants)
local DialogSize = require(Foundation.Enums.DialogSize)
local ElevationLayer = require(Foundation.Enums.ElevationLayer)
local useElevation = require(Foundation.Providers.Elevation.useElevation)
local ElevationOwnerScope = require(Foundation.Providers.Elevation.ElevationProvider).ElevationOwnerScope
local Flags = require(Foundation.Utility.Flags)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local SheetContext = require(script.Parent.SheetContext)
local Types = require(script.Parent.Types)
local SheetType = require(script.Parent.SheetType)
local childrenHasFullBleed = require(script.Parent.childrenHasFullBleed)
local CloseAffordance = require(Foundation.Components.CloseAffordance)
local Image = require(Foundation.Components.Image)
local View = require(Foundation.Components.View)
local t1 = {
	testId = "--foundation-sheet",
	size = DialogSize.Medium
}
local SHADOW_IMAGE = Constants.SHADOW_IMAGE
local SHADOW_SIZE = Constants.SHADOW_SIZE

local function CenterSheet(p1, p2) -- line: 52
	-- upvalues: withDefaults (copy), t1 (copy), useOverlay (copy), useTokens (copy), useElevation (copy), ElevationLayer (copy), usePreferences (copy), useScaledValue (copy), DIALOG_SIZES (copy), React (copy), useAnimatedBinding (copy), Flags (copy), childrenHasFullBleed (copy), Otter (copy), Dash (copy), SheetType (copy), View (copy), StateLayerAffordance (copy), Types (copy), SheetContext (copy), ElevationOwnerScope (copy), CloseAffordance (copy), CloseAffordanceVariant (copy), Image (copy), SHADOW_IMAGE (copy), SHADOW_SIZE (copy), ReactRoblox (copy)
	local v36 = withDefaults(p1, t1)
	local v37 = useOverlay()
	local v38 = useTokens()
	local v39 = useElevation(ElevationLayer.Sheet, {
		stackAboveOwner = false
	})
	local reducedMotion = usePreferences().reducedMotion
	local v41 = useScaledValue(DIALOG_SIZES[v36.size])
	local v42 = useScaledValue(600)
	local Size_800 = v38.Size.Size_800
	local v44, v45 = React.useBinding(v42)
	local v46 = if not v44 then nil else v44:map(function(n1: number) -- line: 69
		-- upvalues: v36 (copy)
		if v36.centerSheetHeight then
			if v36.centerSheetHeight > 0 and v36.centerSheetHeight <= 1 then
				return n1 * v36.centerSheetHeight
			end

			if v36.centerSheetHeight > 1 then
				return (math.min(v36.centerSheetHeight, n1))
			end
		end

		return nil
	end)
	local v47, v48 = React.useState(true)
	local v49 = React.useRef(false)
	local v50, v51 = useAnimatedBinding(1, function() -- line: 84
		-- upvalues: v49 (copy), v36 (copy)
		if v49.current then
			v36.onClose()
		end
	end)
	local v52, v53 = useAnimatedBinding(Size_800, function() -- line: 90
		-- upvalues: v48 (copy)
		v48(false)
	end)
	local v54, v55 = React.useBinding(false)
	local v56, v57 = React.useBinding(false)
	local u58 = nil
	local u59 = nil
	local u60 = nil

	if Flags.FoundationSheetFullBleed then
		u58 = childrenHasFullBleed(v36.children)

		local v61, v62 = React.useBinding(0)

		u59 = v61
		u60 = v62
	end

	local v63, v64 = React.useBinding(0)
	local v65, v66 = React.useBinding(0)
	local v67 = React.useRef(nil)
	local v68, v69 = React.useState(nil)
	local v70 = if not Flags.FoundationCenterSheetUseStableContainer then nil else React.useMemo(function() -- line: 112
		local Frame = Instance.new("Frame")

		Frame.BackgroundTransparency = 1
		Frame.BorderSizePixel = 0
		Frame.AutomaticSize = Enum.AutomaticSize.XY

		return Frame
	end, {})

	if Flags.FoundationCenterSheetUseStableContainer then
		React.useEffect(function() -- line: 122
			-- upvalues: v70 (copy)
			return function() -- line: 123
				-- upvalues: v70 (copy)
				v70:Destroy()
			end
		end, {})
	end

	local v71 = if not Flags.FoundationCenterSheetUseStableContainer then nil else React.useCallback(function(p3) -- line: 131
		-- upvalues: v70 (copy)
		if p3 then
			v70.Parent = p3

			return
		end

		v70.Parent = nil
	end, {})

	React.useEffect(function() -- line: 143
		-- upvalues: reducedMotion (copy), v53 (copy), Otter (copy), v51 (copy), v38 (copy)
		if reducedMotion then
			v53((Otter.instant(0)))
			v51((Otter.instant(0)))

			return
		end

		v53(Otter.ease(0, {
			easingStyle = v38.Ease.StandardOut,
			duration = v38.Time.Time_300
		}))
		v51(Otter.ease(0, {
			duration = v38.Time.Time_100
		}))
	end, {})

	local v72 = React.useCallback(function() -- line: 159
		-- upvalues: v49 (copy), reducedMotion (copy), v53 (copy), Otter (copy), Size_800 (copy), v51 (copy), v38 (copy), v48 (copy)
		if v49.current then
			return
		end

		if reducedMotion then
			v49.current = true
			v53(Otter.instant(Size_800))
			v51(Otter.instant(1))

			return
		end

		v53(Otter.ease(Size_800, {
			easingStyle = v38.Ease.StandardIn,
			duration = v38.Time.Time_100
		}))
		v51(Otter.ease(1, {
			duration = v38.Time.Time_100
		}))
		v48(true)
		v49.current = true
	end, {
		Size_800,
		reducedMotion
	})

	React.useImperativeHandle(v36.sheetRef, function() -- line: 180
		-- upvalues: v72 (copy)
		return {
			close = v72
		}
	end, {})

	local v73 = React.useMemo(function() -- line: 187
		-- upvalues: Dash (copy), v54 (copy), v55 (copy), v46 (copy), v63 (copy), v64 (copy), v56 (copy), v57 (copy), Flags (copy), u58 (ref), u59 (ref), u60 (ref), v72 (copy), SheetType (copy), v36 (copy), v67 (copy), v68 (copy), v69 (copy)
		return {
			actionsHeight = 0,
			sheetHeightAvailable = 0,
			safeAreaPadding = 0,
			bottomPadding = 0,
			innerScrollingEnabled = true,
			setActionsHeight = Dash.noop,
			hasActionsDivider = v54,
			setHasActionsDivider = v55,
			sheetContentHeight = v46,
			setSheetContentHeight = Dash.noop,
			setSheetHeightAvailable = Dash.noop,
			innerScrollY = v63,
			setInnerScrollY = v64,
			hasHeader = v56,
			setHasHeader = v57,
			hasFullBleed = if not Flags.FoundationSheetFullBleed then nil else u58,
			fullBleedHeight = if not Flags.FoundationSheetFullBleed then nil else u59,
			setFullBleedHeight = if not Flags.FoundationSheetFullBleed then nil else u60,
			closeSheet = v72,
			hasRadius = not not Flags.FoundationSheetFullBleed or nil,
			sheetType = SheetType.Center,
			testId = v36.testId,
			closeAffordanceRef = v67,
			contentStartRef = v68,
			setContentStartRef = v69
		}
	end, {
		v36.testId,
		v72,
		v68,
		v67,
		v46,
		u58
	})
	local v74 = React.createElement(View, {
		ClipsDescendants = true,
		ZIndex = 2,
		Size = if not v36.centerSheetHeight or not v46 then nil else v46:map(function(n2: number?) -- line: 222
			if n2 then
				return (UDim2.new(1, 0, 0, n2))
			end

			return nil
		end),
		sizeConstraint = if not v36.centerSheetHeight or not v44 then nil else {
			MaxSize = v44:map(function(n3: number) -- line: 228
				return Vector2.new(1e999, n3)
			end)
		},
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		onActivated = Dash.noop,
		onAbsoluteSizeChanged = function(p4) -- line: 239
			-- upvalues: v66 (copy)
			v66(p4.AbsoluteSize.Y)
		end,
		ref = p2,
		selection = Types.nonSelectable,
		selectionGroup = Types.isolatedSelectionGroup,
		tag = {
			["bg-surface-100 stroke-default stroke-standard radius-large"] = true,
			["size-full-0 auto-y"] = v36.centerSheetHeight == nil
		},
		testId = v36.testId
	}, {
		Content = React.createElement(View, {
			tag = "col items-center size-full-0 auto-y clip",
			Size = if not v36.centerSheetHeight or not v46 then nil else v46:map(function(n4: number?) -- line: 255
				if n4 then
					return (UDim2.new(1, 0, 0, n4))
				end

				return nil
			end)
		}, React.createElement(SheetContext.Provider, {
			value = v73
		}, React.createElement(ElevationOwnerScope, {
			owner = v39
		}, v36.children))),
		CloseAffordance = React.createElement(CloseAffordance, {
			onActivated = v72,
			ref = v67,
			NextSelectionDown = v68,
			variant = if not Flags.FoundationSheetFullBleed or not u58 then CloseAffordanceVariant.Utility else CloseAffordanceVariant.OverMedia,
			Position = UDim2.new(1, -v38.Margin.Small, 0, v38.Margin.Small),
			AnchorPoint = Vector2.new(1, 0),
			Visible = v56:map(function(b1: boolean) -- line: 274
				return not b1
			end),
			testId = `{ v36.testId }--close-affordance`
		})
	})
	local v75 = React.createElement(Image, {
		ZIndex = 1,
		tag = "anchor-center-left",
		Image = SHADOW_IMAGE,
		Size = v65:map(function(n5: number) -- line: 283
			-- upvalues: SHADOW_SIZE (copy)
			return UDim2.new(1, SHADOW_SIZE * 2, 0, n5 + SHADOW_SIZE * 2)
		end),
		Position = UDim2.new(0, -SHADOW_SIZE, 0.5, 0),
		slice = {
			scale = 2,
			center = Rect.new(SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE + 1, SHADOW_SIZE + 1)
		},
		imageStyle = v38.Color.Extended.Black.Black_10
	})

	return v37 and React.createElement(React.Fragment, nil, {
		OverlayPortal = ReactRoblox.createPortal(React.createElement(View, {
			tag = "size-full",
			ZIndex = v39.zIndex,
			testId = `{ v36.testId }--surface`
		}, {
			SheetContainer = React.createElement(View, {
				ZIndex = 2,
				tag = "col align-y-center anchor-center-center size-full padding-medium",
				ref = v71,
				sizeConstraint = {
					MaxSize = Vector2.new(v41, v42)
				},
				Position = v52:map(function(n6: number) -- line: 312
					return UDim2.new(0.5, 0, 0.5, n6)
				end),
				testId = `{ v36.testId }--center-sheet-container`,
				GroupTransparency = if not v47 then nil else v52:map(function(n7: number) -- line: 318
					-- upvalues: Size_800 (copy)
					return n7 / Size_800
				end),
				onAbsoluteSizeChanged = if not v36.centerSheetHeight or not v45 then nil else function(p5) -- line: 323
					-- upvalues: v38 (copy), v45 (copy), v42 (copy)
					local v88 = v38.Margin.Medium * 2

					v45((math.min(p5.AbsoluteSize.Y - v88, v42)))
				end
			}, if Flags.FoundationCenterSheetUseStableContainer then nil else {
				Sheet = v74,
				Shadow = React.createElement("Folder", nil, v75)
			}),
			Backdrop = React.createElement(View, {
				ZIndex = 1,
				Size = UDim2.fromScale(2, 2),
				Position = UDim2.fromScale(-0.5, -0.5),
				stateLayer = {
					affordance = StateLayerAffordance.None
				},
				backgroundStyle = v50:map(function(n8: number) -- line: 343
					-- upvalues: v38 (copy)
					return {
						Color3 = v38.Color.Common.Backdrop.Color3,
						Transparency = math.lerp(v38.Color.Common.Backdrop.Transparency, 1, n8)
					}
				end),
				onActivated = v72,
				testId = `{ v36.testId }--backdrop`
			})
		}), v37),
		SheetContent = if not Flags.FoundationCenterSheetUseStableContainer then nil else ReactRoblox.createPortal({
			Sheet = v74,
			Shadow = v75
		}, v70)
	})
end

return React.memo(React.forwardRef(CenterSheet))
