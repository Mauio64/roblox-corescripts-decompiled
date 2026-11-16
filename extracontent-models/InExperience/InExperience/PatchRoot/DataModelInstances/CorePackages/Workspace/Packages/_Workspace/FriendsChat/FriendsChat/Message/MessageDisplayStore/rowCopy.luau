local parent = script:FindFirstAncestor("FriendsChat").Parent

local Foundation = require(parent.Foundation)
local getModeratedMaskText = require(parent.AppChat.getModeratedMaskText)
local getReplyLabelDescriptor = require(parent.AppChat.getReplyLabelDescriptor)

local NameInfo = require(script.Parent.NameInfo)
require(script.Parent.classifyMessage)
require(script.Parent.Parent.Parent.Utils.useLocalize)

local IconName = Foundation.Enums.IconName
local RowCopy = {}
RowCopy.MODERATED_ICON = IconName.TriangleExclamation
RowCopy.HIDDEN_ICON = IconName.LockClosed
RowCopy.REPLY_ICON = IconName.ArrowCurlToLeft

function RowCopy.systemIcon(p)
	if p == "party" then
		return IconName.TwoPeopleSpeechBubble
	end

	return IconName.CircleI
end

function RowCopy.moderatedNoticeText(callback)
	if callback then
		return (callback("Feature.Chat.Message.MessageContentModerated"))
	end

	return ""
end

function RowCopy.hiddenNoticeText(displayName: string?, callback)
	if callback then
		return (callback({
			"Feature.Chat.Message.CannotBeDisplayedThirdPerson",
			displayName = displayName
		}))
	end

	return ""
end

function RowCopy.maskedBody(p)
	return getModeratedMaskText(p.messageId or p.body)
end

function RowCopy.replyLabelText(data)
	local localUserId = data.localUserId
	local namesByUserId = data.namesByUserId
	local senderIsLocalUser

	if localUserId == nil then
		senderIsLocalUser = false
	else
		senderIsLocalUser = data.senderUserId == localUserId
	end

	local senderRepliedToLocalUser

	if localUserId == nil then
		senderRepliedToLocalUser = false
	else
		senderRepliedToLocalUser = data.repliedToUserId == localUserId
	end

	if
		NameInfo.isNameLoading(namesByUserId[data.senderUserId]) and not senderIsLocalUser
		or NameInfo.isNameLoading(namesByUserId[data.repliedToUserId]) and not senderRepliedToLocalUser
	then
		return nil
	end

	local name = namesByUserId[data.senderUserId]
	local name2 = namesByUserId[data.repliedToUserId]
	local replyLabelDescriptor = getReplyLabelDescriptor({
		senderIsLocalUser = senderIsLocalUser,
		senderRepliedToSelf = data.senderUserId == data.repliedToUserId,
		senderRepliedToLocalUser = senderRepliedToLocalUser,
		isGroup = data.isGroup,
		senderName = not (name and name.name) and "" or name.name,
		repliedToName = not (name2 and name2.name) and "" or name2.name
	})

	if data.localize then
		return (data.localize(replyLabelDescriptor))
	end

	return ""
end

return RowCopy
