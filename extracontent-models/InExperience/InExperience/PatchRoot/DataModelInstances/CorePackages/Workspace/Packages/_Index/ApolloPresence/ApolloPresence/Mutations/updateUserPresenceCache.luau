local ApolloPresence = script:FindFirstAncestor("ApolloPresence")
local ApolloPresenceParent = ApolloPresence.Parent
local fragments = require(ApolloPresenceParent.ApolloLocalState).fragments
local Formatters = require(ApolloPresence.Formatters)

local function updateUserPresenceCache(p1, p2) -- line: 9
	-- upvalues: fragments (copy), Formatters (copy)
	return (p1.cache:writeFragment({
		id = p1.cache:identify({
			__typename = "UserPresence",
			id = p2.id
		}),
		fragment = fragments.userPresenceAllFields,
		data = Formatters.formatUserPresence(p2)
	}))
end

return updateUserPresenceCache
