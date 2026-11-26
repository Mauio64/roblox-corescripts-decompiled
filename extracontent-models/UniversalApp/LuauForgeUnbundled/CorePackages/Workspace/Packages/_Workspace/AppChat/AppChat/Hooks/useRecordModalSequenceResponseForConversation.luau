local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useGetOneToOneFriendIdFromConversationId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetOneToOneFriendIdFromConversationId")
local useGetConversationFromId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetConversationFromId")
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")

return function(p2)
	local v5 = useDispatch()
	local v6 = useGetConversationFromId(p2)

	local v7 = useGetOneToOneFriendIdFromConversationId(p2)

	return function(p3, p4, p5, p6)
		if v6 and v6.source == "friends" and v7 then
			return v5(AppChatNetworking.rodux.RecordModalSequenceResponse.API(p3, p4, p5, p6, nil, v7))
		end

		return v5(AppChatNetworking.rodux.RecordModalSequenceResponse.API(p3, p4, p5, p6, p2))
	end
end
