local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local PYMKCarouselParent = PYMKCarousel.Parent
local dependencies = require(PYMKCarousel.dependencies)
local Rodux = dependencies.Rodux
local RoduxNetworking = dependencies.RoduxNetworking
local RoduxAnalytics = require(script.RoduxAnalytics)
local Users = require(script.Users)
local Friends = require(script.Friends)
local RoduxPresence = require(script.RoduxPresence)

require(PYMKCarousel.Common.OmniTypes)

local FFlagHomepagePYMKPresence = require(PYMKCarouselParent.SharedFlags).FFlagHomepagePYMKPresence

return function(p1) -- line: 16
	-- upvalues: Rodux (copy), Users (copy), Friends (copy), RoduxNetworking (copy), RoduxAnalytics (copy), FFlagHomepagePYMKPresence (copy), RoduxPresence (copy)
	if p1.contentType and p1.treatmentType then
		return (Rodux.combineReducers({
			Users = Users(p1),
			Friends = Friends(p1),
			NetworkStatus = RoduxNetworking.installReducer(),
			Analytics = RoduxAnalytics(p1),
			Presence = if not FFlagHomepagePYMKPresence then nil else RoduxPresence.installReducer()
		}))
	end

	return nil
end
