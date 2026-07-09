local Parent = script:FindFirstAncestor("FriendsChat").Parent
local createSignal = require(Parent.Signals).createSignal

return function() -- line: 11
	-- upvalues: createSignal (copy)
	local v3, v4 = createSignal(nil)

	return {
		getSelectedConversationId = v3,
		setSelectedConversationId = function(s1: string?) -- line: 15
			-- upvalues: v4 (copy)
			v4(s1)
		end
	}
end
