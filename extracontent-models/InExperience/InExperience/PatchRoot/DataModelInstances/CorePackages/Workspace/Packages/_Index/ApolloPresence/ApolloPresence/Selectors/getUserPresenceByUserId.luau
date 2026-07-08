local Parent = script:FindFirstAncestor("ApolloPresence").Parent
local fragments = require(Parent.ApolloLocalState).fragments

local function getUserPresenceByUserId(p1, p2) -- line: 11
	-- upvalues: fragments (copy)
	return (p1.cache:readFragment({
		id = p1.cache:identify({
			__typename = "UserPresence",
			id = p2.userId
		}),
		fragment = fragments.userPresenceAllFields
	}))
end

return getUserPresenceByUserId
