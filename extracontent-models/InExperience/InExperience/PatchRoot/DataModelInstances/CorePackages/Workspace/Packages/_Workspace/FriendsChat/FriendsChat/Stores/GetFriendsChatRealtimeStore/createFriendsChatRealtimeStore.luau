local FriendsChat = script:FindFirstAncestor("FriendsChat")
local FriendsChatParent = FriendsChat.Parent
local createSignal = require(FriendsChatParent.Signals).createSignal
local FFlagFriendsChatTabUnreadBadgeFix = require(FriendsChat.Flags.FFlagFriendsChatTabUnreadBadgeFix)

return function() -- line: 23
	-- upvalues: createSignal (copy), FFlagFriendsChatTabUnreadBadgeFix (copy)
	local v5, v6 = createSignal(false)
	local v7, v8 = createSignal(nil)
	local v9, v10 = createSignal(false)
	local v11, v12 = createSignal({})

	return {
		getHasEnteredFriendsTab = v5,
		getActiveConversationId = v7,
		getHasLocalUnread = v9,
		getLocalUnreadConversationIds = v11,
		markFriendsTabEntered = function() -- line: 36
			-- upvalues: v6 (copy)
			v6(true)
		end,
		setActiveConversationId = function(s1: string?) -- line: 40
			-- upvalues: v8 (copy)
			v8(s1)
		end,
		setHasLocalUnread = function(b1: boolean) -- line: 44
			-- upvalues: FFlagFriendsChatTabUnreadBadgeFix (copy), v10 (copy)
			if not FFlagFriendsChatTabUnreadBadgeFix then
				v10(b1)
			end
		end,
		addLocalUnread = function(s2: string) -- line: 50
			-- upvalues: FFlagFriendsChatTabUnreadBadgeFix (copy), v12 (copy)
			if FFlagFriendsChatTabUnreadBadgeFix then
				v12(function(p1) -- line: 52
					-- upvalues: s2 (copy)
					if p1[s2] then
						return p1
					end

					local v17 = table.clone(p1)

					v17[s2] = true

					return v17
				end)
			end
		end,
		clearLocalUnread = function() -- line: 63
			-- upvalues: FFlagFriendsChatTabUnreadBadgeFix (copy), v12 (copy)
			if FFlagFriendsChatTabUnreadBadgeFix then
				v12(function(p2) -- line: 65
					if next(p2) == nil then
						return p2
					end

					return {}
				end)
			end
		end
	}
end
