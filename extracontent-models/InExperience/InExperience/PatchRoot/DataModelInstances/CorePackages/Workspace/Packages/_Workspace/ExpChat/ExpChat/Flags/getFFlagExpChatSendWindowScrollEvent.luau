local ExpChat = script:FindFirstAncestor("ExpChat")
local getFFlagExpChatTelemetryEventTrigger = require(ExpChat.Flags.getFFlagExpChatTelemetryEventTrigger)

game:DefineFastFlag("ExpChatSendWindowScrollEvent", false)

return function() -- line: 5
	-- upvalues: getFFlagExpChatTelemetryEventTrigger (copy)
	return game:GetFastFlag("ExpChatSendWindowScrollEvent") and getFFlagExpChatTelemetryEventTrigger()
end
