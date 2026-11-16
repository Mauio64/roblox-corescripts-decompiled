local fragments = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloPresence/ApolloLocalState").fragments

local function getUserPresenceByUserId(p2, p3)
	return (p2.cache:readFragment({
		id = p2.cache:identify({ __typename = "UserPresence", id = p3.userId }),
		fragment = fragments.userPresenceAllFields
	}))
end

return getUserPresenceByUserId
