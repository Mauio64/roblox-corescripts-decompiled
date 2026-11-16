local ApolloPresence = script:FindFirstAncestor("ApolloPresence")
local parent = ApolloPresence.Parent

local ApolloLocalState = require(parent.ApolloLocalState)
local fragments = ApolloLocalState.fragments

local Formatters = require(ApolloPresence.Formatters)

local function updateUserPresenceCache(p, p2)
	return (p.cache:writeFragment({
		id = p.cache:identify({ __typename = "UserPresence", id = p2.id }),
		fragment = fragments.userPresenceAllFields,
		data = Formatters.formatUserPresence(p2)
	}))
end

return updateUserPresenceCache
