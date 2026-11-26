local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/dependencies")
local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/EnumScreens")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsLanding/RobloxAppEnums").AppPage
local llama = dependencies.llama
local tutils = dependencies.tutils
local ButtonClickEvents = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingAnalytics/ButtonClickEvents")
local ImpressionEvents = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingAnalytics/ImpressionEvents")
local NavigatedFromPagesEnum = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingAnalytics/NavigatedFromPagesEnum")
local ShowMoreSectionTypeEnum = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/Enums/ShowMoreSectionTypeEnum")
local Logger = require("@game/CorePackages/Workspace/Packages/_Index/FriendsLanding/FriendsLanding/FriendsLandingAnalytics/Logger")

local class = {}
class.__index = class

class.DiagCounters = {
	UserLoadedPage = game:DefineFastString(
		"FriendsLandingUserLoadedPageCounter",
		"FriendsLandingUserLoadedPage"
	),
	ShowMoreButtonPressedFriends = game:DefineFastString(
		"ShowMoreButtonPressedFriends",
		"ShowMoreButtonPressedFriends"
	),
	ShowMoreButtonPressedFriendRequests = game:DefineFastString(
		"ShowMoreButtonPressedFriendRequests",
		"ShowMoreButtonPressedFriendRequests"
	)
}

class.Navigation = {
	[EnumScreens.AddFriends] = game:DefineFastString(
		"FriendsLandingNavigationAddFriendsCounter",
		"FriendsLandingNavigationAddFriends"
	),
	[EnumScreens.ViewUserProfile] = game:DefineFastString(
		"FriendsLandingNavigationViewUserProfileCounter",
		"FriendsLandingNavigationViewUserProfile"
	),
	[EnumScreens.GameDetailsPeekView] = game:DefineFastString(
		"FriendsLandingNavigationGameDetailsPeekViewCounter",
		"FriendsLandingNavigationGameDetailsPeekView"
	),
	[EnumScreens.SearchFriends] = game:DefineFastString(
		"FriendsLandingSearchFriendsCounter",
		"FriendsLandingSearchFriends"
	)
}

class.Navigation[appPage.Home] = game:DefineFastString("AddFriendsHomeEntryCounter", "AddFriendsHomeEntry")

class.Navigation.ViewUserProfileAddFriends = game:DefineFastString(
	"FriendsLandingViewUserProfileAddFriendsCounter",
	"FriendsLandingViewUserProfileAddFriends"
)

class.Navigation.ConnectWithFriends = game:DefineFastString(
	"AddFriendsConnectWithFriendsCounter",
	"AddFriendsConnectWithFriends"
)

class.DiagStats = {
	LoadingPageTime = game:DefineFastString(
		"FriendsLandingLoadingPageTimeStats",
		"FriendsLandingLoadingPageTime"
	),
	MountingPageTime = game:DefineFastString(
		"FriendsLandingMountingPageTimeStats",
		"FriendsLandingMountingPageTime"
	)
}

class.BASE_CONTEXT = "friendsLanding"

function class.new(p2, p3, p4)
	assert(p3, "FriendsLanding must be passed the ID of the local user")

	local v6 = {
		_diagImpl = p2.Diag,
		_eventStreamImpl = p2.EventStream,
		localUserId = p3,
		_getLoadingTimeInfo = p4,
		_reportedPagePerformanceOnce = {}
	}

	setmetatable(v6, class)

	return v6
end

function class:navigate(p3)
	Logger:info("navigate to {}", p3)
	local v6 = class.Navigation[p3]

	if v6 then
		self._diagImpl:reportCounter(v6, 1)
	else
		Logger:error("Error from navigate: Invalid destination '{}'", p3)
	end
end

function class:buttonClick(object2, options)
	assert(ButtonClickEvents.isEnumValue(object2), "invalid button name used")
	Logger:info("eventName: buttonClick btn: {}{}", object2, self:_toStringAdditionalArgs(options))

	local v6 = self.BASE_CONTEXT

	if options and options.contextOverride then
		v6 = options.contextOverride
	end

	local joined = llama.Dictionary.join(options or {}, {
		btn = object2:rawValue(),
		uid = self.localUserId,
		contextOverride = llama.None
	})

	self._eventStreamImpl:setRBXEventStream(v6, "buttonClick", joined)

	local v7 = nil

	if object2 == ButtonClickEvents.LoadMoreUsers then
		if joined.sectionType == ShowMoreSectionTypeEnum.FriendRequests then
			v7 = class.DiagCounters.ShowMoreButtonPressedFriendRequests
		elseif joined.sectionType == ShowMoreSectionTypeEnum.Friends then
			v7 = class.DiagCounters.ShowMoreButtonPressedFriends
		end
	end

	if v7 then
		self._diagImpl:reportCounter(v7, 1)
	end
end

function class:_toStringAdditionalArgs(p3)
	if not p3 then
		return ""
	end

	local v6, v7 = string.gsub(" args: " .. tutils.toString(p3), "%s+", " ")
	return v6
end

function class:pageLoaded()
	Logger:info("pageLoaded")
	local userLoadedPage = class.DiagCounters.UserLoadedPage
	self._diagImpl:reportCounter(userLoadedPage, 1)
end

function class:pageLoadedWithArgs(p3, p4)
	self._eventStreamImpl:setRBXEventStream(p3 or self.BASE_CONTEXT, "luaPageLoad", p4)
end

function class:_pagePerformanceReport(p2, p3, p4)
	local v6 = p4 or os.clock()
	local v7 = self._getLoadingTimeInfo and self._getLoadingTimeInfo() or {}
	local startPage = v7.startPage
	local startTime = v7.startTime

	if not NavigatedFromPagesEnum.fromRawValue(startPage) or type(startTime) ~= "number" then
		Logger:warning("Cannot report loading time: incorrect startPage or startTime")
		return
	end

	local v8 = (v6 - startTime) * 1000
	local rawValue = NavigatedFromPagesEnum[startPage].rawValue()
	local v9 = p2 .. "_" .. rawValue

	local v10 = { startPage = rawValue, loadingTime = v8, uid = self.localUserId }

	Logger:info("pageLoaded in " .. v8 .. "ms")
	self._diagImpl:reportStats(v9, v8)
	self._eventStreamImpl:setRBXEventStream(self.BASE_CONTEXT, p3, v10)
end

function class:_reportPagePerformanceOnceCheck(p3): boolean
	if self._reportedPagePerformanceOnce[p3] then
		return true
	end

	self._reportedPagePerformanceOnce[p3] = true
	return false
end

function class:pageMountingTimeReport(p2)
	if self:_reportPagePerformanceOnceCheck("pageMountingTime") then
		return
	end

	self:_pagePerformanceReport(class.DiagStats.MountingPageTime, "pageMountingTime", p2)
end

function class:pageLoadingTimeReport(p2)
	if self:_reportPagePerformanceOnceCheck("pageLoadingTime") then
		return
	end

	self:_pagePerformanceReport(class.DiagStats.LoadingPageTime, "pageLoadingTime", p2)
end

function class:reportAddFriendsEntrypoint(p3, p4)
	assert(class.Navigation[p3] ~= nil, "invalid screen")

	if p3 == appPage.Home then
		local eventStreamImpl = self._eventStreamImpl

		local v9 = if p4 then p4.showContactImporterModal else nil
		eventStreamImpl:setRBXEventStream("addUniversalFriends", "buttonClick", {
			btn = "LegacyAddFriendsButton",
			absolutePosition = 1,
			showContactImporterModal = v9
		})
	end

	self._diagImpl:reportCounter(class.Navigation[p3], 1)
end

function class:impressionEvent(object, p3)
	assert(ImpressionEvents.isEnumValue(object), "invalid impression name used")

	self._eventStreamImpl:setRBXEventStream("addUniversalFriends", object:rawValue(), p3)
	self._diagImpl:reportCounter(object:rawValue(), 1)
end

return class
