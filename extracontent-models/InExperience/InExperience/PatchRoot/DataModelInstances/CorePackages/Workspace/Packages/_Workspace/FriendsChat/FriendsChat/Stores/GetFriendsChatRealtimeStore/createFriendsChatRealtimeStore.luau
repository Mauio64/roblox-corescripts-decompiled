local Parent = script:FindFirstAncestor("FriendsChat").Parent
local createSignal = require(Parent.Signals).createSignal

return function() -- line: 19
	-- upvalues: createSignal (copy)
	local v3, v4 = createSignal(false)
	local v5, v6 = createSignal(nil)
	local v7, v8 = createSignal({})

	return {
		getHasEnteredFriendsTab = v3,
		getActiveConversationId = v5,
		getLocalUnreadConversationIds = v7,
		markFriendsTabEntered = function() -- line: 31
			-- upvalues: v4 (copy)
			v4(true)
		end,
		setActiveConversationId = function(s1: string?) -- line: 35
			-- upvalues: v6 (copy)
			v6(s1)
		end,
		addLocalUnread = function(s2: string) -- line: 39
			-- upvalues: v8 (copy)
			v8(function(p1) -- line: 40
				-- upvalues: s2 (copy)
				if p1[s2] then
					return p1
				end

				local v12 = table.clone(p1)

				v12[s2] = true

				return v12
			end)
		end,
		clearLocalUnread = function() -- line: 50
			-- upvalues: v8 (copy)
			v8(function(p2) -- line: 51
				if next(p2) == nil then
					return p2
				end

				return {}
			end)
		end
	}
end
