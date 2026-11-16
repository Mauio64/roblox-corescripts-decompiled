local ApolloPresence = script:FindFirstAncestor("ApolloPresence")
local parent = ApolloPresence.Parent

local ApolloLocalState = require(parent.ApolloLocalState)
local fragments = ApolloLocalState.fragments

local Cryo = require(parent.Cryo)

local Formatters = require(ApolloPresence.Formatters)

local function createUserPresenceCache(p, p2)
	return (p.cache:writeFragment({
		data = Cryo.Dictionary.join({ __typename = "UserPresence" }, Formatters.formatUserPresence(p2)),
		fragment = fragments.userPresenceAllFields
	}))
end

return createUserPresenceCache
