local module = require("@luauforge/deferred/enn")

require("@luauforge/deferred/eoz")
local module2 = require("@luauforge/deferred/eoD")
local module3 = require("@luauforge/deferred/eoy")

local function useAvatarTileActivation(p2)
	return module.useCallback(function(p3, p4)
		if p3 == nil or p3 == 0 then
			return
		end

		if p2 ~= nil then
			p2.fireAnalyticsEvent(module2.FriendsActivityTileTap, {
				activityType = module3.ActivityType.Avatar,
				absolutePosition = p4,
				userId = p3
			})
		end
	end, { p2 })
end

return useAvatarTileActivation
