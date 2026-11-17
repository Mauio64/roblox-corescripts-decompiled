local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Dash = require(parent.Dash)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local ReactRoblox = require(parent.ReactRoblox)
local useAnimatedBinding = ReactOtter.useAnimatedBinding

local Backdrop = require(Foundation.Components.Backdrop)
local Constants = require(Foundation.Constants)
local OnCloseCallbackReason = require(Foundation.Enums.OnCloseCallbackReason)
local ElevationProvider = require(Foundation.Providers.Elevation.ElevationProvider)
local ElevationOwnerScope = ElevationProvider.ElevationOwnerScope
local InternalDrawerDismissSwipe = require(script.Parent.InternalDrawerDismissSwipe)
local ScrollView = require(Foundation.Components.ScrollView)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local View = require(Foundation.Components.View)
local drawerMotion = require(script.Parent.drawerMotion)
local useInternalDrawerVariants = require(script.Parent.useInternalDrawerVariants)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local useSurfaceWidth = require(script.Parent.useSurfaceWidth)
local useTokens = require(Foundation.Providers.Style.useTokens)

local InternalDrawerBackdrop = require(Foundation.Enums.InternalDrawerBackdrop)
local InternalDrawerOpenPhase = require(Foundation.Enums.InternalDrawerOpenPhase)
local InternalDrawerShadow = require(Foundation.Enums.InternalDrawerShadow)
local InternalDrawerSide = require(Foundation.Enums.InternalDrawerSide)
require(script.Parent.Types)

local function assignForwardedRef(callback, current) -- 1 equivalent call inferred from this helper
	if typeof(callback) == "function" then
		callback(current)
	elseif callback ~= nil then
		callback.current = current
	end
end

local function InternalDrawerOverlay(props, callback)
	local v = useOverlay()
	local v2 = useTokens()
	local v3 = useInternalDrawerVariants(props.layout, props.side)
	local v4 = props.shadow == InternalDrawerShadow.Overlay300
	local elevation = props.elevation
	local reducedMotion = usePreferences().reducedMotion

	local surface = v3.surface
	local outerBleed = props.outerBleed or 0
	local v5, travel = useSurfaceWidth(props.width, surface.margin, outerBleed)
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
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(nil)

	local ref13 = React.useCallback(function(current)
		ref2.current = current
		assignForwardedRef(callback, current) -- inferred equivalent call
	end, { callback })

	local ref5 = React.useRef(true)
	local ref6 = React.useRef(true)
	local ref7 = React.useRef(0)
	local ref8 = React.useRef(1)
	local ref9 = React.useRef(false)
	local ref10 = React.useRef(props.onExited)
	ref10.current = props.onExited
	local ref11 = React.useRef(props.onOpenComplete)
	ref11.current = props.onOpenComplete
	local ref12 = React.useRef(false)
	local v6

	if props.openPhase == InternalDrawerOpenPhase.Pressed then
		v6 = not props.isOpen
	else
		v6 = false
	end

	local v7

	if props.openPhase == InternalDrawerOpenPhase.Dragging or props.openPhase == InternalDrawerOpenPhase.Requested then
		v7 = not props.isOpen
	else
		v7 = false
	end

	ref12.current = v7 or v6

	local function notifySettled()
		if not ref.current and not ref12.current and ref5.current and ref6.current then
			ref10.current()
		elseif ref9.current and ref5.current and ref6.current and ref7.current == 1 and ref8.current == 0 then
			ref9.current = false
			local current = ref11.current

			if current then
				current()
			end
		end
	end

	local v8, setPanelGoal = useAnimatedBinding(0, function(current: number)
		ref7.current = current
		ref5.current = true
		notifySettled()
	end)
	local v9, setBackdropGoal = useAnimatedBinding(1, function(current: number)
		ref8.current = current
		ref6.current = true
		notifySettled()
	end)

	local drag = props.drag
	local setDrag = props.setDrag
	local motion = React.useMemo(function()
		return {
			panelProgress = v8,
			backdropTransparency = v9,
			setPanelGoal = setPanelGoal,
			setBackdropGoal = setBackdropGoal,
			drag = drag,
			setDrag = setDrag
		}
	end, { v8, v9, setPanelGoal, setBackdropGoal, drag, setDrag })

	local v10 = React.useMemo(function()
		return React.joinBindings({ animated = v8, dragged = drag }):map(function(p)
			if p.dragged == nil then
				return p.animated
			end

			return p.dragged
		end)
	end, { v8, drag })
	local transparency = React.useMemo(function()
		return React.joinBindings({ animated = v9, dragged = drag }):map(function(p)
			if p.dragged == nil then
				return p.animated
			end

			return 1 - p.dragged
		end)
	end, { v9, drag })

	React.useEffect(function()
		if v7 then
			drawerMotion.hold(motion)
			return
		end

		if v6 then
			return
		end

		ref5.current = false
		ref6.current = false
		ref9.current = props.isOpen and ref11.current ~= nil
		drawerMotion.animate(motion, props.isOpen, v2, reducedMotion)
	end, { props.isOpen, v7, v6, reducedMotion })

	local onActivated = React.useCallback(function()
		if props.backdrop == InternalDrawerBackdrop.Dismissible and ref.current then
			props.onRequestClose(OnCloseCallbackReason.BackdropClick)
		end
	end, { props.backdrop, props.onRequestClose })

	local udim = UDim2.new(0, v5 + outerBleed, 1, -surface.margin * 2)
	local side = props.side
	local position = React.useMemo(function()
		return v10:map(function(p: number)
			local v11 = (1 - p) * outerBleed
			local v12

			if side == InternalDrawerSide.End then
				v12 = -p * (v5 + surface.margin) + v11
			else
				local v13 = (1 - p) * v5
				v12 = surface.openOffsetSign * surface.margin * p + surface.hiddenOffsetSign * (v13 + outerBleed + v11)
			end

			return UDim2.new(surface.anchorScaleX, v12, 0, surface.margin)
		end)
	end, { v10, side, v5, outerBleed, surface })

	if not v then
		return v
	end

	local createPortal = ReactRoblox.createPortal
	local createElement = React.createElement
	local v11 = {
		Visible = props.openPhase ~= InternalDrawerOpenPhase.Pressed,
		ZIndex = elevation.zIndex,
		tag = "size-full",
		testId = `{props.testId}--container`
	}

	local createElement2 = React.createElement
	local v12 = {
		Size = udim,
		Position = position,
		ClipsDescendants = true,
		ZIndex = v4 and 3 or 2,
		stateLayer = { affordance = StateLayerAffordance.None },
		onActivated = Dash.noop,
		selection = Constants.MODAL.DISABLE_SELECTION,
		selectionGroup = Constants.MODAL.TRAP_FOCUS,
		tag = `{surface.tag} {props.backgroundColor}`,
		ref = 0,
		testId = 0
	}

	if props.swipeToDismiss == nil then
		ref13 = callback
	end

	v12.ref = ref13
	v12.testId = props.testId

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
		local createElement5 = React.createElement
		local v14 = {
			LayoutOrder = 2,
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromScale(1, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y,
				scrollBarVisibility = props.scrollBarVisibility
			},
			tag = "fill size-full-0",
			scrollingFrameRef = 0,
			testId = 0
		}
		local scrollingFrameRef

		if props.swipeToDismiss ~= nil then
			scrollingFrameRef = ref4
		end

		v14.scrollingFrameRef = scrollingFrameRef
		v14.testId = `{props.testId}--body`
		body = createElement5(ScrollView, v14, {
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
	local children = {
		Surface = createElement2(View, v12, v14),
		Shadow = 0,
		Backdrop = 0,
		Swipe = 0
	}
	local shadow

	if v4 then
		shadow = React.createElement(View, {
			Size = udim,
			Position = position,
			ZIndex = 2,
			tag = v3.shadow.tag,
			testId = `{props.testId}--shadow`
		})
	end

	children.Shadow = shadow

	local createElement5 = React.createElement
	local ref14

	if props.swipeToDismiss ~= nil then
		ref14 = ref3
	end

	children.Backdrop = createElement5(Backdrop, {
		ZIndex = 1,
		transparency = transparency,
		onActivated = onActivated,
		ref = ref14,
		testId = `{props.testId}--backdrop`
	})
	local swipe

	if props.swipeToDismiss ~= nil then
		swipe = React.createElement(InternalDrawerDismissSwipe, {
			config = props.swipeToDismiss,
			panelRef = ref2,
			backdropRef = ref3,
			scrollingFrameRef = ref4,
			travel = travel,
			side = props.side,
			isOpen = props.isOpen,
			motion = motion,
			onRequestClose = props.onRequestClose,
			testId = props.testId
		})
	end

	children.Swipe = swipe
	return (createPortal(createElement(View, v11, children), v))
end

return React.memo(React.forwardRef(InternalDrawerOverlay))
