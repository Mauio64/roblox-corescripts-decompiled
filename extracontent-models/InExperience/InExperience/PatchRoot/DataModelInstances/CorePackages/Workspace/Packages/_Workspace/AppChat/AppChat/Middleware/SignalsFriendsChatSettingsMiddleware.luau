local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
local FFlagAppChatFriendsTabIxpEnabled = require(AppChat.Flags.FFlagAppChatFriendsTabIxpEnabled)
local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local FFlagAppChatUseSignalsForChatSettings = require(AppChat.Flags.FFlagAppChatUseSignalsForChatSettings)

local ThirdPartyChatSettingsLoaded = require(AppChat.Actions.ThirdPartyChatSettingsLoaded)
local GetFriendsChatMetadataStore = require(AppChat.Stores.GetFriendsChatMetadataStore)
local GetFriendsChatSettingsStore = require(AppChat.Stores.GetFriendsChatSettingsStore)

local function handleGetMetadataSucceeded(p)
	GetFriendsChatMetadataStore(false).updateFriendsChatMetadata(p.responseBody)
end

local function handleThirdPartyChatSettingsLoaded(p)
	GetFriendsChatSettingsStore(false).setThirdPartyChatRestrictionStatus(p.status)
end

local v = {
	[AppChatNetworking.rodux.GetMetadata.Succeeded.name] = handleGetMetadataSucceeded,
	[ThirdPartyChatSettingsLoaded.name] = handleThirdPartyChatSettingsLoaded
}

local function SignalsFriendsChatSettingsMiddleware(callback, _)
	return function(p)
		local v2 = callback(p)

		if
			not (FFlagAppChatFriendsTabIxpEnabled or FFlagExpChatEnableFriendsTab)
			or FFlagAppChatUseSignalsForChatSettings
		then
			return v2
		end

		local v3 = v[p.type]

		if v3 then
			v3(p)
		end

		return v2
	end
end

return SignalsFriendsChatSettingsMiddleware
