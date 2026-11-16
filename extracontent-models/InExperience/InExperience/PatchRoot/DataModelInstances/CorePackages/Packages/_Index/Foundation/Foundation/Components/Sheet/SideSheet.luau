local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Dash = require(parent.Dash)
local Otter = require(parent.Otter)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local ReactRoblox = require(parent.ReactRoblox)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local CloseAffordanceVariant = require(Foundation.Enums.CloseAffordanceVariant)
local Constants = require(Foundation.Constants)
local Flags = require(Foundation.Utility.Flags)
local InternalDrawer = require(Foundation.Components.InternalDrawer)
local InternalDrawerBackdrop = require(Foundation.Enums.InternalDrawerBackdrop)
local InternalDrawerLayout = require(Foundation.Enums.InternalDrawerLayout)
local InternalDrawerShadow = require(Foundation.Enums.InternalDrawerShadow)
local InternalDrawerSide = require(Foundation.Enums.InternalDrawerSide)
require(Foundation.Enums.OnCloseCallbackReason)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withDefaults = require(Foundation.Utility.withDefaults)

local SheetContext = require(script.Parent.SheetContext)
local Types = require(script.Parent.Types)

local SheetType = require(script.Parent.SheetType)

local useElevation = require(Foundation.Providers.Elevation.useElevation)
local ElevationProvider = require(Foundation.Providers.Elevation.ElevationProvider)
local ElevationOwnerScope = ElevationProvider.ElevationOwnerScope
local ElevationLayer = require(Foundation.Enums.ElevationLayer)

local DialogSize = require(Foundation.Enums.DialogSize)

local childrenHasFullBleed = require(script.Parent.childrenHasFullBleed)
local useHardwareInsets = require(script.Parent.useHardwareInsets)
local useScreenSize = require(script.Parent.useScreenSize)

local Backdrop = require(Foundation.Components.Backdrop)
local CloseAffordance = require(Foundation.Components.CloseAffordance)
local Image = require(Foundation.Components.Image)
local View = require(Foundation.Components.View)

local usePreferences = require(Foundation.Providers.Preferences.usePreferences)

local v = {
	[DialogSize.Medium] = { TARGET_WIDTH = 0.4, MIN = 360, MAX = 440 },
	[DialogSize.Large] = { TARGET_WIDTH = 0.5, MIN = 440, MAX = 640 }
}

local v2 = { testId = "--foundation-sheet", size = DialogSize.Medium }

local SHADOW_IMAGE = Constants.SHADOW_IMAGE
local SHADOW_SIZE = Constants.SHADOW_SIZE

local function DrawerSideSheet(p, ref)
	local v3 = withDefaults(p, v2)
	local v4 = useTokens()
	local elevation = useElevation(ElevationLayer.Sheet, { stackAboveOwner = false })
	local v5 = useScreenSize()

	local v6 = useHardwareInsets((useOverlay()))
	local v7 = v3.displaySize == Enum.DisplaySize.Small
	local outerBleed = not v7 and 0 or v6.right
	local v8 = v[v3.size]
	local width = math.clamp(v5.X * v8.TARGET_WIDTH, v8.MIN * v4.Config.UI.Scale, v8.MAX * v4.Config.UI.Scale)

	local state, setState = React.useState(true)
	local v9 = React.useCallback(function()
		setState(false)
	end, {})
	local onRequestClose = React.useCallback(function(_)
		v9()
	end, { v9 })

	React.useImperativeHandle(v3.sheetRef, function()
		return { close = v9 }
	end, { v9 })

	local hasActionsDivider, setHasActionsDivider = React.useBinding(false)
	local hasHeader, setHasHeader = React.useBinding(false)
	local hasFullBleed = childrenHasFullBleed(v3.children)
	local fullBleedHeight, setFullBleedHeight = React.useBinding(0)
	local innerScrollY, setInnerScrollY = React.useBinding(0)

	local ref2 = React.useRef(nil)
	local state2, setState2 = React.useState(nil)

	local v10 = React.useMemo(function()
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
			closeSheet = v9,
			hasRadius = not v7,
			sheetType = SheetType.Side,
			testId = v3.testId,
			closeAffordanceRef = ref2,
			contentStartRef = state2,
			setContentStartRef = setState2
		}
	end, { v3.testId, v9, state2, ref2, hasFullBleed, v7 })

	local createElement = React.createElement
	local v11 = {
		elevation = elevation,
		isOpen = state,
		onRequestClose = onRequestClose,
		onCloseComplete = v3.onClose,
		side = InternalDrawerSide.End,
		backdrop = InternalDrawerBackdrop.Dismissible,
		width = width,
		outerBleed = outerBleed,
		layout = 0,
		shadow = 0,
		backgroundColor = "bg-surface-100",
		scrolls = false,
		testId = 0,
		ref = 0
	}
	local layout

	if v7 then
		layout = InternalDrawerLayout.FullBleed
	else
		layout = InternalDrawerLayout.Inset
	end

	v11.layout = layout
	v11.shadow = InternalDrawerShadow.Overlay300

	v11.testId = v3.testId
	v11.ref = ref

	local createElement2 = React.createElement

	local v12 = {
		Body = React.createElement(
			View,
			{ tag = "col items-center size-full-full clip" },
			React.createElement(SheetContext.Provider, { value = v10 }, v3.children)
		),
		CloseAffordance = 0
	}

	local createElement3 = React.createElement
	local v13 = {
		onActivated = v9,
		ref = ref2,
		NextSelectionDown = state2,
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

	v13.variant = variant
	v13.Position = UDim2.new(1, -v4.Margin.Small, 0, v4.Margin.Small)
	v13.AnchorPoint = Vector2.new(1, 0)
	v13.Visible = hasHeader:map(function(flag: boolean): boolean
		return not flag
	end)

	v13.testId = `{v3.testId}--close-affordance`
	v12.CloseAffordance = createElement3(CloseAffordance, v13)
	return createElement(InternalDrawer, v11, {
		Content = createElement2(View, { tag = "size-full" }, v12)
	})
end

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

	local TARGET_WIDTH = v[v3.size].TARGET_WIDTH
	local v9 = v[v3.size].MIN * v5.Config.UI.Scale
	local v10 = v[v3.size].MAX * v5.Config.UI.Scale

	local v11 = math.clamp(v7.X * TARGET_WIDTH, v9, v10)
	local medium = v5.Padding.Medium

	local ref = React.useRef(false)
	local transparency, v12 = useAnimatedBinding(1, function()
		if ref.current then
			v3.onClose()
		end
	end)

	local v13 = -(right + (v8 and 0 or medium))
	local v14, v15 = useAnimatedBinding(v13)

	local hasActionsDivider, setHasActionsDivider = React.useBinding(false)
	local hasHeader, setHasHeader = React.useBinding(false)

	local hasFullBleed = childrenHasFullBleed(v3.children)
	local fullBleedHeight, setFullBleedHeight = React.useBinding(0)

	local innerScrollY, setInnerScrollY = React.useBinding(0)

	local ref2 = React.useRef(nil)
	local state, setState = React.useState(nil)

	React.useEffect(function()
		if reducedMotion then
			v15((Otter.instant(v11)))
			v12((Otter.instant(0)))
		else
			v15(Otter.ease(v11, { easingStyle = v5.Ease.StandardOut, duration = v5.Time.Time_300 }))

			v12(Otter.ease(0, { duration = v5.Time.Time_100 }))
		end
	end, { v11, reducedMotion })

	local v16 = React.useCallback(function()
		if ref.current then
			return
		end

		if reducedMotion then
			ref.current = true
			v15(Otter.instant(v13))
			v12(Otter.instant(1))
		else
			v15(Otter.ease(v13, { easingStyle = v5.Ease.StandardIn, duration = v5.Time.Time_100 }))

			v12(Otter.ease(1, { duration = v5.Time.Time_100 }))

			ref.current = true
		end
	end, { v13, reducedMotion })

	React.useImperativeHandle(v3.sheetRef, function()
		return { close = v16 }
	end, {})

	local udim = UDim2.new(0, v11 + (not v8 and 0 or right), 1, v8 and 0 or -medium * 2)

	local mapped = v14:map(function(p2: number)
		local v17

		if v8 then
			v17 = -p2
		else
			v17 = -(p2 + medium)
		end

		return UDim2.new(1, v17, 0, v8 and 0 or medium)
	end)

	local v17 = React.useMemo(function()
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
			closeSheet = v16,
			hasRadius = not v8,
			sheetType = SheetType.Side,
			testId = v3.testId,
			closeAffordanceRef = ref2,
			contentStartRef = state,
			setContentStartRef = setState
		}
	end, { v3.testId, v16, state, ref2, hasFullBleed, v8 })

	if not v4 then
		return v4
	end

	local createPortal = ReactRoblox.createPortal
	local createElement = React.createElement
	local v18 = { ZIndex = owner.zIndex, tag = "size-full", testId = `{v3.testId}--surface` }

	local createElement2 = React.createElement
	local v19 = {
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
	local v20 = {
		Content = React.createElement(
			View,
			{ tag = "col items-center size-full-full clip" },
			React.createElement(
				SheetContext.Provider,
				{ value = v17 },
				React.createElement(ElevationOwnerScope, { owner = owner }, v3.children)
			)
		),
		CloseAffordance = 0
	}

	local createElement3 = React.createElement
	local v21 = {
		onActivated = v16,
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

	v21.variant = variant

	v21.Position = UDim2.new(1, -v5.Margin.Small, 0, v5.Margin.Small)
	v21.AnchorPoint = Vector2.new(1, 0)
	v21.Visible = hasHeader:map(function(flag: boolean): boolean
		return not flag
	end)

	v21.testId = `{v3.testId}--close-affordance`
	v20.CloseAffordance = createElement3(CloseAffordance, v21)
	local children = {
		Sheet = createElement2(View, v19, v20),
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
		Backdrop = 0
	}
	local backdrop

	if Flags.FoundationSideSheetInternalBackdrop then
		backdrop = React.createElement(Backdrop, {
			transparency = transparency,
			onActivated = v16,
			ZIndex = 1,
			testId = `{v3.testId}--backdrop`
		})
	else
		backdrop = React.createElement(View, {
			Size = UDim2.fromScale(2, 2),
			Position = UDim2.fromScale(-0.5, -0.5),
			ZIndex = 1,
			stateLayer = { affordance = StateLayerAffordance.None },
			backgroundStyle = transparency:map(function(p2: number)
				return {
					Color3 = v5.Color.Common.Backdrop.Color3,
					Transparency = math.lerp(v5.Color.Common.Backdrop.Transparency, 1, p2)
				}
			end),
			onActivated = v16,
			testId = `{v3.testId}--backdrop`
		})
	end

	children.Backdrop = backdrop
	return (createPortal(createElement(View, v18, children), v4))
end

local memo = React.memo
local forwardRef = React.forwardRef

if not Flags.FoundationSideSheetInternalDrawer then
	DrawerSideSheet = SideSheet
end

return memo(forwardRef(DrawerSideSheet))
