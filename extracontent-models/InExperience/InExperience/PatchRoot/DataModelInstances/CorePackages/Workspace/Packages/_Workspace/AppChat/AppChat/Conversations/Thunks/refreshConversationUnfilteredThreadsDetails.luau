local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local AppChatNetworking = require(parent.AppChatNetworking)
require(AppChat.Models.ConversationChannels)
local getOtherParticipants = require(AppChat.Conversations.getOtherParticipants)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatConversationTrustedFriendUpsellBanner = SharedFlags.FFlagAppChatConversationTrustedFriendUpsellBanner
local seedConversationTopModalFromRequest

if FFlagAppChatConversationTrustedFriendUpsellBanner then
	seedConversationTopModalFromRequest = require(AppChat.Sdui.seedConversationTopModalFromRequest)
else
	seedConversationTopModalFromRequest = nil
end

return function(p: string, isInExperience: boolean?)
	return function(object)
		local state = object:getState()

		local deepValue2 = getDeepValue2(state, `ChatAppReducer.Conversations.{p}`)

		if not deepValue2 then
			v:warning(`refreshConversationUnfilteredThreadsDetails: Conversation {p} not found`)
			return
		end

		local friendId = p
		local localUserId = state.LocalUserId

		if deepValue2.source == "friends" then
			local otherParticipants = getOtherParticipants(deepValue2, localUserId)

			if #otherParticipants == 1 then
				friendId = otherParticipants[1]
			else
				v:warning(`refreshConversationUnfilteredThreadsDetails: Friends Conversation {p} has invalid number of participants {#otherParticipants}`)

				return
			end
		end

		if deepValue2.source ~= "channels" and deepValue2.source ~= "friends" then
			v:warning(`refreshConversationUnfilteredThreadsDetails: Conversation {p} has invalid source {deepValue2.source}`)

			return
		end

		local api = AppChatNetworking.rodux.GetModalSequence.API
		local v2 = {
			modalSequence = AppChatNetworking.Constants.ModalSequence.ConversationTopModal,
			isInExperience = isInExperience,
			conversationId = 0,
			friendId = 0
		}
		local conversationId

		if deepValue2.source == "channels" then
			conversationId = friendId
		end

		v2.conversationId = conversationId
		local friendId2

		if deepValue2.source == "friends" then
			friendId2 = friendId
		end

		v2.friendId = friendId2
		local v3 = object:dispatch(api(v2))

		if FFlagAppChatConversationTrustedFriendUpsellBanner then
			v3 = seedConversationTopModalFromRequest(v3, p)
		end

		v3:catch(function(p2)
			v:warning(`refreshConversationUnfilteredThreadsDetails: Error in GetModalSequence -> conversationTopModal request. Error: {tostring(p2)}`)
		end)

		local api2 = AppChatNetworking.rodux.GetModalSequence.API
		local v4 = {
			modalSequence = AppChatNetworking.Constants.ModalSequence.ConversationOverlay,
			isInExperience = isInExperience,
			conversationId = 0,
			friendId = 0
		}
		local conversationId2

		if deepValue2.source == "channels" then
			conversationId2 = friendId
		end

		v4.conversationId = conversationId2

		if deepValue2.source ~= "friends" then
			friendId = nil
		end

		v4.friendId = friendId
		object:dispatch(api2(v4)):catch(function(p2)
			v:warning(`refreshConversationUnfilteredThreadsDetails: Error in GetModalSequence -> conversationOverlay request. Error: {tostring(p2)}`)
		end)
	end
end
