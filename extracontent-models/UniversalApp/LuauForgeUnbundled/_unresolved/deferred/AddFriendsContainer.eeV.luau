local ixpServiceWrapper = require("@luauforge/deferred/eeW").IXPServiceWrapper

local module = require("@luauforge/deferred/eeX")

local analyticsSetup = module.AnalyticsSetup
local eventNames = module.EventNames
local module2 = require("@luauforge/deferred/efQ")

local module3 = require("@luauforge/deferred/efU")
local module4 = require("@luauforge/deferred/eeO")
local useSelector = require("@luauforge/deferred/efh").Hooks.RoactRodux.useSelector
local module5 = require("@luauforge/deferred/efj")

local useLocalUserId = require("@luauforge/deferred/efV").useLocalUserId

local roduxAnalytics = module5.RoduxAnalytics

local RECOMMENDATION_SESSION_ID_KEY = require("@luauforge/deferred/efP").RECOMMENDATION_SESSION_ID_KEY
local getSessionIdByKey = roduxAnalytics.Selectors.getSessionIdByKey
local RelationshipTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/UserRelationshipModals/UserRelationshipModals/Analytics/RelationshipTypes")

local useLoadingTimers = require("@luauforge/deferred/eeZ").Analytics.Timing.useLoadingTimers

local module7 = require("@luauforge/deferred/efX")
local module8 = require("@luauforge/deferred/ejh")

require("@luauforge/deferred/eiu")

local appUserLayers = require("@luauforge/deferred/ejj").AppUserLayers
local fFlagAddFriendsSessionId = require("@luauforge/deferred/efc").FFlagAddFriendsSessionId
local fFlagAddFriendsPageFAEUpsell = require("@luauforge/deferred/efc").FFlagAddFriendsPageFAEUpsell
local fFlagAddFriendsPymkSessionService = require("@luauforge/deferred/efc").FFlagAddFriendsPymkSessionService

local function AddFriendsContainer(p2)
	if fFlagAddFriendsPageFAEUpsell then
		module8()
	end

	local v5 = useLocalUserId()
	local v6

	if fFlagAddFriendsPymkSessionService then
		v6 = nil
	else
		v6 = useSelector(function(p3)
			return getSessionIdByKey(p3)(RECOMMENDATION_SESSION_ID_KEY)
		end)
	end

	local v7

	if fFlagAddFriendsPymkSessionService then
		v7 = module.useFireAnalyticsEvent()
	else
		v7 = module4.useMemo(function()
			return analyticsSetup({
				infoForAllEvents = { uid = v5, recommendationSessionId = v6 }
			}).fireAnalyticsEvent
		end, { v5, v6 })
	end

	local v8 = useLoadingTimers({})
	module4.useEffect(function()
		v8.start("add_friends_page_load")
	end, {})

	local v9 = module4.useCallback(function(p3)
		local v10 = v8.stop("add_friends_page_load")

		v7(eventNames.AddFriendsPageLoadingTime, {
			status = "Done",
			loadingTime = v10,
			statValue = v10
		})

		v7(eventNames.PageLoad, {
			recommendationCount = p3[RelationshipTypes.FriendRecommendations] or 0,
			status = "Done"
		})
	end, { v7, v8 })

	module4.useMemo(function()
		if fFlagAddFriendsSessionId then
			module2.initializeSession()
		end
	end, {})

	local v10 = module4.useCallback(function()
		if fFlagAddFriendsSessionId then
			module2.initializeSession()
		end

		return module3.resolve()
	end, {})

	local v11 = module4.useCallback(function()
		v7(eventNames.UserSearchClick)
	end, { v7 })

	module4.useEffect(function()
		ixpServiceWrapper:LogFlagLinkedUserLayerExposure(appUserLayers.ConnectionsHubExposureLayer)

		return function()
			if fFlagAddFriendsSessionId then
				module2.destroySession()
			end
		end
	end, {})

	return module4.createElement(module7, {
		navigateToLuaAppPages = p2.navigateToLuaAppPages,
		refreshPage = v10,
		fireSearchbarPressedEvent = v11,
		fireSectionsPageLoadEvents = v9
	})
end

return AddFriendsContainer
