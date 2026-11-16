local parent = script:FindFirstAncestor("ApolloPresence").Parent

local ApolloLocalState = require(parent.ApolloLocalState)
local fragments = ApolloLocalState.fragments

local function getUserPresenceByUserId(p, p2)
	return (p.cache:readFragment({
		id = p.cache:identify({ __typename = "UserPresence", id = p2.userId }),
		fragment = fragments.userPresenceAllFields
	}))
end

return getUserPresenceByUserId
