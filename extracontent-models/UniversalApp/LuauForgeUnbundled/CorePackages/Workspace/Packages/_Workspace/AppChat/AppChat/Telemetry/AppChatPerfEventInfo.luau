local AppChatPerfEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfEvent")
local ChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext")

local v5 = {
	ChatLandingTTI = { baseName = "AppChat_TTI_ChatLanding", page = "ChatLanding" },
	ChatConversationTTI = {
		baseName = "AppChat_TTI_ChatConversation",
		page = "ChatConversation"
	},
	MessageSendTTI = { baseName = "AppChat_TTI_MessageSend", page = "ChatConversation" },
	MessageReceiveTTI = {
		baseName = "AppChat_TTI_MessageReceive",
		page = "ChatConversation"
	}
}

local v6 = {
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

return {
	Events = AppChatPerfEvent,
	TTI_CATEGORY = "AppChat",
	isTTIEvent = function(p2): boolean
		return v5[p2] ~= nil
	end,
	isIntervalEvent = function(p2): boolean
		return v6[p2] ~= nil
	end,
	getTTIBaseName = function(p2)
		return v5[p2].baseName
	end,
	getTTIPage = function(p2)
		return v5[p2].page
	end,
	getTTICategory = function(): string
		return "AppChat"
	end,
	buildTTIEventName = function(p2, p3, p4)
		return v5[p2].baseName .. (ChatPlacementContext.isPlacementInExperience(p3) and "_InExp" or "_UA") .. (p4 and "_Cold" or "_Warm")
	end,
	getIntervalName = function(p2)
		return v6[p2].name
	end,
	getParentTTI = function(p2)
		return v6[p2].parentTTI
	end,
	getIntervalsForTTI = function(p2)
		local intervalsForTTI = {}

		for k, v7 in v6 do
			if v7.parentTTI == p2 then
				table.insert(intervalsForTTI, k)
			end
		end

		return intervalsForTTI
	end
}
