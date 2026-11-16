local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local GetFriendsChatSettingsStore = require(AppChat.Stores.GetFriendsChatSettingsStore)

local FFlagAppChatUseSignalsForChatSettings = require(AppChat.Flags.FFlagAppChatUseSignalsForChatSettings)

return function()
	local selected

	if FFlagAppChatUseSignalsForChatSettings then
		selected = useSignalState(GetFriendsChatSettingsStore(false).getChatUserMessagesEnabled)
	else
		selected = useSelector(function(p)
			return getDeepValue2(p, "ChatAppReducer.ChatSettings.chatUserMessagesEnabled")
		end)
	end

	return selected == nil or selected
end
