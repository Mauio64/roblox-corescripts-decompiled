local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local ChatConversationTelemetryEvents = require(Parent.AppChat.ChatConversationTelemetryEvents)
local ChatConversationTelemetryLayer = require(Parent.AppChat.ChatConversationTelemetryLayer)
local ConversationExitType = require(Parent.AppChat.ConversationExitType)
local useTelemetry = require(Parent.AppChat.useTelemetry)

local function useFriendsChatConversationTelemetry(t1: {[any]: any}) -- line: 33
	-- upvalues: useTelemetry (copy), ChatConversationTelemetryLayer (copy), React (copy), ChatConversationTelemetryEvents (copy), ConversationExitType (copy)
	local emit = useTelemetry(ChatConversationTelemetryLayer.Context).emit
	local v10 = React.useRef(emit)

	v10.current = emit

	local v11 = React.useRef(t1.getLoadedMessageCount)

	v11.current = t1.getLoadedMessageCount

	local conversationId = t1.conversationId

	React.useEffect(function() -- line: 50
		-- upvalues: v10 (copy), ChatConversationTelemetryEvents (copy), v11 (copy)
		v10.current(ChatConversationTelemetryEvents.ScreenRendered, {
			loadedMessageCount = v11.current()
		})
	end, { conversationId })
	React.useEffect(function() -- line: 60
		-- upvalues: v10 (copy), ChatConversationTelemetryEvents (copy), ConversationExitType (copy)
		return function() -- line: 61
			-- upvalues: v10 (copy), ChatConversationTelemetryEvents (copy), ConversationExitType (copy)
			v10.current(ChatConversationTelemetryEvents.ScreenExit, {
				conversationExitType = ConversationExitType.Default
			})
		end
	end, {})

	return {
		fireInfoButtonClicked = React.useCallback(function() -- line: 71
			-- upvalues: v10 (copy), ChatConversationTelemetryEvents (copy)
			v10.current(ChatConversationTelemetryEvents.ConversationInfoBtnClicked, {})
		end, {})
	}
end

return useFriendsChatConversationTelemetry
