local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local SharedFlags = require(AppChatParent.SharedFlags)
local Signals = require(AppChatParent.Signals)
local GetFriendsChatMetadataStore = require(AppChat.Stores.GetFriendsChatMetadataStore)
local v6 = require(AppChat.Logger):new(script.Name)

local function createFriendsChatSettingsStore() -- line: 19
	-- upvalues: GetFriendsChatMetadataStore (copy), Signals (copy), SharedFlags (copy), v6 (copy)
	local v8 = GetFriendsChatMetadataStore(false)
	local v9, v10 = Signals.createSignal(Enum.ChatRestrictionStatus.Unknown)
	local v11 = Signals.createComputed(function(p1) -- line: 24
		-- upvalues: v8 (copy), v9 (copy)
		local v16 = v8.getCachedFriendsChatMetadata(p1).data(p1)
		local v17 = v9(p1)

		return v16 ~= nil and (v17 ~= Enum.ChatRestrictionStatus.Unknown and (v16.isChatEnabled and v17 == Enum.ChatRestrictionStatus.NotRestricted))
	end)
	local v12 = Signals.createComputed(function(p2) -- line: 33
		-- upvalues: v8 (copy)
		local v19 = v8.getCachedFriendsChatMetadata(p2).data(p2)

		return v19 ~= nil and (v19.isChatEnabled and v19.isGroupChatEnabledByPrivacySetting == "enabled")
	end)
	local v13 = Signals.createComputed(function(p3) -- line: 38
		-- upvalues: v8 (copy)
		local v21 = v8.getCachedFriendsChatMetadata(p3).data(p3)

		if v21 then
			return v21.isChatUserMessagesEnabled
		end

		return nil
	end)
	local v14 = not SharedFlags.FFlagDebugFriendsChat and function() -- line: 55
	end or Signals.createEffect(function(p4) -- line: 44
		-- upvalues: v8 (copy), v6 (copy), v11 (copy), v9 (copy), v13 (copy)
		local v23 = v8.getCachedFriendsChatMetadata(p4).data(p4)

		v6:debug(`Friends Chat eligibility: chatEnabled={ tostring(v11(p4)) }` .. ` (accountChatEnabled={ tostring((if not v23 then nil else v23.isChatEnabled)) },` .. ` privacySetting={ tostring((if not v23 then nil else v23.isChatEnabledByPrivacySetting)) },` .. ` globalRules={ tostring((if not v23 then nil else v23.isChatEnabledByGlobalRules)) },` .. ` thirdPartyStatus={ tostring(v9(p4)) });` .. ` chatUserMessagesEnabled={ tostring(v13(p4)) }`)
	end)

	return {
		getThirdPartyChatRestrictionStatus = v9,
		getChatEnabled = v11,
		getGroupChatEnabled = v12,
		getChatUserMessagesEnabled = v13,
		setThirdPartyChatRestrictionStatus = v10,
		dispose = v14
	}
end

return createFriendsChatSettingsStore
