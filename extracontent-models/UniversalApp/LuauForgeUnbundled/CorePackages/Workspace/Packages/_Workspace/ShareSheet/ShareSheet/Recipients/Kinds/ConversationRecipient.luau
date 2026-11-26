local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

local ConversationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Utils/ConversationUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/GetConversationListStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Kinds/RecipientKind")
local useExternalChatConversationEligibility = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/useExternalChatConversationEligibility")

return {
	create = function(p2)
		return { kind = "conversation", id = p2.id, conversation = p2 }
	end,
	kind = {
		useEligibility = function(data)
			local v6 = useExternalChatConversationEligibility({
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

				for k, eligibleConversation in v6.eligibleConversations do
					eligibleConversationSet[eligibleConversation] = true
				end

				return {
					isLoading = v6.isLoading,
					isEligible = function(p2): boolean
						return eligibleConversationSet[p2.conversation] == true
					end
				}
			end, { v6 })
		end,
		canSend = function(p2, p3)
			return p2.canSendToConversation(p3.conversation)
		end,
		send = function(p2, p3, p4)
			return p2.sendToConversation(p3.conversation, p4)
		end,
		getName = function(p2)
			return ConversationUtils.getDisplayName(p2.conversation)
		end,
		getParticipantIds = function(p2, p3)
			local participantIds = {}

			for k, v5 in p2.conversation.participants or {} do
				if v5 ~= p3 then
					table.insert(participantIds, v5)
				end
			end

			return participantIds
		end
	}
}
