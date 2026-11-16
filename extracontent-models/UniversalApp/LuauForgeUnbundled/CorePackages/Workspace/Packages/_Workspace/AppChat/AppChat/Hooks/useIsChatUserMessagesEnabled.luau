local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState
local getDeepValue2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue2")
local GetFriendsChatSettingsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetFriendsChatSettingsStore")

local FFlagAppChatUseSignalsForChatSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseSignalsForChatSettings")

return function()
	local v5

	if FFlagAppChatUseSignalsForChatSettings then
		v5 = useSignalState(GetFriendsChatSettingsStore(false).getChatUserMessagesEnabled)
	else
		v5 = useSelector(function(p2)
			return getDeepValue2(p2, "ChatAppReducer.ChatSettings.chatUserMessagesEnabled")
		end)
	end

	if v5 == nil then
		return true
	end

	return v5
end
