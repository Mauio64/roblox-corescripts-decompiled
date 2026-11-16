local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local SignalsMiddleware = require(parent.SignalsMiddleware)
local ActionHandlers = SignalsMiddleware.ActionHandlers

local FFlagAppChatUseSignalsForLastEntryPoint = require(AppChat.Flags.FFlagAppChatUseSignalsForLastEntryPoint)

local FFlagAppChatUseSignalsForExternalNavigationRequest = require(AppChat.Flags.FFlagAppChatUseSignalsForExternalNavigationRequest)
local FFlagAppChatUseSignalsForChatSettings = require(AppChat.Flags.FFlagAppChatUseSignalsForChatSettings)

return function(p)
	if FFlagAppChatUseSignalsForLastEntryPoint then
		ActionHandlers.register(p, "EnteredChatFromEntryPoint", function(p2): boolean
			local GetLastEntryPointStore = require(AppChat.Stores.GetLastEntryPointStore)
			GetLastEntryPointStore(false).enteredChatFromEntryPoint(p2.entryPoint)
			return false
		end)
	end

	if FFlagAppChatUseSignalsForExternalNavigationRequest then
		ActionHandlers.register(p, "NavigateIntoChat", function(p2): boolean
			local GetExternalNavigationRequestStore = require(AppChat.Stores.GetExternalNavigationRequestStore)
			GetExternalNavigationRequestStore(false).navigateIntoChat(p2.screen, p2.params)
			return false
		end)
	end

	if FFlagAppChatUseSignalsForChatSettings then
		ActionHandlers.register(p, "GetMetadata_Succeeded", function(p2): boolean
			local GetFriendsChatMetadataStore = require(AppChat.Stores.GetFriendsChatMetadataStore)
			local GetFriendsChatSettingsStore = require(AppChat.Stores.GetFriendsChatSettingsStore)
			GetFriendsChatMetadataStore(false).updateFriendsChatMetadata(p2.responseBody)
			GetFriendsChatSettingsStore(false).clearDebugGroupChatToggle()
			return false
		end)

		ActionHandlers.register(p, "ThirdPartyChatSettingsLoaded", function(p2): boolean
			local GetFriendsChatSettingsStore = require(AppChat.Stores.GetFriendsChatSettingsStore)
			GetFriendsChatSettingsStore(false).setThirdPartyChatRestrictionStatus(p2.status)
			return false
		end)

		ActionHandlers.register(p, "Debug_GroupChatEnabledToggled", function(_): boolean
			local GetFriendsChatSettingsStore = require(AppChat.Stores.GetFriendsChatSettingsStore)
			GetFriendsChatSettingsStore(false).toggleDebugGroupChatEnabled()
			return false
		end)
	end
end
