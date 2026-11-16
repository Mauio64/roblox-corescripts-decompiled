local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local SignalsExperimental = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsExperimental")
local getOtherParticipants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getOtherParticipants")
local GetConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local GetConversationSearchDataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationSearchDataHydration")
local FFlagAppChatAnyServerSideConversationSearch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatAnyServerSideConversationSearch")

return function(p2, p3)
	local v5 = getOtherParticipants(p2, p3)

	if #v5 ~= 1 then
		return nil
	end

	local v6 = v5[1]

	local v7 = GetConversationStore(false)
	return AppChatNetworking.http.CreateConversation(nil, "one_to_one", { v6 }):andThen(function(p4)
		local responseBody = p4 and p4.responseBody
		local v8 = responseBody and responseBody.conversations and responseBody.conversations[1]

		if v8 == nil or v8.status == "failed" then
			return nil
		end

		local v9 = ConversationChannels.fromChannelsApi(v8)
		SignalsExperimental.batch(function()
			v7.upsertConversation(v9, false)
			v7.removeConversation(p2.id)
		end)

		if FFlagAppChatAnyServerSideConversationSearch then
			GetConversationSearchDataHydration(false).invalidate()
		end

		return v9
	end)
end
