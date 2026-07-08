local AppChat = script:FindFirstAncestor("AppChat")
local v2 = require(AppChat.Logger):new(script.Name)
local createConversation = require(script.Parent.createConversation)
local getOtherParticipants = require(AppChat.Conversations.getOtherParticipants)

require(AppChat.Models.ConversationChannels)

local FriendConversationCreated = require(AppChat.Conversations.Actions.FriendConversationCreated)

local function createFriendConversation(s1: string, p1) -- line: 9
	-- upvalues: v2 (copy), getOtherParticipants (copy), createConversation (copy), FriendConversationCreated (copy)
	return function(p2) -- line: 10
		-- upvalues: s1 (copy), v2 (copy), getOtherParticipants (copy), createConversation (copy), p1 (copy), FriendConversationCreated (copy)
		local v10 = p2:getState()
		local v11 = v10.ChatAppReducer.Conversations[s1]

		if not v11 then
			v2:error("Could not find friendConversationId {} in store state. Unable to create converstation.", s1)

			return
		end

		local v12 = getOtherParticipants(v11, v10.LocalUserId)

		if #v12 > 1 then
			v2:error("friendConversationId {} has more than 2 participants. Unable to create one-to-one conversation.", s1)

			return
		end

		local str = tostring(v12[1])

		return p2:dispatch(createConversation("one_to_one", { str }, p1, "userSentMessageToFriendPlaceholder")):tap(function(p3) -- line: 41
			-- upvalues: p2 (copy), FriendConversationCreated (copy), s1 (copy)
			p2:dispatch(FriendConversationCreated({
				newConversationId = p3.id,
				oldFriendConversationId = s1
			}))
		end)
	end
end

return createFriendConversation
