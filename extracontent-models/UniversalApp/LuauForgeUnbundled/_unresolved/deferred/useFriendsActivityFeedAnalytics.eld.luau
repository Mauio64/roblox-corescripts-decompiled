local module = require("@luauforge/deferred/ejR")

local module2 = require("@luauforge/deferred/ele")

local function useFriendsActivityFeedAnalytics(p2)
	return module.useMemo(function()
		return module2({ infoForAllEvents = p2 })
	end, { p2 })
end

return useFriendsActivityFeedAnalytics
