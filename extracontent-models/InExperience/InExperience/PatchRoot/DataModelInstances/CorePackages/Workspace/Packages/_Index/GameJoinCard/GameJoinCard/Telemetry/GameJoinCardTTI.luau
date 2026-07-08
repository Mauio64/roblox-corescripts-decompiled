local Parent = script:FindFirstAncestor("GameJoinCard").Parent
local TimeToInteractiveTracker = require(Parent.TimeToInteractiveTracker).TimeToInteractiveTracker
local SharedFlags = require(Parent.SharedFlags)
local FFlagMobileGameJoinCardTTITracking = SharedFlags.FFlagMobileGameJoinCardTTITracking
local FFlagJoinCardAgeCheckUpsell = SharedFlags.FFlagJoinCardAgeCheckUpsell
local t1 = {
	MobileCardMounted = "MobileGameJoinCardOpened_Mounted",
	MobileBannerMounted = "MobileGameJoinCardOpened_BannerLoaded",
	PeopleListMounted = "PeopleListContextualMenuOpen_Mounted"
}
local t2 = {
	MobileGameJoinCard = "mobile_game_join_card",
	PeopleListContextualMenu = "people_list_contextual_menu"
}
local t3 = {
	EventName = t1,
	Surface = t2
}
local u9 = nil

function t3.trackMobileCardClickStart() -- line: 52
	-- upvalues: FFlagJoinCardAgeCheckUpsell (copy), u9 (ref), FFlagMobileGameJoinCardTTITracking (copy), TimeToInteractiveTracker (copy), t1 (copy), t2 (copy)
	if FFlagJoinCardAgeCheckUpsell then
		u9 = tick() * 1000
	end

	if not FFlagMobileGameJoinCardTTITracking then
		return
	end

	TimeToInteractiveTracker.trackStart(t1.MobileCardMounted, true)
	TimeToInteractiveTracker.updateMetadata(t1.MobileCardMounted, {
		category = "social_game_join_card",
		page = t2.MobileGameJoinCard
	})
	TimeToInteractiveTracker.trackStart(t1.MobileBannerMounted, true)
	TimeToInteractiveTracker.updateMetadata(t1.MobileBannerMounted, {
		category = "social_game_join_card",
		page = t2.MobileGameJoinCard
	})
end
function t3.consumeMobileCardClickStartMs() -- line: 74
	-- upvalues: u9 (ref)
	local v10 = u9

	u9 = nil

	return v10
end
function t3.trackCardMounted() -- line: 80
	-- upvalues: FFlagMobileGameJoinCardTTITracking (copy), TimeToInteractiveTracker (copy), t1 (copy)
	if not FFlagMobileGameJoinCardTTITracking then
		return
	end

	TimeToInteractiveTracker.trackEnd(t1.MobileCardMounted)
end
function t3.trackBannerLoaded() -- line: 88
	-- upvalues: FFlagMobileGameJoinCardTTITracking (copy), TimeToInteractiveTracker (copy), t1 (copy)
	if not FFlagMobileGameJoinCardTTITracking then
		return
	end

	TimeToInteractiveTracker.trackEnd(t1.MobileBannerMounted)
end
function t3.trackPeopleListClickStart() -- line: 96
	-- upvalues: FFlagMobileGameJoinCardTTITracking (copy), TimeToInteractiveTracker (copy), t1 (copy), t2 (copy)
	if not FFlagMobileGameJoinCardTTITracking then
		return
	end

	TimeToInteractiveTracker.trackStart(t1.PeopleListMounted, true)
	TimeToInteractiveTracker.updateMetadata(t1.PeopleListMounted, {
		category = "social_game_join_card",
		page = t2.PeopleListContextualMenu
	})
end
function t3.trackPeopleListMounted() -- line: 108
	-- upvalues: FFlagMobileGameJoinCardTTITracking (copy), TimeToInteractiveTracker (copy), t1 (copy)
	if not FFlagMobileGameJoinCardTTITracking then
		return
	end

	TimeToInteractiveTracker.trackEnd(t1.PeopleListMounted)
end

return t3
