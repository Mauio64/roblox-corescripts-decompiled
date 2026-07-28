local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local FFlagExpChatEnableFriendsTab = require(AppChatParent.SharedFlags).FFlagExpChatEnableFriendsTab
local ThirdPartyChatSettingsLoaded = require(AppChat.Actions.ThirdPartyChatSettingsLoaded)
local GetFriendsChatMetadataStore = require(AppChat.Stores.GetFriendsChatMetadataStore)
local GetFriendsChatSettingsStore = require(AppChat.Stores.GetFriendsChatSettingsStore)

local function handleGetMetadataSucceeded(p1) -- line: 11
	-- upvalues: GetFriendsChatMetadataStore (copy)
	GetFriendsChatMetadataStore(false).updateFriendsChatMetadata(p1.responseBody)
end
local function handleThirdPartyChatSettingsLoaded(p2) -- line: 15
	-- upvalues: GetFriendsChatSettingsStore (copy)
	GetFriendsChatSettingsStore(false).setThirdPartyChatRestrictionStatus(p2.status)
end

local t1 = {
	[AppChatNetworking.rodux.GetMetadata.Succeeded.name] = handleGetMetadataSucceeded,
	[ThirdPartyChatSettingsLoaded.name] = handleThirdPartyChatSettingsLoaded
}

local function SignalsFriendsChatSettingsMiddleware(p3: ((...any) -> ...any), _) -- line: 24
	-- upvalues: FFlagExpChatEnableFriendsTab (copy), t1 (copy)
	return function(p5) -- line: 25
		-- upvalues: p3 (copy), FFlagExpChatEnableFriendsTab (copy), t1 (copy)
		local v17 = p3(p5)

		if not FFlagExpChatEnableFriendsTab then
			return v17
		end

		local v18 = t1[p5.type]

		if v18 then
			v18(p5)
		end

		return v17
	end
end

return SignalsFriendsChatSettingsMiddleware
