local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)

local rodux = dependencies.Rodux
local roduxNetworking = dependencies.RoduxNetworking
local RoduxAnalytics = require(script.RoduxAnalytics)
local Users = require(script.Users)
local Friends = require(script.Friends)
local RoduxPresence = require(script.RoduxPresence)

require(PYMKCarousel.Common.OmniTypes)

local FFlagPymkCarouselPresenceStoreMigration = require(PYMKCarousel.Flags.FFlagPymkCarouselPresenceStoreMigration)

return function(p)
	if not (p.contentType and p.treatmentType) then
		return nil
	end

	local combineReducers = rodux.combineReducers
	local v = {
		Users = Users(p),
		Friends = Friends(p),
		NetworkStatus = roduxNetworking.installReducer(),
		Analytics = RoduxAnalytics(p),
		Presence = 0
	}
	local presence

	if not FFlagPymkCarouselPresenceStoreMigration then
		presence = RoduxPresence.installReducer()
	end

	v.Presence = presence
	return (combineReducers(v))
end
