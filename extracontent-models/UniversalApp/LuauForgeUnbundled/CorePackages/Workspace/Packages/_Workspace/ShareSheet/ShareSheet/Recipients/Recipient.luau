local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

local ConversationRecipient = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Kinds/ConversationRecipient")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/GetExternalChatMessageSenderStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/LuauPolyfill")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Kinds/RecipientKind")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Signals")
local UserRecipient = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Kinds/UserRecipient")

local frozen = table.freeze({ conversation = ConversationRecipient.kind, user = UserRecipient.kind })

local frozen2 = table.freeze({})

local function getKind(p2)
	return frozen[p2.kind]
end

return {
	canSend = function(p2, p3)
		return frozen[p3.kind].canSend(p2, p3)
	end,
	fromConversation = ConversationRecipient.create,
	fromUserId = UserRecipient.create,
	getName = function(p2, p3)
		return frozen[p2.kind].getName(p2, p3)
	end,
	getParticipantIds = function(p2, p3)
		return frozen[p2.kind].getParticipantIds(p2, p3)
	end,
	send = function(p2, p3, p4)
		return frozen[p3.kind].send(p2, p3, p4)
	end,
	useEligibleRecipients = function(data)
		local v5 = React.useMemo(function()
			local result = {}

			for k, recipient in data.recipients do
				local recipients = result[recipient.kind] or {}
				table.insert(recipients, recipient)
				result[recipient.kind] = recipients
			end

			return result
		end, { data.recipients })

		local function getKindProps(p2)
			return {
				recipients = v5[p2] or frozen2,
				isActive = data.isActive,
				isGroupChatEnabled = data.isGroupChatEnabled,
				maxCount = data.maxCount
			}
		end

		local v6 = frozen.conversation.useEligibility({
			recipients = v5.conversation or frozen2,
			isActive = data.isActive,
			isGroupChatEnabled = data.isGroupChatEnabled,
			maxCount = data.maxCount
		})
		local v7 = frozen.user.useEligibility({
			recipients = v5.user or frozen2,
			isActive = data.isActive,
			isGroupChatEnabled = data.isGroupChatEnabled,
			maxCount = data.maxCount
		})

		local function getEligibleRecipients()
			local v8 = { conversation = v6, user = v7 }

			local v9 = not data.isActive

			for k, v10 in v8 do
				if v5[k] and v10.isLoading then
					v9 = true
				end
			end

			if v9 then
				return { recipients = {}, isLoading = true }
			end

			local recipients = {}

			for k, recipient in data.recipients do
				if not v8[recipient.kind].isEligible(recipient) then
					continue
				end

				table.insert(recipients, recipient)

				if #recipients >= data.maxCount then
					break
				end
			end

			return { recipients = recipients, isLoading = false }
		end

		return React.useMemo(getEligibleRecipients, {
			v6,
			data.isActive,
			data.maxCount,
			data.recipients,
			v5,
			v7
		})
	end
}
