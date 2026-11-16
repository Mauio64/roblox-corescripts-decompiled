local AppChat = script:FindFirstAncestor("AppChat")

local AppChatPerfEvent = require(AppChat.Telemetry.AppChatPerfEvent)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)

local v = {
	ChatLandingTTI = { baseName = "AppChat_TTI_ChatLanding", page = "ChatLanding" },
	ChatConversationTTI = { baseName = "AppChat_TTI_ChatConversation", page = "ChatConversation" },
	MessageSendTTI = { baseName = "AppChat_TTI_MessageSend", page = "ChatConversation" },
	MessageReceiveTTI = { baseName = "AppChat_TTI_MessageReceive", page = "ChatConversation" }
}

local v2 = {
	ScrollConversationList = {
		name = "AppChat_Scroll_ConversationList",
		parentTTI = AppChatPerfEvent.ChatLandingTTI
	},
	PaginationConversationList = {
		name = "AppChat_Pagination_ConversationList",
		parentTTI = AppChatPerfEvent.ChatLandingTTI
	},
	ScrollMessageList = {
		name = "AppChat_Scroll_MessageList",
		parentTTI = AppChatPerfEvent.ChatConversationTTI
	},
	PaginationMessageList = {
		name = "AppChat_Pagination_MessageList",
		parentTTI = AppChatPerfEvent.ChatConversationTTI
	},
	MessageSendToPendingRender = {
		name = "AppChat_Message_SendToPendingRender",
		parentTTI = AppChatPerfEvent.ChatConversationTTI
	},
	MessageSendResponseToFinalRender = {
		name = "AppChat_Message_SendResponseToFinalRender",
		parentTTI = AppChatPerfEvent.ChatConversationTTI
	},
	MessageSendToFinalRender = {
		name = "AppChat_Message_SendToFinalRender",
		parentTTI = AppChatPerfEvent.ChatConversationTTI
	},
	MessageReceiveToRender = {
		name = "AppChat_Message_ReceiveToRender",
		parentTTI = AppChatPerfEvent.ChatConversationTTI
	},
	TopBarRenderInterval = {
		name = "AppChat_TopBar_RenderInterval",
		parentTTI = AppChatPerfEvent.ChatLandingTTI
	}
}

local function getTTIBaseName(p) -- 1 equivalent call inferred from this helper
	return v[p].baseName
end

local AppChatPerfEventInfo = {}
AppChatPerfEventInfo.Events = AppChatPerfEvent
AppChatPerfEventInfo.TTI_CATEGORY = "AppChat"

function AppChatPerfEventInfo.isTTIEvent(p): boolean
	return v[p] ~= nil
end

function AppChatPerfEventInfo.isIntervalEvent(p): boolean
	return v2[p] ~= nil
end

AppChatPerfEventInfo.getTTIBaseName = getTTIBaseName

function AppChatPerfEventInfo.getTTIPage(p)
	return v[p].page
end

function AppChatPerfEventInfo.getTTICategory(): string
	return "AppChat"
end

function AppChatPerfEventInfo.buildTTIEventName(p, p2, flag: boolean)
	return getTTIBaseName(p) .. (ChatPlacementContext.isPlacementInExperience(p2) and "_InExp" or "_UA") .. (flag and "_Cold" or "_Warm") -- inferred equivalent call
end

function AppChatPerfEventInfo.getIntervalName(p)
	return v2[p].name
end

function AppChatPerfEventInfo.getParentTTI(p)
	return v2[p].parentTTI
end

function AppChatPerfEventInfo.getIntervalsForTTI(p)
	local intervalsForTTI = {}

	for k, v3 in v2 do
		if v3.parentTTI == p then
			table.insert(intervalsForTTI, k)
		end
	end

	return intervalsForTTI
end

return AppChatPerfEventInfo
