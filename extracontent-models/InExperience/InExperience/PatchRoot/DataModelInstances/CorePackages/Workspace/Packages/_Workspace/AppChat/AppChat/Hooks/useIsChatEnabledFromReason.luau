local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getDeepValue = require(AppChat.Utils.getDeepValue)
local GetFriendsChatSettingsStore = require(AppChat.Stores.GetFriendsChatSettingsStore)

local FFlagAppChatUseSignalsForChatSettings = require(AppChat.Flags.FFlagAppChatUseSignalsForChatSettings)

return function(p: string)
	if not FFlagAppChatUseSignalsForChatSettings then
		return useSelector(function(p2)
			return getDeepValue(p2, `ChatAppReducer.ChatSettings.{p}`) or false
		end)
	end

	local friendsChatSettingsStore = GetFriendsChatSettingsStore(false)
	local v

	if p == "globalRulesEnabled" then
		v = friendsChatSettingsStore.getGlobalRulesEnabled
	elseif p == "privacySettingsEnabled" then
		v = friendsChatSettingsStore.getPrivacySettingsEnabled
	else
		v = friendsChatSettingsStore.getThirdPartyPrivacySettingsEnabled
	end

	return useSignalState(v)
end
