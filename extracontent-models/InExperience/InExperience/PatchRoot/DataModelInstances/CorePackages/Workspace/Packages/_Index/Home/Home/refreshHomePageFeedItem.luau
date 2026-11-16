local Home = script:FindFirstAncestor("Home")
local parent = Home.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local Promise = require(parent.Promise)
require(parent.SduiCoreSystem)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer

local fetchHomePage = require(Home.fetchHomePage)

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiRefreshFeedItemIsOmissionExpected = SharedFlags.FFlagSduiRefreshFeedItemIsOmissionExpected

local function refreshHomePageFeedItem(topicId: string, feedItemKey: string, requestIntent: string, reportError, p)
	local loadTimer = SduiLoadTimer.createLoadTimer(AppPage.Home)
	loadTimer.start("feed-item-refresh")

	local v = {
		requestIntent = requestIntent,
		contextualFeatures = p.contextFeatures,
		focusedRefresh = 0
	}
	local isOmissionExpected

	if FFlagSduiRefreshFeedItemIsOmissionExpected then
		isOmissionExpected = p.isOmissionExpected
	end

	v.focusedRefresh = {
		topicId = topicId,
		feedItemKey = feedItemKey,
		reportError = reportError,
		isOmissionExpected = isOmissionExpected
	}
	return fetchHomePage(loadTimer, v):andThen(function(p2)
		loadTimer.logRefreshComplete()
		return p2
	end, function(p2)
		loadTimer.logRefreshComplete()
		return Promise.reject(p2)
	end)
end

return refreshHomePageFeedItem
