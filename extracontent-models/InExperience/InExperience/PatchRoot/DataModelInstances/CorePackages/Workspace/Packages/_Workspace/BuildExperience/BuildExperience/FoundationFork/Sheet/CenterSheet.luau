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

local function CenterSheet(p1, p2) -- line: 50
	-- upvalues: withDefaults (copy), t1 (copy), useOverlay (copy), useTokens (copy), useElevation (copy), ElevationLayer (copy), usePreferences (copy), useScaledValue (copy), DIALOG_SIZES (copy), React (copy), useAnimatedBinding (copy), childrenHasFullBleed (copy), Otter (copy), Dash (copy), SheetType (copy), View (copy), StateLayerAffordance (copy), Types (copy), SheetContext (copy), ElevationOwnerScope (copy), CloseAffordance (copy), CloseAffordanceVariant (copy), Image (copy), SHADOW_IMAGE (copy), SHADOW_SIZE (copy), ReactRoblox (copy)
	local v35 = withDefaults(p1, t1)
	local v36 = useOverlay()
	local v37 = useTokens()
	local v38 = useElevation(ElevationLayer.Sheet, {
		stackAboveOwner = false
	})
	local reducedMotion = usePreferences().reducedMotion
	local v40 = useScaledValue(DIALOG_SIZES[v35.size])
	local v41 = useScaledValue(600)
	local Size_800 = v37.Size.Size_800
	local v43, v44 = React.useBinding(v41)
	local v45 = if not v43 then nil else v43:map(function(n1: number) -- line: 67
		-- upvalues: v35 (copy)
		if v35.centerSheetHeight then
			if v35.centerSheetHeight > 0 and v35.centerSheetHeight <= 1 then
				return n1 * v35.centerSheetHeight
			end

			if v35.centerSheetHeight > 1 then
				return (math.min(v35.centerSheetHeight, n1))
			end
		end

		return nil
	end)
	local v46, v47 = React.useState(true)
	local v48 = React.useRef(false)
	local v49, v50 = useAnimatedBinding(1, function() -- line: 82
		-- upvalues: v48 (copy), v35 (copy)
		if v48.current then
			v35.onClose()
		end
	end)
	local v51, v52 = useAnimatedBinding(Size_800, function() -- line: 88
		-- upvalues: v47 (copy)
		v47(false)
	end)
	local v53, v54 = React.useBinding(false)
	local v55, v56 = React.useBinding(false)
	local v57 = childrenHasFullBleed(v35.children)
	local v58, v59 = React.useBinding(0)
	local v60, v61 = React.useBinding(0)
	local v62, v63 = React.useBinding(0)
	local v64 = React.useRef(nil)
	local v65, v66 = React.useState(nil)
	local v67 = React.useMemo(function() -- line: 105
		local Frame = Instance.new("Frame")

		Frame.BackgroundTransparency = 1
		Frame.BorderSizePixel = 0
		Frame.AutomaticSize = Enum.AutomaticSize.XY

		return Frame
	end, {})

	React.useEffect(function() -- line: 113
		-- upvalues: v67 (copy)
		return function() -- line: 114
			-- upvalues: v67 (copy)
			v67:Destroy()
		end
	end, { v67 })

	local v68 = React.useCallback(function(p3) -- line: 120
		-- upvalues: v67 (copy)
		if p3 then
			v67.Parent = p3

			return
		end

		v67.Parent = nil
	end, { v67 })

	React.useEffect(function() -- line: 131
		-- upvalues: reducedMotion (copy), v52 (copy), Otter (copy), v50 (copy), v37 (copy)
		if reducedMotion then
			v52((Otter.instant(0)))
			v50((Otter.instant(0)))

			return
		end

		v52(Otter.ease(0, {
			easingStyle = v37.Ease.StandardOut,
			duration = v37.Time.Time_300
		}))
		v50(Otter.ease(0, {
			duration = v37.Time.Time_100
		}))
	end, {})

	local v69 = React.useCallback(function() -- line: 147
		-- upvalues: v48 (copy), reducedMotion (copy), v52 (copy), Otter (copy), Size_800 (copy), v50 (copy), v37 (copy), v47 (copy)
		if v48.current then
			return
		end

		if reducedMotion then
			v48.current = true
			v52(Otter.instant(Size_800))
			v50(Otter.instant(1))

			return
		end

		v52(Otter.ease(Size_800, {
			easingStyle = v37.Ease.StandardIn,
			duration = v37.Time.Time_100
		}))
		v50(Otter.ease(1, {
			duration = v37.Time.Time_100
		}))
		v47(true)
		v48.current = true
	end, {
		Size_800,
		reducedMotion
	})

	React.useImperativeHandle(v35.sheetRef, function() -- line: 168
		-- upvalues: v69 (copy)
		return {
			close = v69
		}
	end, {})

	local v70 = React.useMemo(function() -- line: 175
		-- upvalues: Dash (copy), v53 (copy), v54 (copy), v45 (copy), v60 (copy), v61 (copy), v55 (copy), v56 (copy), v57 (copy), v58 (copy), v59 (copy), v69 (copy), SheetType (copy), v35 (copy), v64 (copy), v65 (copy), v66 (copy)
		return {
			actionsHeight = 0,
			sheetHeightAvailable = 0,
			safeAreaPadding = 0,
			bottomPadding = 0,
			innerScrollingEnabled = true,
			hasRadius = true,
			setActionsHeight = Dash.noop,
			hasActionsDivider = v53,
			setHasActionsDivider = v54,
			sheetContentHeight = v45,
			setSheetContentHeight = Dash.noop,
			setSheetHeightAvailable = Dash.noop,
			innerScrollY = v60,
			setInnerScrollY = v61,
			hasHeader = v55,
			setHasHeader = v56,
			hasFullBleed = v57,
			fullBleedHeight = v58,
			setFullBleedHeight = v59,
			closeSheet = v69,
			sheetType = SheetType.Center,
			testId = v35.testId,
			closeAffordanceRef = v64,
			contentStartRef = v65,
			setContentStartRef = v66
		}
	end, {
		v35.testId,
		v69,
		v65,
		v64,
		v45,
		v57
	})
	local v71 = React.createElement(View, {
		ClipsDescendants = true,
		ZIndex = 2,
		Size = if not v35.centerSheetHeight or not v45 then nil else v45:map(function(n2: number?) -- line: 210
			if n2 then
				return (UDim2.new(1, 0, 0, n2))
			end

			return nil
		end),
		sizeConstraint = if not v35.centerSheetHeight or not v43 then nil else {
			MaxSize = v43:map(function(n3: number) -- line: 216
				return Vector2.new(1e999, n3)
			end)
		},
		stateLayer = {
			affordance = StateLayerAffordance.None
		},
		onActivated = Dash.noop,
		onAbsoluteSizeChanged = function(p4) -- line: 227
			-- upvalues: v63 (copy)
			v63(p4.AbsoluteSize.Y)
		end,
		ref = p2,
		selection = Types.nonSelectable,
		selectionGroup = Types.isolatedSelectionGroup,
		tag = {
			["bg-surface-100 stroke-default stroke-standard radius-large"] = true,
			["size-full-0 auto-y"] = v35.centerSheetHeight == nil
		},
		testId = v35.testId
	}, {
		Content = React.createElement(View, {
			tag = "col items-center size-full-0 auto-y clip",
			Size = if not v35.centerSheetHeight or not v45 then nil else v45:map(function(n4: number?) -- line: 243
				if n4 then
					return (UDim2.new(1, 0, 0, n4))
				end

				return nil
			end)
		}, React.createElement(SheetContext.Provider, {
			value = v70
		}, React.createElement(ElevationOwnerScope, {
			owner = v38
		}, v35.children))),
		CloseAffordance = React.createElement(CloseAffordance, {
			onActivated = v69,
			ref = v64,
			NextSelectionDown = v65,
			variant = if not v57 then CloseAffordanceVariant.Utility else CloseAffordanceVariant.OverMedia,
			Position = UDim2.new(1, -v37.Margin.Small, 0, v37.Margin.Small),
			AnchorPoint = Vector2.new(1, 0),
			Visible = v55:map(function(b1: boolean) -- line: 260
				return not b1
			end),
			testId = `{ v35.testId }--close-affordance`
		})
	})
	local v72 = React.createElement(Image, {
		ZIndex = 1,
		tag = "anchor-center-left",
		Image = SHADOW_IMAGE,
		Size = v62:map(function(n5: number) -- line: 269
			-- upvalues: SHADOW_SIZE (copy)
			return UDim2.new(1, SHADOW_SIZE * 2, 0, n5 + SHADOW_SIZE * 2)
		end),
		Position = UDim2.new(0, -SHADOW_SIZE, 0.5, 0),
		slice = {
			scale = 2,
			center = Rect.new(SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE + 1, SHADOW_SIZE + 1)
		},
		imageStyle = v37.Color.Extended.Black.Black_10
	})

	return v36 and React.createElement(React.Fragment, nil, {
		OverlayPortal = ReactRoblox.createPortal(React.createElement(View, {
			tag = "size-full",
			ZIndex = v38.zIndex,
			testId = `{ v35.testId }--surface`
		}, {
			SheetContainer = React.createElement(View, {
				ZIndex = 2,
				tag = "col align-y-center anchor-center-center size-full padding-medium",
				ref = v68,
				sizeConstraint = {
					MaxSize = Vector2.new(v40, v41)
				},
				Position = v51:map(function(n6: number) -- line: 296
					return UDim2.new(0.5, 0, 0.5, n6)
				end),
				testId = `{ v35.testId }--center-sheet-container`,
				GroupTransparency = if not v46 then nil else v51:map(function(n7: number) -- line: 302
					-- upvalues: Size_800 (copy)
					return n7 / Size_800
				end),
				onAbsoluteSizeChanged = if not v35.centerSheetHeight or not v44 then nil else function(p5) -- line: 307
					-- upvalues: v37 (copy), v44 (copy), v41 (copy)
					local v85 = v37.Margin.Medium * 2

					v44((math.min(p5.AbsoluteSize.Y - v85, v41)))
				end
			}),
			Backdrop = React.createElement(View, {
				ZIndex = 1,
				Size = UDim2.fromScale(2, 2),
				Position = UDim2.fromScale(-0.5, -0.5),
				stateLayer = {
					affordance = StateLayerAffordance.None
				},
				backgroundStyle = v49:map(function(n8: number) -- line: 320
					-- upvalues: v37 (copy)
					return {
						Color3 = v37.Color.Common.Backdrop.Color3,
						Transparency = math.lerp(v37.Color.Common.Backdrop.Transparency, 1, n8)
					}
				end),
				onActivated = v69,
				testId = `{ v35.testId }--backdrop`
			})
		}), v36),
		SheetContent = ReactRoblox.createPortal({
			Sheet = v71,
			Shadow = v72
		}, v67)
	})
end

return React.memo(React.forwardRef(CenterSheet))
