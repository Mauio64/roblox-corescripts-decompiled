local ixpServiceWrapper = require("@luauforge/deferred/eit").IXPServiceWrapper

local module = require("@luauforge/deferred/eiu")

local eventNames = module.EventNames
local module2 = require("@luauforge/deferred/eiF")

local module3 = require("@luauforge/deferred/eiJ")
local module4 = require("@luauforge/deferred/eil")

local RelationshipTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/UserRelationshipModals/UserRelationshipModals/Analytics/RelationshipTypes")

local useLoadingTimers = require("@luauforge/deferred/eiw").Analytics.Timing.useLoadingTimers

local module6 = require("@luauforge/deferred/eiL")
local module7 = require("@luauforge/deferred/emC")

require("@luauforge/deferred/elP")

local appUserLayers = require("@luauforge/deferred/emE").AppUserLayers
local fFlagAddFriendsSessionId = require("@luauforge/deferred/eiz").FFlagAddFriendsSessionId
local fFlagAddFriendsPageFAEUpsell = require("@luauforge/deferred/eiz").FFlagAddFriendsPageFAEUpsell

local function AddFriendsContainer(p2)
	if fFlagAddFriendsPageFAEUpsell then
		module7()
	end

	local v5 = module.useFireAnalyticsEvent()

	local v6 = useLoadingTimers({})
	module4.useEffect(function()
		v6.start("add_friends_page_load")
	end, {})

	local v7 = module4.useCallback(function(p3)
		local v8 = v6.stop("add_friends_page_load")

		v5(eventNames.AddFriendsPageLoadingTime, {
			status = "Done",
			loadingTime = v8,
			statValue = v8
		})

		v5(eventNames.PageLoad, {
			recommendationCount = p3[RelationshipTypes.FriendRecommendations] or 0,
			status = "Done"
		})
	end, { v5, v6 })

	module4.useMemo(function()
		if fFlagAddFriendsSessionId then
			module2.initializeSession()
		end
	end, {})

	local v8 = module4.useCallback(function()
		if fFlagAddFriendsSessionId then
			module2.initializeSession()
		end

		return module3.resolve()
	end, {})

	local v9 = module4.useCallback(function()
		v5(eventNames.UserSearchClick)
	end, { v5 })

	module4.useEffect(function()
		ixpServiceWrapper:LogFlagLinkedUserLayerExposure(appUserLayers.ConnectionsHubExposureLayer)

		return function()
			if fFlagAddFriendsSessionId then
				module2.destroySession()
			end
		end
	end, {})

	return module4.createElement(module6, {
		navigateToLuaAppPages = p2.navigateToLuaAppPages,
		refreshPage = v8,
		fireSearchbarPressedEvent = v9,
		fireSectionsPageLoadEvents = v7
	})
end

return AddFriendsContainer
