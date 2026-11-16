local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local React = require(parent.React)

local ConversationUtils = require(ShareSheet.Utils.ConversationUtils)
require(parent.AppChat.GetConversationListStore)
require(script.Parent.RecipientKind)
local useExternalChatConversationEligibility = require(parent.AppChat.useExternalChatConversationEligibility)

return {
	create = function(conversation)
		return { kind = "conversation", id = conversation.id, conversation = conversation }
	end,
	kind = {
		useEligibility = function(data)
			local v = useExternalChatConversationEligibility({
				conversations = React.useMemo(function()
					local conversations = table.create(#data.recipients)

					for k, recipient in data.recipients do
						conversations[k] = recipient.conversation
					end

					return conversations
				end, { data.recipients }),
				isActive = data.isActive,
				isGroupChatEnabled = data.isGroupChatEnabled,
				maxConversationCount = data.maxCount
			})

			return React.useMemo(function()
				local eligibleConversationSet = {}

				for _, eligibleConversation in v.eligibleConversations do
					eligibleConversationSet[eligibleConversation] = true
				end

				return {
					isLoading = v.isLoading,
					isEligible = function(p): boolean
						return eligibleConversationSet[p.conversation] == true
					end
				}
			end, { v })
		end,
		canSend = function(p, p2)
			return p.canSendToConversation(p2.conversation)
		end,
		send = function(p, p2, p3)
			return p.sendToConversation(p2.conversation, p3)
		end,
		getName = function(p)
			return ConversationUtils.getDisplayName(p.conversation)
		end,
		getParticipantIds = function(p, p2)
			local participantIds = {}

			for _, v in p.conversation.participants or {} do
				if v ~= p2 then
					table.insert(participantIds, v)
				end
			end

			return participantIds
		end
	}
}
