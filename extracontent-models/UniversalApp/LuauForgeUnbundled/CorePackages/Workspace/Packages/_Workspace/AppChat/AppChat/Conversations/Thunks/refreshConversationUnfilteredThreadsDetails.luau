local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("refreshConversationUnfilteredThreadsDetails")
local getDeepValue2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue2")
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local getOtherParticipants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/getOtherParticipants")

local fFlagAppChatConversationTrustedFriendUpsellBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatConversationTrustedFriendUpsellBanner

local v6 = if fFlagAppChatConversationTrustedFriendUpsellBanner then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Sdui/seedConversationTopModalFromRequest") else nil

return function(p2, p3)
	return function(object)
		local state = object:getState()

		local v7 = getDeepValue2(state, `ChatAppReducer.Conversations.{p2}`)

		if not v7 then
			v5:warning(`refreshConversationUnfilteredThreadsDetails: Conversation {p2} not found`)
			return
		end

		local v8 = p2
		local localUserId = state.LocalUserId

		if v7.source == "friends" then
			local v9 = getOtherParticipants(v7, localUserId)

			if #v9 == 1 then
				v8 = v9[1]
			else
				v5:warning(`refreshConversationUnfilteredThreadsDetails: Friends Conversation {p2} has invalid number of participants {#v9}`)

				return
			end
		end

		if v7.source ~= "channels" and v7.source ~= "friends" then
			v5:warning(`refreshConversationUnfilteredThreadsDetails: Conversation {p2} has invalid source {v7.source}`)

			return
		end

		local api = AppChatNetworking.rodux.GetModalSequence.API
		local v9 = {
			modalSequence = AppChatNetworking.Constants.ModalSequence.ConversationTopModal,
			isInExperience = p3,
			conversationId = 0,
			friendId = 0
		}

		local v10 = if v7.source == "channels" then v8 else nil
		v9.conversationId = v10
		local v11 = if v7.source == "friends" then v8 else nil
		v9.friendId = v11
		local v12 = object:dispatch(api(v9))

		if fFlagAppChatConversationTrustedFriendUpsellBanner then
			v12 = v6(v12, p2)
		end

		v12:catch(function(p4)
			v5:warning(`refreshConversationUnfilteredThreadsDetails: Error in GetModalSequence -> conversationTopModal request. Error: {tostring(p4)}`)
		end)

		local api2 = AppChatNetworking.rodux.GetModalSequence.API
		local v13 = {
			modalSequence = AppChatNetworking.Constants.ModalSequence.ConversationOverlay,
			isInExperience = p3,
			conversationId = 0,
			friendId = 0
		}

		local v14 = if v7.source == "channels" then v8 else nil
		v13.conversationId = v14

		if v7.source ~= "friends" then
			v8 = nil
		end

		v13.friendId = v8
		object:dispatch(api2(v13)):catch(function(p4)
			v5:warning(`refreshConversationUnfilteredThreadsDetails: Error in GetModalSequence -> conversationOverlay request. Error: {tostring(p4)}`)
		end)
	end
end
