local AppChat = script:FindFirstAncestor("AppChat")
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)
local createConversation = require(script.Parent.createConversation)
local getOtherParticipants = require(AppChat.Conversations.getOtherParticipants)
require(AppChat.Models.ConversationChannels)
local FriendConversationCreated = require(AppChat.Conversations.Actions.FriendConversationCreated)

local function createFriendConversation(oldFriendConversationId: string, p)
	return function(object)
		local state = object:getState()

		local conversation = state.ChatAppReducer.Conversations[oldFriendConversationId]

		if not conversation then
			v:error(
				"Could not find friendConversationId {} in store state. Unable to create converstation.",
				oldFriendConversationId
			)

			return
		end

		local otherParticipants = getOtherParticipants(conversation, state.LocalUserId)

		if #otherParticipants > 1 then
			v:error(
				"friendConversationId {} has more than 2 participants. Unable to create one-to-one conversation.",
				oldFriendConversationId
			)
		else
			return object:dispatch(createConversation(
				"one_to_one",
				{ (tostring(otherParticipants[1])) },
				p,
				"userSentMessageToFriendPlaceholder"
			)):tap(function(p2)
				object:dispatch(FriendConversationCreated({
					newConversationId = p2.id,
					oldFriendConversationId = oldFriendConversationId
				}))
			end)
		end
	end
end

return createFriendConversation
