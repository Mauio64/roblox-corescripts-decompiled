local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")

local v5 = {
	[Constants.OptInVariant.OsaContextCard] = {
		field = "osaAcknowledgementStatus",
		value = ConversationChannels.OsaAcknowledgementStatus.Acknowledged
	},
	[Constants.OptInVariant.ChatOptInInfoCard] = {
		field = "userOptedIntoChatMessages",
		value = ConversationChannels.UserOptedIntoChatMessagesStatus.OptedIn
	}
}

return function(p2)
	if p2 == nil then
		return nil
	end

	return v5[p2]
end
