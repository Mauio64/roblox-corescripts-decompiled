local parent = script:FindFirstAncestor("GameJoinCard").Parent

local TimeToInteractiveTracker = require(parent.TimeToInteractiveTracker)
local timeToInteractiveTracker = TimeToInteractiveTracker.TimeToInteractiveTracker
local SharedFlags = require(parent.SharedFlags)

local FFlagMobileGameJoinCardTTITracking = SharedFlags.FFlagMobileGameJoinCardTTITracking

local eventName = {
	MobileCardMounted = "MobileGameJoinCardOpened_Mounted",
	MobileBannerMounted = "MobileGameJoinCardOpened_BannerLoaded",
	PeopleListMounted = "PeopleListContextualMenuOpen_Mounted"
}

local surface = {
	MobileGameJoinCard = "mobile_game_join_card",
	PeopleListContextualMenu = "people_list_contextual_menu"
}

local GameJoinCardTTI = {}
GameJoinCardTTI.EventName = eventName
GameJoinCardTTI.Surface = surface
local v = nil

function GameJoinCardTTI.trackMobileCardClickStart()
	v = tick() * 1000

	if not FFlagMobileGameJoinCardTTITracking then
		return
	end

	timeToInteractiveTracker.trackStart(eventName.MobileCardMounted, true)
	timeToInteractiveTracker.updateMetadata(eventName.MobileCardMounted, {
		category = "social_game_join_card",
		page = surface.MobileGameJoinCard
	})

	timeToInteractiveTracker.trackStart(eventName.MobileBannerMounted, true)
	timeToInteractiveTracker.updateMetadata(eventName.MobileBannerMounted, {
		category = "social_game_join_card",
		page = surface.MobileGameJoinCard
	})
end

function GameJoinCardTTI.consumeMobileCardClickStartMs()
	local v2 = v
	v = nil
	return v2
end

function GameJoinCardTTI.trackCardMounted()
	if not FFlagMobileGameJoinCardTTITracking then
		return
	end

	timeToInteractiveTracker.trackEnd(eventName.MobileCardMounted)
end

function GameJoinCardTTI.trackBannerLoaded()
	if not FFlagMobileGameJoinCardTTITracking then
		return
	end

	timeToInteractiveTracker.trackEnd(eventName.MobileBannerMounted)
end

function GameJoinCardTTI.trackPeopleListClickStart()
	if not FFlagMobileGameJoinCardTTITracking then
		return
	end

	timeToInteractiveTracker.trackStart(eventName.PeopleListMounted, true)
	timeToInteractiveTracker.updateMetadata(eventName.PeopleListMounted, {
		category = "social_game_join_card",
		page = surface.PeopleListContextualMenu
	})
end

function GameJoinCardTTI.trackPeopleListMounted()
	if not FFlagMobileGameJoinCardTTITracking then
		return
	end

	timeToInteractiveTracker.trackEnd(eventName.PeopleListMounted)
end

return GameJoinCardTTI
