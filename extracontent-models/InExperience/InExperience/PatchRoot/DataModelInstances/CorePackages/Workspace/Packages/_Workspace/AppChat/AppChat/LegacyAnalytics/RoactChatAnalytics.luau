local parent = script:FindFirstAncestor("AppChat").Parent

local Cryo = require(parent.Cryo)

local RoactChatAnalytics = {}
RoactChatAnalytics.__index = RoactChatAnalytics

RoactChatAnalytics.DiagCounters = {
	FetchedOlderConversation = game:DefineFastString(
		"RoactChatFetchedOlderConversationCounter",
		"RoactChatFetchedOlderConversation"
	),
	UserLoadedChat = game:DefineFastString("RoactChatUserLoadedCounter", "RoactChatUserLoaded")
}

RoactChatAnalytics.DiagCounters.ChatDetailsProfile = game:DefineFastString(
	"RoactChatNavigationChatDetailsProfileCounter",
	"RoactChatNavigationChatDetailsProfile"
)
RoactChatAnalytics.DiagCounters.ChatConversationProfile = game:DefineFastString(
	"RoactChatNavigationChatConversationProfileCounter",
	"RoactChatNavigationChatConversationProfile"
)

RoactChatAnalytics.NavigationEvents = {
	ChatDetailsProfile = "ChatDetailsProfile",
	ChatConversationProfile = "ChatConversationProfile"
}

local v = {
	[RoactChatAnalytics.NavigationEvents.ChatConversationProfile] = {
		subpage = "peekView",
		page = "playerProfile",
		btn = "chatIcon"
	},
	[RoactChatAnalytics.NavigationEvents.ChatDetailsProfile] = {
		subpage = "peekView",
		page = "playerProfile",
		btn = "chatDetailsMenu"
	}
}

function RoactChatAnalytics.new(p, localUserId)
	assert(localUserId, "RoactChatAnalytics must be passed the ID of the local user")

	local v2 = {
		_diagImpl = p.Diag,
		_eventStreamImpl = p.EventStream,
		hasAlreadyFetchedOlderConversations = false,
		localUserId = localUserId
	}

	setmetatable(v2, RoactChatAnalytics)

	return v2
end

function RoactChatAnalytics:userFetchedOlderConversations()
	if self.hasAlreadyFetchedOlderConversations then
		return
	end

	self.hasAlreadyFetchedOlderConversations = true

	local v2 = { uid = self.localUserId }

	self._eventStreamImpl:setRBXEventStream("roactChat", "userFetchedOlderConversations", v2)

	local fetchedOlderConversation = RoactChatAnalytics.DiagCounters.FetchedOlderConversation
	self._diagImpl:reportCounter(fetchedOlderConversation, 1)
end

function RoactChatAnalytics:loadGameLinkCardInChat(p, p2)
	local v2 = { uid = self.localUserId, cid = tostring(p), pid = tostring(p2) }

	self._eventStreamImpl:setRBXEventStream("roactChat", "loadGameLinkCardInChat", v2)
end

function RoactChatAnalytics:userLoadedChat()
	local v2 = { uid = self.localUserId }

	self._eventStreamImpl:setRBXEventStream("roactChat", "userLoadedChat", v2)

	local userLoadedChat = RoactChatAnalytics.DiagCounters.UserLoadedChat
	self._diagImpl:reportCounter(userLoadedChat, 1)
end

function RoactChatAnalytics:navigate(p)
	assert(v[p], "Invalid navigation option given")

	self._diagImpl:reportCounter(RoactChatAnalytics.DiagCounters[p], 1)
	self._eventStreamImpl:setRBXEventStream(
		"chat",
		"buttonClick",
		Cryo.Dictionary.join({ uid = self.localUserId }, v[p])
	)
end

return RoactChatAnalytics
