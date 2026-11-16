local parent = script:FindFirstAncestor("AppChat").Parent
require(parent.AppChatNetworking)

local MessageModel = require(script.Parent.MessageModel)
local Time = require(parent.Time)
local DateTime = Time.DateTime
local MessageChannels = {}

function MessageChannels.responseUser(data)
	local v = {
		id = not data.id and "message-id" or data.id,
		type = MessageModel.SenderTypes.User,
		sender_user_id = not data.sender_user_id and 1 or data.sender_user_id,
		sent = 0,
		content = 0,
		created_at = 0,
		moderation_type = 0,
		is_previewable = 0,
		is_badgeable = 0
	}
	local sent

	if data.sent then
		sent = data.sent
	else
		sent = DateTime.fromIsoDate("2021-01-01T00:00:00Z")
	end

	v.sent = sent
	v.content = not data.content and "message-content" or data.content
	local created_at

	if data.created_at then
		created_at = data.created_at
	else
		created_at = DateTime.fromIsoDate("2021-01-01T00:00:00Z")
	end

	v.created_at = created_at

	v.moderation_type = not data.moderation_type and "trusted_comms" or data.moderation_type

	v.is_previewable = data.is_previewable ~= nil and data.is_previewable
	v.is_badgeable = data.is_badgeable ~= nil and data.is_badgeable
	return v
end

function MessageChannels.responseSystem(data)
	return {
		id = not data.id and "message-id" or data.id,
		type = "system",
		sent = not data.sent and "2021-01-01T00:00:00Z" or data.sent,
		content = not data.content and "message-content" or data.content,
		created_at = not data.created_at and "2021-01-01T00:00:00Z" or data.created_at
	}
end

return MessageChannels
