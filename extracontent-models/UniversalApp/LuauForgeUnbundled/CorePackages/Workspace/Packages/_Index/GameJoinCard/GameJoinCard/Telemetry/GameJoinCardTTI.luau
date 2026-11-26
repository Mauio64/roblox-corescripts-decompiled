local timeToInteractiveTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/TimeToInteractiveTracker").TimeToInteractiveTracker
local fFlagMobileGameJoinCardTTITracking = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags").FFlagMobileGameJoinCardTTITracking

local v5 = {
	MobileCardMounted = "MobileGameJoinCardOpened_Mounted",
	MobileBannerMounted = "MobileGameJoinCardOpened_BannerLoaded",
	PeopleListMounted = "PeopleListContextualMenuOpen_Mounted"
}

local v6 = {
	MobileGameJoinCard = "mobile_game_join_card",
	PeopleListContextualMenu = "people_list_contextual_menu"
}

local v7 = {}
v7.EventName = v5
v7.Surface = v6
local v8 = nil

function v7.trackMobileCardClickStart()
	v8 = tick() * 1000

	if not fFlagMobileGameJoinCardTTITracking then
		return
	end

	timeToInteractiveTracker.trackStart(v5.MobileCardMounted, true)
	timeToInteractiveTracker.updateMetadata(v5.MobileCardMounted, {
		category = "social_game_join_card",
		page = v6.MobileGameJoinCard
	})

	timeToInteractiveTracker.trackStart(v5.MobileBannerMounted, true)
	timeToInteractiveTracker.updateMetadata(v5.MobileBannerMounted, {
		category = "social_game_join_card",
		page = v6.MobileGameJoinCard
	})
end

function v7.consumeMobileCardClickStartMs()
	local v9 = v8
	v8 = nil
	return v9
end

function v7.trackCardMounted()
	if not fFlagMobileGameJoinCardTTITracking then
		return
	end

	timeToInteractiveTracker.trackEnd(v5.MobileCardMounted)
end

function v7.trackBannerLoaded()
	if not fFlagMobileGameJoinCardTTITracking then
		return
	end

	timeToInteractiveTracker.trackEnd(v5.MobileBannerMounted)
end

function v7.trackPeopleListClickStart()
	if not fFlagMobileGameJoinCardTTITracking then
		return
	end

	timeToInteractiveTracker.trackStart(v5.PeopleListMounted, true)
	timeToInteractiveTracker.updateMetadata(v5.PeopleListMounted, {
		category = "social_game_join_card",
		page = v6.PeopleListContextualMenu
	})
end

function v7.trackPeopleListMounted()
	if not fFlagMobileGameJoinCardTTITracking then
		return
	end

	timeToInteractiveTracker.trackEnd(v5.PeopleListMounted)
end

return v7
