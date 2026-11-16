local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local parent = FriendsLanding.Parent

local dependencies = require(FriendsLanding.dependencies)
local EnumScreens = require(FriendsLanding.EnumScreens)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local llama = dependencies.llama
local tutils = dependencies.tutils
local ButtonClickEvents = require(script.Parent.ButtonClickEvents)
local ImpressionEvents = require(script.Parent.ImpressionEvents)
local NavigatedFromPagesEnum = require(script.Parent.NavigatedFromPagesEnum)
local ShowMoreSectionTypeEnum = require(FriendsLanding.Enums.ShowMoreSectionTypeEnum)
local Logger = require(script.Parent.Logger)

local FriendsLandingAnalytics = {}
FriendsLandingAnalytics.__index = FriendsLandingAnalytics

FriendsLandingAnalytics.DiagCounters = {
	UserLoadedPage = game:DefineFastString("FriendsLandingUserLoadedPageCounter", "FriendsLandingUserLoadedPage"),
	ShowMoreButtonPressedFriends = game:DefineFastString("ShowMoreButtonPressedFriends", "ShowMoreButtonPressedFriends"),
	ShowMoreButtonPressedFriendRequests = game:DefineFastString(
		"ShowMoreButtonPressedFriendRequests",
		"ShowMoreButtonPressedFriendRequests"
	)
}

FriendsLandingAnalytics.Navigation = {
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

FriendsLandingAnalytics.Navigation[AppPage.Home] = game:DefineFastString(
	"AddFriendsHomeEntryCounter",
	"AddFriendsHomeEntry"
)

FriendsLandingAnalytics.Navigation.ViewUserProfileAddFriends = game:DefineFastString(
	"FriendsLandingViewUserProfileAddFriendsCounter",
	"FriendsLandingViewUserProfileAddFriends"
)

FriendsLandingAnalytics.Navigation.ConnectWithFriends = game:DefineFastString(
	"AddFriendsConnectWithFriendsCounter",
	"AddFriendsConnectWithFriends"
)

FriendsLandingAnalytics.DiagStats = {
	LoadingPageTime = game:DefineFastString("FriendsLandingLoadingPageTimeStats", "FriendsLandingLoadingPageTime"),
	MountingPageTime = game:DefineFastString("FriendsLandingMountingPageTimeStats", "FriendsLandingMountingPageTime")
}

FriendsLandingAnalytics.BASE_CONTEXT = "friendsLanding"

function FriendsLandingAnalytics.new(p, localUserId, getLoadingTimeInfo)
	assert(localUserId, "FriendsLanding must be passed the ID of the local user")

	local v = {
		_diagImpl = p.Diag,
		_eventStreamImpl = p.EventStream,
		localUserId = localUserId,
		_getLoadingTimeInfo = getLoadingTimeInfo,
		_reportedPagePerformanceOnce = {}
	}

	setmetatable(v, FriendsLandingAnalytics)

	return v
end

function FriendsLandingAnalytics:navigate(p)
	Logger:info("navigate to {}", p)
	local v = FriendsLandingAnalytics.Navigation[p]

	if v then
		self._diagImpl:reportCounter(v, 1)
	else
		Logger:error("Error from navigate: Invalid destination '{}'", p)
	end
end

function FriendsLandingAnalytics:buttonClick(object, options)
	assert(ButtonClickEvents.isEnumValue(object), "invalid button name used")
	Logger:info("eventName: buttonClick btn: {}{}", object, self:_toStringAdditionalArgs(options))

	local v = self.BASE_CONTEXT

	if options and options.contextOverride then
		v = options.contextOverride
	end

	local joined = llama.Dictionary.join(options or {}, {
		btn = object:rawValue(),
		uid = self.localUserId,
		contextOverride = llama.None
	})

	self._eventStreamImpl:setRBXEventStream(v, "buttonClick", joined)

	local v2 = nil

	if object == ButtonClickEvents.LoadMoreUsers then
		if joined.sectionType == ShowMoreSectionTypeEnum.FriendRequests then
			v2 = FriendsLandingAnalytics.DiagCounters.ShowMoreButtonPressedFriendRequests
		elseif joined.sectionType == ShowMoreSectionTypeEnum.Friends then
			v2 = FriendsLandingAnalytics.DiagCounters.ShowMoreButtonPressedFriends
		end
	end

	if v2 then
		self._diagImpl:reportCounter(v2, 1)
	end
end

function FriendsLandingAnalytics:_toStringAdditionalArgs(p)
	if not p then
		return ""
	end

	local v, _ = string.gsub(" args: " .. tutils.toString(p), "%s+", " ")
	return v
end

function FriendsLandingAnalytics:pageLoaded()
	Logger:info("pageLoaded")
	local userLoadedPage = FriendsLandingAnalytics.DiagCounters.UserLoadedPage
	self._diagImpl:reportCounter(userLoadedPage, 1)
end

function FriendsLandingAnalytics:pageLoadedWithArgs(p, p2)
	self._eventStreamImpl:setRBXEventStream(p or self.BASE_CONTEXT, "luaPageLoad", p2)
end

function FriendsLandingAnalytics:_pagePerformanceReport(p, p2, p3)
	local v = p3 or os.clock()
	local v2 = self._getLoadingTimeInfo and self._getLoadingTimeInfo() or {}
	local startPage = v2.startPage
	local startTime = v2.startTime

	if not NavigatedFromPagesEnum.fromRawValue(startPage) or type(startTime) ~= "number" then
		Logger:warning("Cannot report loading time: incorrect startPage or startTime")
		return
	end

	local loadingTime = (v - startTime) * 1000
	local rawValue = NavigatedFromPagesEnum[startPage].rawValue()
	local v3 = p .. "_" .. rawValue

	local v4 = { startPage = rawValue, loadingTime = loadingTime, uid = self.localUserId }

	Logger:info("pageLoaded in " .. loadingTime .. "ms")
	self._diagImpl:reportStats(v3, loadingTime)
	self._eventStreamImpl:setRBXEventStream(self.BASE_CONTEXT, p2, v4)
end

function FriendsLandingAnalytics:_reportPagePerformanceOnceCheck(p): boolean
	if self._reportedPagePerformanceOnce[p] then
		return true
	end

	self._reportedPagePerformanceOnce[p] = true
	return false
end

function FriendsLandingAnalytics:pageMountingTimeReport(p)
	if self:_reportPagePerformanceOnceCheck("pageMountingTime") then
		return
	end

	self:_pagePerformanceReport(FriendsLandingAnalytics.DiagStats.MountingPageTime, "pageMountingTime", p)
end

function FriendsLandingAnalytics:pageLoadingTimeReport(p)
	if self:_reportPagePerformanceOnceCheck("pageLoadingTime") then
		return
	end

	self:_pagePerformanceReport(FriendsLandingAnalytics.DiagStats.LoadingPageTime, "pageLoadingTime", p)
end

function FriendsLandingAnalytics:reportAddFriendsEntrypoint(p, p2)
	assert(FriendsLandingAnalytics.Navigation[p] ~= nil, "invalid screen")

	if p == AppPage.Home then
		local eventStreamImpl = self._eventStreamImpl
		local showContactImporterModal

		if p2 then
			showContactImporterModal = p2.showContactImporterModal
		end

		eventStreamImpl:setRBXEventStream("addUniversalFriends", "buttonClick", {
			btn = "LegacyAddFriendsButton",
			absolutePosition = 1,
			showContactImporterModal = showContactImporterModal
		})
	end

	self._diagImpl:reportCounter(FriendsLandingAnalytics.Navigation[p], 1)
end

function FriendsLandingAnalytics:impressionEvent(object, p)
	assert(ImpressionEvents.isEnumValue(object), "invalid impression name used")

	self._eventStreamImpl:setRBXEventStream("addUniversalFriends", object:rawValue(), p)
	self._diagImpl:reportCounter(object:rawValue(), 1)
end

return FriendsLandingAnalytics
