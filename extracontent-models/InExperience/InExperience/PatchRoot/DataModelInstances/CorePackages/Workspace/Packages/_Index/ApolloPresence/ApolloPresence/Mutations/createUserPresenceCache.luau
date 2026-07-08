local ApolloPresence = script:FindFirstAncestor("ApolloPresence")
local ApolloPresenceParent = ApolloPresence.Parent
local fragments = require(ApolloPresenceParent.ApolloLocalState).fragments
local Cryo = require(ApolloPresenceParent.Cryo)
local Formatters = require(ApolloPresence.Formatters)

local function createUserPresenceCache(p1, p2) -- line: 11
	-- upvalues: Cryo (copy), Formatters (copy), fragments (copy)
	return (p1.cache:writeFragment({
		data = Cryo.Dictionary.join({
			__typename = "UserPresence"
		}, Formatters.formatUserPresence(p2)),
		fragment = fragments.userPresenceAllFields
	}))
end

return createUserPresenceCache
