local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Dash = require(parent.Dash)
local Otter = require(parent.Otter)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local ReactRoblox = require(parent.ReactRoblox)
local useAnimatedBinding = ReactOtter.useAnimatedBinding

local Backdrop = require(Foundation.Components.Backdrop)
local Constants = require(Foundation.Constants)
local OnCloseCallbackReason = require(Foundation.Enums.OnCloseCallbackReason)
local ElevationProvider = require(Foundation.Providers.Elevation.ElevationProvider)
local ElevationOwnerScope = ElevationProvider.ElevationOwnerScope
local ScrollView = require(Foundation.Components.ScrollView)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local View = require(Foundation.Components.View)
local useInternalDrawerVariants = require(script.Parent.useInternalDrawerVariants)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local useScreenSize = require(Foundation.Components.Sheet.useScreenSize)
local useTokens = require(Foundation.Providers.Style.useTokens)

local InternalDrawerBackdrop = require(Foundation.Enums.InternalDrawerBackdrop)
local InternalDrawerShadow = require(Foundation.Enums.InternalDrawerShadow)
local InternalDrawerSide = require(Foundation.Enums.InternalDrawerSide)
require(script.Parent.Types)

local function InternalDrawerOverlay(props, ref9)
	local v = useOverlay()
	local v2 = useTokens()
	local v3 = useInternalDrawerVariants(props.layout, props.side)
	local v4 = props.shadow == InternalDrawerShadow.Overlay300
	local elevation = props.elevation
	local reducedMotion = usePreferences().reducedMotion
	local v5 = useScreenSize()

	local surface = v3.surface
	local v6 = math.max(v5.X - v2.Size.Size_1200 - surface.margin, 0)
	local v7 = math.min(props.width, v6)

	local outerBleed = props.outerBleed or 0
	local padding

	if outerBleed > 0 then
		if props.side == InternalDrawerSide.End then
			padding = { right = UDim.new(0, outerBleed) }
		else
			padding = { left = UDim.new(0, outerBleed) }
		end
	end

	local ref = React.useRef(props.isOpen)
	ref.current = props.isOpen

	local ref2 = React.useRef(true)
	local ref3 = React.useRef(true)
	local ref4 = React.useRef(0)
	local ref5 = React.useRef(1)
	local ref6 = React.useRef(false)
	local ref7 = React.useRef(props.onExited)
	ref7.current = props.onExited
	local ref8 = React.useRef(props.onOpenComplete)
	ref8.current = props.onOpenComplete

	local function notifySettled()
		if not ref.current and ref2.current and ref3.current then
			ref7.current()
		elseif ref6.current and ref2.current and ref3.current and ref4.current == 1 and ref5.current == 0 then
			ref6.current = false
			local current = ref8.current

			if current then
				current()
			end
		end
	end

	local v8, v9 = useAnimatedBinding(0, function(current: number)
		ref4.current = current
		ref2.current = true
		notifySettled()
	end)
	local transparency, v10 = useAnimatedBinding(1, function(current: number)
		ref5.current = current
		ref3.current = true
		notifySettled()
	end)

	React.useEffect(function()
		ref2.current = false
		ref3.current = false
		ref6.current = props.isOpen and ref8.current ~= nil

		if reducedMotion then
			v9((Otter.instant(props.isOpen and 1 or 0)))
			v10((Otter.instant(props.isOpen and 0 or 1)))
		elseif props.isOpen then
			v9(Otter.ease(1, { easingStyle = v2.Ease.StandardOut, duration = v2.Time.Time_300 }))

			v10(Otter.ease(0, { duration = v2.Time.Time_100 }))
		else
			v9(Otter.ease(0, { easingStyle = v2.Ease.StandardIn, duration = v2.Time.Time_100 }))

			v10(Otter.ease(1, { duration = v2.Time.Time_100 }))
		end
	end, { props.isOpen, reducedMotion })

	local onActivated = React.useCallback(function()
		if props.backdrop == InternalDrawerBackdrop.Dismissible and ref.current then
			props.onRequestClose(OnCloseCallbackReason.BackdropClick)
		end
	end, { props.backdrop, props.onRequestClose })

	local udim = UDim2.new(0, v7 + outerBleed, 1, -surface.margin * 2)
	local mapped = v8:map(function(p: number)
		local v11 = (1 - p) * outerBleed
		local v12

		if props.side == InternalDrawerSide.End then
			v12 = -p * (v7 + surface.margin) + v11
		else
			local v13 = (1 - p) * v7
			v12 = surface.openOffsetSign * surface.margin * p + surface.hiddenOffsetSign * (v13 + outerBleed + v11)
		end

		return UDim2.new(surface.anchorScaleX, v12, 0, surface.margin)
	end)

	if not v then
		return v
	end

	local createPortal = ReactRoblox.createPortal
	local createElement = React.createElement
	local v11 = {
		ZIndex = elevation.zIndex,
		tag = "size-full",
		testId = `{props.testId}--container`
	}

	local createElement2 = React.createElement
	local v12 = {
		Size = udim,
		Position = mapped,
		ClipsDescendants = true,
		ZIndex = v4 and 3 or 2,
		stateLayer = { affordance = StateLayerAffordance.None },
		onActivated = Dash.noop,
		selection = Constants.MODAL.DISABLE_SELECTION,
		selectionGroup = Constants.MODAL.TRAP_FOCUS,
		tag = `{surface.tag} {props.backgroundColor}`,
		ref = ref9,
		testId = props.testId
	}

	local createElement3 = React.createElement

	local v13 = { tag = "col size-full", padding = padding, testId = `{props.testId}--column` }

	local createElement4 = React.createElement
	local header

	if props.header ~= nil then
		header = React.createElement(
			View,
			{ LayoutOrder = 1, tag = "col size-full-0 auto-y", testId = `{props.testId}--header` },
			props.header
		)
	end

	local body

	if props.scrolls == false then
		body = React.createElement(
			View,
			{ LayoutOrder = 2, tag = "fill size-full-0", testId = `{props.testId}--body` },
			props.children
		)
	else
		body = React.createElement(ScrollView, {
			LayoutOrder = 2,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(1, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				scrollBarVisibility = props.scrollBarVisibility
			},
			tag = "fill size-full-0",
			testId = `{props.testId}--body`
		}, {
			Children = React.createElement(
				View,
				{ tag = "col size-full-0 auto-y", testId = `{props.testId}--body-content` },
				props.children
			)
		})
	end

	local footer

	if props.footer ~= nil then
		footer = React.createElement(
			View,
			{ LayoutOrder = 3, tag = "col size-full-0 auto-y", testId = `{props.testId}--footer` },
			props.footer
		)
	end

	local v14 = {
		Content = createElement3(
			View,
			v13,
			createElement4(ElevationOwnerScope, { owner = elevation }, {
				Header = header,
				Body = body,
				Footer = footer
			})
		),
		InnerEdge = 0
	}
	local innerEdge

	if v3.innerEdge.isVisible then
		innerEdge = React.createElement(View, {
			Size = UDim2.new(0, v3.innerEdge.thickness, 1, 0),
			backgroundStyle = v3.innerEdge.backgroundStyle,
			ZIndex = 2,
			tag = v3.innerEdge.tag,
			testId = `{props.testId}--inner-edge`
		})
	end

	v14.InnerEdge = innerEdge
	local children = { Surface = createElement2(View, v12, v14), Shadow = 0, Backdrop = 0 }
	local shadow

	if v4 then
		shadow = React.createElement(View, {
			Size = udim,
			Position = mapped,
			ZIndex = 2,
			tag = v3.shadow.tag,
			testId = `{props.testId}--shadow`
		})
	end

	children.Shadow = shadow

	children.Backdrop = React.createElement(Backdrop, {
		ZIndex = 1,
		transparency = transparency,
		onActivated = onActivated,
		testId = `{props.testId}--backdrop`
	})
	return (createPortal(createElement(View, v11, children), v))
end

return React.memo(React.forwardRef(InternalDrawerOverlay))
