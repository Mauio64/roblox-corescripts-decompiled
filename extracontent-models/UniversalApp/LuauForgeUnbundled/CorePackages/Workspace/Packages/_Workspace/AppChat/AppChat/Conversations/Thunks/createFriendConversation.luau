local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("createFriendConversation")
local createConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/createConversation")
local getOtherParticipants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getOtherParticipants")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local FriendConversationCreated = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/FriendConversationCreated")

local function createFriendConversation(p2, p3)
	return function(object)
		local state = object:getState()

		local conversation = state.ChatAppReducer.Conversations[p2]

		if not conversation then
			v5:error(
				"Could not find friendConversationId {} in store state. Unable to create converstation.",
				p2
			)

			return
		end

		local v6 = getOtherParticipants(conversation, state.LocalUserId)

		if #v6 > 1 then
			v5:error(
				"friendConversationId {} has more than 2 participants. Unable to create one-to-one conversation.",
				p2
			)
		else
			return object:dispatch(createConversation(
				"one_to_one",
				{ (tostring(v6[1])) },
				p3,
				"userSentMessageToFriendPlaceholder"
			)):tap(function(p4)
				object:dispatch(FriendConversationCreated({
					newConversationId = p4.id,
					oldFriendConversationId = p2
				}))
			end)
		end
	end
end

return createFriendConversation
