local CorePackages = game:GetService("CorePackages")
local foundation = CorePackages.Packages._Index.Foundation.Foundation
local parent = foundation.Parent
local Dash = require(parent.Dash)
local Otter = require(parent.Otter)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local ReactRoblox = require(parent.ReactRoblox)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local CloseAffordanceVariant = require(foundation.Enums.CloseAffordanceVariant)
local Constants = require(foundation.Constants)
local StateLayerAffordance = require(foundation.Enums.StateLayerAffordance)
local useOverlay = require(foundation.Providers.Overlay.useOverlay)
local useTokens = require(foundation.Providers.Style.useTokens)
local withDefaults = require(foundation.Utility.withDefaults)

local SheetContext = require(script.Parent.SheetContext)
local Types = require(script.Parent.Types)

local SheetType = require(script.Parent.SheetType)

local useElevation = require(foundation.Providers.Elevation.useElevation)
local ElevationProvider = require(foundation.Providers.Elevation.ElevationProvider)
local ElevationOwnerScope = ElevationProvider.ElevationOwnerScope
local ElevationLayer = require(foundation.Enums.ElevationLayer)

local DialogSize = require(foundation.Enums.DialogSize)

local childrenHasFullBleed = require(script.Parent.childrenHasFullBleed)
local useHardwareInsets = require(script.Parent.useHardwareInsets)
local useScreenSize = require(script.Parent.useScreenSize)

local CloseAffordance = require(foundation.Components.CloseAffordance)
local Image = require(foundation.Components.Image)
local View = require(foundation.Components.View)

local usePreferences = require(foundation.Providers.Preferences.usePreferences)

local v = {
	[DialogSize.Medium] = { TARGET_WIDTH = 0.4, MIN = 360, MAX = 440 },
	[DialogSize.Large] = { TARGET_WIDTH = 0.5, MIN = 440, MAX = 640 }
}

local v2 = { testId = "--foundation-sheet", size = DialogSize.Medium }

local SHADOW_IMAGE = Constants.SHADOW_IMAGE
local SHADOW_SIZE = Constants.SHADOW_SIZE

local function SideSheet(p, ref3)
	local v3 = withDefaults(p, v2)
	local v4 = useOverlay()
	local v5 = useTokens()
	local owner = useElevation(ElevationLayer.Sheet, { stackAboveOwner = false })
	local reducedMotion = usePreferences().reducedMotion

	local v6 = useHardwareInsets(v4)
	local v7 = useScreenSize()
	local right = v6.right

	local v8 = v3.displaySize == Enum.DisplaySize.Small

	local scale = v5.Config.UI.Scale
	local TARGET_WIDTH = v[v3.size].TARGET_WIDTH
	local v9 = v[v3.size].MIN * scale
	local v10 = v[v3.size].MAX * scale

	local v11 = math.clamp(v7.X * TARGET_WIDTH, v9, v10)
	local medium = v5.Padding.Medium

	local ref = React.useRef(false)
	local v12, v13 = useAnimatedBinding(1, function()
		if ref.current then
			v3.onClose()
		end
	end)

	local v14 = -(right + (v8 and 0 or medium))
	local v15, v16 = useAnimatedBinding(v14)

	local hasActionsDivider, setHasActionsDivider = React.useBinding(false)
	local hasHeader, setHasHeader = React.useBinding(false)
	local hasFullBleed = childrenHasFullBleed(v3.children)
	local fullBleedHeight, setFullBleedHeight = React.useBinding(0)

	local innerScrollY, setInnerScrollY = React.useBinding(0)

	local ref2 = React.useRef(nil)
	local state, setState = React.useState(nil)

	React.useEffect(function()
		if reducedMotion then
			v16((Otter.instant(v11)))
			v13((Otter.instant(0)))
		else
			v16(Otter.ease(v11, { easingStyle = v5.Ease.StandardOut, duration = v5.Time.Time_300 }))

			v13(Otter.ease(0, { duration = v5.Time.Time_100 }))
		end
	end, { v11, reducedMotion })

	local v17 = React.useCallback(function()
		if ref.current then
			return
		end

		if reducedMotion then
			ref.current = true
			v16(Otter.instant(v14))
			v13(Otter.instant(1))
		else
			v16(Otter.ease(v14, { easingStyle = v5.Ease.StandardIn, duration = v5.Time.Time_100 }))

			v13(Otter.ease(1, { duration = v5.Time.Time_100 }))

			ref.current = true
		end
	end, { v14, reducedMotion })

	React.useImperativeHandle(v3.sheetRef, function()
		return { close = v17 }
	end, {})

	local udim = UDim2.new(0, v11 + (not v8 and 0 or right), 1, v8 and 0 or -medium * 2)

	local mapped = v15:map(function(p2: number)
		local v18

		if v8 then
			v18 = -p2
		else
			v18 = -(p2 + medium)
		end

		return UDim2.new(1, v18, 0, v8 and 0 or medium)
	end)

	local v18 = React.useMemo(function()
		return {
			actionsHeight = 0,
			setActionsHeight = Dash.noop,
			hasActionsDivider = hasActionsDivider,
			setHasActionsDivider = setHasActionsDivider,
			sheetHeightAvailable = 0,
			setSheetHeightAvailable = Dash.noop,
			safeAreaPadding = 0,
			bottomPadding = 0,
			innerScrollingEnabled = true,
			innerScrollY = innerScrollY,
			setInnerScrollY = setInnerScrollY,
			hasHeader = hasHeader,
			setHasHeader = setHasHeader,
			hasFullBleed = hasFullBleed,
			fullBleedHeight = fullBleedHeight,
			setFullBleedHeight = setFullBleedHeight,
			closeSheet = v17,
			hasRadius = not v8,
			sheetType = SheetType.Side,
			testId = v3.testId,
			closeAffordanceRef = ref2,
			contentStartRef = state,
			setContentStartRef = setState
		}
	end, { v3.testId, v17, state, ref2, hasFullBleed, v8 })

	if not v4 then
		return v4
	end

	local createPortal = ReactRoblox.createPortal
	local createElement = React.createElement
	local v19 = { ZIndex = owner.zIndex, tag = "size-full", testId = `{v3.testId}--surface` }

	local createElement2 = React.createElement
	local v20 = {
		Size = udim,
		Position = mapped,
		ClipsDescendants = true,
		ZIndex = 3,
		padding = v8 and right > 0 and { right = UDim.new(0, right) } or nil,
		stateLayer = { affordance = StateLayerAffordance.None },
		onActivated = Dash.noop,
		ref = ref3,
		selection = Types.nonSelectable,
		selectionGroup = Types.isolatedSelectionGroup,
		tag = {
			["stroke-standard stroke-default bg-surface-100"] = true,
			["radius-large"] = not v8
		},
		testId = v3.testId
	}
	local v21 = {
		Content = React.createElement(
			View,
			{ tag = "col items-center size-full-full clip" },
			React.createElement(
				SheetContext.Provider,
				{ value = v18 },
				React.createElement(ElevationOwnerScope, { owner = owner }, v3.children)
			)
		),
		CloseAffordance = 0
	}

	local createElement3 = React.createElement
	local v22 = {
		onActivated = v17,
		ref = ref2,
		NextSelectionDown = state,
		variant = 0,
		Position = 0,
		AnchorPoint = 0,
		Visible = 0,
		testId = 0
	}
	local variant

	if hasFullBleed then
		variant = CloseAffordanceVariant.OverMedia
	else
		variant = CloseAffordanceVariant.Utility
	end

	v22.variant = variant

	v22.Position = UDim2.new(1, -v5.Margin.Small, 0, v5.Margin.Small)
	v22.AnchorPoint = Vector2.new(1, 0)
	v22.Visible = hasHeader:map(function(flag: boolean): boolean
		return not flag
	end)

	v22.testId = `{v3.testId}--close-affordance`
	v21.CloseAffordance = createElement3(CloseAffordance, v22)
	return (createPortal(createElement(View, v19, {
		Sheet = createElement2(View, v20, v21),
		Shadow = React.createElement(Image, {
			Image = SHADOW_IMAGE,
			Size = udim + UDim2.fromOffset(SHADOW_SIZE * 2, SHADOW_SIZE * 2),
			Position = mapped:map(function(udim2: UDim2)
				return udim2 + UDim2.fromOffset(-SHADOW_SIZE, -SHADOW_SIZE)
			end),
			ZIndex = 2,
			slice = {
				center = Rect.new(SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE + 1, SHADOW_SIZE + 1),
				scale = 2
			},
			imageStyle = v5.Color.Extended.Black.Black_10
		}),
		Backdrop = React.createElement(View, {
			Size = UDim2.fromScale(2, 2),
			Position = UDim2.fromScale(-0.5, -0.5),
			ZIndex = 1,
			stateLayer = { affordance = StateLayerAffordance.None },
			backgroundStyle = v12:map(function(p2: number)
				return {
					Color3 = v5.Color.Common.Backdrop.Color3,
					Transparency = math.lerp(v5.Color.Common.Backdrop.Transparency, 1, p2)
				}
			end),
			onActivated = v17,
			testId = `{v3.testId}--backdrop`
		})
	}), v4))
end

return React.memo(React.forwardRef(SideSheet))
