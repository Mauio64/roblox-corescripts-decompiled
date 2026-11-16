local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState
local getDeepValue = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue")
local GetFriendsChatSettingsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetFriendsChatSettingsStore")

local FFlagAppChatUseSignalsForChatSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseSignalsForChatSettings")

return function(p2)
	if not FFlagAppChatUseSignalsForChatSettings then
		return useSelector(function(p3)
			return getDeepValue(p3, `ChatAppReducer.ChatSettings.{p2}`) or false
		end)
	end

	local v5 = GetFriendsChatSettingsStore(false)
	local v7

	if p2 == "globalRulesEnabled" then
		v7 = v5.getGlobalRulesEnabled
	elseif p2 == "privacySettingsEnabled" then
		v7 = v5.getPrivacySettingsEnabled
	else
		v7 = v5.getThirdPartyPrivacySettingsEnabled
	end

	return useSignalState(v7)
end
