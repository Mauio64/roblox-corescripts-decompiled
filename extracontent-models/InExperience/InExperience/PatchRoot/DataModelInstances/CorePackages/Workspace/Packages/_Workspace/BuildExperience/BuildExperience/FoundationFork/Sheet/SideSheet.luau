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
	local UIScale = v39.Config.UI.Scale
	local TARGET_WIDTH = t1[v37.size].TARGET_WIDTH
	local v48 = t1[v37.size].MIN * UIScale
	local v49 = t1[v37.size].MAX * UIScale
	local v50 = math.clamp(v43.X * TARGET_WIDTH, v48, v49)
	local Medium = v39.Padding.Medium
	local v52 = React.useRef(false)
	local v53, v54 = useAnimatedBinding(1, function() -- line: 88
		-- upvalues: v52 (copy), v37 (copy)
		if v52.current then
			v37.onClose()
		end
	end)
	local v55 = -(right + if not v45 then Medium else 0)
	local v56, v57 = useAnimatedBinding(v55)
	local v58, v59 = React.useBinding(false)
	local v60, v61 = React.useBinding(false)
	local u62 = nil
	local u63 = nil
	local u64 = nil

	if Flags.FoundationSheetFullBleed then
		u62 = childrenHasFullBleed(v37.children)

		local v65, v66 = React.useBinding(0)

		u63 = v65
		u64 = v66
	end

	local v67, v68 = React.useBinding(0)
	local v69 = React.useRef(nil)
	local v70, v71 = React.useState(nil)

	React.useEffect(function() -- line: 112
		-- upvalues: reducedMotion (copy), v57 (copy), Otter (copy), v50 (copy), v54 (copy), v39 (copy)
		if reducedMotion then
			v57((Otter.instant(v50)))
			v54((Otter.instant(0)))

			return
		end

		v57(Otter.ease(v50, {
			easingStyle = v39.Ease.StandardOut,
			duration = v39.Time.Time_300
		}))
		v54(Otter.ease(0, {
			duration = v39.Time.Time_100
		}))
	end, {
		v50,
		reducedMotion
	})

	local v72 = React.useCallback(function() -- line: 128
		-- upvalues: v52 (copy), reducedMotion (copy), v57 (copy), Otter (copy), v55 (copy), v54 (copy), v39 (copy)
		if v52.current then
			return
		end

		if reducedMotion then
			v52.current = true
			v57(Otter.instant(v55))
			v54(Otter.instant(1))

			return
		end

		v57(Otter.ease(v55, {
			easingStyle = v39.Ease.StandardIn,
			duration = v39.Time.Time_100
		}))
		v54(Otter.ease(1, {
			duration = v39.Time.Time_100
		}))
		v52.current = true
	end, {
		v55,
		reducedMotion
	})

	React.useImperativeHandle(v37.sheetRef, function() -- line: 148
		-- upvalues: v72 (copy)
		return {
			close = v72
		}
	end, {})

	local uDim2 = UDim2.new(0, v50 + (not v45 and 0 or right), 1, if not v45 then -Medium * 2 else 0)
	local v74 = v56:map(function(n1: number) -- line: 161
		-- upvalues: v45 (copy), Medium (copy)
		return UDim2.new(1, if not v45 then -(n1 + Medium) else -n1, 0, if not v45 then Medium else 0)
	end)
	local v75 = React.useMemo(function() -- line: 171
		-- upvalues: Dash (copy), v58 (copy), v59 (copy), v67 (copy), v68 (copy), v60 (copy), v61 (copy), Flags (copy), u62 (ref), u63 (ref), u64 (ref), v72 (copy), v45 (copy), SheetType (copy), v37 (copy), v69 (copy), v70 (copy), v71 (copy)
		return {
			actionsHeight = 0,
			sheetHeightAvailable = 0,
			safeAreaPadding = 0,
			bottomPadding = 0,
			innerScrollingEnabled = true,
			setActionsHeight = Dash.noop,
			hasActionsDivider = v58,
			setHasActionsDivider = v59,
			setSheetHeightAvailable = Dash.noop,
			innerScrollY = v67,
			setInnerScrollY = v68,
			hasHeader = v60,
			setHasHeader = v61,
			hasFullBleed = if not Flags.FoundationSheetFullBleed then nil else u62,
			fullBleedHeight = if not Flags.FoundationSheetFullBleed then nil else u63,
			setFullBleedHeight = if not Flags.FoundationSheetFullBleed then nil else u64,
			closeSheet = v72,
			hasRadius = if not Flags.FoundationSheetFullBleed then nil else not v45,
			sheetType = SheetType.Side,
			testId = v37.testId,
			closeAffordanceRef = v69,
			contentStartRef = v70,
			setContentStartRef = v71
		}
	end, {
		v37.testId,
		v72,
		v70,
		v69,
		u62,
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
			Position = v74,
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
				value = v75
			}, React.createElement(ElevationOwnerScope, {
				owner = v40
			}, v37.children))),
			CloseAffordance = React.createElement(CloseAffordance, {
				onActivated = v72,
				ref = v69,
				NextSelectionDown = v70,
				variant = if not Flags.FoundationSheetFullBleed or not u62 then CloseAffordanceVariant.Utility else CloseAffordanceVariant.OverMedia,
				Position = UDim2.new(1, -v39.Margin.Small, 0, v39.Margin.Small),
				AnchorPoint = Vector2.new(1, 0),
				Visible = v60:map(function(b1: boolean) -- line: 257
					return not b1
				end),
				testId = `{ v37.testId }--close-affordance`
			})
		}),
		Shadow = React.createElement(Image, {
			ZIndex = 2,
			Image = SHADOW_IMAGE,
			Size = uDim2 + UDim2.fromOffset(SHADOW_SIZE * 2, SHADOW_SIZE * 2),
			Position = v74:map(function(uDim2_2: UDim2) -- line: 266
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
			backgroundStyle = v53:map(function(n2: number) -- line: 283
				-- upvalues: v39 (copy)
				return {
					Color3 = v39.Color.Common.Backdrop.Color3,
					Transparency = math.lerp(v39.Color.Common.Backdrop.Transparency, 1, n2)
				}
			end),
			onActivated = v72,
			testId = `{ v37.testId }--backdrop`
		})
	}), v38)
end

return React.memo(React.forwardRef(SideSheet))
