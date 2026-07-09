local SocialTab = script:FindFirstAncestor("SocialTab")
local SocialTabParent = SocialTab.Parent
local dependencies = require(SocialTab.dependencies)
local llama = dependencies.llama
local tutils = dependencies.tutils
local LocalizationService = dependencies.LocalizationService
local Logger = require(script.Parent.Logger)
local Sources = require(SocialTabParent.SocialLuaAnalytics).Analytics.Enums.Sources
local t1 = {}

t1.__index = t1
t1.DiagCounters = {
	UserLoadedPage = game:DefineFastString("SocialTabUserLoadedPageCounter", "SocialTabUserLoadedPage"),
	UserLoadedSocialTab = game:DefineFastString("SocialTabUserLoadedCounter", "RoactChatUserLoaded")
}
t1.Navigation = {
	LoggedInUserIdentity = game:DefineFastString("SocialTabNavigationLoggedInUserIdentityCounter", "SocialTabNavigationLoggedInUserIdentity"),
	Chats = game:DefineFastString("SocialTabNavigationChatsCounter", "SocialTabNavigationChats"),
	Groups = game:DefineFastString("SocialTabNavigationGroupsCounter", "SocialTabNavigationGroups"),
	AddFriends = game:DefineFastString("SocialTabNavigationAddFriendsCounter", "SocialTabNavigationAddFriends"),
	FriendRequests = game:DefineFastString("SocialTabNavigationFriendRequestsCounter", "SocialTabNavigationFriendRequests"),
	SearchFriends = game:DefineFastString("SocialTabNavigationSearchFriendsCounter", "SocialTabNavigationSearchFriends"),
	Notifications = game:DefineFastString("SocialTabNavigationNotificationsCounter", "SocialTabNavigationNotifications"),
	CarouselTitle = game:DefineFastString("SocialTabNavigationCarouselTitleCounter", "SocialTabNavigationCarouselTitle"),
	FriendsLandingPage = game:DefineFastString("SocialTabNavigationFriendsLandingCounter", "SocialTabNavigationFriendsLanding"),
	ViewUserProfile = game:DefineFastString("SocialTabLuaViewUserProfileCounter", "SocialTabLuaViewUserProfile")
}
t1.Navigation.LuaProfileTEMP = game:DefineFastString("SocialTabLuaProfileSelfCounter", "SocialTabLuaProfileSelf")

function t1.new(p1, p2) -- line: 58
	-- upvalues: t1 (copy)
	assert(p2, "SocialTabAnalytics must be passed the ID of the local user")

	local t2 = {
		_diagImpl = p1.Diag,
		_eventStreamImpl = p1.EventStream,
		localUserId = p2
	}

	setmetatable(t2, t1)

	return t2
end
function t1.navigate(p3, p4, _) -- line: 71
	-- upvalues: Logger (copy), t1 (copy)
	Logger:info("navigate to {}", p4)

	local v16 = t1.Navigation[p4]

	if v16 then
		p3._diagImpl:reportCounter(v16, 1)

		return
	end

	Logger:error("Error from navigate: Invalid destination '{}'", p4)
end
function t1.buttonClick(p6, p7, p8) -- line: 81
	-- upvalues: Logger (copy), llama (copy)
	Logger:info("eventName: buttonClick btn: {}{}", p7, p6:_toStringAdditionalArgs(p8))

	local v20 = llama.Dictionary.join(p8 or {}, {
		btn = p7,
		uid = p6.localUserId
	})

	p6._eventStreamImpl:setRBXEventStream("SocialTab", "buttonClick", v20)
end
function t1._toStringAdditionalArgs(_, p10) -- line: 93
	-- upvalues: tutils (copy)
	if not p10 then
		return ""
	end

	local result, _ = string.gsub(" args: " .. tutils.toString(p10), "%s+", " ")

	return result
end
function t1.pageLoaded(p11) -- line: 102
	-- upvalues: Logger (copy), t1 (copy)
	Logger:info("pageLoaded")

	local UserLoadedPage = t1.DiagCounters.UserLoadedPage

	p11._diagImpl:reportCounter(UserLoadedPage, 1)
end
function t1.userLoadedSocialTab(p12) -- line: 108
	-- upvalues: t1 (copy)
	local t3 = {
		uid = p12.localUserId
	}

	p12._eventStreamImpl:setRBXEventStream("roactChat", "userLoadedChat", t3)

	local UserLoadedSocialTab = t1.DiagCounters.UserLoadedSocialTab

	p12._diagImpl:reportCounter(UserLoadedSocialTab, 1)
end
function t1.openPlayerSearch(p13) -- line: 121
	-- upvalues: Sources (copy), LocalizationService (copy)
	local t4 = {
		act = "open",
		source = Sources.SocialTab,
		locale = LocalizationService.RobloxLocaleId
	}

	p13._eventStreamImpl:setRBXEventStream("players", "search", t4)
end

return t1
