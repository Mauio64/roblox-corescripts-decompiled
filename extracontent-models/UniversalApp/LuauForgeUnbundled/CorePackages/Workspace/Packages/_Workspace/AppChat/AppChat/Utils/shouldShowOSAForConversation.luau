local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")

return function(p2): boolean
	if not p2 then
		return false
	end

	return p2.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
		and p2.osaAcknowledgementStatus == Conversation.OsaAcknowledgementStatus.Unacknowledged
end
