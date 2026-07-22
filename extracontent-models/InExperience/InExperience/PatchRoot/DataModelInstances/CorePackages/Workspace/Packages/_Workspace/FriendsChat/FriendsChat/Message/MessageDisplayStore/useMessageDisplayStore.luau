local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)

require(Parent.Signals)

local createMessageDisplayStore = require(script.Parent.createMessageDisplayStore)

local function useMessageDisplayStore(p1, s1: string?, p2) -- line: 21
	-- upvalues: React (copy), createMessageDisplayStore (copy)
	return React.useMemo(function() -- line: 26
		-- upvalues: createMessageDisplayStore (copy), p1 (copy), s1 (copy), p2 (copy)
		return createMessageDisplayStore(p1, s1, p2)
	end, {
		p1,
		s1,
		p2
	})
end

return useMessageDisplayStore
