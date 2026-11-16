local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")

local rodux = dependencies.Rodux
local roduxNetworking = dependencies.RoduxNetworking
local RoduxAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/installReducer/RoduxAnalytics")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/installReducer/Users")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/installReducer/Friends")
local RoduxPresence = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/installReducer/RoduxPresence")

require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/OmniTypes")

local FFlagPymkCarouselPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Flags/FFlagPymkCarouselPresenceStoreMigration")

return function(p2)
	if not (p2.contentType and p2.treatmentType) then
		return nil
	end

	local combineReducers = rodux.combineReducers
	local v5 = {
		Users = module3(p2),
		Friends = module4(p2),
		NetworkStatus = roduxNetworking.installReducer(),
		Analytics = RoduxAnalytics(p2),
		Presence = 0
	}
	local v6 = if not FFlagPymkCarouselPresenceStoreMigration then RoduxPresence.installReducer() else nil
	v5.Presence = v6
	return (combineReducers(v5))
end
