local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local parent = PeopleReactView.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local Signals = require(parent.Signals)
local PeopleService = require(parent.PeopleService)

local fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry = PeopleService.getService("Flags").FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry
local ENTRY_POINT = PeopleService.getService("Constants").ANALYTICS.ENTRY_POINT

local View = Foundation.View
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local ControlState = Foundation.Enums.ControlState
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useTokens = Foundation.Hooks.useTokens
local useCursor = Foundation.Hooks.useCursor
local useSignalState = SignalsReact.useSignalState

local VoiceVolumePopover = require(PeopleReactView.Components.Buttons.VoiceVolumePopover)

local signal = Signals.createSignal("")
local signal2 = Signals.createSignal(false)

local memo = React.memo(function(p)
	local v = useTokens()
	local name = useSignalState(p.animatedIcon or signal)
	local v2 = useSignalState(p.isGrayedOut or signal2)

	if name == "" then
		return nil
	end

	local createElement = React.createElement
	local icon = Foundation.Icon
	local v3 = { name = name, size = IconSize.Medium, style = 0 }
	local transparency

	if v2 then
		transparency = v.Color.Common.Shadow.Transparency
	end

	v3.style = { Transparency = transparency }
	return (createElement(icon, v3))
end)

local function MuteVolumeButton(props)
	local v = useTokens()
	local xxSmall = v.Gap.XXSmall
	local config = props.config

	local state, setState = React.useState(false)
	local ref

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		ref = React.useRef(false)
	else
		ref = nil
	end

	local state2, setState2 = React.useState(ControlState.Initialize)
	local state3, setState3 = React.useState(ControlState.Initialize)

	local selectionImageObject = useCursor({
		radius = UDim.new(0, v.Radius.Medium),
		offset = v.Size.Size_150,
		borderWidth = v.Stroke.Thicker
	})

	local onActivated = React.useCallback(function()
		config.onActivated(props.entryPoint)
	end, { config.onActivated, props.entryPoint })
	local onActivated2

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		onActivated2 = React.useCallback(function()
			if props.userId == nil or not ref then
				return
			end

			local current = not ref.current
			ref.current = current

			if current then
				PeopleService.getService("PeopleAnalyticsManager"):recordPerUserVoiceVolumeUiOpened(props.entryPoint or ENTRY_POINT.PEOPLE_LIST)
			end

			setState(current)
		end, { props.entryPoint, props.userId })
	else
		onActivated2 = React.useCallback(function()
			setState(function(p): boolean
				return not p
			end)
		end, {})
	end

	local onClose = React.useCallback(function()
		if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry and ref then
			ref.current = false
		end

		setState(false)
	end, {})

	local ref2 = React.useCallback(function(p)
		if props.onButtonMount then
			props.onButtonMount(p, props.muteButtonName)
		end
	end, { props.onButtonMount, props.muteButtonName })

	local ref3 = React.useCallback(function(p)
		if props.onButtonMount then
			props.onButtonMount(p, props.volumeButtonName)
		end
	end, { props.onButtonMount, props.volumeButtonName })

	local onStateChanged = React.useCallback(function(p)
		setState2(p)
	end, {})

	local onStateChanged2 = React.useCallback(function(p)
		setState3(p)
	end, {})

	local isOpen = state and props.userId ~= nil

	local size_1000 = v.Size.Size_1000
	local size_1000_2 = v.Size.Size_1000
	local layoutOrder = props.LayoutOrder or config.layoutOrder

	local function getInteractionOverlayStyle(state4) -- 2 equivalent calls inferred from this helper
		if state4 == ControlState.Pressed then
			return v.Color.State.Press
		end

		if state4 == ControlState.Hover then
			return v.Color.State.Hover
		end

		return nil
	end

	local interactionOverlayStyle = getInteractionOverlayStyle(state2) -- inferred equivalent call
	local interactionOverlayStyle2 = getInteractionOverlayStyle(state3) -- inferred equivalent call
	local createElement = React.createElement
	local v2 = {
		tag = "size-1000-1000",
		onActivated = onActivated,
		onStateChanged = onStateChanged,
		selection = { SelectionImageObject = selectionImageObject },
		LayoutOrder = layoutOrder,
		ref = ref2,
		stateLayer = { affordance = StateLayerAffordance.None }
	}

	local createElement2 = React.createElement
	local stateOverlay

	if interactionOverlayStyle then
		stateOverlay = React.createElement(View, {
			backgroundStyle = interactionOverlayStyle,
			tag = "radius-left-medium size-full"
		})
	end

	local element = createElement(View, v2, {
		Background = createElement2(View, {
			tag = "radius-left-medium size-1000-1000 bg-action-standard"
		}, {
			StateOverlay = stateOverlay
		}),
		IconOverlay = React.createElement(
			View,
			{ tag = "row align-x-center align-y-center size-full", ZIndex = 2, Active = false },
			{
				Icon = React.createElement(memo, {
					animatedIcon = config.animatedIcon,
					isGrayedOut = config.isGrayedOut
				})
			}
		)
	})

	local createElement3 = React.createElement
	local v3 = {
		tag = "size-1000-1000",
		onActivated = onActivated2,
		onStateChanged = onStateChanged2,
		selection = { SelectionImageObject = selectionImageObject },
		LayoutOrder = layoutOrder + 1,
		ref = ref3,
		stateLayer = { affordance = StateLayerAffordance.None }
	}

	local createElement4 = React.createElement
	local stateOverlay2

	if interactionOverlayStyle2 then
		stateOverlay2 = React.createElement(View, {
			backgroundStyle = interactionOverlayStyle2,
			tag = "radius-right-medium size-full"
		})
	end

	local children = {
		Background = createElement4(View, {
			tag = "radius-right-medium size-1000-1000 bg-action-standard"
		}, {
			StateOverlay = stateOverlay2
		}),
		IconOverlay = 0
	}

	local createElement5 = React.createElement

	local createElement6 = React.createElement
	local icon = Foundation.Icon
	local name

	if isOpen then
		name = IconName.ChevronSmallUp
	else
		name = IconName.ChevronSmallDown
	end

	children.IconOverlay = createElement5(
		View,
		{
			tag = "row align-x-center align-y-center size-full padding-right-xxsmall",
			ZIndex = 2,
			Active = false
		},
		{
			ChevronIcon = createElement6(icon, { name = name, size = IconSize.Large })
		}
	)
	local element2 = createElement3(View, v3, children)

	local createElement7 = React.createElement
	local v4 = {
		userId = props.userId,
		isOpen = isOpen,
		onClose = onClose,
		layoutOrder = layoutOrder,
		muteHalf = element,
		chevronHalf = element2,
		pillWidth = size_1000 * 2 + xxSmall,
		pillHeight = size_1000_2,
		alignOffset = size_1000 + xxSmall,
		isMutedByLocalUser = config.isGrayedOut,
		entryPoint = 0
	}
	local entryPoint

	if fFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		entryPoint = props.entryPoint
	end

	v4.entryPoint = entryPoint
	return createElement7(VoiceVolumePopover, v4)
end

return MuteVolumeButton
