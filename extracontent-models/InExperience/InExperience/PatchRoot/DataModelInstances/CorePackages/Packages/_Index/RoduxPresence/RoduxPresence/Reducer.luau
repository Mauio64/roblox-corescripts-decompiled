local byUserId = require(script.Presence.byUserId)
local byGameId = require(script.Presence.byGameId)
local byGameInstanceId = require(script.Presence.byGameInstanceId)
local byPlaceId = require(script.Presence.byPlaceId)

return function(p1) -- line: 6
	-- upvalues: byUserId (copy), byGameInstanceId (copy), byGameId (copy), byPlaceId (copy)
	return function(p2, p3) -- line: 7
		-- upvalues: byUserId (copy), p1 (copy), byGameInstanceId (copy), byGameId (copy), byPlaceId (copy)
		local v8 = p2 or {
			byUserId = {},
			byGameInstanceId = {},
			byGameId = {},
			byPlaceId = {}
		}

		return {
			byUserId = byUserId(p1)(v8.byUserId, p3),
			byGameInstanceId = byGameInstanceId(p1)(v8, p3),
			byGameId = byGameId(p1)(v8, p3),
			byPlaceId = byPlaceId(p1)(v8, p3)
		}
	end
end
