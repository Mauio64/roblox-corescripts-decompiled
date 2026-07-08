local Parent = script:FindFirstAncestor("AppChat").Parent

require(Parent.AppChatNetworking)

local MessageModel = require(script.Parent.MessageModel)
local DateTime = require(Parent.Time).DateTime

return {
	responseUser = function(t1: {[any]: any}) -- line: 13
		-- upvalues: MessageModel (copy), DateTime (copy)
		return {
			id = not t1.id and "message-id" or t1.id,
			type = MessageModel.SenderTypes.User,
			sender_user_id = not t1.sender_user_id and 1 or t1.sender_user_id,
			sent = if not t1.sent then DateTime.fromIsoDate("2021-01-01T00:00:00Z") else t1.sent,
			content = not t1.content and "message-content" or t1.content,
			created_at = if not t1.created_at then DateTime.fromIsoDate("2021-01-01T00:00:00Z") else t1.created_at,
			moderation_type = not t1.moderation_type and "trusted_comms" or t1.moderation_type,
			is_previewable = t1.is_previewable ~= nil and t1.is_previewable,
			is_badgeable = t1.is_badgeable ~= nil and t1.is_badgeable
		}
	end,
	responseSystem = function(t2: {[any]: any}) -- line: 40
		return {
			type = "system",
			id = not t2.id and "message-id" or t2.id,
			sent = not t2.sent and "2021-01-01T00:00:00Z" or t2.sent,
			content = not t2.content and "message-content" or t2.content,
			created_at = not t2.created_at and "2021-01-01T00:00:00Z" or t2.created_at
		}
	end
}
