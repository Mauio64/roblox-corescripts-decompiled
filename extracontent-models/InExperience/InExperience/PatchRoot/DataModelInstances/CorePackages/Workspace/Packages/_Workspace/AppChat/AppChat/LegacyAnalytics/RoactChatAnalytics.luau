local Parent = script:FindFirstAncestor("AppChat").Parent
local Cryo = require(Parent.Cryo)
local t1 = {}

t1.__index = t1
t1.DiagCounters = {
	FetchedOlderConversation = game:DefineFastString("RoactChatFetchedOlderConversationCounter", "RoactChatFetchedOlderConversation"),
	LuaShareGameInputBarEntry = game:DefineFastString("LuaShareGameRoactChatInputBarEntryCounter", "LuaShareGameRoactChatInputBarEntry"),
	LuaShareGameInputBarInvite = game:DefineFastString("LuaShareGameRoactChatInputBarInviteCounter", "LuaShareGameRoactChatInputBarInvite"),
	UserLoadedChat = game:DefineFastString("RoactChatUserLoadedCounter", "RoactChatUserLoaded")
}
t1.DiagCounters.ChatDetailsProfile = game:DefineFastString("RoactChatNavigationChatDetailsProfileCounter", "RoactChatNavigationChatDetailsProfile")
t1.DiagCounters.ChatConversationProfile = game:DefineFastString("RoactChatNavigationChatConversationProfileCounter", "RoactChatNavigationChatConversationProfile")
t1.NavigationEvents = {
	ChatDetailsProfile = "ChatDetailsProfile",
	ChatConversationProfile = "ChatConversationProfile"
}

local t2 = {
	[t1.NavigationEvents.ChatConversationProfile] = {
		subpage = "peekView",
		page = "playerProfile",
		btn = "chatIcon"
	},
	[t1.NavigationEvents.ChatDetailsProfile] = {
		subpage = "peekView",
		page = "playerProfile",
		btn = "chatDetailsMenu"
	}
}

function t1.new(p1, p2) -- line: 52
	-- upvalues: t1 (copy)
	assert(p2, "RoactChatAnalytics must be passed the ID of the local user")

	local t3 = {
		hasAlreadyFetchedOlderConversations = false,
		_diagImpl = p1.Diag,
		_eventStreamImpl = p1.EventStream,
		localUserId = p2
	}

	setmetatable(t3, t1)

	return t3
end
function t1.withEventStream(p3, p4) -- line: 66
	p3._eventStreamImpl = p4

	return p3
end
function t1.withDiag(p5, p6) -- line: 71
	p5._diagImpl = p6

	return p5
end
function t1.userFetchedOlderConversations(p7) -- line: 76
	-- upvalues: t1 (copy)
	if p7.hasAlreadyFetchedOlderConversations then
		return
	end

	p7.hasAlreadyFetchedOlderConversations = true

	local t4 = {
		uid = p7.localUserId
	}

	p7._eventStreamImpl:setRBXEventStream("roactChat", "userFetchedOlderConversations", t4)

	local FetchedOlderConversation = t1.DiagCounters.FetchedOlderConversation

	p7._diagImpl:reportCounter(FetchedOlderConversation, 1)
end
function t1.inputShareGameInviteSent(p8, p9, p10, p11, p12, p13) -- line: 96
	-- upvalues: t1 (copy)
	local v21 = table.concat(p13, ",")
	local t5 = {
		btn = "roactChatInputBar",
		placeId = tostring(p9),
		gameId = tostring(p10),
		senderId = p11,
		conversationId = tostring(p12),
		participants = v21
	}

	p8._eventStreamImpl:setRBXEventStream("touch", "inputShareGameInviteSent", t5)

	local LuaShareGameInputBarInvite = t1.DiagCounters.LuaShareGameInputBarInvite

	p8._diagImpl:reportCounter(LuaShareGameInputBarInvite, 1)
end
function t1.inputShareGameEntryPoint(p14, p15) -- line: 115
	-- upvalues: t1 (copy)
	local t6 = {
		btn = "roactChatInputBar",
		uid = p14.localUserId,
		cid = tostring(p15)
	}

	p14._eventStreamImpl:setRBXEventStream("touch", "inputShareGameInviteSent", t6)

	local LuaShareGameInputBarEntry = t1.DiagCounters.LuaShareGameInputBarEntry

	p14._diagImpl:reportCounter(LuaShareGameInputBarEntry, 1)
end
function t1.loadGameLinkCardInChat(p16, p17, p18) -- line: 130
	local t7 = {
		uid = p16.localUserId,
		cid = tostring(p17),
		pid = tostring(p18)
	}

	p16._eventStreamImpl:setRBXEventStream("roactChat", "loadGameLinkCardInChat", t7)
end
function t1.userLoadedChat(p19) -- line: 141
	-- upvalues: t1 (copy)
	local t8 = {
		uid = p19.localUserId
	}

	p19._eventStreamImpl:setRBXEventStream("roactChat", "userLoadedChat", t8)

	local UserLoadedChat = t1.DiagCounters.UserLoadedChat

	p19._diagImpl:reportCounter(UserLoadedChat, 1)
end
function t1.navigate(p20, p21) -- line: 153
	-- upvalues: t2 (copy), t1 (copy), Cryo (copy)
	assert(t2[p21], "Invalid navigation option given")
	p20._diagImpl:reportCounter(t1.DiagCounters[p21], 1)
	p20._eventStreamImpl:setRBXEventStream("chat", "buttonClick", Cryo.Dictionary.join({
		uid = p20.localUserId
	}, t2[p21]))
end

return t1
