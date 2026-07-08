local Parent = script:FindFirstAncestor("FriendsChat").Parent
local createSignal = require(Parent.Signals).createSignal

return function() -- line: 18
	-- upvalues: createSignal (copy)
	local v3, v4 = createSignal(false)
	local v5, v6 = createSignal(nil)
	local v7, v8 = createSignal(false)

	return {
		getHasEnteredFriendsTab = v3,
		getActiveConversationId = v5,
		getHasLocalUnread = v7,
		markFriendsTabEntered = function() -- line: 30
			-- upvalues: v4 (copy)
			v4(true)
		end,
		setActiveConversationId = function(s1: string?) -- line: 34
			-- upvalues: v6 (copy)
			v6(s1)
		end,
		setHasLocalUnread = function(b1: boolean) -- line: 38
			-- upvalues: v8 (copy)
			v8(b1)
		end
	}
end
