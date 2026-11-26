local module = require("@luauforge/deferred/hmD")
local llama = module.llama
local tutils = module.tutils
local localizationService = module.LocalizationService

local module2 = require("@luauforge/deferred/hnr")

local sources = require("@luauforge/deferred/hns").Analytics.Enums.Sources

local class = {}
class.__index = class

class.DiagCounters = {
	UserLoadedPage = game:DefineFastString("SocialTabUserLoadedPageCounter", "SocialTabUserLoadedPage"),
	UserLoadedSocialTab = game:DefineFastString("SocialTabUserLoadedCounter", "RoactChatUserLoaded")
}

class.Navigation = {
	LoggedInUserIdentity = game:DefineFastString(
		"SocialTabNavigationLoggedInUserIdentityCounter",
		"SocialTabNavigationLoggedInUserIdentity"
	),
	Chats = game:DefineFastString("SocialTabNavigationChatsCounter", "SocialTabNavigationChats"),
	Groups = game:DefineFastString("SocialTabNavigationGroupsCounter", "SocialTabNavigationGroups"),
	AddFriends = game:DefineFastString(
		"SocialTabNavigationAddFriendsCounter",
		"SocialTabNavigationAddFriends"
	),
	FriendRequests = game:DefineFastString(
		"SocialTabNavigationFriendRequestsCounter",
		"SocialTabNavigationFriendRequests"
	),
	SearchFriends = game:DefineFastString(
		"SocialTabNavigationSearchFriendsCounter",
		"SocialTabNavigationSearchFriends"
	),
	Notifications = game:DefineFastString(
		"SocialTabNavigationNotificationsCounter",
		"SocialTabNavigationNotifications"
	),
	CarouselTitle = game:DefineFastString(
		"SocialTabNavigationCarouselTitleCounter",
		"SocialTabNavigationCarouselTitle"
	),
	FriendsLandingPage = game:DefineFastString(
		"SocialTabNavigationFriendsLandingCounter",
		"SocialTabNavigationFriendsLanding"
	),
	ViewUserProfile = game:DefineFastString(
		"SocialTabLuaViewUserProfileCounter",
		"SocialTabLuaViewUserProfile"
	)
}

class.Navigation.LuaProfileTEMP = game:DefineFastString(
	"SocialTabLuaProfileSelfCounter",
	"SocialTabLuaProfileSelf"
)

function class.new(p2, p3)
	assert(p3, "SocialTabAnalytics must be passed the ID of the local user")

	local v5 = {
		_diagImpl = p2.Diag,
		_eventStreamImpl = p2.EventStream,
		localUserId = p3
	}

	setmetatable(v5, class)

	return v5
end

function class:navigate(p3, p4)
	module2:info("navigate to {}", p3)
	local v5 = class.Navigation[p3]

	if v5 then
		self._diagImpl:reportCounter(v5, 1)
	else
		module2:error("Error from navigate: Invalid destination '{}'", p3)
	end
end

function class:buttonClick(p2, options)
	module2:info("eventName: buttonClick btn: {}{}", p2, self:_toStringAdditionalArgs(options))

	local joined = llama.Dictionary.join(options or {}, {
		btn = p2,
		uid = self.localUserId
	})

	self._eventStreamImpl:setRBXEventStream("SocialTab", "buttonClick", joined)
end

function class:_toStringAdditionalArgs(p3)
	if not p3 then
		return ""
	end

	local v5, v6 = string.gsub(" args: " .. tutils.toString(p3), "%s+", " ")
	return v5
end

function class:pageLoaded()
	module2:info("pageLoaded")
	local userLoadedPage = class.DiagCounters.UserLoadedPage
	self._diagImpl:reportCounter(userLoadedPage, 1)
end

function class:userLoadedSocialTab()
	local v5 = { uid = self.localUserId }

	self._eventStreamImpl:setRBXEventStream("roactChat", "userLoadedChat", v5)

	local userLoadedSocialTab = class.DiagCounters.UserLoadedSocialTab
	self._diagImpl:reportCounter(userLoadedSocialTab, 1)
end

function class:openPlayerSearch()
	local v5 = {
		act = "open",
		source = sources.SocialTab,
		locale = localizationService.RobloxLocaleId
	}

	self._eventStreamImpl:setRBXEventStream("players", "search", v5)
end

return class
