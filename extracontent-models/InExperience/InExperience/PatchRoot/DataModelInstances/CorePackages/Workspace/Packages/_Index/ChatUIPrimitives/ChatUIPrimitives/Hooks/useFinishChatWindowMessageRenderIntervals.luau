local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local parent = ChatUIPrimitives.Parent

local React = require(parent.React)

local ExpChatPerfTracker = require(ChatUIPrimitives.Telemetry.ExpChatPerfTracker)

local function useFinishChatWindowMessageRenderIntervals(callback)
	return React.useCallback(function()
		local messageId = callback() or "UNKNOWN_MESSAGE_ID"
		ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.MessageReceiveToWindowRenderInterval, {
			messageId = messageId
		})

		ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.MessageSendToWindowRenderInterval, {
			messageId = messageId
		})
	end, { callback })
end

return useFinishChatWindowMessageRenderIntervals
