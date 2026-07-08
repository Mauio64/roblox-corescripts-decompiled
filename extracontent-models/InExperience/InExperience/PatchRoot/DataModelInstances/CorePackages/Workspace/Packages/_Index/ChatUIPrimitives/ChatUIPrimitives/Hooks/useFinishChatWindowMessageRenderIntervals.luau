local ChatUIPrimitives = script:FindFirstAncestor("ChatUIPrimitives")
local ChatUIPrimitivesParent = ChatUIPrimitives.Parent
local React = require(ChatUIPrimitivesParent.React)
local ExpChatPerfTracker = require(ChatUIPrimitives.Telemetry.ExpChatPerfTracker)

local function useFinishChatWindowMessageRenderIntervals(p1: ((...any) -> ...any)) -- line: 29
	-- upvalues: React (copy), ExpChatPerfTracker (copy)
	return React.useCallback(function() -- line: 30
		-- upvalues: p1 (copy), ExpChatPerfTracker (copy)
		local v7 = p1() or "UNKNOWN_MESSAGE_ID"

		ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.MessageReceiveToWindowRenderInterval, {
			messageId = v7
		})
		ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.MessageSendToWindowRenderInterval, {
			messageId = v7
		})
	end, { p1 })
end

return useFinishChatWindowMessageRenderIntervals
