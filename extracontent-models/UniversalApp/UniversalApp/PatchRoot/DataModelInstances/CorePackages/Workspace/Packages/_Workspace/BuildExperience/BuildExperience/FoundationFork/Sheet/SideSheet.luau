local Foundation = game:GetService("CorePackages").Packages._Index.Foundation.Foundation
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local Otter = require(FoundationParent.Otter)
local React = require(FoundationParent.React)
local ReactOtter = require(FoundationParent.ReactOtter)
local ReactRoblox = require(FoundationParent.ReactRoblox)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local CloseAffordanceVariant = require(Foundation.Enums.CloseAffordanceVariant)
local Constants = require(Foundation.Constants)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)
local SheetContext = require(script.Parent.SheetContext)
local Types = require(script.Parent.Types)
local SheetType = require(script.Parent.SheetType)
local useElevation = require(Foundation.Providers.Elevation.useElevation)
local ElevationOwnerScope = require(Foundation.Providers.Elevation.ElevationProvider).ElevationOwnerScope
local ElevationLayer = require(Foundation.Enums.ElevationLayer)
local DialogSize = require(Foundation.Enums.DialogSize)
local childrenHasFullBleed = require(script.Parent.childrenHasFullBleed)
local useHardwareInsets = require(script.Parent.useHardwareInsets)
local useScreenSize = require(script.Parent.useScreenSize)
local CloseAffordance = require(Foundation.Components.CloseAffordance)
local Flags = require(Foundation.Utility.Flags)
local Image = require(Foundation.Components.Image)
local View = require(Foundation.Components.View)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local t1 = {
	[DialogSize.Medium] = {
		TARGET_WIDTH = 0.4,
		MIN = 360,
		MAX = 440
	},
	[DialogSize.Large] = {
		TARGET_WIDTH = 0.5,
		MIN = 440,
		MAX = 640
	}
}
local t2 = {
	testId = "--foundation-sheet",
	size = if not Flags.FoundationSideSheetNewWidthCalculation then nil else DialogSize.Medium
}
local SHADOW_IMAGE = Constants.SHADOW_IMAGE
local SHADOW_SIZE = Constants.SHADOW_SIZE

local function SideSheet(p1, p2) -- line: 69
	-- upvalues: withDefaults (copy), t2 (copy), useOverlay (copy), useTokens (copy), useElevation (copy), ElevationLayer (copy), usePreferences (copy), useHardwareInsets (copy), Flags (copy), useScreenSize (copy), t1 (copy), useScaledValue (copy), React (copy), useAnimatedBinding (copy), childrenHasFullBleed (copy), Otter (copy), Dash (copy), SheetType (copy), ReactRoblox (copy), View (copy), StateLayerAffordance (copy), Types (copy), SheetContext (copy), ElevationOwnerScope (copy), CloseAffordance (copy), CloseAffordanceVariant (copy), Image (copy), SHADOW_IMAGE (copy), SHADOW_SIZE (copy)
	local v38 = withDefaults(p1, t2)
	local v39 = useOverlay()
	local v40 = useTokens()
	local v41 = useElevation(ElevationLayer.Sheet, {
		stackAboveOwner = false
	})
	local reducedMotion = usePreferences().reducedMotion
	local v43 = useHardwareInsets(v39)
	local v44 = if not Flags.FoundationSideSheetNewWidthCalculation then nil else useScreenSize()
	local right = v43.right
	local v46 = v38.displaySize == Enum.DisplaySize.Small
	local TARGET_WIDTH = nil
	local v48 = nil
	local v49 = nil

	if Flags.FoundationSideSheetNewWidthCalculation then
		local UIScale = v40.Config.UI.Scale

		TARGET_WIDTH = t1[v38.size].TARGET_WIDTH
		v48 = t1[v38.size].MIN * UIScale
		v49 = t1[v38.size].MAX * UIScale
	end

	local v51 = if not Flags.FoundationSideSheetNewWidthCalculation then useScaledValue(not v46 and 360 or 400) else math.clamp(v44.X * TARGET_WIDTH, v48, v49)
	local Medium = v40.Padding.Medium
	local v53 = React.useRef(false)
	local v54, v55 = useAnimatedBinding(1, function() -- line: 99
		-- upvalues: v53 (copy), v38 (copy)
		if v53.current then
			v38.onClose()
		end
	end)
	local v56 = -(right + if not v46 then Medium else 0)
	local v57, v58 = useAnimatedBinding(v56)
	local v59, v60 = React.useBinding(false)
	local v61, v62 = React.useBinding(false)
	local u63 = nil
	local u64 = nil
	local u65 = nil

	if Flags.FoundationSheetFullBleed then
		u63 = childrenHasFullBleed(v38.children)

		local v66, v67 = React.useBinding(0)

		u64 = v66
		u65 = v67
	end

	local v68, v69 = React.useBinding(0)
	local v70 = React.useRef(nil)
	local v71, v72 = React.useState(nil)

	React.useEffect(function() -- line: 123
		-- upvalues: reducedMotion (copy), v58 (copy), Otter (copy), v51 (copy), v55 (copy), v40 (copy)
		if reducedMotion then
			v58((Otter.instant(v51)))
			v55((Otter.instant(0)))

			return
		end

		v58(Otter.ease(v51, {
			easingStyle = v40.Ease.StandardOut,
			duration = v40.Time.Time_300
		}))
		v55(Otter.ease(0, {
			duration = v40.Time.Time_100
		}))
	end, {
		v51,
		reducedMotion
	})

	local v73 = React.useCallback(function() -- line: 139
		-- upvalues: v53 (copy), reducedMotion (copy), v58 (copy), Otter (copy), v56 (copy), v55 (copy), v40 (copy)
		if v53.current then
			return
		end

		if reducedMotion then
			v53.current = true
			v58(Otter.instant(v56))
			v55(Otter.instant(1))

			return
		end

		v58(Otter.ease(v56, {
			easingStyle = v40.Ease.StandardIn,
			duration = v40.Time.Time_100
		}))
		v55(Otter.ease(1, {
			duration = v40.Time.Time_100
		}))
		v53.current = true
	end, {
		v56,
		reducedMotion
	})

	React.useImperativeHandle(v38.sheetRef, function() -- line: 159
		-- upvalues: v73 (copy)
		return {
			close = v73
		}
	end, {})

	local uDim2 = UDim2.new(0, v51 + (not v46 and 0 or right), 1, if not v46 then -Medium * 2 else 0)
	local v75 = v57:map(function(n1: number) -- line: 172
		-- upvalues: v46 (copy), Medium (copy)
		return UDim2.new(1, if not v46 then -(n1 + Medium) else -n1, 0, if not v46 then Medium else 0)
	end)
	local v76 = React.useMemo(function() -- line: 182
		-- upvalues: Dash (copy), v59 (copy), v60 (copy), v68 (copy), v69 (copy), v61 (copy), v62 (copy), Flags (copy), u63 (ref), u64 (ref), u65 (ref), v73 (copy), v46 (copy), SheetType (copy), v38 (copy), v70 (copy), v71 (copy), v72 (copy)
		return {
			actionsHeight = 0,
			sheetHeightAvailable = 0,
			safeAreaPadding = 0,
			bottomPadding = 0,
			innerScrollingEnabled = true,
			setActionsHeight = Dash.noop,
			hasActionsDivider = v59,
			setHasActionsDivider = v60,
			setSheetHeightAvailable = Dash.noop,
			innerScrollY = v68,
			setInnerScrollY = v69,
			hasHeader = v61,
			setHasHeader = v62,
			hasFullBleed = if not Flags.FoundationSheetFullBleed then nil else u63,
			fullBleedHeight = if not Flags.FoundationSheetFullBleed then nil else u64,
			setFullBleedHeight = if not Flags.FoundationSheetFullBleed then nil else u65,
			closeSheet = v73,
			hasRadius = if not Flags.FoundationSheetFullBleed then nil else not v46,
			sheetType = SheetType.Side,
			testId = v38.testId,
			closeAffordanceRef = v70,
			contentStartRef = v71,
			setContentStartRef = v72
		}
	end, {
		v38.testId,
		v73,
		v71,
		v70,
		u63,
		if not Flags.FoundationSheetFullBleed then nil else v46
	})

	return v39 and ReactRoblox.createPortal(React.createElement(View, {
		tag = "size-full",
		ZIndex = v41.zIndex,
		testId = `{ v38.testId }--surface`
	}, {
		Sheet = React.createElement(View, {
			ClipsDescendants = true,
			ZIndex = 3,
			Size = uDim2,
			Position = v75,
			padding = if not v46 or not (right > 0) then nil else {
				right = UDim.new(0, right)
			},
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			onActivated = Dash.noop,
			ref = p2,
			selection = Types.nonSelectable,
			selectionGroup = Types.isolatedSelectionGroup,
			tag = {
				["stroke-standard stroke-default bg-surface-100"] = true,
				["radius-large"] = not v46
			},
			testId = v38.testId
		}, {
			Content = React.createElement(View, {
				tag = "col items-center size-full-full clip"
			}, React.createElement(SheetContext.Provider, {
				value = v76
			}, React.createElement(ElevationOwnerScope, {
				owner = v41
			}, v38.children))),
			CloseAffordance = React.createElement(CloseAffordance, {
				onActivated = v73,
				ref = v70,
				NextSelectionDown = v71,
				variant = if not Flags.FoundationSheetFullBleed or not u63 then CloseAffordanceVariant.Utility else CloseAffordanceVariant.OverMedia,
				Position = UDim2.new(1, -v40.Margin.Small, 0, v40.Margin.Small),
				AnchorPoint = Vector2.new(1, 0),
				Visible = v61:map(function(b1: boolean) -- line: 268
					return not b1
				end),
				testId = `{ v38.testId }--close-affordance`
			})
		}),
		Shadow = React.createElement(Image, {
			ZIndex = 2,
			Image = SHADOW_IMAGE,
			Size = uDim2 + UDim2.fromOffset(SHADOW_SIZE * 2, SHADOW_SIZE * 2),
			Position = v75:map(function(uDim2_2: UDim2) -- line: 277
				-- upvalues: SHADOW_SIZE (copy)
				return uDim2_2 + UDim2.fromOffset(-SHADOW_SIZE, -SHADOW_SIZE)
			end),
			slice = {
				scale = 2,
				center = Rect.new(SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE + 1, SHADOW_SIZE + 1)
			},
			imageStyle = v40.Color.Extended.Black.Black_10
		}),
		Backdrop = React.createElement(View, {
			ZIndex = 1,
			Size = UDim2.fromScale(2, 2),
			Position = UDim2.fromScale(-0.5, -0.5),
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			backgroundStyle = v54:map(function(n2: number) -- line: 294
				-- upvalues: v40 (copy)
				return {
					Color3 = v40.Color.Common.Backdrop.Color3,
					Transparency = math.lerp(v40.Color.Common.Backdrop.Transparency, 1, n2)
				}
			end),
			onActivated = v73,
			testId = `{ v38.testId }--backdrop`
		})
	}), v39)
end

return React.memo(React.forwardRef(SideSheet))
