local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local parent = AvatarSwitcher.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local ReactUtils = require(parent.ReactUtils)
local useEventConnection = ReactUtils.useEventConnection
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local sendAXCounterV2 = AvatarExperienceAnalytics.sendAXCounterV2

local RespawnChoiceDialog = require(AvatarSwitcher.Components.Modals.RespawnChoiceDialog)
local RespawnLaterDialog = require(AvatarSwitcher.Components.Modals.RespawnLaterDialog)
local getAvatarSwitcherStore = require(AvatarSwitcher.Stores.getAvatarSwitcherStore)
local respawnAvatar = require(AvatarSwitcher.Utils.respawnAvatar)
local Constants = require(AvatarSwitcher.Constants)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAvatarSwitcherCounters = AvatarExperienceFlags.FFlagAvatarSwitcherCounters

local function RespawnDialogContainer(props)
	local v = SignalsReact.useSignalState(getAvatarSwitcherStore)
	local v2 = SignalsReact.useSignalState(v.getRespawnPromptShown)

	local state, setState = React.useState(function()
		local respawnBehaviour, _ = props.getRespawnBehaviour()
		return respawnBehaviour
	end)

	useEventConnection(props.respawnBehaviorChangedEvent.Event, setState, {})

	local onConfirm = React.useCallback(function()
		v.toggleRespawnPrompt(false)
		props.toggleWindow()

		if FFlagAvatarSwitcherCounters then
			sendAXCounterV2(Constants.Counters.ConfirmRespawn)
		end

		v.switchAvatar()
		respawnAvatar(props.getRespawnBehaviour)
	end, { props.getRespawnBehaviour, props.toggleWindow })

	local onDefer = React.useCallback(function()
		v.toggleRespawnPrompt(false)
		props.toggleWindow()

		if FFlagAvatarSwitcherCounters then
			sendAXCounterV2(Constants.Counters.DeferRespawn, { respawnEnabled = tostring(state) })
		end

		v.switchAvatar()
	end, { props.toggleWindow })

	local onClose = React.useCallback(function()
		if FFlagAvatarSwitcherCounters then
			sendAXCounterV2(Constants.Counters.CancelSwitchAvatar)
		end

		v.toggleRespawnPrompt(false)
	end, {})

	return React.createElement(React.Fragment, nil, {
		RespawnChoiceDialog = v2 and state and React.createElement(RespawnChoiceDialog, {
			onConfirm = onConfirm,
			onDefer = onDefer,
			onClose = onClose
		}),
		RespawnLaterDialog = v2 and not state and React.createElement(RespawnLaterDialog, {
			onDefer = onDefer,
			onClose = onClose
		})
	})
end

return RespawnDialogContainer
