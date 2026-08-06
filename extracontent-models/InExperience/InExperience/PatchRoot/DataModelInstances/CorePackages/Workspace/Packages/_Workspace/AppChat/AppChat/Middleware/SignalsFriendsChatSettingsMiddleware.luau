local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local FFlagAppChatFriendsTabIxpEnabled = require(AppChat.Flags.FFlagAppChatFriendsTabIxpEnabled)
local FFlagExpChatEnableFriendsTab = require(AppChatParent.SharedFlags).FFlagExpChatEnableFriendsTab
local ThirdPartyChatSettingsLoaded = require(AppChat.Actions.ThirdPartyChatSettingsLoaded)
local GetFriendsChatMetadataStore = require(AppChat.Stores.GetFriendsChatMetadataStore)
local GetFriendsChatSettingsStore = require(AppChat.Stores.GetFriendsChatSettingsStore)

local function handleGetMetadataSucceeded(p1) -- line: 12
	-- upvalues: GetFriendsChatMetadataStore (copy)
	GetFriendsChatMetadataStore(false).updateFriendsChatMetadata(p1.responseBody)
end
local function handleThirdPartyChatSettingsLoaded(p2) -- line: 16
	-- upvalues: GetFriendsChatSettingsStore (copy)
	GetFriendsChatSettingsStore(false).setThirdPartyChatRestrictionStatus(p2.status)
end

local t1 = {
	[AppChatNetworking.rodux.GetMetadata.Succeeded.name] = handleGetMetadataSucceeded,
	[ThirdPartyChatSettingsLoaded.name] = handleThirdPartyChatSettingsLoaded
}

local function SignalsFriendsChatSettingsMiddleware(p3: ((...any) -> ...any), _) -- line: 25
	-- upvalues: FFlagAppChatFriendsTabIxpEnabled (copy), FFlagExpChatEnableFriendsTab (copy), t1 (copy)
	return function(p5) -- line: 26
		-- upvalues: p3 (copy), FFlagAppChatFriendsTabIxpEnabled (copy), FFlagExpChatEnableFriendsTab (copy), t1 (copy)
		local v18 = p3(p5)

		if not FFlagAppChatFriendsTabIxpEnabled and not FFlagExpChatEnableFriendsTab then
			return v18
		end

		local v19 = t1[p5.type]

		if v19 then
			v19(p5)
		end

		return v18
	end
end

return SignalsFriendsChatSettingsMiddleware
