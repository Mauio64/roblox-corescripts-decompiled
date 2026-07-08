local AppChat = script:FindFirstAncestor("AppChat")
local AppChatPerfEvent = require(AppChat.Telemetry.AppChatPerfEvent)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local t1 = {
	ChatLandingTTI = {
		baseName = "AppChat_TTI_ChatLanding",
		page = "ChatLanding"
	},
	ChatConversationTTI = {
		baseName = "AppChat_TTI_ChatConversation",
		page = "ChatConversation"
	},
	MessageSendTTI = {
		baseName = "AppChat_TTI_MessageSend",
		page = "ChatConversation"
	},
	MessageReceiveTTI = {
		baseName = "AppChat_TTI_MessageReceive",
		page = "ChatConversation"
	}
}
local t2 = {
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
	TTI_CATEGORY = "AppChat",
	Events = AppChatPerfEvent,
	isTTIEvent = function(p1) -- line: 104
		-- upvalues: t1 (copy)
		return t1[p1] ~= nil
	end,
	isIntervalEvent = function(p2) -- line: 108
		-- upvalues: t2 (copy)
		return t2[p2] ~= nil
	end,
	getTTIBaseName = function(p3) -- line: 116
		-- upvalues: t1 (copy)
		return t1[p3].baseName
	end,
	getTTIPage = function(p4) -- line: 120
		-- upvalues: t1 (copy)
		return t1[p4].page
	end,
	getTTICategory = function() -- line: 124
		return "AppChat"
	end,
	buildTTIEventName = function(p5, p6, b1: boolean) -- line: 129
		-- upvalues: t1 (copy), ChatPlacementContext (copy)
		return t1[p5].baseName .. (not ChatPlacementContext.isPlacementInExperience(p6) and "_UA" or "_InExp") .. (not b1 and "_Warm" or "_Cold")
	end,
	getIntervalName = function(p7) -- line: 145
		-- upvalues: t2 (copy)
		return t2[p7].name
	end,
	getParentTTI = function(p8) -- line: 149
		-- upvalues: t2 (copy)
		return t2[p8].parentTTI
	end,
	getIntervalsForTTI = function(p9) -- line: 154
		-- upvalues: t2 (copy)
		local t3 = {}

		for v17, v18 in t2 do
			if p9 == v18.parentTTI then
				table.insert(t3, v17)
			end
		end

		return t3
	end
}
