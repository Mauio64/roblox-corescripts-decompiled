local module = require("@luauforge/deferred/enn")

local module2 = require("@luauforge/deferred/eos")
require("@luauforge/deferred/eoz")
local module3 = require("@luauforge/deferred/eoD")
local module4 = require("@luauforge/deferred/eoy")

local function useBadgeTileActivation(p2)
	local v5 = module2()

	return module.useCallback(function(p3, p4)
		if p3 == nil or p3 == 0 then
			return
		end

		if p2 ~= nil then
			p2.fireAnalyticsEvent(module3.FriendsActivityTileTap, {
				activityType = module4.ActivityType.Badge,
				absolutePosition = p4,
				universeId = p3
			})
		end

		v5(p3)
	end, { v5, p2 })
end

return useBadgeTileActivation
