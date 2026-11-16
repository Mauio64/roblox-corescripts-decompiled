local parent = script:FindFirstAncestor("FriendsChat").Parent

local MessageEnvelopeModel = require(parent.ChatUIPrimitives.MessageEnvelopeModel)
local MessageDraftModel = require(parent.ChatUIPrimitives.MessageDraftModel)
local PlainTextContentModel = require(parent.ChatUIPrimitives.PlainTextContentModel)
local SystemContentModel = require(parent.ChatUIPrimitives.SystemContentModel)

local NameInfo = require(script.Parent.Parent.MessageDisplayStore.NameInfo)
local classifyMessage = require(script.Parent.Parent.MessageDisplayStore.classifyMessage)
local rowCopy = require(script.Parent.Parent.MessageDisplayStore.rowCopy)
require(script.Parent.Parent.Parent.Utils.useLocalize)

local function nameOf(p, p2: number) -- 2 equivalent calls inferred from this helper
	local v = p[p2]
	return if v and v.name then v.name else ""
end

local function authorOf(namesByUserId, senderUserId: number) -- 1 equivalent call inferred from this helper
	return {
		userId = tostring(senderUserId),
		displayName = nameOf(namesByUserId, senderUserId) -- inferred equivalent call
	}
end

local function systemEnvelope(id: string, sentAtUnixMilliseconds: number, p: string, p2: string)
	return MessageEnvelopeModel.incoming({
		id = id,
		sentAtUnixMilliseconds = sentAtUnixMilliseconds,
		author = nil,
		contents = { SystemContentModel.fromSystem(p, p2) }
	})
end

local function repliesToOf(data, data2)
	local replies_to = data.replies_to
	local replyQuote = data2.replyQuote

	if type(replies_to) ~= "table" or replies_to.sender_user_id == nil or replyQuote == nil then
		return nil
	end

	local replyLabelText = rowCopy.replyLabelText({
		senderUserId = data.sender_user_id,
		repliedToUserId = replies_to.sender_user_id,
		localUserId = data2.localUserId,
		isGroup = data2.isGroup == true,
		namesByUserId = data2.namesByUserId,
		localize = data2.localize
	})

	return {
		{
			id = replies_to.id or "",
			preview = { fallbackText = replyQuote },
			label = replyLabelText
		}
	}
end

local function buildMessageEnvelopes(data, data2)
	local sentAtUnixMilliseconds = data2.sentAtUnixMilliseconds
	local namesByUserId = data2.namesByUserId
	local messageEnvelopes = {}

	for _, v in classifyMessage(data) do
		if v.kind == "userText" then
			local author = authorOf(namesByUserId, v.senderUserId) -- inferred equivalent call

			if data.status == "Pending" and v.senderUserId == data2.localUserId then
				table.insert(
					messageEnvelopes,
					MessageEnvelopeModel.sending(
						data.id,
						MessageDraftModel.fromPlainText(v.body),
						author,
						sentAtUnixMilliseconds
					)
				)
			else
				local v2

				if v.moderated then
					v2 = rowCopy.maskedBody(v)
				else
					v2 = v.body
				end

				local repliesTo = repliesToOf(data, data2)
				local v3 = {
					id = data.id,
					sentAtUnixMilliseconds = sentAtUnixMilliseconds,
					author = author,
					contents = { PlainTextContentModel.fromText(v2) },
					repliesTo = repliesTo
				}

				local stableKey = data.stableKey

				if type(stableKey) == "string" and stableKey ~= data.id then
					local sending = MessageEnvelopeModel.sending(
						stableKey,
						MessageDraftModel.fromPlainText(v.body),
						author,
						sentAtUnixMilliseconds
					)

					table.insert(
						messageEnvelopes,
						MessageEnvelopeModel.acknowledged(sending, v3, sentAtUnixMilliseconds)
					)
				else
					table.insert(messageEnvelopes, MessageEnvelopeModel.incoming(v3))
				end
			end
		elseif v.kind == "hiddenUser" then
			if not NameInfo.isNameLoading(namesByUserId[v.senderUserId]) then
				local v2 = rowCopy.hiddenNoticeText(nameOf(namesByUserId, v.senderUserId), data2.localize) -- inferred equivalent call
				table.insert(messageEnvelopes, systemEnvelope(data.id, sentAtUnixMilliseconds, v2, rowCopy.HIDDEN_ICON))
			end
		elseif v.kind == "systemMessage" then
			table.insert(
				messageEnvelopes,
				systemEnvelope(data.id, sentAtUnixMilliseconds, v.body, rowCopy.systemIcon(v.variant))
			)
		elseif v.kind == "moderationNotice" then
			table.insert(
				messageEnvelopes,
				systemEnvelope(
					data.id .. ":moderation",
					sentAtUnixMilliseconds,
					rowCopy.moderatedNoticeText(data2.localize),
					rowCopy.MODERATED_ICON
				)
			)
		end
	end

	return messageEnvelopes
end

return buildMessageEnvelopes
