local actionHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsMiddleware").ActionHandlers

local FFlagAppChatUseSignalsForLastEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseSignalsForLastEntryPoint")

local FFlagAppChatUseSignalsForExternalNavigationRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseSignalsForExternalNavigationRequest")
local FFlagAppChatUseSignalsForChatSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseSignalsForChatSettings")

return function(p2)
	if FFlagAppChatUseSignalsForLastEntryPoint then
		actionHandlers.register(p2, "EnteredChatFromEntryPoint", function(p3): boolean
			require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetLastEntryPointStore")(false).enteredChatFromEntryPoint(p3.entryPoint)
			return false
		end)
	end

	if FFlagAppChatUseSignalsForExternalNavigationRequest then
		actionHandlers.register(p2, "NavigateIntoChat", function(p3): boolean
			require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetExternalNavigationRequestStore")(false).navigateIntoChat(p3.screen, p3.params)
			return false
		end)
	end

	if FFlagAppChatUseSignalsForChatSettings then
		actionHandlers.register(p2, "GetMetadata_Succeeded", function(p3): boolean
			local GetFriendsChatMetadataStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetFriendsChatMetadataStore")
			local GetFriendsChatSettingsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetFriendsChatSettingsStore")
			GetFriendsChatMetadataStore(false).updateFriendsChatMetadata(p3.responseBody)
			GetFriendsChatSettingsStore(false).clearDebugGroupChatToggle()
			return false
		end)

		actionHandlers.register(p2, "ThirdPartyChatSettingsLoaded", function(p3): boolean
			require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetFriendsChatSettingsStore")(false).setThirdPartyChatRestrictionStatus(p3.status)
			return false
		end)

		actionHandlers.register(p2, "Debug_GroupChatEnabledToggled", function(p3): boolean
			require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetFriendsChatSettingsStore")(false).toggleDebugGroupChatEnabled()
			return false
		end)
	end
end
