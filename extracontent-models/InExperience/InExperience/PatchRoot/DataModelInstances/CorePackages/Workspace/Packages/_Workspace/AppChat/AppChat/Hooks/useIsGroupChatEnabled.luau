local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getDeepValue = require(AppChat.Utils.getDeepValue)
local GetFriendsChatSettingsStore = require(AppChat.Stores.GetFriendsChatSettingsStore)

local FFlagAppChatUseSignalsForChatSettings = require(AppChat.Flags.FFlagAppChatUseSignalsForChatSettings)

return function()
	if FFlagAppChatUseSignalsForChatSettings then
		return useSignalState(GetFriendsChatSettingsStore(false).getGroupChatEnabled)
	end

	return useSelector(function(p)
		return getDeepValue(p, "ChatAppReducer.ChatSettings.groupChatEnabled") or false
	end)
end
