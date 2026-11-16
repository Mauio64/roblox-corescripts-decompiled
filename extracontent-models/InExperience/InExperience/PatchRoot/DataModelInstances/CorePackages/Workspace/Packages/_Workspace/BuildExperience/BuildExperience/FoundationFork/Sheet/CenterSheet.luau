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
local StateLayerAffordance = require(foundation.Enums.StateLayerAffordance)
local useOverlay = require(foundation.Providers.Overlay.useOverlay)
local useScaledValue = require(foundation.Utility.useScaledValue)
local useTokens = require(foundation.Providers.Style.useTokens)
local withDefaults = require(foundation.Utility.withDefaults)
local useDialogVariants = require(foundation.Components.Dialog.useDialogVariants)
local DIALOG_SIZES = useDialogVariants.DIALOG_SIZES
local Constants = require(foundation.Constants)
local DialogSize = require(foundation.Enums.DialogSize)

local ElevationLayer = require(foundation.Enums.ElevationLayer)

local useElevation = require(foundation.Providers.Elevation.useElevation)
local ElevationProvider = require(foundation.Providers.Elevation.ElevationProvider)
local ElevationOwnerScope = ElevationProvider.ElevationOwnerScope

local usePreferences = require(foundation.Providers.Preferences.usePreferences)

local SheetContext = require(script.Parent.SheetContext)
local Types = require(script.Parent.Types)

local SheetType = require(script.Parent.SheetType)

local childrenHasFullBleed = require(script.Parent.childrenHasFullBleed)

local CloseAffordance = require(foundation.Components.CloseAffordance)
local Image = require(foundation.Components.Image)
local View = require(foundation.Components.View)

local v = { size = DialogSize.Medium, testId = "--foundation-sheet" }

local SHADOW_IMAGE = Constants.SHADOW_IMAGE
local SHADOW_SIZE = Constants.SHADOW_SIZE

local function CenterSheet(p, ref)
	local v2 = withDefaults(p, v)
	local v3 = useOverlay()
	local v4 = useTokens()
	local owner = useElevation(ElevationLayer.Sheet, { stackAboveOwner = false })

	local reducedMotion = usePreferences().reducedMotion

	local v5 = useScaledValue(DIALOG_SIZES[v2.size])
	local v6 = useScaledValue(600)
	local size_800 = v4.Size.Size_800

	local v7, v8 = React.useBinding(v6)
	local sheetContentHeight

	if v7 then
		sheetContentHeight = v7:map(function(p2: number)
			if not v2.centerSheetHeight then
				return nil
			end

			if v2.centerSheetHeight > 0 and v2.centerSheetHeight <= 1 then
				return p2 * v2.centerSheetHeight
			end

			if v2.centerSheetHeight > 1 then
				return (math.min(v2.centerSheetHeight, p2))
			end

			return nil
		end)
	else
		sheetContentHeight = nil
	end

	local state, setState = React.useState(true)

	local ref2 = React.useRef(false)
	local v9, v10 = useAnimatedBinding(1, function()
		if ref2.current then
			v2.onClose()
		end
	end)

	local v11, v12 = useAnimatedBinding(size_800, function()
		setState(false)
	end)

	local hasActionsDivider, setHasActionsDivider = React.useBinding(false)
	local hasHeader, setHasHeader = React.useBinding(false)
	local hasFullBleed = childrenHasFullBleed(v2.children)
	local fullBleedHeight, setFullBleedHeight = React.useBinding(0)

	local innerScrollY, setInnerScrollY = React.useBinding(0)
	local v13, v14 = React.useBinding(0)

	local ref3 = React.useRef(nil)
	local state2, setState2 = React.useState(nil)

	local v15 = React.useMemo(function()
		local frame = Instance.new("Frame")
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.AutomaticSize = Enum.AutomaticSize.XY
		return frame
	end, {})

	React.useEffect(function()
		return function()
			v15:Destroy()
		end
	end, { v15 })

	local ref4 = React.useCallback(function(parent2)
		if parent2 then
			v15.Parent = parent2
		else
			v15.Parent = nil
		end
	end, { v15 })

	React.useEffect(function()
		if reducedMotion then
			v12((Otter.instant(0)))
			v10((Otter.instant(0)))
		else
			v12(Otter.ease(0, { easingStyle = v4.Ease.StandardOut, duration = v4.Time.Time_300 }))

			v10(Otter.ease(0, { duration = v4.Time.Time_100 }))
		end
	end, {})

	local v16 = React.useCallback(function()
		if ref2.current then
			return
		end

		if reducedMotion then
			ref2.current = true
			v12(Otter.instant(size_800))
			v10(Otter.instant(1))
		else
			v12(Otter.ease(size_800, {
				easingStyle = v4.Ease.StandardIn,
				duration = v4.Time.Time_100
			}))

			v10(Otter.ease(1, { duration = v4.Time.Time_100 }))

			setState(true)
			ref2.current = true
		end
	end, { size_800, reducedMotion })

	React.useImperativeHandle(v2.sheetRef, function()
		return { close = v16 }
	end, {})

	local v17 = React.useMemo(function()
		return {
			actionsHeight = 0,
			setActionsHeight = Dash.noop,
			hasActionsDivider = hasActionsDivider,
			setHasActionsDivider = setHasActionsDivider,
			sheetContentHeight = sheetContentHeight,
			setSheetContentHeight = Dash.noop,
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
			hasRadius = true,
			sheetType = SheetType.Center,
			testId = v2.testId,
			closeAffordanceRef = ref3,
			contentStartRef = state2,
			setContentStartRef = setState2
		}
	end, { v2.testId, v16, state2, ref3, sheetContentHeight, hasFullBleed })

	local createElement = React.createElement
	local size

	if v2.centerSheetHeight and sheetContentHeight then
		size = sheetContentHeight:map(function(p2: number?)
			if p2 then
				return (UDim2.new(1, 0, 0, p2))
			end

			return nil
		end)
	end

	local v18 = {
		ClipsDescendants = true,
		Size = size,
		sizeConstraint = v2.centerSheetHeight and v7 and {
			MaxSize = v7:map(function(p2: number)
				return Vector2.new(1e999, p2)
			end)
		} or nil,
		stateLayer = { affordance = StateLayerAffordance.None },
		ZIndex = 2,
		onActivated = Dash.noop,
		onAbsoluteSizeChanged = function(p2)
			v14(p2.AbsoluteSize.Y)
		end,
		ref = ref,
		selection = Types.nonSelectable,
		selectionGroup = Types.isolatedSelectionGroup,
		tag = {
			["bg-surface-100 stroke-default stroke-standard radius-large"] = true,
			["size-full-0 auto-y"] = v2.centerSheetHeight == nil
		},
		testId = v2.testId
	}

	local createElement2 = React.createElement
	local size2

	if v2.centerSheetHeight and sheetContentHeight then
		size2 = sheetContentHeight:map(function(p2: number?)
			if p2 then
				return (UDim2.new(1, 0, 0, p2))
			end

			return nil
		end)
	end

	local children = {
		Content = createElement2(
			View,
			{ Size = size2, tag = "col items-center size-full-0 auto-y clip" },
			React.createElement(
				SheetContext.Provider,
				{ value = v17 },
				React.createElement(ElevationOwnerScope, { owner = owner }, v2.children)
			)
		),
		CloseAffordance = 0
	}

	local createElement3 = React.createElement
	local v19 = {
		onActivated = v16,
		ref = ref3,
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

	v19.variant = variant
	v19.Position = UDim2.new(1, -v4.Margin.Small, 0, v4.Margin.Small)
	v19.AnchorPoint = Vector2.new(1, 0)
	v19.Visible = hasHeader:map(function(flag: boolean): boolean
		return not flag
	end)

	v19.testId = `{v2.testId}--close-affordance`
	children.CloseAffordance = createElement3(CloseAffordance, v19)
	local element = createElement(View, v18, children)

	local element2 = React.createElement(Image, {
		Image = SHADOW_IMAGE,
		Size = v13:map(function(p2: number)
			return UDim2.new(1, SHADOW_SIZE * 2, 0, p2 + SHADOW_SIZE * 2)
		end),
		Position = UDim2.new(0, -SHADOW_SIZE, 0.5, 0),
		ZIndex = 1,
		slice = {
			center = Rect.new(SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE + 1, SHADOW_SIZE + 1),
			scale = 2
		},
		imageStyle = v4.Color.Extended.Black.Black_10,
		tag = "anchor-center-left"
	})

	if not v3 then
		return v3
	end

	local createElement4 = React.createElement
	local fragment = React.Fragment
	local createPortal = ReactRoblox.createPortal
	local createElement5 = React.createElement
	local v20 = { ZIndex = owner.zIndex, tag = "size-full", testId = `{v2.testId}--surface` }

	local createElement6 = React.createElement
	local v21 = {
		ref = ref4,
		ZIndex = 2,
		sizeConstraint = { MaxSize = Vector2.new(v5, v6) },
		Position = v11:map(function(p2: number)
			return UDim2.new(0.5, 0, 0.5, p2)
		end),
		tag = "col align-y-center anchor-center-center size-full padding-medium",
		testId = `{v2.testId}--center-sheet-container`,
		GroupTransparency = 0,
		onAbsoluteSizeChanged = 0
	}
	local groupTransparency

	if state then
		groupTransparency = v11:map(function(p2: number)
			return p2 / size_800
		end)
	end

	v21.GroupTransparency = groupTransparency

	v21.onAbsoluteSizeChanged = v2.centerSheetHeight and v8 and function(p2)
		local v22 = v4.Margin.Medium * 2
		v8((math.min(p2.AbsoluteSize.Y - v22, v6)))
	end or nil
	return (createElement4(fragment, nil, {
		OverlayPortal = createPortal(createElement5(View, v20, {
			SheetContainer = createElement6(View, v21),
			Backdrop = React.createElement(View, {
				Size = UDim2.fromScale(2, 2),
				Position = UDim2.fromScale(-0.5, -0.5),
				ZIndex = 1,
				stateLayer = { affordance = StateLayerAffordance.None },
				backgroundStyle = v9:map(function(p2: number)
					return {
						Color3 = v4.Color.Common.Backdrop.Color3,
						Transparency = math.lerp(v4.Color.Common.Backdrop.Transparency, 1, p2)
					}
				end),
				onActivated = v16,
				testId = `{v2.testId}--backdrop`
			})
		}), v3),
		SheetContent = ReactRoblox.createPortal({ Sheet = element, Shadow = element2 }, v15)
	}))
end

return React.memo(React.forwardRef(CenterSheet))
