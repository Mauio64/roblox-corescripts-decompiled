local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent
local Dash = require(parent.Dash)
local React = require(parent.React)

local Constants = require(Foundation.Constants)
require(Foundation.Enums.InternalDrawerSide)
require(script.Parent.Types)
local OnCloseCallbackReason = require(Foundation.Enums.OnCloseCallbackReason)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local View = require(Foundation.Components.View)
local dismissSwipeHandlers = require(script.Parent.dismissSwipeHandlers)
local drawerMotion = require(script.Parent.drawerMotion)
local swipeMath = require(script.Parent.swipeMath)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local useSwipeSession = require(script.Parent.useSwipeSession)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function InternalDrawerDismissSwipe(props)
	local v = useTokens()
	local reducedMotion = usePreferences().reducedMotion
	local state, setState = React.useState(false)
	local ref = React.useRef(nil)
	local thresholds, velocityThreshold = swipeMath.resolveThresholds(props.config)

	local onClaim = React.useCallback(function()
		drawerMotion.hold(props.motion)
	end, { props.motion })

	local onRelease = React.useCallback(function(flag: boolean)
		if not flag then
			drawerMotion.animate(props.motion, true, v, reducedMotion)

			return
		end

		props.onRequestClose(OnCloseCallbackReason.Swipe)
		setState(true)
	end, { props.motion, props.onRequestClose, v, reducedMotion })

	local onCancel = React.useCallback(function()
		drawerMotion.animate(props.motion, props.isOpen, v, reducedMotion)
	end, { props.motion, props.isOpen, v, reducedMotion })

	useSwipeSession({
		side = props.side,
		travel = props.travel,
		isOpen = props.isOpen,
		distanceFraction = thresholds,
		velocityThreshold = velocityThreshold,
		onClaim = onClaim,
		setDrag = props.motion.setDrag,
		onRelease = onRelease,
		onCancel = onCancel
	}, function(latest)
		return {
			gesture = nil,
			latest = latest,
			panelRef = props.panelRef,
			backdropRef = props.backdropRef,
			scrollingFrameRef = props.scrollingFrameRef,
			captureRef = ref,
			unlock = nil
		}
	end, dismissSwipeHandlers, props.isOpen)

	React.useEffect(function()
		if not state then
			return
		end

		if props.isOpen then
			drawerMotion.animate(props.motion, true, v, reducedMotion)
		end

		setState(false)
	end, { state, props.isOpen, props.motion, v, reducedMotion })

	return React.createElement(View, {
		Visible = false,
		ZIndex = 5,
		onActivated = Dash.noop,
		selection = Constants.MODAL.DISABLE_SELECTION,
		stateLayer = { affordance = StateLayerAffordance.None },
		ref = ref,
		tag = "size-full",
		testId = `{props.testId}--swipe-capture`
	})
end

return InternalDrawerDismissSwipe
