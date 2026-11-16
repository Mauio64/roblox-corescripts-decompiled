local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local FFlagAppChatFriendsTabIxpEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatFriendsTabIxpEnabled")
local fFlagExpChatEnableFriendsTab = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagExpChatEnableFriendsTab
local FFlagAppChatUseSignalsForChatSettings = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseSignalsForChatSettings")

local ThirdPartyChatSettingsLoaded = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/ThirdPartyChatSettingsLoaded")
local GetFriendsChatMetadataStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetFriendsChatMetadataStore")
local GetFriendsChatSettingsStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetFriendsChatSettingsStore")

local function handleGetMetadataSucceeded(p2)
	GetFriendsChatMetadataStore(false).updateFriendsChatMetadata(p2.responseBody)
end

local function handleThirdPartyChatSettingsLoaded(p2)
	GetFriendsChatSettingsStore(false).setThirdPartyChatRestrictionStatus(p2.status)
end

local v5 = {
	[AppChatNetworking.rodux.GetMetadata.Succeeded.name] = handleGetMetadataSucceeded,
	[ThirdPartyChatSettingsLoaded.name] = handleThirdPartyChatSettingsLoaded
}

local function SignalsFriendsChatSettingsMiddleware(callback, p2)
	return function(p3)
		local v6 = callback(p3)

		if not (FFlagAppChatFriendsTabIxpEnabled or fFlagExpChatEnableFriendsTab) or FFlagAppChatUseSignalsForChatSettings then
			return v6
		end

		local v7 = v5[p3.type]

		if v7 then
			v7(p3)
		end

		return v6
	end
end

return SignalsFriendsChatSettingsMiddleware
