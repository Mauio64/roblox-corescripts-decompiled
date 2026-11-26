local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useLocalUserId
local useGetConversationFromId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetConversationFromId")
local getOtherParticipants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getOtherParticipants")

return function(p2)
	local v5 = useLocalUserId()
	local v6 = useGetConversationFromId(p2)

	if not (p2 and v5 and v6 and v6.type == "one_to_one") then
		return nil
	end

	local v7 = getOtherParticipants(v6, v5)

	if #v7 == 1 then
		return v7[1]
	end

	return nil
end
