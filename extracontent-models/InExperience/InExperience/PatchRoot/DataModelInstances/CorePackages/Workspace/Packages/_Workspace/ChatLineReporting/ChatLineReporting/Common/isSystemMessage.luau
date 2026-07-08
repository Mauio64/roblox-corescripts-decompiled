local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local ChatLineReportingParent = ChatLineReporting.Parent
local Constants = require(ChatLineReporting.Common.Constants)
local FFlagEnableGlobalChatAbuseReporting = require(ChatLineReportingParent.SharedFlags).FFlagEnableGlobalChatAbuseReporting

function isSystemMessage(t1: {[any]: any}) -- line: 11
	-- upvalues: FFlagEnableGlobalChatAbuseReporting (copy), Constants (copy)
	if (not FFlagEnableGlobalChatAbuseReporting or t1.textChannel) and t1.textChannel.Name == Constants.ChannelTypes.System then
		return true
	end

	if not t1.userId or t1.userId == "0" then
		return true
	end

	return false
end

return isSystemMessage
