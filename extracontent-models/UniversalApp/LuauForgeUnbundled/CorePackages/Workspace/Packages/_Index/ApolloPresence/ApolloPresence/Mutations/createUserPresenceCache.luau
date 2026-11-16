local fragments = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloPresence/ApolloLocalState").fragments

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloPresence/Cryo")

local Formatters = require("@game/CorePackages/Workspace/Packages/_Index/ApolloPresence/ApolloPresence/Formatters")

local function createUserPresenceCache(p2, p3)
	return (p2.cache:writeFragment({
		data = Cryo.Dictionary.join({ __typename = "UserPresence" }, Formatters.formatUserPresence(p3)),
		fragment = fragments.userPresenceAllFields
	}))
end

return createUserPresenceCache
