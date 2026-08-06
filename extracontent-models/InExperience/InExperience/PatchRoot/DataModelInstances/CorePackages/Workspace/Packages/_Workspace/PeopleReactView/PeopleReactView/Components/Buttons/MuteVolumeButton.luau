local PeopleReactView = script:FindFirstAncestor("PeopleReactView")
local PeopleReactViewParent = PeopleReactView.Parent
local Foundation = require(PeopleReactViewParent.Foundation)
local React = require(PeopleReactViewParent.React)
local SignalsReact = require(PeopleReactViewParent.SignalsReact)
local Signals = require(PeopleReactViewParent.Signals)
local PeopleService = require(PeopleReactViewParent.PeopleService)
local FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry = PeopleService.getService("Flags").FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry
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
local v19 = Signals.createSignal("")
local v20 = Signals.createSignal(false)
local v21 = React.memo(function(t1: {[any]: any}) -- line: 46
	-- upvalues: useTokens (copy), useSignalState (copy), v19 (copy), v20 (copy), React (copy), Foundation (copy), IconSize (copy)
	local v24 = useTokens()
	local v25 = useSignalState(t1.animatedIcon or v19)
	local v26 = useSignalState(t1.isGrayedOut or v20)

	if v25 ~= "" then
		return (React.createElement(Foundation.Icon, {
			name = v25,
			size = IconSize.Medium,
			style = {
				Transparency = if not v26 then nil else v24.Color.Common.Shadow.Transparency
			}
		}))
	end

	return nil
end)

local function MuteVolumeButton(t2: {[any]: any}) -- line: 65
	-- upvalues: useTokens (copy), React (copy), FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry (copy), ControlState (copy), useCursor (copy), PeopleService (copy), ENTRY_POINT (copy), View (copy), StateLayerAffordance (copy), v21 (copy), Foundation (copy), IconName (copy), IconSize (copy), VoiceVolumePopover (copy)
	local v28 = useTokens()
	local XXSmall = v28.Gap.XXSmall
	local config = t2.config
	local v31, v32 = React.useState(false)
	local u33 = nil

	if FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then
		u33 = React.useRef(false)
	end

	local v34, v35 = React.useState(ControlState.Initialize)
	local v36, v37 = React.useState(ControlState.Initialize)
	local v38 = useCursor({
		radius = UDim.new(0, v28.Radius.Medium),
		offset = v28.Size.Size_150,
		borderWidth = v28.Stroke.Thicker
	})
	local v39 = React.useCallback(function() -- line: 84
		-- upvalues: config (copy), t2 (copy)
		config.onActivated(t2.entryPoint)
	end, {
		config.onActivated,
		t2.entryPoint
	})
	local v40 = if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then React.useCallback(function() -- line: 104
		-- upvalues: v32 (copy)
		v32(function(p1) -- line: 105
			return not p1
		end)
	end, {}) else React.useCallback(function() -- line: 90
		-- upvalues: t2 (copy), u33 (ref), PeopleService (copy), ENTRY_POINT (copy), v32 (copy)
		if t2.userId == nil or not u33 then
			return
		end

		local v55 = not u33.current

		u33.current = v55

		if v55 then
			PeopleService.getService("PeopleAnalyticsManager"):recordPerUserVoiceVolumeUiOpened(t2.entryPoint or ENTRY_POINT.PEOPLE_LIST)
		end

		v32(v55)
	end, {
		t2.entryPoint,
		t2.userId
	})
	local v41 = React.useCallback(function() -- line: 111
		-- upvalues: FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry (copy), u33 (ref), v32 (copy)
		if FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry and u33 then
			u33.current = false
		end

		v32(false)
	end, {})
	local v42 = React.useCallback(function(p2) -- line: 118
		-- upvalues: t2 (copy)
		if t2.onButtonMount then
			t2.onButtonMount(p2, t2.muteButtonName)
		end
	end, {
		t2.onButtonMount,
		t2.muteButtonName
	})
	local v43 = React.useCallback(function(p3) -- line: 124
		-- upvalues: t2 (copy)
		if t2.onButtonMount then
			t2.onButtonMount(p3, t2.volumeButtonName)
		end
	end, {
		t2.onButtonMount,
		t2.volumeButtonName
	})
	local v44 = React.useCallback(function(p4) -- line: 130
		-- upvalues: v35 (copy)
		v35(p4)
	end, {})
	local v45 = React.useCallback(function(p5) -- line: 134
		-- upvalues: v37 (copy)
		v37(p5)
	end, {})
	local v46 = v31 and t2.userId ~= nil
	local Size_1000 = v28.Size.Size_1000
	local Size_1000_2 = v28.Size.Size_1000
	local v49 = t2.LayoutOrder or config.layoutOrder

	local function getInteractionOverlayStyle(p6) -- line: 144
		-- upvalues: ControlState (copy), v28 (copy)
		if p6 == ControlState.Pressed then
			return v28.Color.State.Press
		end

		if p6 == ControlState.Hover then
			return v28.Color.State.Hover
		end

		return nil
	end

	local v51 = if v34 ~= ControlState.Pressed then if v34 ~= ControlState.Hover then nil else v28.Color.State.Hover else v28.Color.State.Press
	local v52 = if v36 ~= ControlState.Pressed then if v36 ~= ControlState.Hover then nil else v28.Color.State.Hover else v28.Color.State.Press
	local v53 = React.createElement(View, {
		tag = "size-1000-1000",
		onActivated = v39,
		onStateChanged = v44,
		selection = {
			SelectionImageObject = v38
		},
		LayoutOrder = v49,
		ref = v42,
		stateLayer = {
			affordance = StateLayerAffordance.None
		}
	}, {
		Background = React.createElement(View, {
			tag = "radius-left-medium size-1000-1000 bg-action-standard"
		}, {
			StateOverlay = if not v51 then nil else React.createElement(View, {
				tag = "radius-left-medium size-full",
				backgroundStyle = v51
			})
		}),
		IconOverlay = React.createElement(View, {
			tag = "row align-x-center align-y-center size-full",
			ZIndex = 2,
			Active = false
		}, {
			Icon = React.createElement(v21, {
				animatedIcon = config.animatedIcon,
				isGrayedOut = config.isGrayedOut
			})
		})
	})
	local v54 = React.createElement(View, {
		tag = "size-1000-1000",
		onActivated = v40,
		onStateChanged = v45,
		selection = {
			SelectionImageObject = v38
		},
		LayoutOrder = v49 + 1,
		ref = v43,
		stateLayer = {
			affordance = StateLayerAffordance.None
		}
	}, {
		Background = React.createElement(View, {
			tag = "radius-right-medium size-1000-1000 bg-action-standard"
		}, {
			StateOverlay = if not v52 then nil else React.createElement(View, {
				tag = "radius-right-medium size-full",
				backgroundStyle = v52
			})
		}),
		IconOverlay = React.createElement(View, {
			tag = "row align-x-center align-y-center size-full padding-right-xxsmall",
			ZIndex = 2,
			Active = false
		}, {
			ChevronIcon = React.createElement(Foundation.Icon, {
				name = if not v46 then IconName.ChevronSmallDown else IconName.ChevronSmallUp,
				size = IconSize.Large
			})
		})
	})

	return React.createElement(VoiceVolumePopover, {
		userId = t2.userId,
		isOpen = v46,
		onClose = v41,
		layoutOrder = v49,
		muteHalf = v53,
		chevronHalf = v54,
		pillWidth = Size_1000 * 2 + XXSmall,
		pillHeight = Size_1000_2,
		alignOffset = Size_1000 + XXSmall,
		isMutedByLocalUser = config.isGrayedOut,
		entryPoint = if not FFlagVoiceVolumeControlsEnablePerUserVolumeInteractionTelemetry then nil else t2.entryPoint
	})
end

return MuteVolumeButton
