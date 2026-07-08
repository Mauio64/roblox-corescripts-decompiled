local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local v3 = require(AppChat.Logger):new(script.Name)
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)

require(AppChat.Models.ConversationChannels)

local getOtherParticipants = require(AppChat.Conversations.getOtherParticipants)

return function(s1: string, b1: boolean?) -- line: 15
	-- upvalues: getDeepValue2 (copy), v3 (copy), getOtherParticipants (copy), AppChatNetworking (copy)
	return function(p1) -- line: 16
		-- upvalues: getDeepValue2 (copy), s1 (copy), v3 (copy), getOtherParticipants (copy), AppChatNetworking (copy), b1 (copy)
		local v10 = p1:getState()
		local v11 = getDeepValue2(v10, `ChatAppReducer.Conversations.{ s1 }`)

		if not v11 then
			v3:warning(`refreshConversationUnfilteredThreadsDetails: Conversation { s1 } not found`)

			return
		end

		local v12 = s1
		local LocalUserId = v10.LocalUserId

		if v11.source == "friends" then
			local v14 = getOtherParticipants(v11, LocalUserId)

			if #v14 ~= 1 then
				v3:warning(`refreshConversationUnfilteredThreadsDetails: Friends Conversation { s1 } has invalid number of participants { #v14 }`)

				return
			end

			v12 = v14[1]
		end

		if v11.source == "channels" or v11.source == "friends" then
			p1:dispatch(AppChatNetworking.rodux.GetModalSequence.API({
				modalSequence = AppChatNetworking.Constants.ModalSequence.ConversationTopModal,
				isInExperience = b1,
				conversationId = if v11.source ~= "channels" then nil else v12,
				friendId = if v11.source ~= "friends" then nil else v12
			})):catch(function(p2) -- line: 45
				-- upvalues: v3 (copy)
				v3:warning(`refreshConversationUnfilteredThreadsDetails: Error in GetModalSequence -> conversationTopModal request. Error: { tostring(p2) }`)
			end)
			p1:dispatch(AppChatNetworking.rodux.GetModalSequence.API({
				modalSequence = AppChatNetworking.Constants.ModalSequence.ConversationOverlay,
				isInExperience = b1,
				conversationId = if v11.source ~= "channels" then nil else v12,
				friendId = if v11.source ~= "friends" then nil else v12
			})):catch(function(p3) -- line: 59
				-- upvalues: v3 (copy)
				v3:warning(`refreshConversationUnfilteredThreadsDetails: Error in GetModalSequence -> conversationOverlay request. Error: { tostring(p3) }`)
			end)

			return
		end

		v3:warning(`refreshConversationUnfilteredThreadsDetails: Conversation { s1 } has invalid source { v11.source }`)
	end
end
