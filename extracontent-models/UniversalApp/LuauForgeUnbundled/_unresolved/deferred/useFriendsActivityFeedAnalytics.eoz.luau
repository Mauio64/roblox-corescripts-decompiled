local module = require("@luauforge/deferred/enn")

local module2 = require("@luauforge/deferred/eoA")

local function useFriendsActivityFeedAnalytics(p2)
	return module.useMemo(function()
		return module2({ infoForAllEvents = p2 })
	end, { p2 })
end

return useFriendsActivityFeedAnalytics
