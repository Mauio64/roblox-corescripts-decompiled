local FriendsChat = script:FindFirstAncestor("FriendsChat")
local parent = FriendsChat.Parent

local React = require(parent.React)

local ChatConversationTelemetryEvents = require(parent.AppChat.ChatConversationTelemetryEvents)
local ChatConversationTelemetryLayer = require(parent.AppChat.ChatConversationTelemetryLayer)
local ConversationExitType = require(parent.AppChat.ConversationExitType)
local useTelemetry = require(parent.AppChat.useTelemetry)

local FFlagFriendsChatScreenExitLoadedMessageCount = require(FriendsChat.Flags.FFlagFriendsChatScreenExitLoadedMessageCount)

local function useFriendsChatConversationTelemetry(p)
	local emit = useTelemetry(ChatConversationTelemetryLayer.Context).emit

	local ref = React.useRef(emit)
	ref.current = emit
	local ref2 = React.useRef(p.getLoadedMessageCount)
	ref2.current = p.getLoadedMessageCount

	local v = { p.conversationId }
	React.useEffect(function()
		ref.current(ChatConversationTelemetryEvents.ScreenRendered, {
			loadedMessageCount = ref2.current()
		})
	end, v)

	React.useEffect(function()
		return function()
			local current = ref.current
			local screenExit = ChatConversationTelemetryEvents.ScreenExit
			local v2 = {
				conversationExitType = ConversationExitType.Default,
				loadedMessageCount = 0
			}
			local loadedMessageCount

			if FFlagFriendsChatScreenExitLoadedMessageCount then
				loadedMessageCount = ref2.current()
			end

			v2.loadedMessageCount = loadedMessageCount
			current(screenExit, v2)
		end
	end, {})

	return {
		fireInfoButtonClicked = React.useCallback(function()
			ref.current(ChatConversationTelemetryEvents.ConversationInfoBtnClicked, {})
		end, {})
	}
end

return useFriendsChatConversationTelemetry
