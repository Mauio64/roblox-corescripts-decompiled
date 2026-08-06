local Foundation = script:FindFirstAncestor("Foundation")
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
	size = DialogSize.Medium
}
local SHADOW_IMAGE = Constants.SHADOW_IMAGE
local SHADOW_SIZE = Constants.SHADOW_SIZE

local function SideSheet(p1, p2) -- line: 65
	-- upvalues: withDefaults (copy), t2 (copy), useOverlay (copy), useTokens (copy), useElevation (copy), ElevationLayer (copy), usePreferences (copy), useHardwareInsets (copy), useScreenSize (copy), t1 (copy), React (copy), useAnimatedBinding (copy), Flags (copy), childrenHasFullBleed (copy), Otter (copy), Dash (copy), SheetType (copy), ReactRoblox (copy), View (copy), StateLayerAffordance (copy), Types (copy), SheetContext (copy), ElevationOwnerScope (copy), CloseAffordance (copy), CloseAffordanceVariant (copy), Image (copy), SHADOW_IMAGE (copy), SHADOW_SIZE (copy)
	local v37 = withDefaults(p1, t2)
	local v38 = useOverlay()
	local v39 = useTokens()
	local v40 = useElevation(ElevationLayer.Sheet, {
		stackAboveOwner = false
	})
	local reducedMotion = usePreferences().reducedMotion
	local v42 = useHardwareInsets(v38)
	local v43 = useScreenSize()
	local right = v42.right
	local v45 = v37.displaySize == Enum.DisplaySize.Small
	local TARGET_WIDTH = t1[v37.size].TARGET_WIDTH
	local v47 = t1[v37.size].MIN * v39.Config.UI.Scale
	local v48 = t1[v37.size].MAX * v39.Config.UI.Scale
	local v49 = math.clamp(v43.X * TARGET_WIDTH, v47, v48)
	local Medium = v39.Padding.Medium
	local v51 = React.useRef(false)
	local v52, v53 = useAnimatedBinding(1, function() -- line: 87
		-- upvalues: v51 (copy), v37 (copy)
		if v51.current then
			v37.onClose()
		end
	end)
	local v54 = -(right + if not v45 then Medium else 0)
	local v55, v56 = useAnimatedBinding(v54)
	local v57, v58 = React.useBinding(false)
	local v59, v60 = React.useBinding(false)
	local u61 = nil
	local u62 = nil
	local u63 = nil

	if Flags.FoundationSheetFullBleed then
		u61 = childrenHasFullBleed(v37.children)

		local v64, v65 = React.useBinding(0)

		u62 = v64
		u63 = v65
	end

	local v66, v67 = React.useBinding(0)
	local v68 = React.useRef(nil)
	local v69, v70 = React.useState(nil)

	React.useEffect(function() -- line: 111
		-- upvalues: reducedMotion (copy), v56 (copy), Otter (copy), v49 (copy), v53 (copy), v39 (copy)
		if reducedMotion then
			v56((Otter.instant(v49)))
			v53((Otter.instant(0)))

			return
		end

		v56(Otter.ease(v49, {
			easingStyle = v39.Ease.StandardOut,
			duration = v39.Time.Time_300
		}))
		v53(Otter.ease(0, {
			duration = v39.Time.Time_100
		}))
	end, {
		v49,
		reducedMotion
	})

	local v71 = React.useCallback(function() -- line: 127
		-- upvalues: v51 (copy), reducedMotion (copy), v56 (copy), Otter (copy), v54 (copy), v53 (copy), v39 (copy)
		if v51.current then
			return
		end

		if reducedMotion then
			v51.current = true
			v56(Otter.instant(v54))
			v53(Otter.instant(1))

			return
		end

		v56(Otter.ease(v54, {
			easingStyle = v39.Ease.StandardIn,
			duration = v39.Time.Time_100
		}))
		v53(Otter.ease(1, {
			duration = v39.Time.Time_100
		}))
		v51.current = true
	end, {
		v54,
		reducedMotion
	})

	React.useImperativeHandle(v37.sheetRef, function() -- line: 147
		-- upvalues: v71 (copy)
		return {
			close = v71
		}
	end, {})

	local uDim2 = UDim2.new(0, v49 + (not v45 and 0 or right), 1, if not v45 then -Medium * 2 else 0)
	local v73 = v55:map(function(n1: number) -- line: 160
		-- upvalues: v45 (copy), Medium (copy)
		return UDim2.new(1, if not v45 then -(n1 + Medium) else -n1, 0, if not v45 then Medium else 0)
	end)
	local v74 = React.useMemo(function() -- line: 170
		-- upvalues: Dash (copy), v57 (copy), v58 (copy), v66 (copy), v67 (copy), v59 (copy), v60 (copy), Flags (copy), u61 (ref), u62 (ref), u63 (ref), v71 (copy), v45 (copy), SheetType (copy), v37 (copy), v68 (copy), v69 (copy), v70 (copy)
		return {
			actionsHeight = 0,
			sheetHeightAvailable = 0,
			safeAreaPadding = 0,
			bottomPadding = 0,
			innerScrollingEnabled = true,
			setActionsHeight = Dash.noop,
			hasActionsDivider = v57,
			setHasActionsDivider = v58,
			setSheetHeightAvailable = Dash.noop,
			innerScrollY = v66,
			setInnerScrollY = v67,
			hasHeader = v59,
			setHasHeader = v60,
			hasFullBleed = if not Flags.FoundationSheetFullBleed then nil else u61,
			fullBleedHeight = if not Flags.FoundationSheetFullBleed then nil else u62,
			setFullBleedHeight = if not Flags.FoundationSheetFullBleed then nil else u63,
			closeSheet = v71,
			hasRadius = if not Flags.FoundationSheetFullBleed then nil else not v45,
			sheetType = SheetType.Side,
			testId = v37.testId,
			closeAffordanceRef = v68,
			contentStartRef = v69,
			setContentStartRef = v70
		}
	end, {
		v37.testId,
		v71,
		v69,
		v68,
		u61,
		if not Flags.FoundationSheetFullBleed then nil else v45
	})

	return v38 and ReactRoblox.createPortal(React.createElement(View, {
		tag = "size-full",
		ZIndex = v40.zIndex,
		testId = `{ v37.testId }--surface`
	}, {
		Sheet = React.createElement(View, {
			ClipsDescendants = true,
			ZIndex = 3,
			Size = uDim2,
			Position = v73,
			padding = if not v45 or not (right > 0) then nil else {
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
				["radius-large"] = not v45
			},
			testId = v37.testId
		}, {
			Content = React.createElement(View, {
				tag = "col items-center size-full-full clip"
			}, React.createElement(SheetContext.Provider, {
				value = v74
			}, React.createElement(ElevationOwnerScope, {
				owner = v40
			}, v37.children))),
			CloseAffordance = React.createElement(CloseAffordance, {
				onActivated = v71,
				ref = v68,
				NextSelectionDown = v69,
				variant = if not Flags.FoundationSheetFullBleed or not u61 then CloseAffordanceVariant.Utility else CloseAffordanceVariant.OverMedia,
				Position = UDim2.new(1, -v39.Margin.Small, 0, v39.Margin.Small),
				AnchorPoint = Vector2.new(1, 0),
				Visible = v59:map(function(b1: boolean) -- line: 256
					return not b1
				end),
				testId = `{ v37.testId }--close-affordance`
			})
		}),
		Shadow = React.createElement(Image, {
			ZIndex = 2,
			Image = SHADOW_IMAGE,
			Size = uDim2 + UDim2.fromOffset(SHADOW_SIZE * 2, SHADOW_SIZE * 2),
			Position = v73:map(function(uDim2_2: UDim2) -- line: 265
				-- upvalues: SHADOW_SIZE (copy)
				return uDim2_2 + UDim2.fromOffset(-SHADOW_SIZE, -SHADOW_SIZE)
			end),
			slice = {
				scale = 2,
				center = Rect.new(SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE + 1, SHADOW_SIZE + 1)
			},
			imageStyle = v39.Color.Extended.Black.Black_10
		}),
		Backdrop = React.createElement(View, {
			ZIndex = 1,
			Size = UDim2.fromScale(2, 2),
			Position = UDim2.fromScale(-0.5, -0.5),
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			backgroundStyle = v52:map(function(n2: number) -- line: 282
				-- upvalues: v39 (copy)
				return {
					Color3 = v39.Color.Common.Backdrop.Color3,
					Transparency = math.lerp(v39.Color.Common.Backdrop.Transparency, 1, n2)
				}
			end),
			onActivated = v71,
			testId = `{ v37.testId }--backdrop`
		})
	}), v38)
end

return React.memo(React.forwardRef(SideSheet))
