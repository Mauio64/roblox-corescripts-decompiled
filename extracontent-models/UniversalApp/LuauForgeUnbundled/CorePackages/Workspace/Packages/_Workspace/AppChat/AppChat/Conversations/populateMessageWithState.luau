local getThumbnailsForUserIds = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Users/getThumbnailsForUserIds")
local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local MessageModel = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/MessageModel")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("populateMessageWithState")

return function(p2, data, p3, data2, data3, p4, data4)
	local v6 = data.senderTargetId ~= tostring(p2.LocalUserId)
	local v7 = data.repliesTo ~= nil

	local function timeDiffExceeds(p5, p6, p7): boolean
		if p5 and p6 and p5.sent and p6.sent then
			return p7 < math.abs(p5.sent:GetUnixTimestamp() - p6.sent:GetUnixTimestamp())
		end

		return false
	end

	local function isSystemMessage(p5)
		return p5 and p5.messageType == "System"
	end

	local function isModerated(p5)
		return p5 and p5.moderated == true
	end

	local function isHiddenMessage(p5)
		return p5 and p5.visibility == MessageModel.VisibilityTypes.Hidden
	end

	local function isReplyMessage(p5)
		return p5 and p5.repliesTo ~= nil
	end

	local function hasSenderChange(p5, p6)
		return p5 and p6 and p5.senderTargetId ~= p6.senderTargetId
	end

	local function hasModeratedBreak(p5, p6)
		return p5 and p5.moderated == true or p6 and p6.moderated == true
	end

	local v8

	if data3 or not data2.fetchedOldestMessage then
		if data and data3 and data.sent and data3.sent then
			v8 = math.abs(data.sent:GetUnixTimestamp() - data3.sent:GetUnixTimestamp()) > 300
		else
			v8 = false
		end
	else
		v8 = true
	end

	local v9 = v8
		or not data3
		or data3 and data and data3.senderTargetId ~= data.senderTargetId
		or data3 and data3.messageType == "System"
		or data and data.repliesTo ~= nil
		or data3 and data3.visibility == MessageModel.VisibilityTypes.Hidden
		or data3 and data3.moderated == true
		or data and data.moderated == true
	local v10 = not data4
		or data4 and data4.messageType == "System"
		or data4 and data and data4.senderTargetId ~= data.senderTargetId

	if not v10 then
		v10 = (if data4 and data and data4.sent and data.sent then math.abs(data4.sent:GetUnixTimestamp() - data.sent:GetUnixTimestamp()) > 300 else false)
			or data4 and data4.repliesTo ~= nil
			or data4 and data4.visibility == MessageModel.VisibilityTypes.Hidden
			or data and data.moderated == true
			or data4 and data4.moderated == true
	end

	local users = p2.Users

	local v11 = if v6 and v9 or v7 then data.senderTargetId else v7
	local v12 = {}

	if v11 or v10 then
		local user = users[data.senderTargetId]

		v12 = { id = 0, thumbnail = 0, shouldShowName = 0 }

		local v13 = if v11 or v6 and v10 then data.senderTargetId else nil
		v12.id = v13

		local v14 = if v6 and v10 and v6 and user then getThumbnailsForUserIds({ data.senderTargetId })[1] else nil
		v12.thumbnail = v14

		local v15 = if v11 then data2.conversationType == Conversation.Type.MULTI_USER_CONVERSATION or v7 else nil
		v12.shouldShowName = v15
	elseif data.senderType == MessageModel.SenderTypes.User and not data.senderTargetId then
		v5:warning(`User message with no senderTargetId: {data.id}`)
	end

	local v13 = {
		placeId = data.placeId,
		universeId = data.gameLink and data.gameLink.universeId,
		senderUserId = 0,
		isEarlyTesting = 0
	}
	local v14 = if v6 then data.senderTargetId or nil else nil
	v13.senderUserId = v14
	v13.isEarlyTesting = data.isEarlyTesting

	return Cryo.Dictionary.join(data, {
		conversationId = data2.id,
		messageId = p3,
		position = data3 and data3.position + 1 or 1,
		isIncoming = v6,
		isLastMessageInMessageGroup = v10,
		isNewSender = v9,
		sender = v12,
		isSending = p4 or false,
		showDateTime = v8,
		additionalProps = v13
	})
end
