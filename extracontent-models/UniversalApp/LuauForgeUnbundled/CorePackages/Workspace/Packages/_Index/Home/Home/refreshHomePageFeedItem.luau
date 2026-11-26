local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/RobloxAppEnums").AppPage
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SduiCoreSystem")
local sduiLoadTimer = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SduiSharedUtilities").SduiLoadTimer

local fetchHomePage = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/fetchHomePage")

local fFlagSduiRefreshFeedItemIsOmissionExpected = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SharedFlags").FFlagSduiRefreshFeedItemIsOmissionExpected

local function refreshHomePageFeedItem(p2, p3, p4, p5, p6)
	local loadTimer = sduiLoadTimer.createLoadTimer(appPage.Home)
	loadTimer.start("feed-item-refresh")

	local v6 = {
		requestIntent = p4,
		contextualFeatures = p6.contextFeatures,
		focusedRefresh = 0
	}

	local v8 = if fFlagSduiRefreshFeedItemIsOmissionExpected then p6.isOmissionExpected else nil
	v6.focusedRefresh = {
		topicId = p2,
		feedItemKey = p3,
		reportError = p5,
		isOmissionExpected = v8
	}
	return fetchHomePage(loadTimer, v6):andThen(function(p7)
		loadTimer.logRefreshComplete()
		return p7
	end, function(p7)
		loadTimer.logRefreshComplete()
		return Promise.reject(p7)
	end)
end

return refreshHomePageFeedItem
