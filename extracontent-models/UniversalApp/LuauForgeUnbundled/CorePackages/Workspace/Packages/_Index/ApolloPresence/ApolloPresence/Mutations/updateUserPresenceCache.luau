local fragments = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloPresence/ApolloLocalState").fragments

local Formatters = require("@game/CorePackages/Workspace/Packages/_Index/ApolloPresence/ApolloPresence/Formatters")

local function updateUserPresenceCache(p2, p3)
	return (p2.cache:writeFragment({
		id = p2.cache:identify({ __typename = "UserPresence", id = p3.id }),
		fragment = fragments.userPresenceAllFields,
		data = Formatters.formatUserPresence(p3)
	}))
end

return updateUserPresenceCache
