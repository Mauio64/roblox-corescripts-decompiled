local parent = script:FindFirstAncestor("ShareSheet").Parent

local React = require(parent.React)

local ConversationRecipient = require(script.Parent.Kinds.ConversationRecipient)
require(parent.AppChat.GetExternalChatMessageSenderStore)
require(parent.LuauPolyfill)
require(script.Parent.Kinds.RecipientKind)
require(parent.Signals)
local UserRecipient = require(script.Parent.Kinds.UserRecipient)

local frozen = table.freeze({ conversation = ConversationRecipient.kind, user = UserRecipient.kind })

local frozen2 = table.freeze({})

local function getKind(p) -- 4 equivalent calls inferred from this helper
	return frozen[p.kind]
end

local Recipient = {}

function Recipient.canSend(p, p2)
	return getKind(p2).canSend(p, p2) -- inferred equivalent call
end

Recipient.fromConversation = ConversationRecipient.create
Recipient.fromUserId = UserRecipient.create

function Recipient.getName(p, p2)
	return getKind(p).getName(p, p2) -- inferred equivalent call
end

function Recipient.getParticipantIds(p, p2: string)
	return getKind(p).getParticipantIds(p, p2) -- inferred equivalent call
end

function Recipient.send(p, p2, p3: string)
	return getKind(p2).send(p, p2, p3) -- inferred equivalent call
end

function Recipient.useEligibleRecipients(data)
	local v = React.useMemo(function()
		local result = {}

		for _, recipient in data.recipients do
			local recipients = result[recipient.kind] or {}
			table.insert(recipients, recipient)
			result[recipient.kind] = recipients
		end

		return result
	end, { data.recipients })

	local function getKindProps(p: string) -- 2 equivalent calls inferred from this helper
		return {
			recipients = v[p] or frozen2,
			isActive = data.isActive,
			isGroupChatEnabled = data.isGroupChatEnabled,
			maxCount = data.maxCount
		}
	end

	local conversation = frozen.conversation.useEligibility(getKindProps("conversation")) -- inferred equivalent call
	local user = frozen.user.useEligibility(getKindProps("user")) -- inferred equivalent call

	local function getEligibleRecipients()
		local v2 = { conversation = conversation, user = user }

		local v3 = not data.isActive

		for k, v4 in v2 do
			if v[k] and v4.isLoading then
				v3 = true
			end
		end

		if v3 then
			return { recipients = {}, isLoading = true }
		end

		local recipients = {}

		for _, recipient in data.recipients do
			if not v2[recipient.kind].isEligible(recipient) then
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
		conversation,
		data.isActive,
		data.maxCount,
		data.recipients,
		v,
		user
	})
end

return Recipient
