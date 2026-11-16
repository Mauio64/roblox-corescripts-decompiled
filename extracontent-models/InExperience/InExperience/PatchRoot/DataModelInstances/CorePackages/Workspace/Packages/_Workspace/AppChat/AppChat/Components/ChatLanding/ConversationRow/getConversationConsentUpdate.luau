local AppChat = script:FindFirstAncestor("AppChat")

local Constants = require(AppChat.Constants)
local ConversationChannels = require(AppChat.Models.ConversationChannels)

local v = {
	[Constants.OptInVariant.OsaContextCard] = {
		field = "osaAcknowledgementStatus",
		value = ConversationChannels.OsaAcknowledgementStatus.Acknowledged
	},
	[Constants.OptInVariant.ChatOptInInfoCard] = {
		field = "userOptedIntoChatMessages",
		value = ConversationChannels.UserOptedIntoChatMessagesStatus.OptedIn
	}
}

return function(p: string?)
	if p == nil then
		return nil
	end

	return v[p]
end
