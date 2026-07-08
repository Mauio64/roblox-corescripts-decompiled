local FriendsLanding = script:FindFirstAncestor("FriendsLanding")
local FriendsLandingParent = FriendsLanding.Parent
local dependencies = require(FriendsLanding.dependencies)
local EnumScreens = require(FriendsLanding.EnumScreens)
local AppPage = require(FriendsLandingParent.RobloxAppEnums).AppPage
local llama = dependencies.llama
local tutils = dependencies.tutils
local ButtonClickEvents = require(script.Parent.ButtonClickEvents)
local ImpressionEvents = require(script.Parent.ImpressionEvents)
local NavigatedFromPagesEnum = require(script.Parent.NavigatedFromPagesEnum)
local ShowMoreSectionTypeEnum = require(FriendsLanding.Enums.ShowMoreSectionTypeEnum)
local Logger = require(script.Parent.Logger)
local t1 = {}

t1.__index = t1
t1.DiagCounters = {
	UserLoadedPage = game:DefineFastString("FriendsLandingUserLoadedPageCounter", "FriendsLandingUserLoadedPage"),
	ShowMoreButtonPressedFriends = game:DefineFastString("ShowMoreButtonPressedFriends", "ShowMoreButtonPressedFriends"),
	ShowMoreButtonPressedFriendRequests = game:DefineFastString("ShowMoreButtonPressedFriendRequests", "ShowMoreButtonPressedFriendRequests")
}
t1.Navigation = {
	[EnumScreens.AddFriends] = game:DefineFastString("FriendsLandingNavigationAddFriendsCounter", "FriendsLandingNavigationAddFriends"),
	[EnumScreens.ViewUserProfile] = game:DefineFastString("FriendsLandingNavigationViewUserProfileCounter", "FriendsLandingNavigationViewUserProfile"),
	[EnumScreens.GameDetailsPeekView] = game:DefineFastString("FriendsLandingNavigationGameDetailsPeekViewCounter", "FriendsLandingNavigationGameDetailsPeekView"),
	[EnumScreens.SearchFriends] = game:DefineFastString("FriendsLandingSearchFriendsCounter", "FriendsLandingSearchFriends")
}
t1.Navigation[AppPage.Home] = game:DefineFastString("AddFriendsHomeEntryCounter", "AddFriendsHomeEntry")
t1.Navigation.ViewUserProfileAddFriends = game:DefineFastString("FriendsLandingViewUserProfileAddFriendsCounter", "FriendsLandingViewUserProfileAddFriends")
t1.Navigation.ConnectWithFriends = game:DefineFastString("AddFriendsConnectWithFriendsCounter", "AddFriendsConnectWithFriends")
t1.DiagStats = {
	LoadingPageTime = game:DefineFastString("FriendsLandingLoadingPageTimeStats", "FriendsLandingLoadingPageTime"),
	MountingPageTime = game:DefineFastString("FriendsLandingMountingPageTimeStats", "FriendsLandingMountingPageTime")
}
t1.BASE_CONTEXT = "friendsLanding"

function t1.new(p1, p2, p3) -- line: 71
	-- upvalues: t1 (copy)
	assert(p2, "FriendsLanding must be passed the ID of the local user")

	local t2 = {
		_diagImpl = p1.Diag,
		_eventStreamImpl = p1.EventStream,
		localUserId = p2,
		_getLoadingTimeInfo = p3,
		_reportedPagePerformanceOnce = {}
	}

	setmetatable(t2, t1)

	return t2
end
function t1.navigate(p4, p5) -- line: 87
	-- upvalues: Logger (copy), t1 (copy)
	Logger:info("navigate to {}", p5)

	local v20 = t1.Navigation[p5]

	if v20 then
		p4._diagImpl:reportCounter(v20, 1)

		return
	end

	Logger:error("Error from navigate: Invalid destination '{}'", p5)
end
function t1.buttonClick(p6, p7, p8) -- line: 97
	-- upvalues: ButtonClickEvents (copy), Logger (copy), llama (copy), ShowMoreSectionTypeEnum (copy), t1 (copy)
	assert(ButtonClickEvents.isEnumValue(p7), "invalid button name used")
	Logger:info("eventName: buttonClick btn: {}{}", p7, p6:_toStringAdditionalArgs(p8))

	local BASE_CONTEXT = p6.BASE_CONTEXT

	if p8 and p8.contextOverride then
		BASE_CONTEXT = p8.contextOverride
	end

	local v25 = llama.Dictionary.join(p8 or {}, {
		btn = p7:rawValue(),
		uid = p6.localUserId,
		contextOverride = llama.None
	})

	p6._eventStreamImpl:setRBXEventStream(BASE_CONTEXT, "buttonClick", v25)

	local ShowMoreButtonPressedFriendRequests = nil

	if p7 == ButtonClickEvents.LoadMoreUsers then
		if v25.sectionType == ShowMoreSectionTypeEnum.FriendRequests then
			ShowMoreButtonPressedFriendRequests = t1.DiagCounters.ShowMoreButtonPressedFriendRequests
		elseif v25.sectionType == ShowMoreSectionTypeEnum.Friends then
			ShowMoreButtonPressedFriendRequests = t1.DiagCounters.ShowMoreButtonPressedFriends
		end
	end

	if ShowMoreButtonPressedFriendRequests then
		p6._diagImpl:reportCounter(ShowMoreButtonPressedFriendRequests, 1)
	end
end
function t1._toStringAdditionalArgs(_, p10) -- line: 127
	-- upvalues: tutils (copy)
	if not p10 then
		return ""
	end

	local result, _ = string.gsub(" args: " .. tutils.toString(p10), "%s+", " ")

	return result
end
function t1.pageLoaded(p11) -- line: 136
	-- upvalues: Logger (copy), t1 (copy)
	Logger:info("pageLoaded")

	local UserLoadedPage = t1.DiagCounters.UserLoadedPage

	p11._diagImpl:reportCounter(UserLoadedPage, 1)
end
function t1.pageLoadedWithArgs(p12, p13, p14) -- line: 142
	p12._eventStreamImpl:setRBXEventStream(p13 or p12.BASE_CONTEXT, "luaPageLoad", p14)
end
function t1._pagePerformanceReport(p15, p16, p17, p18) -- line: 147
	-- upvalues: NavigatedFromPagesEnum (copy), Logger (copy)
	local v40 = p18 or os.clock()
	local v41 = p15._getLoadingTimeInfo and p15._getLoadingTimeInfo() or {}
	local startPage = v41.startPage
	local startTime = v41.startTime

	if not NavigatedFromPagesEnum.fromRawValue(startPage) or type(startTime) ~= "number" then
		Logger:warning("Cannot report loading time: incorrect startPage or startTime")

		return
	end

	local v44 = (v40 - startTime) * 1000
	local v45 = NavigatedFromPagesEnum[startPage].rawValue()
	local v46 = p16 .. "_" .. v45
	local t3 = {
		startPage = v45,
		loadingTime = v44,
		uid = p15.localUserId
	}

	Logger:info("pageLoaded in " .. v44 .. "ms")
	p15._diagImpl:reportStats(v46, v44)
	p15._eventStreamImpl:setRBXEventStream(p15.BASE_CONTEXT, p17, t3)
end
function t1._reportPagePerformanceOnceCheck(p19, p20) -- line: 173
	if p19._reportedPagePerformanceOnce[p20] then
		return true
	end

	p19._reportedPagePerformanceOnce[p20] = true

	return false
end
function t1.pageMountingTimeReport(p21, p22) -- line: 181
	-- upvalues: t1 (copy)
	if p21:_reportPagePerformanceOnceCheck("pageMountingTime") then
		return
	end

	p21:_pagePerformanceReport(t1.DiagStats.MountingPageTime, "pageMountingTime", p22)
end
function t1.pageLoadingTimeReport(p23, p24) -- line: 189
	-- upvalues: t1 (copy)
	if p23:_reportPagePerformanceOnceCheck("pageLoadingTime") then
		return
	end

	p23:_pagePerformanceReport(t1.DiagStats.LoadingPageTime, "pageLoadingTime", p24)
end
function t1.reportAddFriendsEntrypoint(p25, p26, p27) -- line: 197
	-- upvalues: t1 (copy), AppPage (copy)
	assert(t1.Navigation[p26] ~= nil, "invalid screen")

	if p26 == AppPage.Home then
		p25._eventStreamImpl:setRBXEventStream("addUniversalFriends", "buttonClick", {
			btn = "LegacyAddFriendsButton",
			absolutePosition = 1,
			showContactImporterModal = if not p27 then nil else p27.showContactImporterModal
		})
	end

	p25._diagImpl:reportCounter(t1.Navigation[p26], 1)
end
function t1.impressionEvent(p28, p29, p30) -- line: 209
	-- upvalues: ImpressionEvents (copy)
	assert(ImpressionEvents.isEnumValue(p29), "invalid impression name used")
	p28._eventStreamImpl:setRBXEventStream("addUniversalFriends", p29:rawValue(), p30)
	p28._diagImpl:reportCounter(p29:rawValue(), 1)
end

return t1
