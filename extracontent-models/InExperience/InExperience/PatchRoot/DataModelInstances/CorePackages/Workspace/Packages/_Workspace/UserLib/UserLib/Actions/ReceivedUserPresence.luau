local parent = script:FindFirstAncestor("UserLib").Parent

local Rodux = require(parent.Rodux)
local makeActionCreator = Rodux.makeActionCreator

local Time = require(parent.Time)
local DateTime = Time.DateTime

return makeActionCreator(
	script.Name,
	function(userId, presence, lastLocation, placeId, rootPlaceId, gameInstanceId, p, universeId, previousUniverseId)
		local lastOnline = 0

		if p ~= nil then
			local v = DateTime.fromIsoDate(p)

			if v ~= nil then
				lastOnline = v:GetUnixTimestamp()
			end
		end

		return {
			userId = userId,
			presence = presence,
			lastLocation = lastLocation,
			placeId = placeId,
			rootPlaceId = rootPlaceId,
			gameInstanceId = gameInstanceId,
			lastOnline = lastOnline,
			universeId = universeId,
			previousUniverseId = previousUniverseId
		}
	end
)
