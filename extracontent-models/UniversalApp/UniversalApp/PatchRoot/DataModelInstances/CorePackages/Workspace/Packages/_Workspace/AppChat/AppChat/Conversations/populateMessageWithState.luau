local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local getThumbnailsForUserIds = require(AppChat.Users.getThumbnailsForUserIds)
local Conversation = require(AppChat.Models.Conversation)
local MessageModel = require(AppChat.Models.MessageModel)
local Cryo = require(AppChatParent.Cryo)
local v7 = require(AppChat.Logger):new(script.Name)

return function(p1, p2, p3, p4, p5, p6, p7) -- line: 31
	-- upvalues: MessageModel (copy), getThumbnailsForUserIds (copy), Conversation (copy), v7 (copy), Cryo (copy)
	local v15 = p2.senderTargetId ~= tostring(p1.LocalUserId)
	local v16 = p2.repliesTo ~= nil

	local function timeDiffExceeds(p8, p9, p10) -- line: 37
		if not p8 or (not p9 or not p8.sent or not p9.sent) then
			return false
		end

		return p10 < math.abs(p8.sent:GetUnixTimestamp() - p9.sent:GetUnixTimestamp())
	end
	local function isSystemMessage(p11) -- line: 43
		return p11 and p11.messageType == "System"
	end
	local function isModerated(p12) -- line: 47
		return p12 and p12.moderated == true
	end
	local function isHiddenMessage(p13) -- line: 51
		-- upvalues: MessageModel (copy)
		return p13 and p13.visibility == MessageModel.VisibilityTypes.Hidden
	end
	local function isReplyMessage(p14) -- line: 55
		return p14 and p14.repliesTo ~= nil
	end
	local function hasSenderChange(p15, p16) -- line: 59
		return p15 and (p16 and p15.senderTargetId ~= p16.senderTargetId)
	end
	local function hasModeratedBreak(p17, p18) -- line: 63
		return p17 and p17.moderated == true or p18 and p18.moderated == true
	end

	local v24 = not p5 and not not p4.fetchedOldestMessage or not not p2 and (not not p5 and not not p2.sent) and if p5.sent then math.abs(p2.sent:GetUnixTimestamp() - p5.sent:GetUnixTimestamp()) > 300 else false
	local v25 = v24 or (not p5 or (p5 and (p2 and p5.senderTargetId ~= p2.senderTargetId) or (p5 and p5.messageType == "System" or (p2 and p2.repliesTo ~= nil or (p5 and p5.visibility == MessageModel.VisibilityTypes.Hidden or (p5 and p5.moderated == true or p2 and p2.moderated == true))))))
	local v26 = not p7 or (p7 and p7.messageType == "System" or (p7 and (p2 and p7.senderTargetId ~= p2.senderTargetId) or (not not p7 and (not not p2 and not not p7.sent) and (if p2.sent then math.abs(p7.sent:GetUnixTimestamp() - p2.sent:GetUnixTimestamp()) > 300 else false) or (p7 and p7.repliesTo ~= nil or (p7 and p7.visibility == MessageModel.VisibilityTypes.Hidden or (p2 and p2.moderated == true or p7 and p7.moderated == true))))))
	local Users = p1.Users
	local v28 = (v15 and v25 or v16) and p2.senderTargetId
	local t1 = {}

	if v28 or v26 then
		local v30 = Users[p2.senderTargetId]

		t1 = {
			id = if not v28 and (not v15 or not v26) then nil else p2.senderTargetId,
			thumbnail = if not v15 or not v26 then nil else if not v15 or not v30 then nil else getThumbnailsForUserIds({ p2.senderTargetId })[1],
			shouldShowName = if not v28 then nil else p4.conversationType == Conversation.Type.MULTI_USER_CONVERSATION or v16
		}
	elseif p2.senderType == MessageModel.SenderTypes.User and not p2.senderTargetId then
		v7:warning(`User message with no senderTargetId: { p2.id }`)
	end

	local t2 = {
		placeId = p2.placeId,
		universeId = p2.gameLink and p2.gameLink.universeId,
		senderUserId = v15 and p2.senderTargetId or nil
	}

	return Cryo.Dictionary.join(p2, {
		conversationId = p4.id,
		messageId = p3,
		position = p5 and p5.position + 1 or 1,
		isIncoming = v15,
		isLastMessageInMessageGroup = v26,
		isNewSender = v25,
		sender = t1,
		isSending = p6 or false,
		showDateTime = v24,
		additionalProps = t2
	})
end
