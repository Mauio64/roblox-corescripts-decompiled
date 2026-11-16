local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
require(parent.Signals)

local createMessageDisplayStore = require(script.Parent.createMessageDisplayStore)

local function useMessageDisplayStore(p, p2: string?)
	return React.useMemo(function()
		return createMessageDisplayStore(p, p2)
	end, { p, p2 })
end

return useMessageDisplayStore
