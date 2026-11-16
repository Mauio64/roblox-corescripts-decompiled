local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local getThumbnailsForUserIds = require(AppChat.Users.getThumbnailsForUserIds)
local Conversation = require(AppChat.Models.Conversation)
local MessageModel = require(AppChat.Models.MessageModel)

local Cryo = require(parent.Cryo)

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

return function(p, data, messageId, data2, data3, p2, data4)
	local isIncoming = data.senderTargetId ~= tostring(p.LocalUserId)
	local v2 = data.repliesTo ~= nil

	local function timeDiffExceeds(p3, p4, p5): boolean
		if p3 and p4 and p3.sent and p4.sent then
			return p5 < math.abs(p3.sent:GetUnixTimestamp() - p4.sent:GetUnixTimestamp())
		end

		return false
	end

	local function isSystemMessage(data5) -- 2 equivalent calls inferred from this helper
		return data5 and data5.messageType == "System"
	end

	local function isModerated(p3)
		return p3 and p3.moderated == true
	end

	local function isHiddenMessage(data5) -- 2 equivalent calls inferred from this helper
		return data5 and data5.visibility == MessageModel.VisibilityTypes.Hidden
	end

	local function isReplyMessage(p3) -- 2 equivalent calls inferred from this helper
		return p3 and p3.repliesTo ~= nil
	end

	local function hasSenderChange(data5, data6) -- 2 equivalent calls inferred from this helper
		return data5 and data6 and data5.senderTargetId ~= data6.senderTargetId
	end

	local function hasModeratedBreak(p3, p4)
		return p3 and p3.moderated == true or p4 and p4.moderated == true
	end

	local showDateTime

	if data3 or not data2.fetchedOldestMessage then
		if data and data3 and data.sent and data3.sent then
			showDateTime = math.abs(data.sent:GetUnixTimestamp() - data3.sent:GetUnixTimestamp()) > 300
		else
			showDateTime = false
		end
	else
		showDateTime = true
	end

	local isNewSender = showDateTime
		or not data3
		or hasSenderChange(data3, data) -- inferred equivalent call
		or isSystemMessage(data3) -- inferred equivalent call
		or isReplyMessage(data) -- inferred equivalent call
		or isHiddenMessage(data3) -- inferred equivalent call
		or data3 and data3.moderated == true
		or data and data.moderated == true
	local isLastMessageInMessageGroup = not data4 or isSystemMessage(data4) or hasSenderChange(data4, data) -- inferred equivalent call

	if not isLastMessageInMessageGroup then
		local v3

		if data4 and data and data4.sent and data.sent then
			v3 = math.abs(data4.sent:GetUnixTimestamp() - data.sent:GetUnixTimestamp()) > 300
		else
			v3 = false
		end

		isLastMessageInMessageGroup = v3
			or isReplyMessage(data4) -- inferred equivalent call
			or isHiddenMessage(data4) -- inferred equivalent call
			or data and data.moderated == true
			or data4 and data4.moderated == true
	end

	local users = p.Users
	local v3

	if isIncoming and isNewSender or v2 then
		v3 = data.senderTargetId
	else
		v3 = v2
	end

	local sender = {}

	if v3 or isLastMessageInMessageGroup then
		local user = users[data.senderTargetId]

		sender = { id = 0, thumbnail = 0, shouldShowName = 0 }
		local id

		if v3 or isIncoming and isLastMessageInMessageGroup then
			id = data.senderTargetId
		end

		sender.id = id
		local thumbnail

		if isIncoming and isLastMessageInMessageGroup and isIncoming and user then
			thumbnail = getThumbnailsForUserIds({ data.senderTargetId })[1]
		end

		sender.thumbnail = thumbnail
		local shouldShowName

		if v3 then
			shouldShowName = data2.conversationType == Conversation.Type.MULTI_USER_CONVERSATION or v2
		end

		sender.shouldShowName = shouldShowName
	elseif data.senderType == MessageModel.SenderTypes.User and not data.senderTargetId then
		v:warning(`User message with no senderTargetId: {data.id}`)
	end

	local additionalProps = {
		placeId = data.placeId,
		universeId = data.gameLink and data.gameLink.universeId,
		senderUserId = 0,
		isEarlyTesting = 0
	}
	local senderUserId

	if isIncoming then
		senderUserId = data.senderTargetId or nil
	end

	additionalProps.senderUserId = senderUserId
	additionalProps.isEarlyTesting = data.isEarlyTesting

	return Cryo.Dictionary.join(data, {
		conversationId = data2.id,
		messageId = messageId,
		position = data3 and data3.position + 1 or 1,
		isIncoming = isIncoming,
		isLastMessageInMessageGroup = isLastMessageInMessageGroup,
		isNewSender = isNewSender,
		sender = sender,
		isSending = p2 or false,
		showDateTime = showDateTime,
		additionalProps = additionalProps
	})
end
