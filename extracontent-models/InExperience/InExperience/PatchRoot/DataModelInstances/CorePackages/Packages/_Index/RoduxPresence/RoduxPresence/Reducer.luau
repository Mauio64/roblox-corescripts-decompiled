local byUserId = require(script.Presence.byUserId)
local byGameId = require(script.Presence.byGameId)
local byGameInstanceId = require(script.Presence.byGameInstanceId)
local byPlaceId = require(script.Presence.byPlaceId)

return function(p)
	return function(p2, p3)
		local v = p2 or { byUserId = {}, byGameInstanceId = {}, byGameId = {}, byPlaceId = {} }

		return {
			byUserId = byUserId(p)(v.byUserId, p3),
			byGameInstanceId = byGameInstanceId(p)(v, p3),
			byGameId = byGameId(p)(v, p3),
			byPlaceId = byPlaceId(p)(v, p3)
		}
	end
end
