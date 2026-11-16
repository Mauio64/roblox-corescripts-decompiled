local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")

local class = {}
class.__index = class

class.DiagCounters = {
	FetchedOlderConversation = game:DefineFastString(
		"RoactChatFetchedOlderConversationCounter",
		"RoactChatFetchedOlderConversation"
	),
	UserLoadedChat = game:DefineFastString("RoactChatUserLoadedCounter", "RoactChatUserLoaded")
}

class.DiagCounters.ChatDetailsProfile = game:DefineFastString(
	"RoactChatNavigationChatDetailsProfileCounter",
	"RoactChatNavigationChatDetailsProfile"
)
class.DiagCounters.ChatConversationProfile = game:DefineFastString(
	"RoactChatNavigationChatConversationProfileCounter",
	"RoactChatNavigationChatConversationProfile"
)

class.NavigationEvents = {
	ChatDetailsProfile = "ChatDetailsProfile",
	ChatConversationProfile = "ChatConversationProfile"
}

local v5 = {
	[class.NavigationEvents.ChatConversationProfile] = {
		subpage = "peekView",
		page = "playerProfile",
		btn = "chatIcon"
	},
	[class.NavigationEvents.ChatDetailsProfile] = {
		subpage = "peekView",
		page = "playerProfile",
		btn = "chatDetailsMenu"
	}
}

function class.new(p2, p3)
	assert(p3, "RoactChatAnalytics must be passed the ID of the local user")

	local v6 = {
		_diagImpl = p2.Diag,
		_eventStreamImpl = p2.EventStream,
		hasAlreadyFetchedOlderConversations = false,
		localUserId = p3
	}

	setmetatable(v6, class)

	return v6
end

function class:userFetchedOlderConversations()
	if self.hasAlreadyFetchedOlderConversations then
		return
	end

	self.hasAlreadyFetchedOlderConversations = true

	local v6 = { uid = self.localUserId }

	self._eventStreamImpl:setRBXEventStream("roactChat", "userFetchedOlderConversations", v6)

	local fetchedOlderConversation = class.DiagCounters.FetchedOlderConversation
	self._diagImpl:reportCounter(fetchedOlderConversation, 1)
end

function class:loadGameLinkCardInChat(p3, p4)
	local v6 = { uid = self.localUserId, cid = tostring(p3), pid = tostring(p4) }

	self._eventStreamImpl:setRBXEventStream("roactChat", "loadGameLinkCardInChat", v6)
end

function class:userLoadedChat()
	local v6 = { uid = self.localUserId }

	self._eventStreamImpl:setRBXEventStream("roactChat", "userLoadedChat", v6)

	local userLoadedChat = class.DiagCounters.UserLoadedChat
	self._diagImpl:reportCounter(userLoadedChat, 1)
end

function class:navigate(p2)
	assert(v5[p2], "Invalid navigation option given")

	self._diagImpl:reportCounter(class.DiagCounters[p2], 1)
	self._eventStreamImpl:setRBXEventStream(
		"chat",
		"buttonClick",
		Cryo.Dictionary.join({ uid = self.localUserId }, v5[p2])
	)
end

return class
