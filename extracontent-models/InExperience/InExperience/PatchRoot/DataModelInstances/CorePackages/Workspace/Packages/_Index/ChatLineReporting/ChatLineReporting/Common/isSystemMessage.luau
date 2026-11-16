local ChatLineReporting = script:FindFirstAncestor("ChatLineReporting")
local parent = ChatLineReporting.Parent
local Constants = require(ChatLineReporting.Common.Constants)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableGlobalChatAbuseReporting = SharedFlags.FFlagEnableGlobalChatAbuseReporting
local FFlagAbuseReportAttributedRBXSystemMessages = SharedFlags.FFlagAbuseReportAttributedRBXSystemMessages

function isSystemMessage(p): boolean
	if
		not FFlagAbuseReportAttributedRBXSystemMessages
		and (not FFlagEnableGlobalChatAbuseReporting or p.textChannel)
		and p.textChannel.Name == Constants.ChannelTypes.System
	then
		return true
	end

	return not p.userId or p.userId == "0"
end

return isSystemMessage
