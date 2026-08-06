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

local function SideSheet(p1, p2) -- line: 64
	-- upvalues: withDefaults (copy), t2 (copy), useOverlay (copy), useTokens (copy), useElevation (copy), ElevationLayer (copy), usePreferences (copy), useHardwareInsets (copy), useScreenSize (copy), t1 (copy), React (copy), useAnimatedBinding (copy), childrenHasFullBleed (copy), Otter (copy), Dash (copy), SheetType (copy), ReactRoblox (copy), View (copy), StateLayerAffordance (copy), Types (copy), SheetContext (copy), ElevationOwnerScope (copy), CloseAffordance (copy), CloseAffordanceVariant (copy), Image (copy), SHADOW_IMAGE (copy), SHADOW_SIZE (copy)
	local v36 = withDefaults(p1, t2)
	local v37 = useOverlay()
	local v38 = useTokens()
	local v39 = useElevation(ElevationLayer.Sheet, {
		stackAboveOwner = false
	})
	local reducedMotion = usePreferences().reducedMotion
	local v41 = useHardwareInsets(v37)
	local v42 = useScreenSize()
	local right = v41.right
	local v44 = v36.displaySize == Enum.DisplaySize.Small
	local UIScale = v38.Config.UI.Scale
	local TARGET_WIDTH = t1[v36.size].TARGET_WIDTH
	local v47 = t1[v36.size].MIN * UIScale
	local v48 = t1[v36.size].MAX * UIScale
	local v49 = math.clamp(v42.X * TARGET_WIDTH, v47, v48)
	local Medium = v38.Padding.Medium
	local v51 = React.useRef(false)
	local v52, v53 = useAnimatedBinding(1, function() -- line: 87
		-- upvalues: v51 (copy), v36 (copy)
		if v51.current then
			v36.onClose()
		end
	end)
	local v54 = -(right + if not v44 then Medium else 0)
	local v55, v56 = useAnimatedBinding(v54)
	local v57, v58 = React.useBinding(false)
	local v59, v60 = React.useBinding(false)
	local v61 = childrenHasFullBleed(v36.children)
	local v62, v63 = React.useBinding(0)
	local v64, v65 = React.useBinding(0)
	local v66 = React.useRef(nil)
	local v67, v68 = React.useState(nil)

	React.useEffect(function() -- line: 107
		-- upvalues: reducedMotion (copy), v56 (copy), Otter (copy), v49 (copy), v53 (copy), v38 (copy)
		if reducedMotion then
			v56((Otter.instant(v49)))
			v53((Otter.instant(0)))

			return
		end

		v56(Otter.ease(v49, {
			easingStyle = v38.Ease.StandardOut,
			duration = v38.Time.Time_300
		}))
		v53(Otter.ease(0, {
			duration = v38.Time.Time_100
		}))
	end, {
		v49,
		reducedMotion
	})

	local v69 = React.useCallback(function() -- line: 123
		-- upvalues: v51 (copy), reducedMotion (copy), v56 (copy), Otter (copy), v54 (copy), v53 (copy), v38 (copy)
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
			easingStyle = v38.Ease.StandardIn,
			duration = v38.Time.Time_100
		}))
		v53(Otter.ease(1, {
			duration = v38.Time.Time_100
		}))
		v51.current = true
	end, {
		v54,
		reducedMotion
	})

	React.useImperativeHandle(v36.sheetRef, function() -- line: 143
		-- upvalues: v69 (copy)
		return {
			close = v69
		}
	end, {})

	local uDim2 = UDim2.new(0, v49 + (not v44 and 0 or right), 1, if not v44 then -Medium * 2 else 0)
	local v71 = v55:map(function(n1: number) -- line: 156
		-- upvalues: v44 (copy), Medium (copy)
		return UDim2.new(1, if not v44 then -(n1 + Medium) else -n1, 0, if not v44 then Medium else 0)
	end)
	local v72 = React.useMemo(function() -- line: 166
		-- upvalues: Dash (copy), v57 (copy), v58 (copy), v64 (copy), v65 (copy), v59 (copy), v60 (copy), v61 (copy), v62 (copy), v63 (copy), v69 (copy), v44 (copy), SheetType (copy), v36 (copy), v66 (copy), v67 (copy), v68 (copy)
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
			innerScrollY = v64,
			setInnerScrollY = v65,
			hasHeader = v59,
			setHasHeader = v60,
			hasFullBleed = v61,
			fullBleedHeight = v62,
			setFullBleedHeight = v63,
			closeSheet = v69,
			hasRadius = not v44,
			sheetType = SheetType.Side,
			testId = v36.testId,
			closeAffordanceRef = v66,
			contentStartRef = v67,
			setContentStartRef = v68
		}
	end, {
		v36.testId,
		v69,
		v67,
		v66,
		v61,
		v44
	})

	return v37 and ReactRoblox.createPortal(React.createElement(View, {
		tag = "size-full",
		ZIndex = v39.zIndex,
		testId = `{ v36.testId }--surface`
	}, {
		Sheet = React.createElement(View, {
			ClipsDescendants = true,
			ZIndex = 3,
			Size = uDim2,
			Position = v71,
			padding = if not v44 or not (right > 0) then nil else {
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
				["radius-large"] = not v44
			},
			testId = v36.testId
		}, {
			Content = React.createElement(View, {
				tag = "col items-center size-full-full clip"
			}, React.createElement(SheetContext.Provider, {
				value = v72
			}, React.createElement(ElevationOwnerScope, {
				owner = v39
			}, v36.children))),
			CloseAffordance = React.createElement(CloseAffordance, {
				onActivated = v69,
				ref = v66,
				NextSelectionDown = v67,
				variant = if not v61 then CloseAffordanceVariant.Utility else CloseAffordanceVariant.OverMedia,
				Position = UDim2.new(1, -v38.Margin.Small, 0, v38.Margin.Small),
				AnchorPoint = Vector2.new(1, 0),
				Visible = v59:map(function(b1: boolean) -- line: 252
					return not b1
				end),
				testId = `{ v36.testId }--close-affordance`
			})
		}),
		Shadow = React.createElement(Image, {
			ZIndex = 2,
			Image = SHADOW_IMAGE,
			Size = uDim2 + UDim2.fromOffset(SHADOW_SIZE * 2, SHADOW_SIZE * 2),
			Position = v71:map(function(uDim2_2: UDim2) -- line: 261
				-- upvalues: SHADOW_SIZE (copy)
				return uDim2_2 + UDim2.fromOffset(-SHADOW_SIZE, -SHADOW_SIZE)
			end),
			slice = {
				scale = 2,
				center = Rect.new(SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE + 1, SHADOW_SIZE + 1)
			},
			imageStyle = v38.Color.Extended.Black.Black_10
		}),
		Backdrop = React.createElement(View, {
			ZIndex = 1,
			Size = UDim2.fromScale(2, 2),
			Position = UDim2.fromScale(-0.5, -0.5),
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			backgroundStyle = v52:map(function(n2: number) -- line: 278
				-- upvalues: v38 (copy)
				return {
					Color3 = v38.Color.Common.Backdrop.Color3,
					Transparency = math.lerp(v38.Color.Common.Backdrop.Transparency, 1, n2)
				}
			end),
			onActivated = v69,
			testId = `{ v36.testId }--backdrop`
		})
	}), v37)
end

return React.memo(React.forwardRef(SideSheet))
