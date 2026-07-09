local AvatarSwitcher = script:FindFirstAncestor("AvatarSwitcher")
local AvatarSwitcherParent = AvatarSwitcher.Parent
local React = require(AvatarSwitcherParent.React)
local SignalsReact = require(AvatarSwitcherParent.SignalsReact)
local useEventConnection = require(AvatarSwitcherParent.ReactUtils).useEventConnection
local sendAXCounterV2 = require(AvatarSwitcherParent.AvatarExperienceAnalytics).sendAXCounterV2
local RespawnChoiceDialog = require(AvatarSwitcher.Components.Modals.RespawnChoiceDialog)
local RespawnLaterDialog = require(AvatarSwitcher.Components.Modals.RespawnLaterDialog)
local getAvatarSwitcherStore = require(AvatarSwitcher.Stores.getAvatarSwitcherStore)
local respawnAvatar = require(AvatarSwitcher.Utils.respawnAvatar)
local Constants = require(AvatarSwitcher.Constants)
local FFlagAvatarSwitcherCounters = require(AvatarSwitcherParent.AvatarExperienceFlags).FFlagAvatarSwitcherCounters

local function RespawnDialogContainer(t1: {[any]: any}) -- line: 31
	-- upvalues: SignalsReact (copy), getAvatarSwitcherStore (copy), React (copy), useEventConnection (copy), FFlagAvatarSwitcherCounters (copy), sendAXCounterV2 (copy), Constants (copy), respawnAvatar (copy), RespawnChoiceDialog (copy), RespawnLaterDialog (copy)
	local v15 = SignalsReact.useSignalState(getAvatarSwitcherStore)
	local v16 = SignalsReact.useSignalState(v15.getRespawnPromptShown)
	local v17, v18 = React.useState(function() -- line: 35
		-- upvalues: t1 (copy)
		local v22, _ = t1.getRespawnBehaviour()

		return v22
	end)

	useEventConnection(t1.respawnBehaviorChangedEvent.Event, v18, {})

	local v19 = React.useCallback(function() -- line: 42
		-- upvalues: v15 (copy), t1 (copy), FFlagAvatarSwitcherCounters (copy), sendAXCounterV2 (copy), Constants (copy), respawnAvatar (copy)
		v15.toggleRespawnPrompt(false)
		t1.toggleWindow()

		if FFlagAvatarSwitcherCounters then
			sendAXCounterV2(Constants.Counters.ConfirmRespawn)
		end

		v15.switchAvatar()
		respawnAvatar(t1.getRespawnBehaviour)
	end, {
		t1.getRespawnBehaviour,
		t1.toggleWindow
	})
	local v20 = React.useCallback(function() -- line: 53
		-- upvalues: v15 (copy), t1 (copy), FFlagAvatarSwitcherCounters (copy), sendAXCounterV2 (copy), Constants (copy), v17 (copy)
		v15.toggleRespawnPrompt(false)
		t1.toggleWindow()

		if FFlagAvatarSwitcherCounters then
			sendAXCounterV2(Constants.Counters.DeferRespawn, {
				respawnEnabled = tostring(v17)
			})
		end

		v15.switchAvatar()
	end, { t1.toggleWindow })
	local v21 = React.useCallback(function() -- line: 63
		-- upvalues: FFlagAvatarSwitcherCounters (copy), sendAXCounterV2 (copy), Constants (copy), v15 (copy)
		if FFlagAvatarSwitcherCounters then
			sendAXCounterV2(Constants.Counters.CancelSwitchAvatar)
		end

		v15.toggleRespawnPrompt(false)
	end, {})

	return React.createElement(React.Fragment, nil, {
		RespawnChoiceDialog = v16 and (v17 and React.createElement(RespawnChoiceDialog, {
			onConfirm = v19,
			onDefer = v20,
			onClose = v21
		})),
		RespawnLaterDialog = v16 and (not v17 and React.createElement(RespawnLaterDialog, {
			onDefer = v20,
			onClose = v21
		}))
	})
end

return RespawnDialogContainer
